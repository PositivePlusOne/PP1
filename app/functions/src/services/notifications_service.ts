import * as functions from "firebase-functions";

import { NotificationPayload, NotificationPayloadResponse, appendPriorityToMessagePayload } from "./types/notification_payload";
import { FeedService } from "./feed_service";
import { DefaultGenerics, StreamClient } from "getstream";
import { adminApp } from "..";
import { FlamelinkHelpers } from "../helpers/flamelink_helpers";
import { StreamHelpers } from "../helpers/stream_helpers";

export namespace NotificationsService {
  export function prepareNewNotification(notification: NotificationPayload): NotificationPayload {
    if (!notification.id || notification.id.length === 0) {
      notification.id = FlamelinkHelpers.generateIdentifier();
      functions.logger.info(`Setting id for notification to: ${notification.id}`);
    }

    // if created_at is not set, set it to now
    if (!notification.created_at || notification.created_at.length === 0) {
      notification.created_at = StreamHelpers.getCurrentTimestamp();
      functions.logger.info(`Setting created_at to now for notification: ${notification.id} to ${notification.created_at}`);
    }

    return notification;
  }

  /**
   * Send a payload to a user
    * @param {string} token The FCM token of the user
    * @param {NotificationBody} notification The notification to send
    * @return {Promise<void>} The result of the send operation
   */
  export async function sendPayloadToUserIfTokenSet(token: string, notification: NotificationPayload): Promise<void> {
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
    if (!uid || !notification || !notification.id) {
      functions.logger.info(`No uid or notification provided, skipping post notification payload to user feed`);
      throw new Error("No uid or notification provided, skipping post notification payload to user feed");
    }

    const client = FeedService.getFeedsClient();
    const feed = client.feed("notification", uid);
    await feed.addActivity({
      verb: "post",
      actor: uid,
      object: notification,
      foreign_id: notification.id,
    });
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
        for (const nestedActivity of activity.activities) {
          functions.logger.info(`Processing nested notification payload for user: ${uid}`, { nestedActivity });
          const objectStr = nestedActivity?.object;
          let object = {} as any;
          try {
            if (typeof objectStr === "string") {
              functions.logger.info(`Attempting to parse notification as JSON for user: ${uid}`, { objectStr });
              object = JSON.parse(objectStr);
            } else if (typeof objectStr === "object") {
              functions.logger.info(`Notification is already an object for user: ${uid}`, { objectStr });
              object = objectStr;
            } else {
              throw new Error(`Notification is not a string or object for user: ${uid}`);
            }
          } catch (ex) {
            functions.logger.error(`Error parsing notification as JSON for user: ${uid}`, ex);
            continue;
          }

          functions.logger.info(`Successfully processed notification payload for user: ${uid}`, { activity, object });
          notifications.push(new NotificationPayload(object));
        }
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
