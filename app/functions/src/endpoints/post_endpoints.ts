import * as functions from "firebase-functions";

import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";

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
import { ReactionStatisticsService } from "../services/reaction_statistics_service";

export namespace PostEndpoints {
    export const listActivities = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
        const uid = context.auth?.uid || "";
        const feedId = request.data.feed || "";
        const slugId = request.data.options?.slug || "";
        const limit = request.limit || 25;
        const cursor = request.cursor || "";

        functions.logger.info(`Listing activities`, { uid, feedId, slugId, limit, cursor });

        if (!feedId || feedId.length === 0 || !slugId || slugId.length === 0) {
          throw new functions.https.HttpsError("invalid-argument", "Feed and slug must be provided");
        }
    
        const feedsClient = FeedService.getFeedsClient();
        const feed = feedsClient.feed(feedId, slugId);
        const origin = StreamHelpers.getOriginFromFeed(feed);
        const window = await FeedService.getFeedWindow(uid, feed, limit, cursor);
    
        // Convert window results to a list of IDs
        let activities = await ActivitiesService.getActivityFeedWindow(window.results);
        const statistics = await ReactionStatisticsService.getReactionStatisticsForActivityArray(activities);
        const reactions = await ReactionStatisticsService.getUniqueReactionsForUserInFeedActivity(origin, uid, statistics);
        activities = ActivitiesService.enrichActivitiesWithReactionStatistics(activities, statistics);
        activities = ActivitiesService.enrichActivitiesWithUniqueReactions(activities, reactions);

        const paginationToken = StreamHelpers.extractPaginationToken(window.next);
    
        return buildEndpointResponse(context, {
          sender: uid,
          data: [...activities, ...statistics, ...reactions],
          limit: limit,
          cursor: paginationToken,
          seedData: {
            next: paginationToken,
            unread: window.unread,
            unseen: window.unseen,
          },
        });
      });
      
  export const getActivity = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
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


  export const shareActivityToFeed = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);
    const activityId = request.data.activityId || "";
    const feed = request.data.feed || FeedName.User;

    if (!activityId || !feed) {
      throw new functions.https.HttpsError("invalid-argument", "Missing activity or feed");
    }

    const activity = await ActivitiesService.getActivity(activityId) as ActivityJSON;
    if (!activity || !activity.publisherInformation?.publisherId) {
      throw new functions.https.HttpsError("not-found", "Activity not found");
    }

    const isConnected = RelationshipService.isConnected([uid, activity.publisherInformation?.publisherId || '']);
    const isPublic = activity.securityConfiguration?.shareMode === "public";
    const isConnections = activity.securityConfiguration?.shareMode?.includes("connections");

    if (!isPublic || (isConnections && !isConnected)) {
      throw new functions.https.HttpsError("permission-denied", "Cannot share with unconnected users");
    }

    const streamClient = FeedService.getFeedsUserClient(uid);
    const senderUserFeed = streamClient.feed(feed, uid);
    
    await FeedService.shareActivityToFeed(uid, senderUserFeed, activity);
    functions.logger.info(`Shared activity to feed`, { uid, activityId, feed });

    return buildEndpointResponse(context, {
      sender: uid,
      data: [],
    });
  });

  export const shareActivityToConversations = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    functions.logger.info(`Sharing activity`, { request });
    
    const uid = await UserService.verifyAuthenticated(context, request.sender);
    const activityId = request.data.activityId || "";
    const feed = request.data.feed || FeedName.User;
    const targets = request.data.targets || [] as string[];

    const title = request.data.title || "";
    const description = request.data.description || "";

    if (!activityId || !feed) {
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

    return buildEndpointResponse(context, {
      sender: uid,
      data: [],
    });
  });

  export const postActivity = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    functions.logger.info(`Posting activity`, { request });

    const uid = await UserService.verifyAuthenticated(context, request.sender);
    const content = request.data.content || "";
    const media = request.data.media || [] as MediaJSON[];
    const userTags = request.data.tags || [] as string[];

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

    const validatedTags = TagsService.removeRestrictedTagsFromStringArray(userTags);
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
      },
      securityConfiguration: {
        viewMode: visibleTo,
        commentMode: allowComments,
        shareMode: allowSharing,
      },
      media: media,
    } as ActivityJSON;

    const userActivity = await ActivitiesService.postActivity(uid, feed, activityRequest);
    await ActivitiesService.updateTagFeedsForActivity(userActivity);
    
    functions.logger.info("Posted user activity", { feedActivity: userActivity });
    return buildEndpointResponse(context, {
      sender: uid,
      data: [userActivity, ...tagObjects],
    });
  });

  export const deleteActivity = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
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

    await ActivitiesService.updateTagFeedsForActivity(activity);
    await ActivitiesService.removeActivityFromFeed("user", uid, activityId);

    await DataService.deleteDocument({
      schemaKey: "activities",
      entryId: activityId,
    });
  });

  export const updateActivity = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    functions.logger.info(`Updating activity`, { request });
    const uid = await UserService.verifyAuthenticated(context, request.sender);

    const activityId = request.data.postId || "" as string;
    const content = request.data.content || "";
    const media = request.data.media || [] as MediaJSON[];
    const userTags = request.data.tags || [] as string[];

    const allowSharing = request.data.allowSharing ? "public" : "private" as ActivitySecurityConfigurationMode;
    const visibleTo = request.data.visibleTo || "public" as ActivitySecurityConfigurationMode;
    const allowComments = request.data.allowComments || "public" as ActivitySecurityConfigurationMode;
    
    const allowLikes = request.data.allowLikes || "public" as ActivitySecurityConfigurationMode;
    const allowBookmarks = request.data.allowBookmarks || "public" as ActivitySecurityConfigurationMode;

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

    functions.logger.info(`Updating activity`, { uid, content, media, userTags, activityId });
    const hasContentOrMedia = content || media.length > 0 || userTags.length > 0;
    if (!hasContentOrMedia) {
      throw new functions.https.HttpsError("invalid-argument", "Content missing from activity");
    }

    // validate updated set of tags and replace activity tags
    // Validated tags are the new tags provided by the user, minus any restricted tags
    const validatedTags = TagsService.removeRestrictedTagsFromStringArray(userTags);
    const tagObjects = await TagsService.getOrCreateTags(validatedTags);

    functions.logger.info(`Got validated tags`, { validatedTags });
    if (validatedTags) {
      activity.enrichmentConfiguration!.tags = validatedTags;
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
      data: [activity, ...tagObjects],
    });
  });
}
