import { NotificationAction } from "../../../../constants/notification_actions";
import { NotificationTopic } from "../../../../constants/notification_topics";
import { ActivityJSON } from "../../../../dto/activities";
import { ProfileJSON } from "../../../../dto/profile";
import { ReactionJSON } from "../../../../dto/reactions";
import { FlamelinkHelpers } from "../../../../helpers/flamelink_helpers";
import { LocalizationsService } from "../../../localizations_service";
import { NotificationsService } from "../../../notifications_service";
import { NotificationPayload } from "../../../types/notification_payload";

export namespace ReactionCommentNotification {
  /**
   * Sends a notification to the user that a connection request has been accepted.
   * @param {any} userProfile the user profile of the current user.
   * @param {any} targetProfile the target of the notification.
   */
  export async function sendNotification(userProfile: ProfileJSON, targetProfile: ProfileJSON, activity: ActivityJSON, reaction: ReactionJSON): Promise<void> {
    await LocalizationsService.changeLanguageToProfile(targetProfile);

    // Limit to 25 characters and end with ellipsis
    let activityContent = activity?.generalConfiguration?.content ?? "";
    const hasActivityContent = activityContent.length > 0;
    if (activityContent.length > 25) {
      activityContent = activityContent.substring(0, 25) + "...";
    }

    const displayName = userProfile.displayName || "";
    const title = await LocalizationsService.getLocalizedString("notifications.post_comment.title");
    const body = hasActivityContent ? await LocalizationsService.getLocalizedString("notifications.post_comment.body", { displayName, shortBody: activityContent }) : await LocalizationsService.getLocalizedString("notifications.post_comment.body_empty", { displayName });
    
    const senderId = FlamelinkHelpers.getFlamelinkIdFromObject(userProfile);
    const receiverId = FlamelinkHelpers.getFlamelinkIdFromObject(targetProfile);
    const activityId = FlamelinkHelpers.getFlamelinkIdFromObject(activity);

    const reactionId = FlamelinkHelpers.getFlamelinkIdFromObject(reaction) || "";

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
      },
      topic: NotificationTopic.NEW_COMMENT,
      action: NotificationAction.POST_COMMENTED,
    });

    const preparedNotification = NotificationsService.prepareNewNotification(payload);
    await NotificationsService.sendPayloadToUserIfTokenSet(targetProfile.fcmToken ?? "", preparedNotification);
    await NotificationsService.postNotificationPayloadToUserFeed(receiverId, preparedNotification);
  }
}
