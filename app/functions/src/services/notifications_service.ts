import * as functions from "firebase-functions";

import { v1 as uuidv1 } from "uuid";

import { NotificationPayload, NotificationPayloadResponse, appendPriorityToMessagePayload } from "./types/notification_payload";
import { FeedService } from "./feed_service";
import { DefaultGenerics, StreamClient } from "getstream";
import { adminApp } from "..";

export namespace NotificationsService {
  /**
   * Send a payload to a user
    * @param {string} token The FCM token of the user
    * @param {NotificationBody} notification The notification to send
    * @return {Promise<void>} The result of the send operation
   */
  export async function sendPayloadToUser(token: string, notification: NotificationPayload): Promise<void> {
    functions.logger.info(`Attempting to send payload to user: ${notification.user_id}`);
    if (!token || token.length === 0) {
      functions.logger.info(`User does not have a FCM token, skipping notification: ${notification.user_id}`);
      return;
    }

    let message = {
      token,
      data: {
        payload: JSON.stringify(notification),
      },
    };

    // Update the payload with the priority
    message = appendPriorityToMessagePayload(message, notification.priority);

    try {
      functions.logger.info(`Sending payload to user: ${notification.user_id} with token ${token}`, { message });
      await adminApp.messaging().send(message);
    } catch (ex) {
      functions.logger.error(`Error sending payload to user: ${notification.user_id} with token ${token}`, ex);
    }
  }

  export async function postNotificationPayloadToUserFeed(uid: string, notification: NotificationPayload): Promise<void> {
    functions.logger.info(`Attempting to post notification payload to user feed: ${uid}`);
    if (!uid || uid.length === 0) {
      functions.logger.info(`No uid provided, skipping post notification payload to user feed`);
      return;
    }

    const client = FeedService.getFeedsClient();

    // Assume the notification is new
    notification.created_at = new Date().toISOString();
    if (!notification.id) {
      notification.id = uuidv1();
    }

    const feed = client.feed("notification", uid);
    await feed.addActivity({
      verb: "post",
      actor: uid,
      object: notification,
      time: notification.created_at,
      foreign_id: notification.id,
    });

    functions.logger.info(`Successfully posted notification payload to user feed: ${uid}`);
  }

  export async function listNotificationWindow(client: StreamClient<DefaultGenerics>, uid: string, windowSize: number, next: string): Promise<NotificationPayloadResponse> {
    functions.logger.info(`Attempting to list notification window for user: ${uid}`);
    const payloadResponse = new NotificationPayloadResponse();

    if (!uid || uid.length === 0) {
      functions.logger.info(`No uid provided, skipping list notification window`);
      return payloadResponse;
    }

    functions.logger.info(`Listing notification window for user: ${uid}`);
    const feed = client.feed("notification", uid);
    const response = await feed.get({
      limit: windowSize,
      id_lt: next,
    });

    functions.logger.info(`Successfully listed notification window for user: ${uid}`, { response });
    const notifications = [] as NotificationPayload[];

    if (response.results.length > 0) {
      functions.logger.info(`Successfully listed notification window for user: ${uid}`, { response });
      const initialResult = response.results[0] as any;
      if (initialResult?.unread) {
        payloadResponse.unread_count = initialResult.unread;
      }

      if (initialResult?.unseen) {
        payloadResponse.unseen_count = initialResult.unseen;
      }

      response.results.forEach((activity: any) => {
        functions.logger.info(`Processing notification payload for user: ${uid}`, { activity });
        const realActivity = activity.activities[0] || {};
        const objectStr = realActivity.object;
        let object = {} as any;
        if (typeof objectStr === "string") {
          object = JSON.parse(objectStr);
        } else if (typeof objectStr === "object") {
          object = objectStr;
        }

        functions.logger.info(`Successfully processed notification payload for user: ${uid}`, { activity, object });

        notifications.push(new NotificationPayload({
            user_id: uid,
            id: realActivity.id,
            sender: realActivity.actor,
            created_at: realActivity.time,
            action: object?.action || "",
            topic: object?.topic || "",
            title: object?.title || "",
            body: object?.body || "",
            icon: object?.icon || "",
            extra_data: object?.extra_data || {},
          }));
      });
    }

    functions.logger.info(`Successfully listed notification window for user: ${uid}`, { notifications });
    payloadResponse.payloads = notifications;

    return payloadResponse;
  }

  export async function markAllNotificationsReadAndSeen(client: StreamClient<DefaultGenerics>, uid: string): Promise<void> {
    functions.logger.info(`Attempting to mark all notifications read for user: ${uid}`);
    if (!uid || uid.length === 0) {
      functions.logger.info(`No uid provided, skipping mark all notifications read`);
      return;
    }

    const feed = client.feed("notification", uid);
    await feed.get({ mark_read: true, mark_seen: true });

    functions.logger.info(`Successfully marked all notifications read for user: ${uid}`);
  }
}
