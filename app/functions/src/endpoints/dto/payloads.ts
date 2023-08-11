import * as functions from 'firebase-functions';
import { FlamelinkHelpers } from '../../helpers/flamelink_helpers';
import safeJsonStringify from 'safe-json-stringify';
import { Activity, activitySchemaKey } from '../../dto/activities';
import { Profile, profileSchemaKey } from '../../dto/profile';
import { Relationship, RelationshipJSON, relationshipSchemaKey } from '../../dto/relationships';
import { Tag, tagSchemaKey } from '../../dto/tags';
import { DirectoryEntry, directorySchemaKey } from '../../dto/directory_entry';
import { DataService } from '../../services/data_service';
import { CacheService } from '../../services/cache_service';
import { StringHelpers } from '../../helpers/string_helpers';
import { Comment, commentSchemaKey } from '../../dto/comments';
import { Reaction, reactionSchemaKey } from '../../dto/reactions';

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
            "comments": [],
            "reactions": [],
        },
    } as EndpointResponse;

    const joinedDataRecords = new Map<string, Set<string>>();
    joinedDataRecords.set(profileSchemaKey, new Set<string>());
    joinedDataRecords.set(relationshipSchemaKey, new Set<string>());
    joinedDataRecords.set(tagSchemaKey, new Set<string>());

    // Prepare join
    for (const obj of data) {
        const flamelinkId = FlamelinkHelpers.getFlamelinkIdFromObject(obj);
        const schema = FlamelinkHelpers.getFlamelinkSchemaFromObject(obj);
        if (!flamelinkId || !schema) {
            continue;
        }

        switch (schema) {
            case activitySchemaKey:
                const foreignKey = obj.publisherInformation?.foreignKey;
                const isActivityPublisher = sender === foreignKey;
                if (foreignKey && !isActivityPublisher) {
                    joinedDataRecords.get(profileSchemaKey)?.add(obj.publisherInformation!.foreignKey!);

                    const flid = StringHelpers.generateDocumentNameFromGuids([sender, obj.publisherInformation!.foreignKey!]);
                    joinedDataRecords.get(relationshipSchemaKey)?.add(flid);
                }

                const tags = obj.enrichmentConfiguration?.tags || [] as string[];
                for (const tag of tags) {
                    joinedDataRecords.get(tagSchemaKey)?.add(tag);
                }
                break;
            case profileSchemaKey:
                const isCurrentProfile = sender === obj._fl_meta_?.fl_id;
                const hasId = obj._fl_meta_?.fl_id;
                if (hasId && !isCurrentProfile) {
                    const flid = StringHelpers.generateDocumentNameFromGuids([sender, obj._fl_meta_!.fl_id!]);
                    joinedDataRecords.get(relationshipSchemaKey)?.add(flid);
                }
                break;
            case directorySchemaKey:
                const profile = obj.profile;
                if (profile && profile._path && profile._path.segments.length > 1) {
                    const data = await DataService.getDocument({
                        schemaKey: profileSchemaKey,
                        entryId: profile._path.segments[1],
                    });

                    const dataId = FlamelinkHelpers.getFlamelinkIdFromObject(data);
                    if (dataId) {
                        obj.profile = data._fl_meta_!.fl_id!;
                        joinedDataRecords.get(profileSchemaKey)?.add(data._fl_meta_!.fl_id!);

                        const relationshipSchemaKey = StringHelpers.generateDocumentNameFromGuids([sender, obj.profile]);
                        joinedDataRecords.get(relationshipSchemaKey)?.add(relationshipSchemaKey);
                    }
                }
                break;
            default:
                break;
        }
    }
    // Prepare Join
    const joinPromises = [] as Promise<any>[];
    const allFlamelinkIds = [];

    for (const [schemaKey, flamelinkIds] of joinedDataRecords.entries()) {
        for (const flamelinkId of flamelinkIds) {
            if (data.find((obj) => obj && obj._fl_meta_?.fl_id === flamelinkId)) {
                joinedDataRecords.get(schemaKey)?.delete(flamelinkId);
                continue;
            }

            const cacheKey = CacheService.generateCacheKey({
                schemaKey: schemaKey,
                entryId: flamelinkId,
            });

            allFlamelinkIds.push(cacheKey);
        }
    }

    const cachedData = await CacheService.getMultipleFromCache(allFlamelinkIds);
    functions.logger.debug(`Got ${cachedData.length} records from cache.`, { sender, allFlamelinkIds, cachedData });

    // Cache Join
    for (const obj of cachedData) {
        if (!obj) {
            continue;
        }

        const flamelinkId = FlamelinkHelpers.getFlamelinkIdFromObject(obj);
        const schema = FlamelinkHelpers.getFlamelinkSchemaFromObject(obj);
        if (!flamelinkId || !schema) {
            continue;
        }

        data.push(obj);
        joinedDataRecords.get(schema)?.delete(flamelinkId);
    }

    // Fetch Join
    for (const [schemaKey, flamelinkIds] of joinedDataRecords.entries()) {
        for (const flamelinkId of flamelinkIds) {
            if (schemaKey && data.find((obj) => obj && obj?._fl_meta_?.fl_id === flamelinkId)) {
                continue;
            }

            // Remove low priority or ephemeral data (e.g. tags)
            if (schemaKey === tagSchemaKey) {
                continue;
            }

            functions.logger.debug(`ID not found in cache. Fetching from Flamelink.`, { sender, flamelinkId, schemaKey });
            joinPromises.push(DataService.getDocument({
                schemaKey: schemaKey,
                entryId: flamelinkId,
            }).then((result) => {
                if (result) {
                    data.push(result);
                }
            }));
        }
    }

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
                const publisher = obj.publisherInformation?.foreignKey && responseData.data[profileSchemaKey].find((profile: any) => {
                    return profile._fl_meta_?.fl_id === obj.publisherInformation?.foreignKey;
                });

                const isActivityPublisher = sender === obj.publisherInformation?.foreignKey;
                if (publisher && !isActivityPublisher) {
                    break;
                }

                responseData.data[schema].push(new Activity(obj));
                break;
            case profileSchemaKey:
                const profile = new Profile(obj);
                if (!isCurrentDocument) {
                    const flid = StringHelpers.generateDocumentNameFromGuids([sender, profile._fl_meta_?.fl_id || ""]);
                    const relationship = data.find((obj) => obj && obj._fl_meta_?.fl_id === flid) as RelationshipJSON;
                    const relationshipMember = relationship?.members?.find((member) => member?.memberId === profile._fl_meta_?.fl_id);
                    const isConnected = relationshipMember?.hasConnected || false;
                    
                    functions.logger.debug(`Relationship Filter`, { flid, relationship, sender, profile, isConnected, relationshipMember});

                    profile.removeFlaggedData(isConnected);
                    profile.removePrivateData();
                }

                responseData.data[schema].push(profile);
                break;
            case relationshipSchemaKey:
                responseData.data[schema].push(new Relationship(obj));
                break;
            case tagSchemaKey:
                responseData.data[schema].push(new Tag(obj));
                break;
            case directorySchemaKey:
                responseData.data[schema].push(new DirectoryEntry(obj));
                break;
            case commentSchemaKey:
                responseData.data[schema].push(new Comment(obj));
                break;
            case reactionSchemaKey:
                responseData.data[schema].push(new Reaction(obj));
                break;
            default:
                break;
        }
    }

    functions.logger.debug(`Built endpoint response.`, { sender, responseData });
    return safeJsonStringify(responseData);
}
