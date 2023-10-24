import * as functions from "firebase-functions";

import { FIREBASE_FUNCTION_INSTANCE_DATA, FIREBASE_FUNCTION_INSTANCE_DATA_1G } from "../constants/domain";

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

export namespace PostEndpoints {
    export const listActivities = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA_1G).https.onCall(async (request: EndpointRequest, context) => {
        const uid = await UserService.verifyAuthenticated(context, request.sender);

        const targetUserId = request.data.targetUserId || "";
        const targetSlug = request.data.targetSlug || "";
        const limit = request.limit || 25;
        const cursor = request.cursor || "";

        functions.logger.info(`Listing activities`, { uid, targetUserId, targetSlug, limit, cursor });

        if (!targetSlug || targetSlug.length === 0 || !targetUserId || targetUserId.length === 0) {
          throw new functions.https.HttpsError("invalid-argument", "Feed and slug must be provided");
        }
    
        const feedsClient = FeedService.getFeedsClient();
        const feed = feedsClient.feed(targetSlug, targetUserId);
        const window = await FeedService.getFeedWindow(uid, feed, limit, cursor);
    
        // Convert window results to a list of IDs
        const activities = await ActivitiesService.getActivityFeedWindow(window.results) as ActivityJSON[];
        const paginationToken = StreamHelpers.extractPaginationToken(window.next);

        // We supply this so we can support reposts and the client can filter out the nested activity
        const windowIds = activities.map((activity: ActivityJSON) => activity?._fl_meta_?.fl_id || "");

        // Get promotions from activities where the promotion key is set
        let promotionIds = activities.filter((activity) => activity?.enrichmentConfiguration?.promotionKey).map((activity) => activity?.enrichmentConfiguration?.promotionKey || "");
        promotionIds = [...new Set(promotionIds)].filter((promotionId) => promotionId.length > 0);
        const promotionKeys = promotionIds.map((promotionId) => `promotions_${promotionId}`);

        const feedStatisticsKey = FeedStatisticsService.getExpectedKeyFromOptions(targetSlug, targetUserId);

        functions.logger.info(`Got activities`, { activities, paginationToken, windowIds });
    
        return buildEndpointResponse(context, {
          sender: uid,
          joins: [feedStatisticsKey, ...promotionKeys],
          data: [...activities],
          limit: limit,
          cursor: paginationToken,
          seedData: {
            next: paginationToken,
            unread: window.unread,
            unseen: window.unseen,
            windowIds,
          },
        });
      });
      
  export const getActivity = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
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


  export const shareActivityToFeed = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);
    const activityId = request.data.activityId || "";

    if (!activityId) {
      throw new functions.https.HttpsError("invalid-argument", "Missing activity or feed");
    }

    const activity = await ActivitiesService.getActivity(activityId) as ActivityJSON;
    const activityOriginFeed = activity.publisherInformation?.originFeed || "";
    const activityOriginPosterId = activity.publisherInformation?.publisherId || "";
    const activityPromotionKey = activity.enrichmentConfiguration?.promotionKey;
    if (!activity || !activityOriginFeed || !activityOriginPosterId) {
      throw new functions.https.HttpsError("not-found", "Activity not found");
    }

    const profile = await ProfileService.getProfile(uid) as ProfileJSON;
    if (!profile) {
      throw new functions.https.HttpsError("not-found", "Profile not found");
    }

    const isRepost = activity.generalConfiguration?.type === "repost";
    if (isRepost) {
      throw new functions.https.HttpsError("invalid-argument", "Cannot share a repost");
    }

    const relationship = await RelationshipService.getRelationship([uid, activityOriginPosterId], true) as RelationshipJSON;
    const shareMode = activity.securityConfiguration?.shareMode || "disabled";
    const canAct = SecurityHelpers.canActOnActivity(activity, relationship, uid, shareMode);

    if (!canAct) {
      throw new functions.https.HttpsError("permission-denied", "User cannot share activity");
    }

    const isPromotion = (activityPromotionKey && activityPromotionKey.length > 0) || false;
    const validatedTags = TagsService.removeRestrictedTagsFromStringArray(activity.enrichmentConfiguration?.tags || [], isPromotion);
    const tagObjects = await TagsService.getOrCreateTags(validatedTags);

    const activityRequest = {
      searchDescription: ActivitiesService.generateFlamelinkDescription(activity, profile),
      publisherInformation: {
        publisherId: uid,
        originFeed: `${FeedName.User}:${uid}`,
      },
      generalConfiguration: {
        type: "repost",
        repostActivityId: activityId,
        repostActivityPublisherId: activityOriginPosterId,
        repostActivityOriginFeed: activityOriginFeed,
      },
      enrichmentConfiguration: {
        tags: validatedTags,
        promotionKey: activityPromotionKey,
      },
      securityConfiguration: {
        viewMode: "public",
        commentMode: "public",
        shareMode: "public",
      },
    } as ActivityJSON;

    const userActivity = await ActivitiesService.postActivity(uid, FeedName.User, activityRequest);
    await ActivitiesService.updateTagFeedsForActivity(userActivity);

    await ProfileStatisticsService.updateReactionCountForProfile(uid, "share", 1);
    
    functions.logger.info("Posted user activity", { feedActivity: userActivity });
    return buildEndpointResponse(context, {
      sender: uid,
      data: [userActivity, ...tagObjects],
    });
  });

  export const shareActivityToConversations = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    functions.logger.info(`Sharing activity`, { request });
    
    const uid = await UserService.verifyAuthenticated(context, request.sender);
    const activityId = request.data.activityId || "";
    const targets = request.data.targets || [] as string[];

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

    const profiles = await ProfileService.getMultipleProfiles(targets) as ProfileJSON[];
    const filteredProfiles = profiles.filter((profile) => profile?._fl_meta_?.fl_id && profile?._fl_meta_?.fl_id !== uid);
    const relationships = await Promise.all(filteredProfiles.map((profile) => RelationshipService.getRelationship([uid, profile._fl_meta_!.fl_id!]))) as RelationshipJSON[];

    // Check all relationships are connected
    const hasUnconnectedRelationships = relationships.some((relationship) => relationship?.connected !== true);
    if (hasUnconnectedRelationships) {
      throw new functions.https.HttpsError("permission-denied", "Cannot share with unconnected users");
    }

    const streamClient = ConversationService.getStreamChatInstance();
    const conversations = await ConversationService.getOneOnOneChannels(streamClient, uid, targets);
    await ConversationService.sendBulkMessage(conversations, uid, title, description);

    await ProfileStatisticsService.updateReactionCountForProfile(uid, "share", 1);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [],
    });
  });

  export const postActivity = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    functions.logger.info(`Posting activity`, { request });

    const uid = await UserService.verifyAuthenticated(context, request.sender);
    const content = request.data.content || "";
    const media = request.data.media || [] as MediaJSON[];
    const userTags = request.data.tags || [] as string[];
    const promotionKey = request.data.promotionKey || "" as string;

    const feed = request.data.feed || FeedName.User;
    const type = request.data.type;
    const style = request.data.style;

    const allowSharing = request.data.allowSharing ? "public" : "private" as ActivitySecurityConfigurationMode;
    const visibleTo = request.data.visibleTo || "public" as ActivitySecurityConfigurationMode;
    const allowComments = request.data.allowComments || "public" as ActivitySecurityConfigurationMode;

    if (!allowComments || !allowSharing || !visibleTo) {
      throw new functions.https.HttpsError("invalid-argument", "Missing security configuration");
    }

    functions.logger.info(`Posting activity`, { uid, content, media, userTags });
    const hasContentOrMedia = content || media.length > 0;
    if (!hasContentOrMedia) {
      throw new functions.https.HttpsError("invalid-argument", "Content missing from activity");
    }

    const publisherProfile = await ProfileService.getProfile(uid) as ProfileJSON;
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

    const validatedTags = TagsService.removeRestrictedTagsFromStringArray(userTags, promotionKey.length > 0);
    const tagObjects = await TagsService.getOrCreateTags(validatedTags);

    functions.logger.info(`Got validated tags`, { validatedTags });

    const mediaBucketPaths = StorageService.getBucketPathsFromMediaArray(media);
    await StorageService.verifyMediaPathsContainsData(mediaBucketPaths);

    if (!type || !style) {
      throw new functions.https.HttpsError("invalid-argument", "Missing type or style");
    }

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
      },
      securityConfiguration: {
        viewMode: visibleTo,
        commentMode: allowComments,
        shareMode: allowSharing,
      },
      media: media,
    } as ActivityJSON;

    // Add a search description to the activity so that it can be found in flamelink
    activityRequest.searchDescription = ActivitiesService.generateFlamelinkDescription(activityRequest, publisherProfile);

    const userActivity = await ActivitiesService.postActivity(uid, feed, activityRequest);
    await ActivitiesService.updateTagFeedsForActivity(userActivity);

    await ProfileStatisticsService.updateReactionCountForProfile(uid, "post", 1);

    // Deduct a promotion from the profile if the activity was promoted
    if (isPromotion) {
      await ProfileService.increaseAvailablePromotedCountsForProfile(publisherProfile, -1);
    }
    
    functions.logger.info("Posted user activity", { feedActivity: userActivity });
    return buildEndpointResponse(context, {
      sender: uid,
      data: [userActivity, ...tagObjects, promotion],
    });
  });

  export const deleteActivity = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);
    const activityId = request.data.activityId || "";

    if (!activityId) {
      throw new functions.https.HttpsError("invalid-argument", "Missing activityId");
    }

    const activity = await DataService.getDocument({
      schemaKey: "activities",
      entryId: activityId,
    }) as ActivityJSON;

    if (!activity) {
      throw new functions.https.HttpsError("not-found", "Activity not found");
    }

    if (activity.publisherInformation?.publisherId !== uid) {
      throw new functions.https.HttpsError("permission-denied", "User does not own activity");
    }

    const publisherId = activity.publisherInformation?.publisherId || "";
    const publisherProfile = await ProfileService.getProfile(publisherId) as ProfileJSON;
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
    await ProfileStatisticsService.updateReactionCountForProfile(uid, "post", -1);

    const searchClient = SearchService.getAlgoliaClient();
    const index = SearchService.getIndex(searchClient, "activities");
    await SearchService.deleteDocumentInIndex(index, activityId);
    functions.logger.info("Deleted activity from search index", { activityId });

    return buildEndpointResponse(context, {
      sender: uid,
      data: [activity],
    });
  });

  export const updateActivity = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    functions.logger.info(`Updating activity`, { request });
    const uid = await UserService.verifyAuthenticated(context, request.sender);

    const activityId = request.data.postId || "" as string;
    const content = request.data.content || "";

    const media = request.data.media || [] as MediaJSON[];
    const userTags = request.data.tags || [] as string[];
    const promotionKey = request.data.promotionKey || "" as string;

    const allowSharing = request.data.allowSharing ? "public" : "disabled" as ActivitySecurityConfigurationMode;
    const visibleTo = request.data.visibleTo || "public" as ActivitySecurityConfigurationMode;
    const allowComments = request.data.allowComments || "disabled" as ActivitySecurityConfigurationMode;
    
    const allowLikes = request.data.allowLikes || "disabled" as ActivitySecurityConfigurationMode;
    const allowBookmarks = request.data.allowBookmarks || "disabled" as ActivitySecurityConfigurationMode;

    if (!allowComments || !allowSharing || !visibleTo) {
      throw new functions.https.HttpsError("invalid-argument", "Missing security configuration");
    }

    if (!activityId) {
      throw new functions.https.HttpsError("invalid-argument", "Missing activityId");
    }

    let activity = await DataService.getDocument({
      schemaKey: "activities",
      entryId: activityId,
    }) as ActivityJSON;

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

    functions.logger.info(`Updating activity`, { uid, content, media, userTags, activityId });
    const hasContentOrMedia = content || media.length > 0 || userTags.length > 0 || activity?.repostConfiguration?.targetActivityId;
    if (!hasContentOrMedia) {
      throw new functions.https.HttpsError("invalid-argument", "Content missing from activity");
    }

    // validate updated set of tags and replace activity tags
    // Validated tags are the new tags provided by the user, minus any restricted tags
    const validatedTags = TagsService.removeRestrictedTagsFromStringArray(userTags, promotionKey.length > 0);
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

    activity = await DataService.updateDocument({
      schemaKey: "activities",
      entryId: activityId,
      data: activity,
    });

    await ActivitiesService.updateTagFeedsForActivity(activity);

    functions.logger.info("Updated user activity", { feedActivity: activity });
    return buildEndpointResponse(context, {
      sender: uid,
      data: [activity, ...tagObjects, promotion],
    });
  });
}
