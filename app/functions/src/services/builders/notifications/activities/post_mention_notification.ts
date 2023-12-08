import { NotificationAction } from "../../../../constants/notification_actions";
import { ActivityJSON } from "../../../../dto/activities";
import { ProfileJSON } from "../../../../dto/profile";
import { FlamelinkHelpers } from "../../../../helpers/flamelink_helpers";
import { LocalizationsService } from "../../../localizations_service";
import { NotificationsService } from "../../../notifications_service";
import { NotificationPayload } from "../../../types/notification_payload";

export namespace PostMentionNotification {
  /**
   * Sends a notification to the user that they have been mentioned in a post.
   * @param {any} userProfile the user profile of the current user.
   * @param {any} targetProfile the target of the notification.
   */
  export async function sendNotification(userProfile: ProfileJSON, targetProfile: ProfileJSON, activity: ActivityJSON): Promise<void> {
    await LocalizationsService.changeLanguageToProfile(targetProfile);

    const content = activity.generalConfiguration?.content ?? "";

    const displayName = userProfile.displayName || "";
    const title = await LocalizationsService.getLocalizedString("notifications.post_mentioned.title");
    const body = await LocalizationsService.getLocalizedString("notifications.post_mentioned.body", { displayName, shortBody: content });

    const senderId = FlamelinkHelpers.getFlamelinkIdFromObject(userProfile);
    const receiverId = FlamelinkHelpers.getFlamelinkIdFromObject(targetProfile);
    const activityId = FlamelinkHelpers.getFlamelinkIdFromObject(activity);
    const origin = activity.publisherInformation?.originFeed ?? "";

    if (!senderId || !receiverId || !activityId) {
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
        activity_id: activityId,
        origin,
      },
      action: NotificationAction.POST_MENTIONED,
    });

    const preparedNotification = NotificationsService.prepareNewNotification(payload);
    await NotificationsService.sendPayloadToUserIfTokenSet(targetProfile.fcmToken ?? "", preparedNotification);
    await NotificationsService.postNotificationPayloadToUserFeed(receiverId, preparedNotification);
  }
}
