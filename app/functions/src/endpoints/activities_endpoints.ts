import * as functions from "firebase-functions";

import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";

import { DataService } from "../services/data_service";

import { DefaultGenerics, NewActivity } from "getstream";
import { v4 as uuidv4 } from "uuid";
import { ActivityActionVerb } from "../dto/activities";
import { ActivitiesService } from "../services/activities_service";
import { UserService } from "../services/user_service";
import { convertFlamelinkObjectToResponse } from "../mappers/response_mappers";
import { EndpointRequest } from "./dto/payloads";

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

    if (request.data.activity.generalConfiguration.content === "") {
      throw new functions.https.HttpsError("invalid-argument", "Content missing from activity");
    }

    // Set the publisher to the authenticated user
    request.data.activity.publisherInformation.foreignKey = uid;

    // generate a new uuid from the uuid package
    const activityId = uuidv4();

    await DataService.updateDocument({
      schemaKey: "activities",
      entryId: activityId,
      data: request.data.activity,
    });


    const getStreamActivity: NewActivity<DefaultGenerics> = {
      actor: uid,
      verb: ActivityActionVerb.Post,
      object: activityId,
    };

    // TODO(someone): Sanatize and generate the correct tags

    const userActivity = await ActivitiesService.addActivity("user", uid, getStreamActivity);
    request.data.activity.enrichmentConfiguration?.tags.forEach(async (tag:any) => {
      const tagActivity = await ActivitiesService.addActivity("tags", tag, getStreamActivity);
      functions.logger.info("Posted tag activity", { tagActivity });
    });

    functions.logger.info("Posted user activity", { feedActivity: userActivity });
    return convertFlamelinkObjectToResponse(context, request.sender, request.data.activity);
  });
}
