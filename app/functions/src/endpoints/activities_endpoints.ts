import * as functions from "firebase-functions";

import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";

import { DataService } from "../services/data_service";

import safeJsonStringify from "safe-json-stringify";

export namespace ActivitiesEndpoints {
  export const getBatchActivities = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (data) => {
      const entries = data.entries;
      functions.logger.info(`Getting batch activities: ${entries}`);

      // Check if entries is an empty array or contains null values
      if (entries && entries.length > 0 && entries.every((e: any) => e)) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "Missing entries"
        );
      }

      const activities = DataService.getBatchDocuments({
        schemaKey: "activities",
        entryIds: entries,
      });

      functions.logger.info(`Returning batch activities: ${activities}`);
      return safeJsonStringify(activities);
    });
}
