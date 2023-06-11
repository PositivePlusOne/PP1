import * as functions from 'firebase-functions';
import { FIREBASE_FUNCTION_INSTANCE_DATA } from '../constants/domain';
import { ProfileService } from '../services/profile_service';
import safeJsonStringify from 'safe-json-stringify';

export namespace AnalyticsEndpoints {
    export const getProfileAnalytics = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data) => {
        const targetUid = data.uid || "";
        if (targetUid.length === 0) {
            throw new functions.https.HttpsError("invalid-argument", "The function must be called with a valid uid");
        }

        const profileAnalytics = await ProfileService.getProfileAnalytics(targetUid);
        return safeJsonStringify(profileAnalytics);
    });
}