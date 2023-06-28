import * as functions from "firebase-functions";

import { UserService } from "../services/user_service";
import { ProfileService } from "../services/profile_service";
import { NotificationsService } from "../services/notifications_service";

import safeJsonStringify from "safe-json-stringify";
import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";

export namespace NotificationEndpoints {
  export const listNotifications = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data, context) => {
    await UserService.verifyAuthenticated(context);

    const uid = context.auth?.uid || "";
    functions.logger.info(`Getting notifications for current user: ${uid}`);

    const profile = await ProfileService.getProfile(uid);
    if (!profile) {
      throw new functions.https.HttpsError("not-found", "User profile not found");
    }

    const notificationResult = await NotificationsService.listNotifications(profile, data.limit || 10, data.cursor);
    return safeJsonStringify(notificationResult);
  });

  export const countUnreadNotifications = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (_data, context) => {
    await UserService.verifyAuthenticated(context);

    const uid = context.auth?.uid || "";
    functions.logger.info(`Getting unread notification count for current user: ${uid}`);

    const profile = await ProfileService.getProfile(uid);
    if (!profile) {
      throw new functions.https.HttpsError("not-found", "User profile not found");
    }

    const notificationCount = await NotificationsService.getUnreadNotificationsCount(profile);
    return safeJsonStringify({ count: notificationCount });
  });

  export const dismissNotification = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data, context) => {
    await UserService.verifyAuthenticated(context);

    const uid = context.auth?.uid || "";
    functions.logger.info(`Dismissing notification for current user: ${uid}`);

    const notificationKey = data.notificationKey || "";
    if (!notificationKey) {
      throw new functions.https.HttpsError("invalid-argument", "Notification key not provided");
    }

    const notification = await NotificationsService.getNotification(notificationKey);
    if (!notification) {
      throw new functions.https.HttpsError("not-found", "Notification not found");
    }

    if (notification.receiver !== uid) {
      throw new functions.https.HttpsError("permission-denied", "Notification does not belong to current user");
    }

    await NotificationsService.dismissNotification(notification);

    return safeJsonStringify({ success: true });
  });

  export const dismissAllNotifications = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data, context) => {
    await UserService.verifyAuthenticated(context);

    const uid = context.auth?.uid || "";
    functions.logger.info(`Dismissing all notifications for current user: ${uid}`);

    const profile = await ProfileService.getProfile(uid);
    if (!profile) {
      throw new functions.https.HttpsError("not-found", "User profile not found");
    }

    await NotificationsService.dismissAllNotifications(profile);

    return safeJsonStringify({ success: true });
  });
}
