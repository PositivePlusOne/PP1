import * as functions from "firebase-functions";

import { FIREBASE_FUNCTION_INSTANCE_DATA, FIREBASE_FUNCTION_INSTANCE_DATA_1G, FIREBASE_FUNCTION_INSTANCE_DATA_256 } from "../constants/domain";

import { DataService } from "../services/data_service";

import { ActivitiesService } from "../services/activities_service";
import { UserService } from "../services/user_service";
import { EndpointRequest, buildEndpointResponse } from "./dto/payloads";
import { ActivityJSON, ActivitySecurityConfigurationMode } from "../dto/activities";
import { MediaJSON } from "../dto/media";
import { TagsService } from "../services/tags_service";
import { StorageService } from "../services/storage_service";
import { FeedService } from "../services/feed_service";
import { StreamHelpers } from "../helpers/stream_helpers";
import { FeedName } from "../constants/default_feeds";
import { ProfileService } from "../services/profile_service";
import { ProfileJSON } from "../dto/profile";
import { ConversationService } from "../services/conversation_service";
import { RelationshipService } from "../services/relationship_service";
import { RelationshipJSON } from "../dto/relationships";
import { SecurityHelpers } from "../helpers/security_helpers";
import { ProfileStatisticsService } from "../services/profile_statistics_service";
import { FeedStatisticsService } from "../services/feed_statistics_service";
import { SearchService } from "../services/search_service";
import { SystemService } from "../services/system_service";
import { CacheService } from "../services/cache_service";
import { PostMentionNotification } from "../services/builders/notifications/activities/post_mention_notification";
import { MentionJSON } from "../dto/mentions";
import { PostSharedNotification } from "../services/builders/notifications/activities/post_shared_notification";

