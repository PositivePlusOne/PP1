import * as functions from "firebase-functions";

import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";
import { ActivitiesService } from "../services/activities_service";

import safeJsonStringify from "safe-json-stringify";

export namespace ActivitiesEndpoints {
    export const getEventActivities = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async () => {
        const activities = await ActivitiesService.getEventActivities();
        return safeJsonStringify(activities);
    });
}