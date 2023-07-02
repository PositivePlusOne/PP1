import { NotificationAction } from "../../../../constants/notification_actions";
import { NotificationTopic } from "../../../../constants/notification_topics";
import { FlamelinkHelpers } from "../../../../helpers/flamelink_helpers";
import { LocalizationsService } from "../../../localizations_service";
import { NotificationsService } from "../../../notifications_service";
import { NotificationPayload } from "../../../types/notification_payload";

export namespace ChatConnectionRejectedNotification {

  export const KEY_PREFIX = "connection_rejected";

  /**
   * Sends a notification to the user that a connection request has been rejected.
   * @param {any} userProfile the user profile of the current user.
   * @param {any} target the target of the notification.
   */
  export async function sendNotification(userProfile: any, target: any): Promise<void> {
    await LocalizationsService.changeLanguageToProfile(target);
    const displayName = userProfile.displayName || "";

    const senderId = FlamelinkHelpers.getFlamelinkIdFromObject(userProfile);
    const receiverId = FlamelinkHelpers.getFlamelinkIdFromObject(target);

    const title = await LocalizationsService.getLocalizedString("notifications.connection_rejected.title");
    const body = await LocalizationsService.getLocalizedString("notifications.connection_rejected.body", { displayName });

    const key = `${KEY_PREFIX}_${senderId}_${receiverId}`;

    if (!senderId || !receiverId) {
      throw new Error("Could not get sender or receiver id");
    }
    
    const payload = new NotificationPayload({
      key,
      sender: senderId,
      receiver: receiverId,
      title,
      body,
      topic: NotificationTopic.CONNECTION_REQUEST,
      action: NotificationAction.CONNECTION_REQUEST_REJECTED,
    });

    await NotificationsService.sendPayloadToUser(target.fcmToken, payload);
  }
}
