import * as functions from "firebase-functions";

import { NotificationAction } from "../../../../constants/notification_actions";
import { NotificationTopic } from "../../../../constants/notification_topics";
import { ProfileJSON } from "../../../../dto/profile";
import { FlamelinkHelpers } from "../../../../helpers/flamelink_helpers";
import { LocalizationsService } from "../../../localizations_service";
import { NotificationsService } from "../../../notifications_service";
import { NotificationPayload } from "../../../types/notification_payload";
import { StringHelpers } from "../../../../helpers/string_helpers";

export namespace ChatConnectionSentNotification {
  export const TAG = "ChatConnectionSentNotification";

  /**
   * Sends a notification to the user that a connection request has been sent.
   * @param {any} userProfile the user profile of the current user.
   * @param {any} target the target of the connection sent notification.
   */
  export async function sendNotification(sender: ProfileJSON, target: ProfileJSON): Promise<void> {
    await LocalizationsService.changeLanguageToProfile(target);
    const displayName = StringHelpers.asHandle(sender.displayName || "");

    const senderId = FlamelinkHelpers.getFlamelinkIdFromObject(sender);
    const receiverId = FlamelinkHelpers.getFlamelinkIdFromObject(target);

    const title = await LocalizationsService.getLocalizedString("notifications.connection_sent.title");
    const body = await LocalizationsService.getLocalizedString("notifications.connection_sent.body", { displayName });

    if (!senderId || !receiverId) {
      throw new Error("Could not get sender or receiver id");
    }

    const id = FlamelinkHelpers.generateIdentifier();
    const groupId = FlamelinkHelpers.generateIdentifierFromStrings([TAG, NotificationTopic.CONNECTION_REQUEST, senderId, receiverId]);

    functions.logger.log("Sending connection sent notification", { id, groupId, senderId, receiverId, title, body });

    const payload = new NotificationPayload({
      id,
      group_id: groupId,
      sender: senderId,
      user_id: receiverId,
      title,
      body,
      topic: NotificationTopic.CONNECTION_REQUEST,
      action: NotificationAction.CONNECTION_REQUEST_SENT,
    });

    await NotificationsService.sendPayloadToUserIfTokenSet(target.fcmToken, payload);
    await NotificationsService.postNotificationPayloadToUserFeed(receiverId, payload);
  }
}
