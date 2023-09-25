import * as functions from "firebase-functions";

import { UserService } from "../services/user_service";
import { ProfileService } from "../services/profile_service";
import { NotificationsService } from "../services/notifications_service";

import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";
import { FeedService } from "../services/feed_service";
import { EndpointRequest, buildEndpointResponse } from "./dto/payloads";

export namespace NotificationEndpoints {
  export const listNotifications = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);
    functions.logger.info(`Getting notifications for current user: ${uid}`);

    if (uid.length === 0) {
      throw new functions.https.HttpsError("permission-denied", "User is not authenticated");
    }

    const client = FeedService.getFeedsUserClient(uid);
    const notificationResult = await NotificationsService.listNotificationWindow(client, uid, request.limit, request.cursor);
    const profileData = await ProfileService.getMultipleProfiles(notificationResult.payloads.map((notification) => notification.sender).filter((sender) => sender.length > 0));

    let cursor = "";
    if (notificationResult.payloads.length > 0) {
      const lastReaction = notificationResult.payloads[notificationResult.payloads.length - 1];
      if (lastReaction.id && lastReaction.id.length > 0) {
        cursor = lastReaction.id;
      }
    }

    return buildEndpointResponse(context, {
      sender: uid,
      data: [...profileData],
      cursor: cursor,
      limit: request.limit,
      seedData: {
        notifications: notificationResult.payloads,
        unread_count: notificationResult.unread_count,
        unseen_count: notificationResult.unseen_count,
      },
    });
  });

  export const markNotificationsAsReadAndSeen = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);

    functions.logger.info(`Marking notifications as read and seen for current user: ${uid}`);
    if (uid.length === 0) {
      throw new functions.https.HttpsError("permission-denied", "User is not authenticated");
    }

    const client = FeedService.getFeedsUserClient(uid);
    await NotificationsService.markAllNotificationsReadAndSeen(client, uid);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [],
    });
  });
}
