import { NotificationTopics } from "../../../../constants/notification_topics";
import { FlamelinkHelpers } from "../../../../helpers/flamelink_helpers";
import { LocalizationsService } from "../../../localizations_service";
import { NotificationsService } from "../../../notifications_service";

export namespace ChatConnectionReceivedNotification {
  /**
   * Sends a notification to the user that a connection request has been sent.
   * @param {any} userProfile the user profile of the current user.
   * @param {any} target the target of the notification.
   */
  export async function sendNotification(userProfile: any, target: any): Promise<void> {
    await LocalizationsService.changeLanguageToProfile(target);
    const displayName = userProfile.displayName || "";
    const senderID = FlamelinkHelpers.getFlamelinkIdFromObject(userProfile);

    const title = await LocalizationsService.getLocalizedString(
      "notifications.connection_received.title"
    );

    const body = await LocalizationsService.getLocalizedString(
      "notifications.connection_received.body", { displayName },
    );

    await NotificationsService.sendNotificationToUser(target, {
      title,
      body,
      topic: NotificationTopics.TOPIC_CONNECTIONS,
      store: true,
      payload: JSON.stringify({
        sender: senderID,
      }),
    });
  }
}
