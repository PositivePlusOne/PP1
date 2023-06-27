import * as functions from "firebase-functions";

import { adminApp } from "..";
import { FlamelinkHelpers } from "../helpers/flamelink_helpers";
import { DataService } from "./data_service";
import { NotificationPayload } from "./types/notification_payload";

export namespace NotificationsService {
  /**
   * Send a payload to a user
    * @param {string} token The FCM token of the user
    * @param {NotificationBody} notification The notification to send
    * @return {Promise<void>} The result of the send operation
   */
  export async function sendPayloadToUser(token: string, notification: NotificationPayload, shouldStore = true): Promise<void> {
    functions.logger.info(`Sending payload to user: ${notification.receiver}`);
    if (!token || token.length === 0) {
      functions.logger.info(`User does not have a FCM token, skipping notification: ${notification.receiver}`);
      return;
    }

    if (shouldStore) {
      await storeNotification(notification);
    }

    try {
      await adminApp.messaging().send({
        token,
        data: {
          payload: JSON.stringify(notification),
        },
      });
    } catch (ex) {
      functions.logger.error(`Error sending payload to user: ${notification.receiver} with token ${token}`, ex);
    }
  }

  /**
   * Store a notification for a target
   * @param {NotificationBody} notification The notification to store
   * @return {Promise<void>} The result of the store operation
   */
  export async function storeNotification(notification: NotificationPayload): Promise<void> {
    functions.logger.info(`Storing notification ${notification.key} for user: ${notification.receiver}`);
    await DataService.updateDocument({
      schemaKey: "notifications",
      entryId: notification.key,
      data: notification,
    });
  }

  /**
   * Get a notification
   * @param {string} notificationKey The key of the notification to get
   * @return {Promise<any>} The result of the get operation
   */
  export async function getNotification(notificationKey: string): Promise<any> {
    functions.logger.info(`Getting notification ${notificationKey}`);
    return await DataService.getDocument({
      schemaKey: "notifications",
      entryId: notificationKey,
    });
  }

  /**
   * Lists notifications for a target
   * @param {any} target The target to get the notifications for
   * @param {Pagination} pagination The pagination to use
   * @return {Promise<any>} The stored notifications
   */
  export async function listNotifications(target: any, startAfter: any, limit: number | undefined): Promise<any> {
    functions.logger.info(`Getting stored notifications for target: ${target.uid}`);
    const flamelinkID = FlamelinkHelpers.getFlamelinkIdFromObject(target);

    return await DataService.getDocumentWindow({
      schemaKey: "notifications",
      startAfter: startAfter,
      limit: limit,
      where: [
        { fieldPath: "receiver", op: "==", value: flamelinkID },
        { fieldPath: "dismissed", op: "==", value: false },
      ],
    });
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
