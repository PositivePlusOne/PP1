import * as functions from 'firebase-functions';
import { FlamelinkHelpers } from '../../helpers/flamelink_helpers';
import safeJsonStringify from 'safe-json-stringify';
import { RelationshipService } from '../../services/relationship_service';
import { Activity, ActivityJSON, activitySchemaKey } from '../../dto/activities';
import { Profile, ProfileJSON, profileSchemaKey } from '../../dto/profile';
import { Relationship, relationshipSchemaKey } from '../../dto/relationships';
import { Tag, tagSchemaKey } from '../../dto/tags';
import { ProfileService } from '../../services/profile_service';

export type EndpointRequest = {
    sender: string;
    cursor: string;
    limit: number;
    data: Record<string, any>;
};

export type EndpointResponse = {
    data: Record<string, any>;
    cursor: string;
    limit: number;
};

export async function buildEndpointResponse(context: functions.https.CallableContext, {
    sender,
    data = [],
    seedData = {},
    cursor = "",
    limit = 0,
}: {
    data?: Record<string, any>[];
    seedData?: Record<string, any>;
    cursor?: string;
    limit?: number;
    sender: string;
}): Promise<string> {
    functions.logger.info(`Building endpoint response for ${context.rawRequest.url}.`, {
        sender,
        data,
        seedData,
        cursor,
        limit,
    });

    const responseData = {
        cursor: cursor,
        limit: limit,
        data: {
            ...seedData,
            "activities": [],
            "users": [],
            "relationships": [],
            "tags": [],
        },
    } as EndpointResponse;

    const joinedDataRecords = {
        [profileSchemaKey]: new Set<string>(),
        [relationshipSchemaKey]: new Set<string>(),
    } as Record<string, Set<string>>;
    
    // Prepare join
    for (const obj of data) {
        const flamelinkId = FlamelinkHelpers.getFlamelinkIdFromObject(obj);
        const schema = FlamelinkHelpers.getFlamelinkSchemaFromObject(obj);
        if (!flamelinkId || !schema) {
            continue;
        }

        switch (schema) {
            case activitySchemaKey:
                functions.logger.debug(`Expanding activity into endpoint response.`, { sender, obj, responseData });
                const activityJson = obj as ActivityJSON;
                const foreignKey = activityJson.publisherInformation?.foreignKey;
                const isActivityPublisher = sender === foreignKey;
                if (foreignKey && !isActivityPublisher && data.filter((d) => FlamelinkHelpers.getFlamelinkIdFromObject(d) === foreignKey).length === 0) {
                    joinedDataRecords[profileSchemaKey].add(activityJson.publisherInformation!.foreignKey!);
                    joinedDataRecords[relationshipSchemaKey].add(activityJson.publisherInformation!.foreignKey!);
                }
                break;
            case profileSchemaKey:
                functions.logger.debug(`Expanding profile into endpoint response.`, { sender, obj, responseData });
                const profileJson = obj as ProfileJSON;
                const isCurrentProfile = sender === profileJson._fl_meta_?.fl_id;
                const hasId = profileJson._fl_meta_?.fl_id !== undefined;
                if (hasId && !isCurrentProfile && data.filter((d) => FlamelinkHelpers.getFlamelinkIdFromObject(d) === profileJson._fl_meta_!.fl_id).length === 0) {
                    joinedDataRecords[relationshipSchemaKey].add(profileJson._fl_meta_!.fl_id!);
                }
                break;
            default:
                functions.logger.error(`Cannot handle schema in response ${schema}.`);
                break;
        }
    }

    functions.logger.debug(`Joining data records.`, { sender, joinedDataRecords });

    // Join
    await Promise.all([
        joinedDataRecords[profileSchemaKey].forEach(async (flamelinkId) => {
            const profile = await ProfileService.getProfile(flamelinkId);
            if (profile) {
                data.push(profile);
            }
        }),

        joinedDataRecords[relationshipSchemaKey].forEach(async (flamelinkId) => {
            const relationship = await RelationshipService.getRelationship([sender, flamelinkId]);
            if (relationship) {
                data.push(relationship);
            }
        }),
    ]);

    // Populate
    for (const obj of data) {
        const flamelinkId = FlamelinkHelpers.getFlamelinkIdFromObject(obj);
        const schema = FlamelinkHelpers.getFlamelinkSchemaFromObject(obj);
        const isCurrentDocument = sender && sender.length > 0 && flamelinkId === sender;

        // Skip if no flamelink id or schema
        if (!flamelinkId || !schema) {
            continue;
        }

        if (responseData.data[schema] === undefined) {
            responseData.data[schema] = [];
        }

        switch (schema) {
            case activitySchemaKey:
                functions.logger.debug(`Injecting activity into endpoint response.`, { sender, obj, responseData });
                responseData.data[schema].push(new Activity(obj));
                break;
            case profileSchemaKey:
                functions.logger.debug(`Injecting profile into endpoint response.`, { sender, obj, responseData });
                const profile = new Profile(obj);
                if (!isCurrentDocument) {
                    profile.removePrivateData();
                    profile.removeFlaggedData();
                }

                responseData.data[schema].push(profile);
                break;
            case relationshipSchemaKey:
                functions.logger.debug(`Injecting relationship into endpoint response.`, { sender, obj, responseData });
                responseData.data[schema].push(new Relationship(obj));
                break;
            case tagSchemaKey:
                functions.logger.debug(`Injecting tag into endpoint response.`, { sender, obj, responseData });
                responseData.data[schema].push(new Tag(obj));
                break;
            default:
                functions.logger.error(`Cannot handle schema in response ${schema}.`);
                break;
        }
    }

    functions.logger.debug(`Built endpoint response.`, { sender, responseData });
    return safeJsonStringify(responseData);
}