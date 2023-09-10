import * as functions from 'firebase-functions';
import { FlamelinkHelpers } from '../../helpers/flamelink_helpers';
import safeJsonStringify from 'safe-json-stringify';
import { Activity, ActivityJSON, activitySchemaKey } from '../../dto/activities';
import { Profile, profileSchemaKey } from '../../dto/profile';
import { Relationship, RelationshipJSON, relationshipSchemaKey } from '../../dto/relationships';
import { Tag, tagSchemaKey } from '../../dto/tags';
import { DirectoryEntry, directorySchemaKey } from '../../dto/directory_entry';
import { DataService } from '../../services/data_service';
import { CacheService } from '../../services/cache_service';
import { StringHelpers } from '../../helpers/string_helpers';
import { Reaction, ReactionStatistics, reactionSchemaKey, reactionStatisticsSchemaKey } from '../../dto/reactions';
import { ReactionStatisticsService } from '../../services/reaction_statistics_service';
// import { FeedService } from '../../services/feed_service';

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
    joins = [],
    cursor = "",
    limit = 0,
}: {
    data?: Record<string, any>[];
    seedData?: Record<string, any>;
    joins?: string[];
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
            "reactions": [],
            "reactionStatistics": [],
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
                const activity = obj as ActivityJSON;
                const publisherId = activity.publisherInformation?.publisherId || "";
                const isActivityPublisher = sender && sender === publisherId;
                if (publisherId && !isActivityPublisher) {
                    joinedDataRecords.get(profileSchemaKey)?.add(activity.publisherInformation!.publisherId!);
                    const flid = StringHelpers.generateDocumentNameFromGuids([sender, publisherId]);
                    joinedDataRecords.get(relationshipSchemaKey)?.add(flid);
                }

                const isRepost = activity.generalConfiguration?.repostActivityId && activity.generalConfiguration?.repostActivityPublisherId;
                const isReposter = sender && sender === activity.generalConfiguration?.repostActivityPublisherId;
                if (isRepost && !isReposter) {
                    joinedDataRecords.get(activitySchemaKey)?.add(activity.generalConfiguration!.repostActivityId!);
                    joinedDataRecords.get(profileSchemaKey)?.add(activity.generalConfiguration!.repostActivityPublisherId!);
                    const flid = StringHelpers.generateDocumentNameFromGuids([sender, activity.generalConfiguration!.repostActivityPublisherId!]);
                    joinedDataRecords.get(relationshipSchemaKey)?.add(flid);
                }

                const tags = activity.enrichmentConfiguration?.tags || [] as string[];
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
            case reactionSchemaKey:
                const userId = obj?.user_id || "";
                const activityId = obj?.activity_id || "";
                const origin = obj?.origin || "";
                if (userId && userId !== sender) {
                    joinedDataRecords.get(profileSchemaKey)?.add(userId);
                }

                if (activityId && activityId.length > 0 && origin && origin.length > 0) {
                    const expectedStatisticsKey = ReactionStatisticsService.getExpectedKeyFromOptions(origin, activityId);
                    joinedDataRecords.get(reactionStatisticsSchemaKey)?.add(expectedStatisticsKey);
                }
                break;
            default:
                break;
        }
    }

    // Prepare Join
    const joinPromises = [] as Promise<any>[];
    const allFlamelinkIds = [];

    if (joins) {
        allFlamelinkIds.push(...joins);
    }

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

    let cachedData = [];
    if (allFlamelinkIds.length > 0) {
        cachedData = await CacheService.getMultipleFromCache(allFlamelinkIds);
    }

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
    functions.logger.debug(`Fetched joined data.`, { sender, data, allFlamelinkIds });
    
    // Populate
    const populatePromises = [] as Promise<any>[];
    for (const obj of data) {
        const flamelinkId = FlamelinkHelpers.getFlamelinkIdFromObject(obj);
        const schema = FlamelinkHelpers.getFlamelinkSchemaFromObject(obj);
        const isCurrentDocument = sender && sender.length > 0 && flamelinkId === sender;

        functions.logger.debug(`Populating object data.`, { sender, flamelinkId, schema, isCurrentDocument, obj });

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

                const activity = new Activity(obj);
                responseData.data[activitySchemaKey].push(activity);
                break;
            case profileSchemaKey:
                const profile = new Profile(obj);
                if (!isCurrentDocument) {
                    const flid = StringHelpers.generateDocumentNameFromGuids([sender, profile._fl_meta_?.fl_id || ""]);
                    const relationship = data.find((obj) => obj && obj._fl_meta_?.fl_id === flid) as RelationshipJSON;
                    const relationshipMember = relationship?.members?.find((member) => member?.memberId === profile._fl_meta_?.fl_id);
                    const isConnected = relationshipMember?.hasConnected || false;

                    profile.removeFlaggedData(isConnected);
                    profile.removePrivateData();
                }

                populatePromises.push(profile.appendFollowersAndFollowingData().finally(() => {
                    responseData.data[profileSchemaKey].push(profile);
                }));
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
            case reactionSchemaKey:
                responseData.data[schema].push(new Reaction(obj));
                break;
            case reactionStatisticsSchemaKey:
                responseData.data[schema].push(new ReactionStatistics(obj));
                break;
            default:
                break;
        }
    }

    await Promise.all(populatePromises);

    functions.logger.debug(`Built endpoint response.`, { sender, responseData });
    return safeJsonStringify(responseData);
}
