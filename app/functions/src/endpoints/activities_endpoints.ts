import * as functions from "firebase-functions";

import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";

import { DataService } from "../services/data_service";

import { DefaultGenerics, NewActivity } from "getstream";
import { v4 as uuidv4 } from "uuid";
import { ActivitiesService } from "../services/activities_service";
import { UserService } from "../services/user_service";
import { EndpointRequest, buildEndpointResponse } from "./dto/payloads";
import { ActivityActionVerb, ActivityJSON } from "../dto/activities";
import { MediaJSON } from "../dto/media";
import { TagsService } from "../services/tags_service";
import { StorageService } from "../services/storage_service";

export namespace ActivitiesEndpoints {
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
    const type = request.data.type;
    const style = request.data.style;

    // const allowSharing = request.data.allowSharing;
    // const visibleTo = request.data.visibleTo;
    // const allowComments = request.data.allowComments;
    // const saveToGallery = request.data.saveToGallery;

    const activityForeignId = uuidv4();

    functions.logger.info(`Posting activity`, { uid, content, media, userTags, activityForeignId });
    const hasContentOrMedia = content || media.length > 0;
    if (!hasContentOrMedia) {
      throw new functions.https.HttpsError("invalid-argument", "Content missing from activity");
    }

    const validatedTags = TagsService.removeRestrictedTagsFromStringArray(userTags);
    functions.logger.info(`Got validated tags`, { validatedTags });

    const mediaBucketPaths = StorageService.getBucketPathsFromMediaArray(media);
    await StorageService.verifyMediaPathsExist(mediaBucketPaths);

    if (!type || !style) {
      throw new functions.https.HttpsError("invalid-argument", "Missing type or style");
    }

    const activityRequest = {
      foreignKey: activityForeignId,
      publisherInformation: {
        foreignKey: uid,
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

    const activityResponse = await DataService.updateDocument({
      schemaKey: "activities",
      entryId: activityRequest.foreignKey!,
      data: activityRequest,
    }) as ActivityJSON;

    const getStreamActivity: NewActivity<DefaultGenerics> = {
      actor: uid,
      verb: ActivityActionVerb.Post,
      object: activityRequest.foreignKey,
    };

    const userActivity = await ActivitiesService.addActivity("user", uid, getStreamActivity);

    activityResponse.enrichmentConfiguration?.tags?.forEach(async (tag) => {
      const tagActivity = await ActivitiesService.addActivity("tags", tag, getStreamActivity);
      functions.logger.info("Posted tag activity", { tagActivity });
    });

    functions.logger.info("Posted user activity", { feedActivity: userActivity });
    return buildEndpointResponse(context, {
      sender: uid,
      data: [activityResponse],
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
      await ActivitiesService.removeActivity("tags", tag, activityId);
      functions.logger.info("Removed tag activity", { tag });
    });

    await ActivitiesService.removeActivity("user", uid, activityId);

    await DataService.deleteDocument({
      schemaKey: "activities",
      entryId: activityId,
    });
  });

  export const updateActivity = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    functions.logger.info(`Posting activity`, { request });

    const uid = await UserService.verifyAuthenticated(context, request.sender);
    const activityId = request.data.postId || "";

    const content = request.data.content || "";
    const media = request.data.media || [] as MediaJSON[];
    const userTags = request.data.tags || [] as string[];
    //TODO update these params
    // const allowSharing = request.data.allowSharing;
    // const visibleTo = request.data.visibleTo;
    // const allowComments = request.data.allowComments;

    let activity = await DataService.getDocument({
      schemaKey: "activities",
      entryId: activityId,
    }) as ActivityJSON;

    if (!activity) {
      throw new functions.https.HttpsError("not-found", "Activity not found");
    }

    if (content) { activity.generalConfiguration!.content = content; }
    if (media) { activity.media = media; }
    if (userTags) { activity.enrichmentConfiguration!.tags = userTags; }

    if (activity.publisherInformation?.foreignKey !== uid) {
      throw new functions.https.HttpsError("permission-denied", "User does not own activity");
    }

    functions.logger.info(`Updating activity`, { uid, content, media, userTags, activityId });
    const hasContentOrMedia = content || media.length > 0;
    if (!hasContentOrMedia) {
      throw new functions.https.HttpsError("invalid-argument", "Content missing from activity");
    }

    const validatedTags = TagsService.removeRestrictedTagsFromStringArray(userTags);
    functions.logger.info(`Got validated tags`, { validatedTags });

    const mediaBucketPaths = StorageService.getBucketPathsFromMediaArray(media);
    await StorageService.verifyMediaPathsExist(mediaBucketPaths);

    const activityResponse = await DataService.updateDocument({
      schemaKey: "activities",
      entryId: activity.foreignKey!,
      data: activity,
    }) as ActivityJSON;

    //TODO remove and readd tags if they have changed
    // activityResponse.enrichmentConfiguration?.tags?.forEach(async (tag) => {
    //   const tagActivity = await ActivitiesService.addActivity("tags", tag, getStreamActivity);
    //   functions.logger.info("Posted tag activity", { tagActivity });
    // });

    functions.logger.info("Updated user activity", { feedActivity: activityResponse });
    return buildEndpointResponse(context, {
      sender: uid,
      data: [activityResponse],
    });
  });
}
