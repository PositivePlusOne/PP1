import * as functions_v2 from "firebase-functions/v2";

import { UserService } from "../services/user_service";
import { ProfileService } from "../services/profile_service";
import { NotificationsService } from "../services/notifications_service";
import { NotificationAction } from "../constants/notification_actions";
import { NotificationPayload } from "../services/types/notification_payload";
import { EndpointRequest, buildEndpointResponse } from "./dto/payloads";
import { CacheService } from "../services/cache_service";

export namespace HealthEndpoints {
    export const MAXIMUM_UPDATE_REQUESTS = 100;

    export const sendTestNotification = functions_v2.https.onCall(async (payload) => {
        functions_v2.logger.info("Sending test notification", { structuredData: true });
        await UserService.verifyAuthenticatedV2(payload);

        // Get the users profile
        const uid = payload.auth?.uid;
        if (!uid) {
            throw new functions_v2.https.HttpsError("unauthenticated", "User not authenticated");
        }

        const profile = await ProfileService.getProfile(uid);
        if (!profile) {
            throw new functions_v2.https.HttpsError("not-found", "Profile not found");
        }

        const notificationPayload = new NotificationPayload({
            user_id: uid,
            title: "Test notification",
            body: "This is a test notification",
            action: NotificationAction.TEST,
        });

        // Send the notification
        const preparedNotification = NotificationsService.prepareNewNotification(notificationPayload);
        await NotificationsService.sendPayloadToUserIfTokenSet(profile.fcmToken, preparedNotification);
        await NotificationsService.postNotificationPayloadToUserFeed(uid, preparedNotification);
    });

    export const updateLocalCache = functions_v2.https.onCall(async (payload) => {
        const request = payload.data as EndpointRequest;
        functions_v2.logger.info("Updating local cache", { structuredData: true });

        const data = request.data = request.data || {};
        const requestIds = data.requestIds || [];

        if (!requestIds.length) {
            functions_v2.logger.info("No request IDs provided, skipping local cache update");
            return;
        }

        if (requestIds.length > MAXIMUM_UPDATE_REQUESTS) {
            throw new functions_v2.https.HttpsError("invalid-argument", `Too many request IDs provided, maximum is ${MAXIMUM_UPDATE_REQUESTS}`);
        }

        const uid = payload.auth?.uid || "";
        let sender = "";
        if (uid) {
            sender = await UserService.verifyAuthenticatedV2(payload);
        }

        const cacheData = await CacheService.getMultipleFromCache(requestIds) || [];

        return buildEndpointResponse({
            sender,
            data: [...cacheData],
        });
    });
}