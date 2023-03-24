import * as functions from "firebase-functions";

import { adminApp } from "..";

export namespace NotificationsService {
  /**
   * Send a notification to a user
   * @param {string} titleKey The key of the title to send
   * @param {string} bodyKey The key of the body to send
   * @param {string} iconKey The key of the icon to send
   * @param {any} userProfile The user profile to send the notification to
   */
  export async function sendNotification(
    titleKey: string,
    bodyKey: string,
    iconKey = "0",
    userProfile: any
  ): Promise<void> {
    functions.logger.info(`Sending notification to user: ${userProfile.uid}`);
    const FCMToken = userProfile.fcmToken;
    if (!FCMToken) {
      functions.logger.info(
        `User does not have a FCM token, skipping notification: ${userProfile.uid}`
      );

      return;
    }

    const payload = {
      token: FCMToken,
      data: {
        title: titleKey,
        body: bodyKey,
        icon: iconKey,
      },
    };

    await adminApp.messaging().send(payload);
  }
}
