import * as functions from "firebase-functions";

import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";

import safeJsonStringify from "safe-json-stringify";

export namespace ActivitiesEndpoints {
  export const getBatchActivities = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async () => {
      // TODO: Implement
      return safeJsonStringify({});
    });
}
