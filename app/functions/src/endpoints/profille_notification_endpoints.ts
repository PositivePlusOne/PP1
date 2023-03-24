import * as functions from "firebase-functions";

import { NotificationsService } from "../services/notifications_service";
import { ProfileService } from "../services/profile_service";

export namespace ProfileNotificationEndpoints {
  export const sendTestNotification = functions.https.onCall(
    async (data, context) => {
      functions.logger.info("Sending test notification");

      const uid = data.uid || "";
      if (uid.length === 0) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "The function must be called with a valid uid"
        );
      }

      const userProfile = await ProfileService.getUserProfile(uid);
      await NotificationsService.sendNotification(
        "test",
        "test",
        "0",
        userProfile
      );

      return { success: true };
    }
  );
}