export namespace PostEndpoints {
  export const listActivities = functions
    .region("europe-west3")
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA_1G)
    .https.onCall(async (request: EndpointRequest, context) => {
      await SystemService.validateUsingRedisUserThrottle(context);
      const uid = context.auth?.uid || "";

      const targetUserId = request.data.targetUserId || "";
      const targetSlug = request.data.targetSlug || "";
      const limit = request.limit || 25;
      const cursor = request.cursor || "";
      const shouldPersonalize = request.data.shouldPersonalize || false;

      functions.logger.info(`Listing activities`, { uid, targetUserId, targetSlug, limit, cursor });
      if (!targetSlug || targetSlug.length === 0 || !targetUserId || targetUserId.length === 0) {
        throw new functions.https.HttpsError("invalid-argument", "Feed and slug must be provided");
      }

      const feedsClient = FeedService.getFeedsClient();
      const activities = [] as ActivityJSON[];
      const windowIds = [] as string[];

      let next = cursor;
      let unread = 0;
      let unseen = 0;

      if (shouldPersonalize) {
        const response = await feedsClient.personalization.get("personalized_feed", { user_id: uid, feed_slug: targetSlug, id_lt: cursor, limit: limit.toString() });
        const window = await FeedService.getPersonalizedFeedWindow(uid, response, limit);
        const activitiesResponse = (await ActivitiesService.getActivityFeedWindow(window.results)) as ActivityJSON[];

        activities.push(...activitiesResponse);
        windowIds.push(...window.results.map((result) => result.id));
        next = window.next;
      } else {
        const feed = feedsClient.feed(targetSlug, targetUserId);
        const window = await FeedService.getFeedWindow(uid, feed, limit, cursor);
        const activitiesResponse = (await ActivitiesService.getActivityFeedWindow(window.results)) as ActivityJSON[];

        activities.push(...activitiesResponse);
        windowIds.push(...window.results.map((result) => result.id));
        next = window.next;
        unread = window.unread;
        unseen = window.unseen;
      }

      // Convert window results to a list of IDs
      const paginationToken = StreamHelpers.extractPaginationToken(next);

      // We supply this so we can support reposts and the client can filter out the nested activity
      const feedStatisticsKey = FeedStatisticsService.getExpectedKeyFromOptions(targetSlug, targetUserId);

      functions.logger.info(`Got activities`, { activities, paginationToken, windowIds, shouldPersonalize });
      return buildEndpointResponse(context, {
        sender: uid,
        joins: [feedStatisticsKey],
        data: [...activities],
        limit: limit,
        cursor: paginationToken,
        seedData: {
          next: paginationToken,
          unread: unread,
          unseen: unseen,
          windowIds,
        },
      });
    });

  export const getActivity = functions
    .region("europe-west3")
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (request: EndpointRequest, context) => {
      await SystemService.validateUsingRedisUserThrottle(context);
      const entry = request.data.entry || "";
      if (!entry) {
        throw new functions.https.HttpsError("invalid-argument", "Missing entry");
      }

      functions.logger.info(`Getting activity: ${entry}`);
      const activity = await DataService.getDocument({
        schemaKey: "activities",
        entryId: entry as string,
      });

      return buildEndpointResponse(context, {
        sender: request.sender,
        data: [activity],
      });
    });

  export const shareActivityToConversations = functions
    .region("europe-west3")
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (request: EndpointRequest, context) => {
      await SystemService.validateUsingRedisUserThrottle(context);
      functions.logger.info(`Sharing activity`, { request });

      const uid = await UserService.verifyAuthenticated(context, request.sender);
      const activityId = request.data.activityId || "";
      const targets = request.data.targets || ([] as string[]);

      const title = request.data.title || "";
      const description = request.data.description || "";

      if (!activityId) {
        throw new functions.https.HttpsError("invalid-argument", "Missing activity or feed");
      }

      if (!targets || targets.length === 0) {
        throw new functions.https.HttpsError("invalid-argument", "Missing targets");
      }

      if (!title || !description) {
        throw new functions.https.HttpsError("invalid-argument", "Missing title or description");
      }

      const profiles = (await ProfileService.getMultipleProfiles(targets)) as ProfileJSON[];
      const filteredProfiles = profiles.filter((profile) => profile?._fl_meta_?.fl_id && profile?._fl_meta_?.fl_id !== uid);
      const relationships = (await Promise.all(filteredProfiles.map((profile) => RelationshipService.getRelationship([uid, profile._fl_meta_!.fl_id!])))) as RelationshipJSON[];

      // Check all relationships are connected
      const hasUnconnectedRelationships = relationships.some((relationship) => relationship?.connected !== true);
      if (hasUnconnectedRelationships) {
        throw new functions.https.HttpsError("permission-denied", "Cannot share with unconnected users");
      }

      const streamClient = ConversationService.getStreamChatInstance();
      const conversations = await ConversationService.getOneOnOneChannels(streamClient, uid, targets);
      await ConversationService.sendBulkMessage(conversations, uid, title, description);

      const newStats = await ProfileStatisticsService.updateReactionCountForProfile(uid, "share", 1);

      return buildEndpointResponse(context, {
        sender: uid,
        data: [newStats],
      });
    });

  export const postActivity = functions
    .region("europe-west3")
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA_256)
    .https.onCall(async (request: EndpointRequest, context) => {
      await SystemService.validateUsingRedisUserThrottle(context);
      functions.logger.info(`Posting activity`, { request });

      const uid = await UserService.verifyAuthenticated(context, request.sender);
      const content = request.data.content || "";
      const media = request.data.media || ([] as MediaJSON[]);
      const userTags = request.data.tags || ([] as string[]);
      const promotionKey = request.data.promotionKey || ("" as string);
      const mentions = ((request.data.mentions || []) as MentionJSON[]) || ([] as MentionJSON[]);

      functions.logger.info(`Posting activity`, { uid, content, media, userTags, mentions });

      const feed = request.data.feed || FeedName.User;
      const type = request.data.type || TagsService.PostTypeTag.post;
      const style = request.data.style;

      // Check the type is a valid PostTypeTag
      const validPostTypeTags = Object.values(TagsService.PostTypeTag);
      const isValidPostTypeTag = validPostTypeTags.includes(type);
      if (!isValidPostTypeTag) {
        throw new functions.https.HttpsError("invalid-argument", "Invalid post type");
      }

      const allowSharing = request.data.allowSharing ? "public" : ("private" as ActivitySecurityConfigurationMode);
      const visibleTo = request.data.visibleTo || ("public" as ActivitySecurityConfigurationMode);
      const allowComments = request.data.allowComments || ("public" as ActivitySecurityConfigurationMode);

      const repostTargetActivityId = request.data.reposterActivityId || "";
      let repostTargetActivityOriginFeed = "";
      let repostTargetActivityPublisherId = "";

      const isRepost = repostTargetActivityId && repostTargetActivityId.length > 0;
      if (isRepost) {
        const originalActivity = (await ActivitiesService.getActivity(repostTargetActivityId)) as ActivityJSON;
        if (!originalActivity) {
          throw new functions.https.HttpsError("not-found", "Original activity not found");
        }

        repostTargetActivityOriginFeed = originalActivity.publisherInformation?.originFeed || "";
        repostTargetActivityPublisherId = originalActivity.publisherInformation?.publisherId || "";

        const relationship = (await RelationshipService.getRelationship([uid, repostTargetActivityPublisherId], true)) as RelationshipJSON;
        const shareMode = originalActivity.securityConfiguration?.shareMode || "disabled";
        const canActOnRepost = SecurityHelpers.canActOnActivity(originalActivity, relationship, uid, shareMode);

        if (!canActOnRepost) {
          throw new functions.https.HttpsError("permission-denied", "User cannot share activity");
        }
      }

      if (!allowComments || !allowSharing || !visibleTo) {
        throw new functions.https.HttpsError("invalid-argument", "Missing security configuration");
      }

      functions.logger.info(`Posting activity`, { uid, content, media, userTags, mentions });
      const hasContentOrMedia = content || media.length > 0;
      if (!hasContentOrMedia) {
        throw new functions.https.HttpsError("invalid-argument", "Content missing from activity");
      }

      const publisherProfile = (await ProfileService.getProfile(uid)) as ProfileJSON;
      if (!publisherProfile) {
        throw new functions.https.HttpsError("not-found", "Profile not found");
      }

      let promotion: any;
      if (promotionKey) {
        promotion = await ActivitiesService.getPromotion(promotionKey);
        if (!promotion) {
          throw new functions.https.HttpsError("invalid-argument", "Invalid promotion key");
        }
      }

      const isPromotion = promotionKey && promotionKey.length > 0;
      const availablePromotionsCount = publisherProfile.availablePromotionsCount || 0;
      if (isPromotion && availablePromotionsCount <= 0) {
        throw new functions.https.HttpsError("invalid-argument", "No promotions available");
      }

      let validatedTags = TagsService.removeRestrictedTagsFromStringArray(userTags, promotionKey.length > 0);
      validatedTags = TagsService.appendActivityTagsToTags(visibleTo, validatedTags, type);
      const tagObjects = await TagsService.getOrCreateTags(validatedTags);

      functions.logger.info(`Got validated tags`, { validatedTags });
      const mediaBucketPaths = StorageService.getBucketPathsFromMediaArray(media);
      await StorageService.verifyMediaPathsContainsData(mediaBucketPaths);

      if (!type || !style) {
        throw new functions.https.HttpsError("invalid-argument", "Missing type or style");
      }

      //? For each mentionedUser attempt get the users ID and prepare to notify
      const sanitizedMentions = await ActivitiesService.sanitizeMentions(publisherProfile, content, visibleTo, mentions);
      const uniqueMentions = sanitizedMentions.filter((mention, index, self) => index === self.findIndex((t) => t.label === mention.label));

      functions.logger.info(`Got sanitized mentions`, { sanitizedMentions, uniqueMentions });

      const activityRequest = {
        publisherInformation: {
          publisherId: uid,
          originFeed: `${feed}:${uid}`,
        },
        generalConfiguration: {
          content: content,
          style: style,
          type: type,
        },
        enrichmentConfiguration: {
          tags: validatedTags,
          promotionKey: promotionKey,
          mentions: sanitizedMentions,
        },
        securityConfiguration: {
          viewMode: visibleTo,
          commentMode: allowComments,
          shareMode: allowSharing,
        },
        repostConfiguration: {
          targetActivityId: repostTargetActivityId,
          targetActivityOriginFeed: repostTargetActivityOriginFeed,
          targetActivityPublisherId: repostTargetActivityPublisherId,
        },
        media: media,
      } as ActivityJSON;

      // Add a search description to the activity so that it can be found in flamelink
      activityRequest.searchDescription = ActivitiesService.generateFlamelinkDescription(activityRequest, publisherProfile);

      const userActivity = await ActivitiesService.postActivity(uid, feed, activityRequest);
      await ActivitiesService.updateTagFeedsForActivity(userActivity);

      const newProfileStats = await ProfileStatisticsService.updateReactionCountForProfile(uid, "post", 1);

      // Deduct a promotion from the profile if the activity was promoted
      if (isPromotion) {
        await ProfileService.increaseAvailablePromotedCountsForProfile(publisherProfile, -1);
      }

      for (let index = 0; index < uniqueMentions.length; index++) {
        const mention = uniqueMentions[index];
        const foreignKey = mention.foreignKey;
        if (!foreignKey) {
          continue;
        }

        const mentionedProfile = (await ProfileService.getProfile(foreignKey)) as ProfileJSON;
        if (!mentionedProfile) {
          continue;
        }

        functions.logger.info(`Sending notification to mentioned user`, { mentionedProfile });
        await PostMentionNotification.sendNotification(publisherProfile, mentionedProfile, userActivity);
      }

      if (repostTargetActivityPublisherId) {
        const targetProfile = (await ProfileService.getProfile(repostTargetActivityPublisherId)) as ProfileJSON;
        if (targetProfile) {
          functions.logger.info(`Sending notification to repost target`, { targetProfile });
          await PostSharedNotification.sendNotification(publisherProfile, targetProfile, userActivity);
        }
      }

      functions.logger.info("Posted user activity", { feedActivity: userActivity });
      return buildEndpointResponse(context, {
        sender: uid,
        data: [userActivity, ...tagObjects, promotion, newProfileStats],
      });
    });

  export const deleteActivity = functions
    .region("europe-west3")
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (request: EndpointRequest, context) => {
      await SystemService.validateUsingRedisUserThrottle(context);
      const uid = await UserService.verifyAuthenticated(context, request.sender);
      const activityId = request.data.activityId || "";

      if (!activityId) {
        throw new functions.https.HttpsError("invalid-argument", "Missing activityId");
      }

      const activity = (await DataService.getDocument({
        schemaKey: "activities",
        entryId: activityId,
      })) as ActivityJSON;

      if (!activity) {
        throw new functions.https.HttpsError("not-found", "Activity not found");
      }

      if (activity.publisherInformation?.publisherId !== uid) {
        throw new functions.https.HttpsError("permission-denied", "User does not own activity");
      }

      const publisherId = activity.publisherInformation?.publisherId || "";
      const publisherProfile = (await ProfileService.getProfile(publisherId)) as ProfileJSON;
      if (!publisherProfile) {
        throw new functions.https.HttpsError("not-found", "Profile not found");
      }

      // Give the profile back a promotion if the activity was promoted
      const isPromotion = activity.enrichmentConfiguration?.promotionKey && activity.enrichmentConfiguration?.promotionKey.length > 0;
      if (isPromotion) {
        await ProfileService.increaseAvailablePromotedCountsForProfile(publisherProfile, 1);
      }

      // Remove all tags and the promotion key so that the activity can correctly sync its feeds
      activity.enrichmentConfiguration ??= {};
      activity.enrichmentConfiguration.tags = [];
      activity.enrichmentConfiguration.promotionKey = "";

      const streamClient = FeedService.getFeedsClient();

      await ActivitiesService.updateTagFeedsForActivity(activity);
      await ActivitiesService.removeActivityFromFeed("user", uid, activityId, streamClient);

      await DataService.deleteDocument({
        schemaKey: "activities",
        entryId: activityId,
      });

      functions.logger.info("Deleted user activity", { feedActivity: activity });
      const newStats = await ProfileStatisticsService.updateReactionCountForProfile(uid, "post", -1);

      const searchClient = SearchService.getAlgoliaClient();
      const index = SearchService.getIndex(searchClient, "activities");
      await SearchService.deleteDocumentInIndex(index, activityId);
      functions.logger.info("Deleted activity from search index", { activityId });

      await CacheService.deleteFromCache(activityId);
      functions.logger.info("Deleted activity from cache", { activityId });

      return buildEndpointResponse(context, {
        sender: uid,
        data: [activity, newStats],
      });
    });

  export const updateActivity = functions
    .region("europe-west3")
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA_256)
    .https.onCall(async (request: EndpointRequest, context) => {
      await SystemService.validateUsingRedisUserThrottle(context);
      functions.logger.info(`Updating activity`, { request });
      const uid = await UserService.verifyAuthenticated(context, request.sender);

      const activityId = request.data.postId || ("" as string);
      const content = request.data.content || "";

      const media = request.data.media || ([] as MediaJSON[]);
      const userTags = request.data.tags || ([] as string[]);
      const promotionKey = request.data.promotionKey || ("" as string);

      const allowSharing = request.data.allowSharing ? "public" : ("disabled" as ActivitySecurityConfigurationMode);
      const visibleTo = request.data.visibleTo || ("public" as ActivitySecurityConfigurationMode);
      const allowComments = request.data.allowComments || ("disabled" as ActivitySecurityConfigurationMode);

      const allowLikes = request.data.allowLikes || ("disabled" as ActivitySecurityConfigurationMode);
      const allowBookmarks = request.data.allowBookmarks || ("disabled" as ActivitySecurityConfigurationMode);

      const mentions = request.data.mentions || ([] as MentionJSON[]) || ([] as MentionJSON[]) || ([] as MentionJSON[]);

      if (!allowComments || !allowSharing || !visibleTo) {
        throw new functions.https.HttpsError("invalid-argument", "Missing security configuration");
      }

      if (!activityId) {
        throw new functions.https.HttpsError("invalid-argument", "Missing activityId");
      }

      let activity = (await DataService.getDocument({
        schemaKey: "activities",
        entryId: activityId,
      })) as ActivityJSON;

      if (!activity) {
        throw new functions.https.HttpsError("not-found", "Activity not found");
      }

      if (activity.publisherInformation?.publisherId !== uid) {
        throw new functions.https.HttpsError("permission-denied", "User does not own activity");
      }

      let promotion: any;
      if (promotionKey) {
        promotion = await ActivitiesService.getPromotion(promotionKey);
        if (!promotion) {
          throw new functions.https.HttpsError("invalid-argument", "Invalid promotion key");
        }
      }

      const publisherProfile = (await ProfileService.getProfile(uid)) as ProfileJSON;
      if (!publisherProfile) {
        throw new functions.https.HttpsError("not-found", "Profile not found");
      }

      functions.logger.info(`Updating activity`, { uid, content, media, userTags, activityId });
      const hasContentOrMedia = content || media.length > 0 || userTags.length > 0 || activity?.repostConfiguration?.targetActivityId;
      if (!hasContentOrMedia) {
        throw new functions.https.HttpsError("invalid-argument", "Content missing from activity");
      }

      const type = TagsService.postTypeFromActivityGeneralConfigurationJSON(activity.generalConfiguration?.type || "post");

      // validate updated set of tags and replace activity tags
      // Validated tags are the new tags provided by the user, minus any restricted tags
      let validatedTags = TagsService.removeRestrictedTagsFromStringArray(userTags, promotionKey.length > 0);
      validatedTags = TagsService.appendActivityTagsToTags(visibleTo, validatedTags, type);
      const tagObjects = await TagsService.getOrCreateTags(validatedTags);

      functions.logger.info(`Got validated tags`, { validatedTags });
      if (validatedTags) {
        activity.enrichmentConfiguration!.tags = validatedTags;
      }

      if (promotionKey) {
        // the promotion key goes in the enrichment when there is one
        activity.enrichmentConfiguration!.promotionKey = promotionKey;
      } else {
        // otherwise we remove it
        activity.enrichmentConfiguration!.promotionKey = "";
      }

      // Update remaining fields
      if (content) {
        activity.generalConfiguration!.content = content;
      }

      if (media) {
        activity.media = media;
      }

      if (!activity.securityConfiguration) {
        activity.securityConfiguration = {};
      }

      activity.securityConfiguration.viewMode = visibleTo;
      activity.securityConfiguration.shareMode = allowSharing;
      activity.securityConfiguration.commentMode = allowComments;
      activity.securityConfiguration.likesMode = allowLikes;
      activity.securityConfiguration.bookmarksMode = allowBookmarks;

      const mediaBucketPaths = StorageService.getBucketPathsFromMediaArray(media);
      await StorageService.verifyMediaPathsContainsData(mediaBucketPaths);

      //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
      //* -=-=-=-=-=-                   Mentions                   -=-=-=-=-=- *\\
      //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
      //? For each mentionedUser attempt get the users ID and prepare to notify
      const sanitizedMentions = await ActivitiesService.sanitizeMentions(publisherProfile, content, visibleTo, mentions);
      const uniqueMentions = sanitizedMentions.filter((mention, index, self) => index === self.findIndex((t) => t.label === mention.label));

      functions.logger.info(`Got sanitized mentions`, { sanitizedMentions, uniqueMentions });
      const oldMentions = [...(activity.enrichmentConfiguration?.mentions || [])];

      if (activity.enrichmentConfiguration) {
        activity.enrichmentConfiguration.mentions = sanitizedMentions;
      } else {
        activity.enrichmentConfiguration = {
          mentions: sanitizedMentions,
        };
      }

      activity = await DataService.updateDocument({
        schemaKey: "activities",
        entryId: activityId,
        data: activity,
      });

      await ActivitiesService.updateTagFeedsForActivity(activity);

      for (let index = 0; index < uniqueMentions.length; index++) {
        const mention = uniqueMentions[index];
        const foreignKey = mention.foreignKey;
        if (!foreignKey) {
          continue;
        }

        const mentionedProfile = (await ProfileService.getProfile(foreignKey)) as ProfileJSON;
        if (!mentionedProfile) {
          continue;
        }

        // If the mention already exists, skip it
        const existingMention = oldMentions.find((oldMention) => oldMention.foreignKey === foreignKey);
        if (existingMention) {
          continue;
        }

        functions.logger.info(`Sending notification to mentioned user`, { mentionedProfile });
        await PostMentionNotification.sendNotification(publisherProfile, mentionedProfile, activity);
      }

      functions.logger.info("Updated user activity", { feedActivity: activity });
      return buildEndpointResponse(context, {
        sender: uid,
        data: [activity, ...tagObjects, promotion],
      });
    });
}
