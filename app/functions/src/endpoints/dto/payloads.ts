import * as functions from 'firebase-functions';
import { FlamelinkHelpers } from '../../helpers/flamelink_helpers';
import safeJsonStringify from 'safe-json-stringify';
import { Activity, ActivityJSON, ActivityStatistics, activitySchemaKey, activityStatisticsSchemaKey } from '../../dto/activities';
import { Profile, ProfileStatistics, profileSchemaKey, profileStatisticsSchemaKey } from '../../dto/profile';
import { Relationship, RelationshipJSON, relationshipSchemaKey } from '../../dto/relationships';
import { Tag, tagSchemaKey } from '../../dto/tags';
import { DirectoryEntry, directorySchemaKey } from '../../dto/directory_entry';
import { DataService } from '../../services/data_service';
import { CacheService } from '../../services/cache_service';
import { StringHelpers } from '../../helpers/string_helpers';
import { Reaction, reactionSchemaKey } from '../../dto/reactions';
import { ActivityStatisticsService } from '../../services/activity_statistics_service';
import { ReactionService } from '../../services/reaction_service';
import { Promotion, promotionsSchemaKey } from '../../dto/promotions';
import { ProfileStatisticsService } from '../../services/profile_statistics_service';
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
    // Stage 0: Prepare
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
            "promotions": [],
            "guidanceDirectoryEntries": [],
            "reactions": [],
            "reactionStatistics": [],
        },
    } as EndpointResponse;

    const joinedDataRecords = new Map<string, Set<string>>();
    joinedDataRecords.set(profileSchemaKey, new Set<string>());
    joinedDataRecords.set(activitySchemaKey, new Set<string>());
    joinedDataRecords.set(reactionSchemaKey, new Set<string>());
    joinedDataRecords.set(activityStatisticsSchemaKey, new Set<string>());
    joinedDataRecords.set(profileStatisticsSchemaKey, new Set<string>());
    joinedDataRecords.set(relationshipSchemaKey, new Set<string>());
    joinedDataRecords.set(tagSchemaKey, new Set<string>());

    // Stage 1: Prepare join record keys
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
                const originFeed = activity.publisherInformation?.originFeed || "";
                const activityId = activity._fl_meta_?.fl_id || "";
                const isActivityPublisher = sender && sender === publisherId;

                if (publisherId && !isActivityPublisher) {
                    joinedDataRecords.get(profileSchemaKey)?.add(activity.publisherInformation!.publisherId!);
                    const flid = StringHelpers.generateDocumentNameFromGuids([sender, publisherId]);
                    joinedDataRecords.get(relationshipSchemaKey)?.add(flid);
                }

                // Overall statistics
                if (originFeed && activityId) {
                    const expectedStatisticsKey = ActivityStatisticsService.getExpectedKeyFromOptions(originFeed, activityId);
                    joinedDataRecords.get(activityStatisticsSchemaKey)?.add(expectedStatisticsKey);

                    // Unique reactions
                    if (sender) {
                        const expectedReactionKeys = ReactionService.buildUniqueReactionKeysForActivitiesAndUser([activity], sender);
                        functions.logger.info("Unique reaction keys", { expectedReactionKeys });
                        for (const expectedReactionKey of expectedReactionKeys) {
                            if (expectedReactionKey) {
                                joinedDataRecords.get(reactionSchemaKey)?.add(expectedReactionKey);
                            }
                        }
                    }
                }

                const repostActivityId = activity.generalConfiguration?.repostActivityId || "";
                const repostActivityPublisherId = activity.generalConfiguration?.repostActivityPublisherId || "";
                const repostActivityOriginFeed = activity.generalConfiguration?.repostActivityOriginFeed || "";
                const isRepost = repostActivityId && repostActivityPublisherId && repostActivityOriginFeed;
                const isReposter = sender && sender === repostActivityPublisherId;

                if (isRepost && !isReposter) {
                    joinedDataRecords.get(activitySchemaKey)?.add(repostActivityId);
                    joinedDataRecords.get(profileSchemaKey)?.add(repostActivityPublisherId);

                    const flid = StringHelpers.generateDocumentNameFromGuids([sender, repostActivityPublisherId]);
                    joinedDataRecords.get(relationshipSchemaKey)?.add(flid);
                }

                if (isRepost) {
                    const expectedStatisticsKey = ActivityStatisticsService.getExpectedKeyFromOptions(repostActivityOriginFeed, repostActivityId);
                    joinedDataRecords.get(activityStatisticsSchemaKey)?.add(expectedStatisticsKey);

                    // Unique reactions
                    if (sender) {
                        const expectedReactionKeys = ReactionService.buildUniqueReactionKeysForOptions(repostActivityOriginFeed, repostActivityId, sender);
                        functions.logger.info("Unique nested reaction keys", { expectedReactionKeys });
                        for (const expectedReactionKey of expectedReactionKeys) {
                            if (expectedReactionKey) {
                                joinedDataRecords.get(reactionSchemaKey)?.add(expectedReactionKey);
                            }
                        }
                    }
                }

                const tags = activity.enrichmentConfiguration?.tags || [] as string[];
                for (const tag of tags) {
                    joinedDataRecords.get(tagSchemaKey)?.add(tag);
                }

                if (activity.enrichmentConfiguration?.promotionKey) {
                    functions.logger.info(`Promotion key: ${activity.enrichmentConfiguration?.promotionKey}`);
                    joinedDataRecords.get(promotionsSchemaKey)?.add(activity.enrichmentConfiguration?.promotionKey);
                }
                break;
            case profileSchemaKey:
                const isCurrentProfile = sender === obj._fl_meta_?.fl_id;
                const hasId = obj._fl_meta_?.fl_id;
                if (hasId && !isCurrentProfile) {
                    const flid = StringHelpers.generateDocumentNameFromGuids([sender, obj._fl_meta_!.fl_id!]);
                    joinedDataRecords.get(relationshipSchemaKey)?.add(flid);
                }

                const expectedStatsKey = ProfileStatisticsService.getExpectedKeyFromOptions(obj._fl_meta_?.fl_id || "");
                joinedDataRecords.get(profileStatisticsSchemaKey)?.add(expectedStatsKey);
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
                if (userId && userId !== sender) {
                    const flid = StringHelpers.generateDocumentNameFromGuids([sender, userId]);
                    joinedDataRecords.get(relationshipSchemaKey)?.add(flid);
                    joinedDataRecords.get(profileSchemaKey)?.add(userId);
                }
                break;
            default:
                break;
        }
    }

    // Stage 2: Prepare join promises
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

    // Stage 3: Fetch from cache
    let cachedData = [];
    if (allFlamelinkIds.length > 0) {
        cachedData = await CacheService.getMultipleFromCache(allFlamelinkIds);
    }

    // Stage 4: Insert cached data
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

    // Stage 5: Fetch from Redis/Firestore
    for (const [schemaKey, flamelinkIds] of joinedDataRecords.entries()) {
        for (const flamelinkId of flamelinkIds) {
            if (schemaKey && data.find((obj) => obj && obj?._fl_meta_?.fl_id === flamelinkId)) {
                continue;
            }

            // Remove low priority or ephemeral data (e.g. tags)
            if (schemaKey === tagSchemaKey) {
                continue;
            }

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

    // Stage 6: Wait for all joins to complete
    await Promise.all(joinPromises);

    // Stage 7: Build response
    const populatePromises = [] as Promise<any>[];
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

                const activity = new Activity(obj);
                responseData.data[activitySchemaKey].push(activity);
                break;
            case profileSchemaKey:
                const profile = new Profile(obj);
                if (!profile._fl_meta_?.fl_id) {
                    break;
                }

                if (!isCurrentDocument) {
                    const flid = StringHelpers.generateDocumentNameFromGuids([sender, profile._fl_meta_?.fl_id || ""]);
                    const relationship = data.find((obj) => obj && obj._fl_meta_?.fl_id === flid) as RelationshipJSON;
                    const relationshipMember = relationship?.members?.find((member) => member?.memberId === profile._fl_meta_?.fl_id);
                    const isConnected = relationshipMember?.hasConnected || false;

                    profile.removeFlaggedData(isConnected);
                    profile.removePrivateData();
                }

                
                responseData.data[profileSchemaKey].push(profile);
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
            case activityStatisticsSchemaKey:
                responseData.data[schema].push(new ActivityStatistics(obj));
                break;
            case profileStatisticsSchemaKey:
                responseData.data[schema].push(new ProfileStatistics(obj));
                break;
            case promotionsSchemaKey:
                responseData.data[schema].push(new Promotion(obj));
                break;
            default:
                break;
        }
    }

    // Stage 8: Wait for all population to complete
    await Promise.all(populatePromises);

    // For now, the client will handle this.
    // Stage 9: Enrich response
    // const reactions = data.filter((obj) => obj && obj._fl_meta_?.schema === reactionSchemaKey) as ReactionJSON[];
    // const reactionStatistics = data.filter((obj) => obj && obj._fl_meta_?.schema === reactionStatisticsSchemaKey) as ReactionStatisticsJSON[];

    // if (reactions && reactions.length > 0 && reactionStatistics && reactionStatistics.length > 0) {
    //     const newStatistics = ReactionStatisticsService.enrichStatisticsWithUniqueUserReactions(reactionStatistics, reactions);
    //     if (newStatistics) {
    //         responseData.data[reactionStatisticsSchemaKey] = [];
    //         for (const stat of newStatistics) {
    //             if (!stat) {
    //                 continue;
    //             }

    //             responseData.data[reactionStatisticsSchemaKey].push(new ReactionStatistics(stat));
    //         }
    //     }
    // }

    // Stage 10: Return response
    return safeJsonStringify(responseData);
}
