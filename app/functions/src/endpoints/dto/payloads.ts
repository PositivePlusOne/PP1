import * as functions from 'firebase-functions';
import { FlamelinkHelpers } from '../../helpers/flamelink_helpers';
import { ActivityMappers } from '../../mappers/activity_mappers';
import safeJsonStringify from 'safe-json-stringify';
import { StringHelpers } from '../../helpers/string_helpers';
import { CacheService } from '../../services/cache_service';
import { RelationshipService } from '../../services/relationship_service';
import { Activity, ActivityJSON, activitySchemaKey } from '../../dto/activities';
import { Profile, ProfileJSON, profileSchemaKey } from '../../dto/profile';
import { Relationship, relationshipSchemaKey } from '../../dto/relationships';
import { Tag, tagSchemaKey } from '../../dto/tags';
import { TagsService } from '../../services/tags_service';
import { ProfileService } from '../../services/profile_service';

export type EndpointRequest = {
    sender: string;
    cursor: string;
    limit: number;
    data: Record<string, any>;
};

export type EndpointResponse = {
    data: {
        activities: Activity[];
        users: Profile[];
        relationships: Relationship[];
        tags: Tag[];
    };
    cursor: string;
    limit: number;
};

// const visibleFlags = user.visibilityFlags;
//         const connectedUser: ConnectedUserDto = {
//           id: user._fl_meta_.fl_id,
//           displayName: user.displayName,
//           accentColor: user.accentColor,
//           profileImage: await StorageService.getMediaLinkByPath(user.profileImage, ThumbnailType.Medium),
//           ...(visibleFlags.includes("birthday") ? { birthday: user.birthday } : {}),
//           ...(visibleFlags.includes("genders") ? { genders: user.genders } : {}),
//           ...(visibleFlags.includes("hiv_status") ? { hivStatus: user.hivStatus } : {}),
//           ...(visibleFlags.includes("interests") ? { interests: user.interests } : {}),
//           ...(visibleFlags.includes("location") ? { place: user.place } : {}),
//         };

export async function buildEndpointResponse(context: functions.https.CallableContext, options = {
    data: [] as Record<string, any>[],
    cursor: "" as string,
    limit: 0 as number,
    sender: "" as string,
}): Promise<string> {
    if (!options.sender) {
        options.sender = context.auth?.uid || "";
    }

    const responseData = {
        cursor: options.cursor,
        limit: options.limit,
        data: {
            activities: [] as Activity[],
            users: [] as Profile[],
            relationships: [] as Relationship[],
            tags: [] as Tag[],
        },
    } as EndpointResponse;

    const promises = [] as Promise<any>[];
    for (const data of options.data) {
        const flamelinkId = FlamelinkHelpers.getFlamelinkIdFromObject(data);
        const schema = FlamelinkHelpers.getFlamelinkSchemaFromObject(data);

        // Skip if no flamelink id or schema
        if (!flamelinkId || !schema) {
            continue;
        }

        switch (schema) {
            case activitySchemaKey:
                promises.push(injectActivityIntoEndpointResponse(options.sender, data, responseData));
                break;
            case profileSchemaKey:
                promises.push(injectProfileIntoEndpointResponse(options.sender, data, responseData));
                break;
            case relationshipSchemaKey:
                responseData.data[schema].push(new Relationship(data));
                break;
            case tagSchemaKey:
                responseData.data[schema].push(new Tag(data));
                break;
            default:
                functions.logger.error(`Cannot handle schema in response ${schema}.`);
                break;
        }
    }

    await Promise.all(promises);

    return safeJsonStringify(responseData);
}

export async function injectActivityIntoEndpointResponse(sender: string, data: any, responseData: EndpointResponse): Promise<void> {
    const activity = new Activity(data as ActivityJSON);
    const presenterId = activity.publisherInformation?.foreignKey;
    const promises = [] as Promise<any>[];

    if (presenterId && presenterId !== sender) {
        promises.push(ProfileService.getProfile(presenterId).then(profile => {
            if (profile) {
                responseData.data.users.push(profile);
            }
        }));

        promises.push(RelationshipService.getRelationship([presenterId, sender]).then(relationship => {
            if (relationship) {
                responseData.data.relationships.push(relationship);
            }
        }));
    }

    if (activity.enrichmentConfiguration?.tags) {
        for (const tag of activity.enrichmentConfiguration.tags) {
            promises.push(TagsService.getTag(tag).then(tag => {
                if (tag) {
                    responseData.data.tags.push(tag);
                }
            }));
        }
    }

    await Promise.all(promises);

    responseData.data.activities.push(activity);
}

export async function injectProfileIntoEndpointResponse(sender: string, data: any, responseData: EndpointResponse): Promise<void> {
    const profile = new Profile(data as ProfileJSON);
    const profileId = profile.flMeta?.id || "";
    const hasSender = sender && sender.length > 0;
    const isSenderProfile = hasSender && profileId === sender;
    const promises = [] as Promise<any>[];

    if (!isSenderProfile) {
        profile.removePrivateData();
        profile.removeFlaggedData();
    }

    if (!isSenderProfile && hasSender) {
        promises.push(RelationshipService.getRelationship([profileId, sender]).then(relationship => {
            if (relationship) {
                responseData.data.relationships.push(relationship);
            }
        }));
    }

    await Promise.all(promises);

    responseData.data.users.push(profile);
}