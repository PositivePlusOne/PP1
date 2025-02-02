import { NotificationAction } from "../../../../constants/notification_actions";
import { NotificationTopic } from "../../../../constants/notification_topics";
import { FlamelinkHelpers } from "../../../../helpers/flamelink_helpers";
import { StringHelpers } from "../../../../helpers/string_helpers";
import { LocalizationsService } from "../../../localizations_service";
import { NotificationsService } from "../../../notifications_service";
import { NotificationPayload } from "../../../types/notification_payload";

export namespace ChatConnectionRejectedNotification {
  export const TAG = "ChatConnectionRejectedNotification";

  /**
   * Sends a notification to the user that a connection request has been rejected.
   * @param {any} userProfile the user profile of the current user.
   * @param {any} target the target of the notification.
   */
  export async function sendNotification(userProfile: any, target: any): Promise<void> {
    await LocalizationsService.changeLanguageToProfile(target);
    const displayName = StringHelpers.asHandle(userProfile.displayName || "");

    const senderId = FlamelinkHelpers.getFlamelinkIdFromObject(userProfile);
    const receiverId = FlamelinkHelpers.getFlamelinkIdFromObject(target);

    const title = await LocalizationsService.getLocalizedString("notifications.connection_rejected.title");
    const body = await LocalizationsService.getLocalizedString("notifications.connection_rejected.body", { displayName });

    if (!senderId || !receiverId) {
      throw new Error("Could not get sender or receiver id");
    }

    const id = FlamelinkHelpers.generateIdentifier();
    const groupId = FlamelinkHelpers.generateIdentifierFromStrings([TAG, NotificationTopic.CONNECTION_REQUEST, senderId, receiverId]);

    const payload = new NotificationPayload({
      id,
      group_id: groupId,
      sender: senderId,
      user_id: receiverId,
      title,
      body,
      topic: NotificationTopic.CONNECTION_REQUEST,
      action: NotificationAction.CONNECTION_REQUEST_REJECTED,
    });

    const preparedNotification = NotificationsService.prepareNewNotification(payload);
    await NotificationsService.sendPayloadToUserIfTokenSet(target.fcmToken, preparedNotification);
    await NotificationsService.postNotificationPayloadToUserFeed(receiverId, preparedNotification);
  }
}
