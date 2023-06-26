import * as functions from "firebase-functions";

import { adminApp } from "..";
import { NotificationTypes } from "../constants/notification_types";
import { NotificationTopics } from "../constants/notification_topics";
import { NotificationActions } from "../constants/notification_actions";
import { FlamelinkHelpers } from "../helpers/flamelink_helpers";
import { DataService } from "./data_service";
import { SystemService } from "./system_service";
import { NotificationBody } from "./builders/notifications/notification_body";

export namespace NotificationsService {
  /**
   * Send a payload to a user
    * @param {string} token The FCM token of the user
    * @param {NotificationBody} notification The notification to send
    * @return {Promise<void>} The result of the send operation
   */
  export async function sendPayloadToUser(token: string, notification: NotificationBody): Promise<void> {
    functions.logger.info(`Sending payload to user: ${notification.receiver}`);
    if (!token || token.length === 0) {
      functions.logger.info(`User does not have a FCM token, skipping notification: ${notification.receiver}`);
      return;
    }

    const message = {
      token,
      data: {
        payload: JSON.stringify(notification),
      },
    };

    try {
      await storeNotification(notification);
      await adminApp.messaging().send(message);
    } catch (ex) {
      functions.logger.error(`Error sending payload to user: ${notification.receiver} with token ${token}`, ex);
    }
  }

  /**
   * Store a notification for a target
   * @param {NotificationBody} notification The notification to store
   * @return {Promise<void>} The result of the store operation
   */
  export async function storeNotification(notification: NotificationBody): Promise<void> {
    functions.logger.info(`Storing notification ${notification.key} for user: ${notification.receiver}`);
    await DataService.updateDocument({
      schemaKey: "notifications",
      entryId: notification.key,
      data: notification,
    });
  }

  /**
   * Get stored notifications for a target
   * @param {any} target The target to get the notifications for
   * @return {Promise<any>} The stored notifications
   */
  export async function getStoredNotifications(target: any): Promise<any> {
    functions.logger.info(`Getting stored notifications for user: ${target.uid}`);

    const flamelinkID = FlamelinkHelpers.getFlamelinkIdFromObject(target);
    const flamelinkApp = SystemService.getFlamelinkApp();

    const notifications = await flamelinkApp.content.get({
      schemaKey: "notifications",
      filters: [
        ["receiver", "==", flamelinkID],
        ["hasDismissed", "==", false],
      ],
    });

    return notifications;
  }

  /**
   * Get a stored notification for a target
   * @param {any} target The target to get the notification for
   * @param {string} notificationKey The key of the notification to get
   * @return {Promise<any>} The stored notification
   */
  export async function getStoredNotification(target: any, notificationKey: string): Promise<any> {
    functions.logger.info(`Getting stored notification for user: ${target.uid}`);

    const flamelinkID = FlamelinkHelpers.getFlamelinkIdFromObject(target);
    const flamelinkApp = SystemService.getFlamelinkApp();

    const notification = await flamelinkApp.content.get({
      schemaKey: "notifications",
      entryId: notificationKey,
      filters: [
        ["receiver", "==", flamelinkID],
        ["hasDismissed", "==", false],
      ],
    });

    return notification;
  }

  /**
   * Dismiss a notification
   * @param {any} notification The notification to dismiss
   * @return {Promise<any>} The result of the dismiss operation
   */
  export async function dismissNotification(notification: any): Promise<any> {
    if (!notification) {
      throw new Error("Notification does not exist");
    }

    const notificationKey = notification.key;
    functions.logger.info(`Dismissing notification: ${notificationKey}`);

    if (notificationKey === "") {
      throw new Error("Notification key is empty");
    }

    return await DataService.updateDocument({
      schemaKey: "notifications",
      entryId: notificationKey,
      data: {
        hasDismissed: true,
      },
    });
  }
}
