import * as functions from "firebase-functions";

import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";
import { UserService } from "../services/user_service";
import { ProfileService } from "../services/profile_service";
import { NotificationsService } from "../services/notifications_service";
import { NotificationAction } from "../constants/notification_actions";
import { NotificationPayload } from "../services/types/notification_payload";

export namespace HealthEndpoints {
    export const sendTestNotification = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data, context) => {
        await UserService.verifyAuthenticated(context);

        // Get the users profile
        const uid = context.auth?.uid;
        if (!uid) {
            throw new functions.https.HttpsError("unauthenticated", "User not authenticated");
        }
        
        const profile = await ProfileService.getProfile(uid);
        if (!profile) {
            throw new functions.https.HttpsError("not-found", "Profile not found");
        }

        const payload = new NotificationPayload({
            user_id: uid,
            title: "Test notification",
            body: "This is a test notification",            
            action: NotificationAction.TEST,
        });

        // Send the notification
        await NotificationsService.sendPayloadToUser(uid, payload);
        await NotificationsService.postNotifationPayloadToUserFeed(uid, payload);
    });
}