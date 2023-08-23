import { NotificationAction } from "../../../../constants/notification_actions";
import { NotificationTopic } from "../../../../constants/notification_topics";
import { FlamelinkHelpers } from "../../../../helpers/flamelink_helpers";
import { LocalizationsService } from "../../../localizations_service";
import { NotificationsService } from "../../../notifications_service";
import { NotificationPayload } from "../../../types/notification_payload";

export namespace ChatConnectionSentNotification {
  /**
   * Sends a notification to the user that a connection request has been sent.
   * @param {any} userProfile the user profile of the current user.
   * @param {any} target the target of the connection sent notification.
   */
  export async function sendNotification(sender: any, target: any): Promise<void> {
    await LocalizationsService.changeLanguageToProfile(target);
    const displayName = sender.displayName || "";

    const senderId = FlamelinkHelpers.getFlamelinkIdFromObject(sender);
    const receiverId = FlamelinkHelpers.getFlamelinkIdFromObject(target);

    const title = await LocalizationsService.getLocalizedString("notifications.connection_sent.title");
    const body = await LocalizationsService.getLocalizedString("notifications.connection_sent.body", { displayName });

    const id = `connection_sent_${senderId}_${receiverId}`;

    if (!senderId || !receiverId) {
      throw new Error("Could not get sender or receiver id");
    }

    const payload = new NotificationPayload({
      id,
      sender: senderId,
      user_id: receiverId,
      title,
      body,
      topic: NotificationTopic.CONNECTION_REQUEST,
      action: NotificationAction.CONNECTION_REQUEST_SENT,
    });

    await NotificationsService.sendPayloadToUser(target.fcmToken, payload);
    await NotificationsService.postNotifationPayloadToUserFeed(target.fcmToken, payload);
  }
}
