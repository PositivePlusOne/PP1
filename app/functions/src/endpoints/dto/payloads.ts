import * as functions from "firebase-functions";
import { FlamelinkHelpers } from "../../helpers/flamelink_helpers";
import safeJsonStringify from "safe-json-stringify";
import { Activity, ActivityJSON, activitySchemaKey } from "../../dto/activities";
import { Profile, ProfileStatistics, profileSchemaKey, profileStatisticsSchemaKey } from "../../dto/profile";
import { Relationship, RelationshipJSON, relationshipSchemaKey } from "../../dto/relationships";
import { Tag, tagSchemaKey } from "../../dto/tags";
import { DirectoryEntry, directorySchemaKey } from "../../dto/directory_entry";
import { DataService } from "../../services/data_service";
import { CacheService } from "../../services/cache_service";
import { StringHelpers } from "../../helpers/string_helpers";
import { Reaction, reactionSchemaKey } from "../../dto/reactions";
import { ReactionStatisticsService } from "../../services/reaction_statistics_service";
import { ReactionService } from "../../services/reaction_service";
import { Promotion, PromotionJSON, promotionsSchemaKey } from "../../dto/promotions";
import { ProfileStatisticsService } from "../../services/profile_statistics_service";
import { ReactionStatistics, reactionStatisticsSchemaKey } from "../../dto/reaction_statistics";
import { feedStatisticsSchemaKey } from "../../dto/feed_statistics";

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

