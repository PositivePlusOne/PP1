import * as functions from "firebase-functions";

import { v1 as uuidv1 } from "uuid";

import { NotificationPayload, NotificationPriority, appendPriorityToMessagePayload } from "./types/notification_payload";
import { FeedService } from "./feed_service";
import { DefaultGenerics, FlatActivity, StreamClient } from "getstream";
import { NotificationTopic } from "../constants/notification_topics";
import { NotificationAction } from "../constants/notification_actions";
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
      await adminApp.messaging().send(message);
    } catch (ex) {
      functions.logger.error(`Error sending payload to user: ${notification.user_id} with token ${token}`, ex);
    }
  }

  export async function postNotifationPayloadToUserFeed(uid: string, notification: NotificationPayload): Promise<void> {
    functions.logger.info(`Attempting to post notification payload to user feed: ${uid}`);
    if (!uid || uid.length === 0) {
      functions.logger.info(`No uid provided, skipping post notification payload to user feed`);
      return;
    }

    const client = FeedService.getFeedsUserClient(uid);

    // Assume the notification is new
    notification.created_at = new Date().toISOString();
    if (notification.id) {
      notification.id = uuidv1();
    }

    const feed = client.feed("notification", uid);
    await feed.addActivity({
      verb: "notification",
      schema: "payload",
      actor: notification.user_id,
      sender: notification.sender,
      action: notification.action,
      priority: notification.priority,
      extra_data: notification.extra_data,
      time: notification.created_at,
      object: notification.id,
      foreign_id: notification.id,
      id: notification.id,
    });

    functions.logger.info(`Successfully posted notification payload to user feed: ${uid}`);
  }

  export async function listNotificationWindow(client: StreamClient<DefaultGenerics>, uid: string, windowSize: number, next: string): Promise<NotificationPayload[]> {
    functions.logger.info(`Attempting to list notification window for user: ${uid}`);
    if (!uid || uid.length === 0) {
      functions.logger.info(`No uid provided, skipping list notification window`);
      return [];
    }

    const feed = client.feed("notification", uid);
    const response = await feed.get({ 
      limit: windowSize,
      id_lt: next,
     });

     const results = (response.results as FlatActivity<DefaultGenerics>[]).map((activity) => {
        return new NotificationPayload({
          id: activity.id,
          user_id: activity.actor.toString(),
          sender: activity.sender?.toString() ?? "",
          title: activity.title?.toString() ?? "",
          body: activity.body?.toString() ?? "",
          icon: activity.icon?.toString() ?? "",
          created_at: activity.time,
          extra_data: activity.extra_data ?? {},
          topic: activity.topic as NotificationTopic ?? NotificationTopic.OTHER,
          action: activity.action as NotificationAction ?? NotificationAction.NONE,
          priority: activity.priority as NotificationPriority ?? NotificationPriority.PRIORITY_HIGH,
        });
      }) as NotificationPayload[];

    functions.logger.info(`Successfully listed notification window for user: ${uid}`);
    return results;
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
