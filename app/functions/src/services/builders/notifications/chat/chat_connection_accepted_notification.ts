import { NotificationAction } from "../../../../constants/notification_actions";
import { NotificationTopic } from "../../../../constants/notification_topics";
import { ProfileJSON } from "../../../../dto/profile";
import { FlamelinkHelpers } from "../../../../helpers/flamelink_helpers";
import { LocalizationsService } from "../../../localizations_service";
import { NotificationsService } from "../../../notifications_service";
import { NotificationPayload } from "../../../types/notification_payload";

export namespace ChatConnectionAcceptedNotification {
  export const TAG = "ChatConnectionAcceptedNotification";

  /**
   * Sends a notification to the user that a connection request has been accepted.
   * @param {any} userProfile the user profile of the current user.
   * @param {any} target the target of the notification.
   */
  export async function sendNotification(userProfile: ProfileJSON, target: ProfileJSON): Promise<void> {
    await LocalizationsService.changeLanguageToProfile(target);
    const displayName = userProfile.displayName || "";
    const title = await LocalizationsService.getLocalizedString("notifications.connection_accepted.title");
    const body = await LocalizationsService.getLocalizedString("notifications.connection_accepted.body", { displayName });

    const senderId = FlamelinkHelpers.getFlamelinkIdFromObject(userProfile);
    const receiverId = FlamelinkHelpers.getFlamelinkIdFromObject(target);

    if (!senderId || !receiverId) {
      throw new Error("Could not get sender or receiver id");
    }

    const id = FlamelinkHelpers.generateIdentifier();
    const foreignKey = FlamelinkHelpers.generateIdentifierFromStrings([TAG, NotificationTopic.CONNECTION_REQUEST, senderId, receiverId]);
    
    const payload = new NotificationPayload({
      id,
      foreign_id: foreignKey,
      sender: senderId,
      user_id: receiverId,
      title,
      body,
      topic: NotificationTopic.CONNECTION_REQUEST,
      action: NotificationAction.CONNECTION_REQUEST_ACCEPTED,
    });

    const preparedNotification = NotificationsService.prepareNewNotification(payload);
    await NotificationsService.sendPayloadToUserIfTokenSet(target.fcmToken, preparedNotification);
    await NotificationsService.postNotificationPayloadToUserFeed(receiverId, preparedNotification);
  }
}
