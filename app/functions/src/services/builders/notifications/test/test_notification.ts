import { NotificationAction } from "../../../../constants/notification_actions";
import { NotificationTopic } from "../../../../constants/notification_topics";
import { ProfileJSON } from "../../../../dto/profile";
import { FlamelinkHelpers } from "../../../../helpers/flamelink_helpers";
import { LocalizationsService } from "../../../localizations_service";
import { NotificationsService } from "../../../notifications_service";
import { NotificationPayload } from "../../../types/notification_payload";

export namespace TestNotification {
  export const TAG = "TestNotification";

  /**
   * Sends a notification to the user that a connection request has been accepted.
   * @param {any} target the target of the notification.
   */
  export async function sendNotification(target: ProfileJSON): Promise<void> {
    await LocalizationsService.changeLanguageToProfile(target);
    const receiverId = FlamelinkHelpers.getFlamelinkIdFromObject(target);

    if (!receiverId) {
      throw new Error("Could not get sender or receiver id");
    }

    const id = FlamelinkHelpers.generateIdentifier();
    const groupId = FlamelinkHelpers.generateIdentifierFromStrings([TAG, NotificationTopic.OTHER, receiverId]);

    const payload = new NotificationPayload({
      id,
      group_id: groupId,
      sender: receiverId,
      user_id: receiverId,
      title: "Test notification",
      body: "This is a test notification",
      topic: NotificationTopic.OTHER,
      action: NotificationAction.NONE,
    });

    const preparedNotification = NotificationsService.prepareNewNotification(payload);
    await NotificationsService.sendPayloadToUserIfTokenSet(target.fcmToken, preparedNotification);
  }
}