export async function buildEndpointResponse(
  context: functions.https.CallableContext,
  {
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
  },
): Promise<string> {
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
      activities: [],
      users: [],
      relationships: [],
      tags: [],
      promotions: [],
      guidanceDirectoryEntries: [],
      reactions: [],
      reactionStatistics: [],
      userStatistics: [],
      feedStatistics: [],
    },
  } as EndpointResponse;

  const joinedDataRecords = new Map<string, Set<string>>();
  joinedDataRecords.set(profileSchemaKey, new Set<string>());
  joinedDataRecords.set(activitySchemaKey, new Set<string>());
  joinedDataRecords.set(reactionSchemaKey, new Set<string>());
  joinedDataRecords.set(relationshipSchemaKey, new Set<string>());
  joinedDataRecords.set(tagSchemaKey, new Set<string>());
  joinedDataRecords.set(reactionStatisticsSchemaKey, new Set<string>());
  joinedDataRecords.set(profileStatisticsSchemaKey, new Set<string>());
  joinedDataRecords.set(feedStatisticsSchemaKey, new Set<string>());
  joinedDataRecords.set(promotionsSchemaKey, new Set<string>());
  joinedDataRecords.set(directorySchemaKey, new Set<string>());

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
        const activityId = activity._fl_meta_?.fl_id || "";
        const isActivityPublisher = publisherId && sender === publisherId;

        if (publisherId && !isActivityPublisher) {
          joinedDataRecords.get(profileSchemaKey)?.add(publisherId);
        }

        if (sender && publisherId && !isActivityPublisher) {
          const flid = StringHelpers.generateDocumentNameFromGuids([sender, publisherId]);
          joinedDataRecords.get(relationshipSchemaKey)?.add(flid);
        }

        // Overall statistics
        if (activityId) {
          const expectedStatisticsKey = ReactionStatisticsService.getExpectedKeyFromOptions(activityId);
          joinedDataRecords.get(reactionStatisticsSchemaKey)?.add(expectedStatisticsKey);

          // Unique reactions
          if (sender) {
            const expectedReactionKeys = ReactionService.buildUniqueReactionKeysForOptions(activityId, sender);
            for (const expectedReactionKey of expectedReactionKeys) {
              if (expectedReactionKey) {
                joinedDataRecords.get(reactionSchemaKey)?.add(expectedReactionKey);
              }
            }
          }
        }

        const repostTargetActivityId = activity.repostConfiguration?.targetActivityId || "";
        const repostTargetActivityPublisherId = activity.repostConfiguration?.targetActivityPublisherId || "";
        const repostTargetActivityOriginFeed = activity.repostConfiguration?.targetActivityOriginFeed || "";
        const isRepost = repostTargetActivityId && repostTargetActivityPublisherId && repostTargetActivityOriginFeed;
        const isReposter = repostTargetActivityPublisherId && sender === repostTargetActivityPublisherId;

        if (isRepost && !isReposter) {
          joinedDataRecords.get(profileSchemaKey)?.add(repostTargetActivityPublisherId);
        }

        if (sender && isRepost && !isReposter) {
          const flid = StringHelpers.generateDocumentNameFromGuids([sender, repostTargetActivityPublisherId]);
          joinedDataRecords.get(relationshipSchemaKey)?.add(flid);
        }

        if (isRepost) {
          joinedDataRecords.get(activitySchemaKey)?.add(repostTargetActivityId);

          const expectedStatisticsKey = ReactionStatisticsService.getExpectedKeyFromOptions(repostTargetActivityId);
          joinedDataRecords.get(reactionStatisticsSchemaKey)?.add(expectedStatisticsKey);

          // Unique reactions
          if (sender) {
            const expectedReactionKeys = ReactionService.buildUniqueReactionKeysForOptions(repostTargetActivityId, sender);
            functions.logger.info("Unique nested reaction keys", { expectedReactionKeys });
            for (const expectedReactionKey of expectedReactionKeys) {
              if (expectedReactionKey) {
                joinedDataRecords.get(reactionSchemaKey)?.add(expectedReactionKey);
              }
            }
          }
        }

        const tags = activity.enrichmentConfiguration?.tags || ([] as string[]);
        for (const tag of tags) {
          joinedDataRecords.get(tagSchemaKey)?.add(tag);
        }

        if (activity.enrichmentConfiguration?.promotionKey) {
          functions.logger.info(`Promotion key: ${activity.enrichmentConfiguration?.promotionKey}`);
          joinedDataRecords.get(promotionsSchemaKey)?.add(activity.enrichmentConfiguration?.promotionKey);
        }
        break;
      case relationshipSchemaKey:
        const relationship = obj as RelationshipJSON;
        const members = relationship.members || [];

        for (const member of members) {
          const memberId = member.memberId || "";
          const isCurrentMember = sender && sender === memberId;
          const hasId = obj._fl_meta_?.fl_id;

          if (sender && hasId && !isCurrentMember) {
            const flid = StringHelpers.generateDocumentNameFromGuids([sender, obj._fl_meta_!.fl_id!]);
            joinedDataRecords.get(relationshipSchemaKey)?.add(flid);
          }

          if (sender && memberId && !isCurrentMember) {
            joinedDataRecords.get(profileSchemaKey)?.add(memberId);
          }
        }
        break;
      case profileSchemaKey:
        const isCurrentProfile = obj._fl_meta_?.fl_id && sender === obj._fl_meta_?.fl_id;
        const hasId = obj._fl_meta_?.fl_id;
        if (sender && hasId && !isCurrentProfile) {
          const flid = StringHelpers.generateDocumentNameFromGuids([sender, obj._fl_meta_!.fl_id!]);
          joinedDataRecords.get(relationshipSchemaKey)?.add(flid);
        }

        const ownerId = obj._fl_meta_?.ownedBy || "";
        if (ownerId && !isCurrentProfile) {
          joinedDataRecords.get(profileSchemaKey)?.add(ownerId);
        }

        if (sender && ownerId && !isCurrentProfile) {
          const flid = StringHelpers.generateDocumentNameFromGuids([sender, ownerId]);
          joinedDataRecords.get(relationshipSchemaKey)?.add(flid);
        }

        const directoryEntry = obj._fl_meta_?.directoryEntryId || "";
        if (directoryEntry) {
          joinedDataRecords.get(directorySchemaKey)?.add(directoryEntry);
        }

        const expectedStatsKey = ProfileStatisticsService.getExpectedKeyFromOptions(obj._fl_meta_?.fl_id || "");
        joinedDataRecords.get(profileStatisticsSchemaKey)?.add(expectedStatsKey);
        break;
      case directorySchemaKey:
        const entry = obj as DirectoryEntry;
        const entryOwnerId = entry._fl_meta_?.ownedBy || "";
        if (entryOwnerId) {
          joinedDataRecords.get(profileSchemaKey)?.add(entryOwnerId);

          if (sender && entryOwnerId !== sender) {
            const flid = StringHelpers.generateDocumentNameFromGuids([sender, entryOwnerId]);
            joinedDataRecords.get(relationshipSchemaKey)?.add(flid);
          }
        }
        break;
      case reactionSchemaKey:
        const userId = obj?.user_id || "";
        if (userId && userId !== sender) {
          joinedDataRecords.get(profileSchemaKey)?.add(userId);
        }

        if (sender && userId && userId !== sender) {
          const flid = StringHelpers.generateDocumentNameFromGuids([sender, userId]);
          joinedDataRecords.get(relationshipSchemaKey)?.add(flid);
        }
        break;
      case promotionsSchemaKey:
        const promotion = obj as PromotionJSON;
        if (promotion.ownerId && promotion.ownerId !== sender) {
          joinedDataRecords.get(profileSchemaKey)?.add(promotion.ownerId);

          if (sender) {
            const flid = StringHelpers.generateDocumentNameFromGuids([sender, promotion.ownerId]);
            joinedDataRecords.get(relationshipSchemaKey)?.add(flid);
          }
        }
        if (promotion.activityId) {
          joinedDataRecords.get(activitySchemaKey)?.add(promotion.activityId);
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

      joinPromises.push(
        DataService.getDocument({
          schemaKey: schemaKey,
          entryId: flamelinkId,
        }).then((result) => {
          if (result) {
            data.push(result);
          }
        }),
      );
    }
  }

  // Stage 6: Wait for all joins to complete
  functions.logger.info(`Waiting for ${joinPromises.length} joins to complete`, { joins });
  await Promise.all(joinPromises);

  // Stage 7: Build response
  const populatePromises = [] as Promise<any>[];
  let currentEpochMillis = Date.now();

  for (const obj of data) {
    const flamelinkId = FlamelinkHelpers.getFlamelinkIdFromObject(obj);
    const schema = FlamelinkHelpers.getFlamelinkSchemaFromObject(obj);
    const isCurrentDocument = sender && sender.length > 0 && flamelinkId === sender;

    // Skip if no flamelink id or schema
    if (!flamelinkId || !schema) {
      continue;
    }

    // We append one millisecond to ensure that the order of the data is preserved.
    if (obj._fl_meta_) {
      obj._fl_meta_.lastFetchMillis = currentEpochMillis;
    }

    if (responseData.data[schema] === undefined) {
      responseData.data[schema] = [];
    }

    switch (schema) {
      case activitySchemaKey:
        const publisher =
          obj.publisherInformation?.foreignKey &&
          responseData.data[profileSchemaKey].find((profile: any) => {
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

        if (sender && !isCurrentDocument) {
          const flid = StringHelpers.generateDocumentNameFromGuids([sender, profile._fl_meta_?.fl_id || ""]);
          const relationship = data.find((obj) => obj && obj._fl_meta_?.fl_id === flid) as RelationshipJSON;
          const currentRelationshipMember = relationship?.members?.find((member) => member?.memberId === sender);

          const isManager = currentRelationshipMember?.canManage || false;

          // If the account is not connected and not managed by the current user
          // And the account has flagged data (e.g. email, phone number, etc.)
          // Then we remove the flagged data from the response.
          if (!isManager) {
            profile.removeFlaggedData();
            profile.removePrivateData();
            profile.notifyPartial();
          }
        } else if (!isCurrentDocument) {
          profile.removeFlaggedData();
          profile.removePrivateData();
          profile.notifyPartial();
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
      case promotionsSchemaKey:
        responseData.data[schema].push(new Promotion(obj));
        break;
      case reactionStatisticsSchemaKey:
        responseData.data[schema].push(new ReactionStatistics(obj));
        break;
      case profileStatisticsSchemaKey:
        responseData.data[schema].push(new ProfileStatistics(obj));
        break;
      case feedStatisticsSchemaKey:
        responseData.data[schema].push(obj);
        break;
      default:
        break;
    }

    currentEpochMillis++;
  }

  // Stage 8: Wait for all population to complete
  await Promise.all(populatePromises);

  // Stage 9: Return response
  return safeJsonStringify(responseData);
}
