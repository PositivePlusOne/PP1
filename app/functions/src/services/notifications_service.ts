import * as functions from "firebase-functions";

import { adminApp } from "..";

export namespace NotificationsService {
  // No action will be taken when the user taps the notification
  export const ACTION_NAVIGATION_NONE = "ACTION_NAVIGATION_NONE";

  // The action will push the new screen onto the navigation stack, keeping the current screen
  export const ACTION_NAVIGATION_PUSH = "ACTION_NAVIGATION_PUSH";

  // The action will push the new screen onto the navigation stack, replacing the current screen
  export const ACTION_NAVIGATION_REPLACE = "ACTION_NAVIGATION_REPLACE";

  // The action will replace the current navigation stack with the new stack
  export const ACTION_NAVIGATION_REPLACE_ALL = "ACTION_NAVIGATION_REPLACE_ALL";

  // The action will pop the users current screen from the navigation stack
  export const ACTION_NAVIGATION_POP = "ACTION_NAVIGATION_POP";

  // When an entity has been followed as part of a relationship
  export const ACTION_FOLLOWED = "ACTION_FOLLOWED";

  // When an entity has been unfollowed as part of a relationship
  export const ACTION_UNFOLLOWED = "ACTION_UNFOLLOWED";

  // When an entity has been blocked as part of a relationship
  export const ACTION_BLOCKED = "ACTION_BLOCKED";

  // When an entity has been unblocked as part of a relationship
  export const ACTION_UNBLOCKED = "ACTION_UNBLOCKED";

  // When an entity has been connected as part of a relationship
  export const ACTION_CONNECTED = "ACTION_CONNECTED";

  // When an entity has been disconnected as part of a relationship
  export const ACTION_DISCONNECTED = "ACTION_DISCONNECTED";

  // When an entity has been muted as part of a relationship
  export const ACTION_MUTED = "ACTION_MUTED";

  // When an entity has been unmuted as part of a relationship
  export const ACTION_UNMUTED = "ACTION_UNMUTED";

  // When an entity has been hidden as part of a relationship
  export const ACTION_HIDDEN = "ACTION_HIDDEN";

  // When an entity has been unhidden as part of a relationship
  export const ACTION_UNHIDDEN = "ACTION_UNHIDDEN";

  // When an entity has been reported as part of a relationship
  export const ACTION_REPORTED = "ACTION_REPORTED";

  // The notification is sent immediately to the user and will not be stored in the database
  export const TYPE_DEFAULT = "TYPE_DEFAULT";

  // The notification is stored in the database and will be sent when the user opens the app
  export const TYPE_STORED = "TYPE_STORED";

  // The notification is sent immediately to the user, but the user will not be notified
  export const TYPE_DATA = "TYPE_DATA";

  // The notification has no specific topic, and may be displayed to all users
  export const TOPIC_NONE = "TOPIC_NONE";

  // The notification is sent to all users, and likely will be displayed to all users
  export const TOPIC_SYSTEM = "TOPIC_SYSTEM";

  /**
   * Send a notification to a user
   * @param {any} userProfile The user profile to send the notification to
   * @param {string} title The key of the title to send
   * @param {string} body The key of the body to send
   * @param {string} icon The key of the icon to send
   * @param {string} key The key of the notification
   * @param {string} type The type of notification to send
   * @param {string} topic The topic of the notification
   * @param {string} action The action to take when the user taps the notification
   * @param {string} actionData The data to send with the action
   */
  export async function sendNotificationToUser(
    userProfile: any,
    {
      title = "",
      body = "",
      icon = "0xe9d3",
      key = "",
      type = TYPE_DEFAULT,
      topic = TOPIC_NONE,
      action = ACTION_NAVIGATION_NONE,
      actionData = "",
    }
  ): Promise<void> {
    functions.logger.info(`Sending notification to user: ${userProfile.uid}`);
    const token = userProfile.fcmToken;
    if (!token) {
      functions.logger.info(
        `User does not have a FCM token, skipping notification: ${userProfile.uid}`
      );

      return;
    }

    // If the key is empty, then generate a random string
    let actualKey = key;
    if (!key) {
      actualKey = Math.random().toString(36).substring(2, 15);
    }

    const payload = {
      token,
      data: {
        title,
        body,
        actualKey,
        icon,
        type,
        topic,
        action,
        actionData,
      },
    };

    await adminApp.messaging().send(payload);
  }

  export function sendPayloadToUser(
    target: any,
    payload: { action: string; payload: any }
  ) {
    functions.logger.info(`Sending payload to user: ${target.uid}`);
    const token = target.fcmToken;
    if (!token) {
      functions.logger.info(
        `User does not have a FCM token, skipping notification: ${target.uid}`
      );

      return;
    }

    const message = {
      token,
      data: payload,
    };

    return adminApp.messaging().send(message);
  }
}
