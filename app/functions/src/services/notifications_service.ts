import * as functions from "firebase-functions";

import { adminApp } from "..";
import { NotificationTypes } from "../constants/notification_types";
import { NotificationTopics } from "../constants/notification_topics";
import { NotificationActions } from "../constants/notification_actions";
import { FlamelinkHelpers } from "../helpers/flamelink_helpers";
import { DataService } from "./data_service";
import { SystemService } from "./system_service";

export namespace NotificationsService {
  /**
   * Send a notification to a user
   * @param {any} userProfile The user profile to send the notification to
   * @param {string} title The title of the notification
   * @param {string} body The body of the notification
   * @param {string} icon The icon to use for the notification
   * @param {string} key The key to use for the notification
   * @param {string} type The type of the notification
   * @param {string} topic The topic of the notification
   * @param {string} action The action which started the notification
   * @param {boolean} store Whether or not to store the notification in the database
   * @return {Promise<any>} The result of the send operation
   */
  export async function sendNotificationToUser(userProfile: any, { title = "", body = "", icon = "0xe9d3", payload = "", key = "", type = NotificationTypes.TYPE_DEFAULT, topic = NotificationTopics.TOPIC_NONE, action = NotificationActions.ACTION_NONE, store = false }): Promise<any> {
    functions.logger.info(`Sending notification to user: ${userProfile.uid}`);

    // If the key is empty, then generate a random string
    let actualKey = key;
    if (!key) {
      actualKey = Math.random().toString(36).substring(2, 15);
    }

    const dataPayload = {
      key: actualKey,
      title,
      body,
      payload,
      icon,
      type,
      topic,
      action,
    };

    if (store) {
      await storeNotification(userProfile, dataPayload);
    }

    const token = userProfile.fcmToken;
    if (!token || token.length === 0) {
      functions.logger.info(`User does not have a FCM token, skipping sending to users device: ${userProfile.uid}`);

      return;
    }

    const notificationPayload = {
      token,
      data: dataPayload,
    };

    try {
      await adminApp.messaging().send(notificationPayload);
    } catch (ex) {
      functions.logger.error(`Error sending notification to user: ${userProfile.uid}`, ex);
    }
  }

  /**
   * Send a payload to a user
   * @param {any} target The user profile to send the payload to
   * @param {any} payload The payload to send to the user
   * @param {string} action The action to perform when the notification is clicked
   */
  export async function sendPayloadToUser(target: any, payload: object, { action = NotificationActions.ACTION_NONE }): Promise<void> {
    functions.logger.info(`Sending payload to user: ${target.uid}`);
    const token = target.fcmToken;
    if (!token || token.length === 0) {
      functions.logger.info(`User does not have a FCM token, skipping notification: ${target.uid}`);

      return;
    }

    const message = {
      token,
      data: {
        action,
        payload: JSON.stringify(payload),
      },
    };

    try {
      await adminApp.messaging().send(message);
    } catch (ex) {
      functions.logger.error(`Error sending payload to user: ${target.uid}`, ex);
    }
  }

  /**
   * Store a notification for a target
   * @param {any} target The target to store the notification for
   * @param {string} title The title of the notification
   * @param {string} body The body of the notification
   * @param {string} payload The payload of the notification
   * @param {string} icon The icon to use for the notification
   * @param {string} key The key to use for the notification
   * @param {string} type The type of the notification
   * @param {string} topic The topic of the notification
   * @param {string} action The action which started the notification
   * @return {Promise<any>} The result of the store operation
   */
  export async function storeNotification(target: any, { title = "", body = "", payload = "", icon = "0xe9d3", key = "", type = NotificationTypes.TYPE_DEFAULT, topic = NotificationTopics.TOPIC_NONE, action = NotificationActions.ACTION_NONE }): Promise<any> {
    functions.logger.info(`Storing notification for user: ${target.uid}`);

    // If the key is empty, then generate a random string
    let actualKey = key;
    if (!key) {
      actualKey = Math.random().toString(36).substring(2, 15);
    }

    const flamelinkID = FlamelinkHelpers.getFlamelinkIdFromObject(target);
    const notification = {
      key: actualKey,
      action,
      receiver: flamelinkID ?? "",
      hasDismissed: false,
      title,
      body,
      payload,
      icon,
      type,
      topic,
    };

    const flamelinkApp = SystemService.getFlamelinkApp();

    return await flamelinkApp.content.add({
      schemaKey: "notifications",
      entryId: actualKey,
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
