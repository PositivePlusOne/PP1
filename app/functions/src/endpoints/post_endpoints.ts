import * as functions from "firebase-functions";

import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";

import { DataService } from "../services/data_service";

import { ActivitiesService } from "../services/activities_service";
import { UserService } from "../services/user_service";
import { EndpointRequest, buildEndpointResponse } from "./dto/payloads";
import { ActivityJSON } from "../dto/activities";
import { MediaJSON } from "../dto/media";
import { TagsService } from "../services/tags_service";
import { StorageService } from "../services/storage_service";
import { FeedService } from "../services/feed_service";
import { StreamHelpers } from "../helpers/stream_helpers";
import { FeedName } from "../constants/default_feeds";

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
    
        const feedsClient = await FeedService.getFeedsClient();
        const feed = feedsClient.feed(feedId, slugId);

        const window = await FeedService.getFeedWindow(feed, limit, cursor);
        const reactionCounts = window.results.map((item) => item.reaction_counts || {});
    
        // Convert window results to a list of IDs
        const activityObjectIds = window.results.map((item) => item.object);
        const activityIds = window.results.map((item) => item.id);
    
        // Loop over window IDs in parallel and get the activity data
        const payloadData = await Promise.all([...activityObjectIds.map((id) => ActivitiesService.getActivity(id))]);
        const paginationToken = StreamHelpers.extractPaginationToken(window.next);

        for (const activityId of activityIds) {
          if (!activityId) {
            continue;
          }

          const activityDetail = await feed.getActivityDetail(activityId, {
            enrich: true,
            withReactionCounts: true,
            ownReactions: true,
            reactionKindsFilter: "comment",
            withOwnChildren: true,
            withOwnReactions: true,
            withRecentReactions: true,
          });

          functions.logger.info("Got activity detail", { activityDetail });
        }
    
        return buildEndpointResponse(context, {
          sender: uid,
          data: payloadData,
          limit: limit,
          cursor: paginationToken,
          seedData: {
            next: paginationToken,
            unread: window.unread,
            unseen: window.unseen,
            reactionCounts: reactionCounts,
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

  export const postActivity = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    functions.logger.info(`Posting activity`, { request });

    const uid = await UserService.verifyAuthenticated(context, request.sender);
    const content = request.data.content || "";
    const media = request.data.media || [] as MediaJSON[];
    const userTags = request.data.tags || [] as string[];
    const feed = request.data.feed || FeedName.User;
    const type = request.data.type;
    const style = request.data.style;

    functions.logger.info(`Posting activity`, { uid, content, media, userTags });
    const hasContentOrMedia = content || media.length > 0;
    if (!hasContentOrMedia) {
      throw new functions.https.HttpsError("invalid-argument", "Content missing from activity");
    }

    const validatedTags = TagsService.removeRestrictedTagsFromStringArray(userTags);
    functions.logger.info(`Got validated tags`, { validatedTags });

    const mediaBucketPaths = StorageService.getBucketPathsFromMediaArray(media);
    await StorageService.verifyMediaPathsContainsData(mediaBucketPaths);

    if (!type || !style) {
      throw new functions.https.HttpsError("invalid-argument", "Missing type or style");
    }

    const activityRequest = {
      publisherInformation: {
        foreignKey: uid,
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
      media: media,
    } as ActivityJSON;

    const userActivity = await ActivitiesService.postActivity(uid, feed, activityRequest);
    functions.logger.info("Posted user activity", { feedActivity: userActivity });

    return buildEndpointResponse(context, {
      sender: uid,
      data: [userActivity],
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

    if (activity.publisherInformation?.foreignKey !== uid) {
      throw new functions.https.HttpsError("permission-denied", "User does not own activity");
    }

    functions.logger.info(`Deleting activity`, { uid, activityId });

    activity.enrichmentConfiguration?.tags?.forEach(async (tag) => {
      await ActivitiesService.removeActivityFromFeed("tags", tag, activityId);
      functions.logger.info("Removed tag activity", { tag });
    });

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
    // TODO update these params
    // const allowSharing = request.data.allowSharing;
    // const visibleTo = request.data.visibleTo;
    // const allowComments = request.data.allowComments;

    if (!activityId) {
      throw new functions.https.HttpsError("invalid-argument", "Missing activityId");
    }

    let activity = await DataService.getDocument({
      schemaKey: "activities",
      entryId: activityId,
    });

    if (!activity) {
      throw new functions.https.HttpsError("not-found", "Activity not found");
    }


    if (activity.publisherInformation?.foreignKey !== uid) {
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

    // create a copy of the previous tags
    const previousTags = [] as string[];
    if (activity.enrichmentConfiguration?.tags) {
      previousTags.push(...activity.enrichmentConfiguration!.tags);
    }

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

    const mediaBucketPaths = StorageService.getBucketPathsFromMediaArray(media);
    await StorageService.verifyMediaPathsContainsData(mediaBucketPaths);

    activity = await DataService.updateDocument({
      schemaKey: "activities",
      entryId: activityId,
      data: activity,
    });

    let newValidatedTags = [...validatedTags];
    //? Tags to remove are the previous tags that are not in the new validated tags
    const tagsToRemove = new Array<string>();

    for (const tag of validatedTags) {
      if (previousTags.includes(tag)) {
        const index = newValidatedTags.indexOf(tag);
        if (index > -1) {
          newValidatedTags = newValidatedTags.splice(index, 1);
        }
      }
    }

    for (const tag of previousTags) {
      if (!newValidatedTags.includes(tag)) {
        tagsToRemove.push(tag);
      }
    }

    // add missing tags to activity
    newValidatedTags.forEach(async (tag) => {
      TagsService.createTagIfNonexistant(tag);
      const tagActivity = await ActivitiesService.postActivityToFeed("tags", tag, activity);
      functions.logger.info("Posted tag activity", { tagActivity });
    });

    // remove tags that are no longer needed from the activity
    tagsToRemove.forEach(async (tag: string) => {
      await ActivitiesService.removeActivityFromFeed("tags", tag, activityId);
      functions.logger.info("Removed tag activity", { tag });
    });

    functions.logger.info("Updated user activity", { feedActivity: activity });
    return buildEndpointResponse(context, {
      sender: uid,
      data: [activity],
    });
  });
}
