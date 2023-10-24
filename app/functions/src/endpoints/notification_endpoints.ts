import * as functions from "firebase-functions";
import * as functions_v2 from "firebase-functions/v2";

import { UserService } from "../services/user_service";
import { ProfileService } from "../services/profile_service";
import { NotificationsService } from "../services/notifications_service";

import { FeedService } from "../services/feed_service";
import { EndpointRequest, buildEndpointResponse } from "./dto/payloads";

export namespace NotificationEndpoints {
  export const listNotifications = functions_v2.https.onCall(async (payload) => {
    const request = payload.data as EndpointRequest;
    const uid = await UserService.verifyAuthenticatedV2(payload, request.sender);
    functions.logger.info(`Getting notifications for current user: ${uid}`);

    if (uid.length === 0) {
      throw new functions.https.HttpsError("permission-denied", "User is not authenticated");
    }

    const client = FeedService.getFeedsClient();
    const notificationResult = await NotificationsService.listNotificationWindow(client, uid, request.limit, request.cursor);
    const profileData = await ProfileService.getMultipleProfiles(notificationResult.payloads.map((notification) => notification.sender).filter((sender) => sender.length > 0));

    let cursor = "";
    if (notificationResult.payloads.length > 0) {
      const lastReaction = notificationResult.payloads[notificationResult.payloads.length - 1];
      if (lastReaction.id && lastReaction.id.length > 0) {
        cursor = lastReaction.id;
      }
    }

    return buildEndpointResponse({
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

  export const markNotificationsAsReadAndSeen = functions_v2.https.onCall(async (payload) => {
    const request = payload.data as EndpointRequest;
    const uid = await UserService.verifyAuthenticatedV2(payload, request.sender);

    functions.logger.info(`Marking notifications as read and seen for current user: ${uid}`);
    if (uid.length === 0) {
      throw new functions.https.HttpsError("permission-denied", "User is not authenticated");
    }

    const client = FeedService.getFeedsClient();
    await NotificationsService.markAllNotificationsReadAndSeen(client, uid);

    return buildEndpointResponse({
      sender: uid,
      data: [],
    });
  });
}
