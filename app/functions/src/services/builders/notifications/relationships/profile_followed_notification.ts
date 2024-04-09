import { NotificationAction } from "../../../../constants/notification_actions";
import { ProfileJSON } from "../../../../dto/profile";
import { FlamelinkHelpers } from "../../../../helpers/flamelink_helpers";
import { StringHelpers } from "../../../../helpers/string_helpers";
import { LocalizationsService } from "../../../localizations_service";
import { NotificationsService } from "../../../notifications_service";
import { NotificationPayload } from "../../../types/notification_payload";

export namespace ProfileFollowedNotification {
  /**
   * Sends a notification to the user that they have been shared in a post.
   * @param {any} userProfile the user profile of the current user.
   * @param {any} targetProfile the target of the notification.
   */
  export async function sendNotification(userProfile: ProfileJSON, targetProfile: ProfileJSON): Promise<void> {
    await LocalizationsService.changeLanguageToProfile(targetProfile);

    const displayName = StringHelpers.asHandle(userProfile.displayName || "");
    const title = await LocalizationsService.getLocalizedString("notifications.profile_followed.title");

    const body = await LocalizationsService.getLocalizedString("notifications.profile_followed.body", { displayName });

    const senderId = FlamelinkHelpers.getFlamelinkIdFromObject(userProfile);
    const receiverId = FlamelinkHelpers.getFlamelinkIdFromObject(targetProfile);

    if (!senderId || !receiverId) {
      throw new Error("Unable to generate notification payload");
    }

    const id = FlamelinkHelpers.generateIdentifier();

    const payload = new NotificationPayload({
      id,
      sender: senderId,
      user_id: receiverId,
      title,
      body,
      extra_data: {
        origin,
      },
      action: NotificationAction.NEW_FOLLOWER,
    });

    const preparedNotification = NotificationsService.prepareNewNotification(payload);
    await NotificationsService.sendPayloadToUserIfTokenSet(targetProfile.fcmToken ?? "", preparedNotification);
    await NotificationsService.postNotificationPayloadToUserFeed(receiverId, preparedNotification);
  }
}
