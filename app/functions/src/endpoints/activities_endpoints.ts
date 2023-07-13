import * as functions from "firebase-functions";

import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";

import { DataService } from "../services/data_service";

import { DefaultGenerics, NewActivity } from "getstream";
import { v4 as uuidv4 } from "uuid";
import { ActivitiesService } from "../services/activities_service";
import { UserService } from "../services/user_service";
import { convertFlamelinkObjectToResponse } from "../mappers/response_mappers";
import { EndpointRequest } from "./dto/payloads";
import { ActivityActionVerb, ActivityJSON } from "../dto/activities";

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

    return await convertFlamelinkObjectToResponse(context, request.sender, activity);
  });

  // export const getBatchActivities = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data) => {
  //   const entries = data.entries;
  //   functions.logger.info(`Getting batch activities: ${entries}`);

  //   // Check if entries is an empty array or contains null values
  //   if (entries && entries.length > 0 && entries.every((e: any) => e)) {
  //     throw new functions.https.HttpsError("invalid-argument", "Missing entries");
  //   }

  //   const activities = await DataService.getBatchDocuments({
  //     schemaKey: "activities",
  //     entryIds: entries,
  //   });

  //   functions.logger.info(`Returning batch activities: ${activities}`);
  //   return safeJsonStringify(activities);
  // });


  export const postActivity = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);
    const content = request.data.content;
    const media = request.data.media || [];

    const hasContentOrMedia = content || media.length > 0;
    if (hasContentOrMedia) {
      throw new functions.https.HttpsError("invalid-argument", "Content missing from activity");
    }

    // TODO(ryan): Tags
    // TODO(ryan): Tag Validation
    // TODO(ryan): Media
    // TODO(ryan): Update request

    // Set the publisher to the authenticated user
    const activityRequest = {
      foreignKey: uuidv4(),
      publisherInformation: {
        publisher: uid,
      },
      generalConfiguration: {
        content: content,
        style: "text",
        type: "post",
        
      },
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

    // TODO(someone): Sanatize and generate the correct tags

    const userActivity = await ActivitiesService.addActivity("user", uid, getStreamActivity);
    activityResponse.enrichmentConfiguration?.tags?.forEach(async (tag) => {
      const tagActivity = await ActivitiesService.addActivity("tags", tag, getStreamActivity);
      functions.logger.info("Posted tag activity", { tagActivity });
    });

    functions.logger.info("Posted user activity", { feedActivity: userActivity });
    return convertFlamelinkObjectToResponse(context, request.sender, request.data.activity);
  });
}
