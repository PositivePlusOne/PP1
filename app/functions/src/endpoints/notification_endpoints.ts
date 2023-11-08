import * as functions from "firebase-functions";

import { UserService } from "../services/user_service";
import { ProfileService } from "../services/profile_service";
import { NotificationsService } from "../services/notifications_service";

import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";
import { FeedService } from "../services/feed_service";
import { EndpointRequest, buildEndpointResponse } from "./dto/payloads";
import { SystemService } from "../services/system_service";

export namespace NotificationEndpoints {
  export const listNotifications = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    await SystemService.validateUsingRedisUserThrottle(context);
    const uid = await UserService.verifyAuthenticated(context, request.sender);
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
}
