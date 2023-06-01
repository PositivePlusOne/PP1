import * as functions from "firebase-functions";

import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";

import { DataService } from "../services/data_service";

import safeJsonStringify from "safe-json-stringify";

export namespace ActivitiesEndpoints {
  export const getActivity = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data) => {
    const entry = data.entry;
    functions.logger.info(`Getting activity: ${entry}`);

    // Check if entry is null
    if (!entry) {
      throw new functions.https.HttpsError("invalid-argument", "Missing entry");
    }

    const activity = await DataService.getDocument({
      schemaKey: "activities",
      entryId: entry,
    });

    functions.logger.info(`Returning activity: ${activity}`);
    return safeJsonStringify(activity);
  });

  export const getBatchActivities = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data) => {
    const entries = data.entries;
    functions.logger.info(`Getting batch activities: ${entries}`);

    // Check if entries is an empty array or contains null values
    if (entries && entries.length > 0 && entries.every((e: any) => e)) {
      throw new functions.https.HttpsError("invalid-argument", "Missing entries");
    }

    const activities = await DataService.getBatchDocuments({
      schemaKey: "activities",
      entryIds: entries,
    });

    functions.logger.info(`Returning batch activities: ${activities}`);
    return safeJsonStringify(activities);
  });
}
