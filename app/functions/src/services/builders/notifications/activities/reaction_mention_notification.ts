import { NotificationAction } from "../../../../constants/notification_actions";
import { ActivityJSON } from "../../../../dto/activities";
import { ProfileJSON } from "../../../../dto/profile";
import { ReactionJSON } from "../../../../dto/reactions";
import { FlamelinkHelpers } from "../../../../helpers/flamelink_helpers";
import { StringHelpers } from "../../../../helpers/string_helpers";
import { LocalizationsService } from "../../../localizations_service";
import { NotificationsService } from "../../../notifications_service";
import { NotificationPayload } from "../../../types/notification_payload";

export namespace ReactionMentionNotification {
  /**
   * Sends a notification to the user that they have been mentioned in a post.
   * @param {any} userProfile the user profile of the current user.
   * @param {any} targetProfile the target of the notification.
   */
  export async function sendNotification(userProfile: ProfileJSON, targetProfile: ProfileJSON, activity: ActivityJSON, reaction: ReactionJSON): Promise<void> {
    await LocalizationsService.changeLanguageToProfile(targetProfile);

    const content = reaction?.text ?? "";

    const displayName = userProfile.displayName || "";
    const title = await LocalizationsService.getLocalizedString("notifications.reaction_mentioned.title");
    const safeContent = StringHelpers.markdownToPlainText(content);
    const body = await LocalizationsService.getLocalizedString("notifications.reaction_mentioned.body", { displayName, shortBody: safeContent });

    const senderId = FlamelinkHelpers.getFlamelinkIdFromObject(userProfile);
    const receiverId = FlamelinkHelpers.getFlamelinkIdFromObject(targetProfile);
    const activityId = FlamelinkHelpers.getFlamelinkIdFromObject(activity);
    const reactionId = FlamelinkHelpers.getFlamelinkIdFromObject(reaction);
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
        reaction_id: reactionId,
        origin,
      },
      action: NotificationAction.REACTION_MENTIONED,
    });

    const preparedNotification = NotificationsService.prepareNewNotification(payload);
    await NotificationsService.sendPayloadToUserIfTokenSet(targetProfile.fcmToken ?? "", preparedNotification);
    await NotificationsService.postNotificationPayloadToUserFeed(receiverId, preparedNotification);
  }
}
