import * as functions from "firebase-functions";

import { FIREBASE_FUNCTION_INSTANCE_DATA, FIREBASE_FUNCTION_INSTANCE_DATA_256 } from "../constants/domain";
import { UserService } from "../services/user_service";
import { ProfileService } from "../services/profile_service";
import { NotificationsService } from "../services/notifications_service";
import { NotificationAction } from "../constants/notification_actions";
import { NotificationPayload } from "../services/types/notification_payload";
import { EndpointRequest, buildEndpointResponse } from "./dto/payloads";
import { CacheService } from "../services/cache_service";

export namespace HealthEndpoints {
    export const MAXIMUM_UPDATE_REQUESTS = 100;

    export const sendTestNotification = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data, context) => {
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
        const preparedNotification = NotificationsService.prepareNewNotification(payload);
        await NotificationsService.sendPayloadToUserIfTokenSet(profile.fcmToken, preparedNotification);
        await NotificationsService.postNotificationPayloadToUserFeed(uid, preparedNotification);
    });

    export const updateLocalCache = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA_256).https.onCall(async (request: EndpointRequest, context) => {
        functions.logger.info("Updating local cache", { request, context });

        const data = request.data = request.data || {};
        const requestIds = data.requestIds || [];

        if (!requestIds.length) {
            functions.logger.info("No request IDs provided, skipping local cache update");
            return;
        }

        if (requestIds.length > MAXIMUM_UPDATE_REQUESTS) {
            throw new functions.https.HttpsError("invalid-argument", `Too many request IDs provided, maximum is ${MAXIMUM_UPDATE_REQUESTS}`);
        }

        const uid = context.auth?.uid || "";
        let sender = "";
        if (uid) {
            sender = await UserService.verifyAuthenticated(context);
        }

        const cacheData = await CacheService.getMultipleFromCache(requestIds) || [];

        return buildEndpointResponse(context, {
            sender,
            data: [...cacheData],
        });
    });
}