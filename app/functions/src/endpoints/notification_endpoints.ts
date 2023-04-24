import * as functions from "firebase-functions";

import { UserService } from "../services/user_service";
import { ProfileService } from "../services/profile_service";
import { NotificationsService } from "../services/notifications_service";

import safeJsonStringify from "safe-json-stringify";
import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";

export namespace NotificationEndpoints {
  export const listNotifications = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (_data, context) => {
      await UserService.verifyAuthenticated(context);

      const uid = context.auth?.uid || "";
      functions.logger.info(`Getting notifications for current user: ${uid}`);

      const userProfile = await ProfileService.getUserProfile(uid);
      if (!userProfile) {
        throw new functions.https.HttpsError(
          "not-found",
          "User profile not found"
        );
      }

      const notifications =
        (await NotificationsService.getStoredNotifications(userProfile)) ?? [];

      return safeJsonStringify(notifications);
    });

  export const dismissNotification = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (data, context) => {
      await UserService.verifyAuthenticated(context);

      const uid = context.auth?.uid || "";
      functions.logger.info(`Dismissing notification for current user: ${uid}`);

      const notificationKey = data.notificationKey || "";
      if (!notificationKey) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "Notification key not provided"
        );
      }

      const userProfile = await ProfileService.getUserProfile(uid);
      if (!userProfile) {
        throw new functions.https.HttpsError(
          "not-found",
          "User profile not found"
        );
      }

      const notification = await NotificationsService.getStoredNotification(
        userProfile,
        notificationKey
      );

      if (!notification) {
        throw new functions.https.HttpsError(
          "not-found",
          "Notification not found"
        );
      }

      const result =
        (await NotificationsService.dismissNotification(notification)) ?? [];

      return safeJsonStringify(result);
    });
}
