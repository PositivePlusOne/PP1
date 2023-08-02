import * as functions from 'firebase-functions';
import { FlamelinkHelpers } from '../../helpers/flamelink_helpers';
import safeJsonStringify from 'safe-json-stringify';
import { RelationshipService } from '../../services/relationship_service';
import { Activity, activitySchemaKey } from '../../dto/activities';
import { Profile, profileSchemaKey } from '../../dto/profile';
import { Relationship, relationshipSchemaKey } from '../../dto/relationships';
import { Tag, tagSchemaKey } from '../../dto/tags';
import { ProfileService } from '../../services/profile_service';
import { DirectoryEntry, directorySchemaKey } from '../../dto/directory_entry';
import { DataService } from '../../services/data_service';
import { TagsService } from '../../services/tags_service';

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
            "guidanceDirectoryEntries": [],
        },
    } as EndpointResponse;

    const joinedDataRecords = {
        [profileSchemaKey]: new Set<string>(),
        [relationshipSchemaKey]: new Set<string>(),
        [tagSchemaKey]: new Set<string>(),
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
                const foreignKey = obj.publisherInformation?.foreignKey;
                const isActivityPublisher = sender === foreignKey;
                if (foreignKey && !isActivityPublisher) {
                    joinedDataRecords[profileSchemaKey].add(obj.publisherInformation!.foreignKey!);
                    joinedDataRecords[relationshipSchemaKey].add(obj.publisherInformation!.foreignKey!);
                }

                const tags = obj.enrichmentConfiguration?.tags || [] as string[];
                for (const tag of tags) {
                    joinedDataRecords[tagSchemaKey].add(tag);
                }
                break;
            case profileSchemaKey:
                functions.logger.debug(`Expanding profile into endpoint response.`, { sender, obj, responseData });
                const isCurrentProfile = sender === obj._fl_meta_?.fl_id;
                const hasId = obj._fl_meta_?.fl_id;
                if (hasId && !isCurrentProfile) {
                    joinedDataRecords[relationshipSchemaKey].add(obj._fl_meta_!.fl_id!);
                }
                break;
            case directorySchemaKey:
                functions.logger.debug(`Expanding directory entry profile into endpoint response.`, { sender, obj, responseData });
                // Convert the profile from obj to the string flamelinkId
                const profile = obj.profile;
                if (profile && profile._path && profile._path.segments.length > 1) {
                    const data = await DataService.getDocument({
                        schemaKey: profileSchemaKey,
                        entryId: profile._path.segments[1],
                    });

                    const dataId = FlamelinkHelpers.getFlamelinkIdFromObject(data);
                    if (dataId) {
                        obj.profile = data._fl_meta_!.fl_id!;
                        joinedDataRecords[profileSchemaKey].add(data._fl_meta_!.fl_id!);
                        joinedDataRecords[relationshipSchemaKey].add(data._fl_meta_!.fl_id!);
                    }
                }
                break;
            default:
                break;
        }
    }

    functions.logger.debug(`Joining data records.`, { sender, joinedDataRecords });
    for (const key in joinedDataRecords) {
        joinedDataRecords[key] = new Set(Array.from(joinedDataRecords[key]));
    }

    // Join
    const joinPromises = [] as Promise<any>[];
    joinedDataRecords[profileSchemaKey]?.forEach(async (flamelinkId) => {
        joinPromises.push(ProfileService.getProfile(flamelinkId).then((profile) => {
            if (profile) {
                data.push(profile);
            }
        }));
    });

    joinedDataRecords[relationshipSchemaKey]?.forEach(async (flamelinkId) => {
        joinPromises.push(RelationshipService.getRelationship([sender, flamelinkId]).then((relationship) => {
            if (relationship) {
                data.push(relationship);
            }
        }));
    });

    joinedDataRecords[tagSchemaKey]?.forEach(async (flamelinkId) => {
        joinPromises.push(TagsService.getTag(flamelinkId).then((tag) => {
            if (tag) {
                data.push(tag);
            }
        }));
    });

    await Promise.all(joinPromises);

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
                const publisher = obj.publisherInformation?.foreignKey && responseData.data[profileSchemaKey].find((profile: any) => {
                    return profile._fl_meta_?.fl_id === obj.publisherInformation?.foreignKey;
                });

                const isActivityPublisher = sender === obj.publisherInformation?.foreignKey;
                if (publisher && !isActivityPublisher) {
                    functions.logger.debug(`Removing Activity from endpoint response.`, { sender, obj, responseData });
                    break;
                }

                responseData.data[schema].push(new Activity(obj));
                break;
            case profileSchemaKey:
                functions.logger.debug(`Injecting profile into endpoint response.`, { sender, obj, responseData });
                const profile = new Profile(obj);
                if (!isCurrentDocument) {
                    const relationship = responseData.data[relationshipSchemaKey].find((relationship: any) => {
                        return relationship._fl_meta_?.fl_id === profile._fl_meta_?.fl_id;
                    });
                    const isConnected = (relationship?.connected && !relationship?.blocked) || false;

                    profile.removeFlaggedData(isConnected);
                    profile.removePrivateData();
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
            case directorySchemaKey:
                functions.logger.debug(`Injecting directory entry into endpoint response.`, { sender, obj, responseData });
                responseData.data[schema].push(new DirectoryEntry(obj));
                break;
            default:
                functions.logger.error(`Cannot handle schema in response ${schema}.`);
                break;
        }
    }

    functions.logger.debug(`Built endpoint response.`, { sender, responseData });
    return safeJsonStringify(responseData);
}