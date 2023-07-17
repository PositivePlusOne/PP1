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
    
    const activityRequest = {
      foreignKey: activityForeignId,
      publisherInformation: {
        foreignKey: uid,
      },
      generalConfiguration: {
        content: content,
        style: "text",
        type: "post",
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
}
