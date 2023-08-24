import { NotificationAction } from "../../../../constants/notification_actions";
import { NotificationTopic } from "../../../../constants/notification_topics";
import { FlamelinkHelpers } from "../../../../helpers/flamelink_helpers";
import { LocalizationsService } from "../../../localizations_service";
import { NotificationsService } from "../../../notifications_service";
import { NotificationPayload } from "../../../types/notification_payload";

export namespace ChatConnectionReceivedNotification {

  export const KEY_PREFIX = "connection_received";

  /**
   * Sends a notification to the user that a connection request has been sent.
   * @param {any} userProfile the user profile of the current user.
   * @param {any} target the target of the notification.
   */
  export async function sendNotification(userProfile: any, target: any): Promise<void> {
    await LocalizationsService.changeLanguageToProfile(target);
    const displayName = userProfile.displayName || "";
    const senderId = FlamelinkHelpers.getFlamelinkIdFromObject(userProfile);
    const receiverId = FlamelinkHelpers.getFlamelinkIdFromObject(target);

    const title = await LocalizationsService.getLocalizedString("notifications.connection_received.title");
    const body = await LocalizationsService.getLocalizedString("notifications.connection_received.body", { displayName });
    
    if (!senderId || !receiverId) {
      throw new Error("Could not get sender or receiver id");
    }

    const id = `${KEY_PREFIX}_${senderId}_${receiverId}`;
    const payload = new NotificationPayload({
      id,
      sender: senderId,
      user_id: receiverId,
      title,
      body,
      topic: NotificationTopic.CONNECTION_REQUEST,
      action: NotificationAction.CONNECTION_REQUEST_RECEIVED,
    });

    await NotificationsService.sendPayloadToUser(target.fcmToken, payload);
    await NotificationsService.postNotificationPayloadToUserFeed(target.fcmToken, payload);
  }
}
