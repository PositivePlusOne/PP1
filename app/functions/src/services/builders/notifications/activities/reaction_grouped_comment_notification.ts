import { ACTIVITY_NOTIFICATION_TRUNSCATE_LENGTH, NotificationAction } from "../../../../constants/notification_actions";
import { NotificationTopic } from "../../../../constants/notification_topics";
import { ActivityJSON } from "../../../../dto/activities";
import { ProfileJSON } from "../../../../dto/profile";
import { ReactionStatisticsJSON } from "../../../../dto/reaction_statistics";
import { ReactionJSON } from "../../../../dto/reactions";
import { FlamelinkHelpers } from "../../../../helpers/flamelink_helpers";
import { LocalizationsService } from "../../../localizations_service";
import { NotificationsService } from "../../../notifications_service";
import { NotificationPayload } from "../../../types/notification_payload";

export namespace ReactionGroupedCommentNotification {
  /**
   * Sends a notification to the user that a connection request has been accepted.
   * @param {any} userProfile the user profile of the current user.
   * @param {any} targetProfile the target of the notification.
   */
  export async function sendNotification(targetProfile: ProfileJSON, activity: ActivityJSON, reaction: ReactionJSON, reactionStatistics: ReactionStatisticsJSON): Promise<void> {
    await LocalizationsService.changeLanguageToProfile(targetProfile);

    let activityContent = activity?.generalConfiguration?.content ?? "";
    const hasActivityContent = activityContent.length > 0;
    if (activityContent.length > ACTIVITY_NOTIFICATION_TRUNSCATE_LENGTH) {
      activityContent = activityContent.substring(0, ACTIVITY_NOTIFICATION_TRUNSCATE_LENGTH) + "...";
    }

    let count = 0;
    const kind = reaction?.kind ?? "";
    if (reactionStatistics?.counts && reactionStatistics?.counts[kind]) {
      count = reactionStatistics?.counts[kind];
    }

    const title = await LocalizationsService.getLocalizedString("notifications.post_comment_grouped.title");
    const body = hasActivityContent ? await LocalizationsService.getLocalizedString("notifications.post_comment_grouped.body", { shortBody: activityContent, count }) : await LocalizationsService.getLocalizedString("notifications.post_comment_grouped.body_empty", { count });
    const origin = activity.publisherInformation?.originFeed ?? "";

    const receiverId = FlamelinkHelpers.getFlamelinkIdFromObject(targetProfile);
    const activityId = FlamelinkHelpers.getFlamelinkIdFromObject(activity);
    const reactionId = FlamelinkHelpers.getFlamelinkIdFromObject(reaction);

    if (!receiverId || !activityId || !reactionId) {
      throw new Error("Unable to generate notification payload");
    }

    const identifierParts = [NotificationAction.POST_COMMENTED_GROUP, receiverId, activityId];

    const id = FlamelinkHelpers.generateIdentifier();
    const groupId = FlamelinkHelpers.generateIdentifierFromStrings(identifierParts);
    const payload = new NotificationPayload({
      id,
      group_id: groupId,
      sender: receiverId,
      user_id: receiverId,
      title,
      body,
      extra_data: {
        activity_id: activityId,
        reaction_id: reactionId,
        origin,
      },
      topic: NotificationTopic.NEW_COMMENT,
      action: NotificationAction.POST_COMMENTED_GROUP,
    });

    const preparedNotification = NotificationsService.prepareNewNotification(payload);
    await NotificationsService.sendPayloadToUserIfTokenSet(targetProfile.fcmToken ?? "", preparedNotification);
    await NotificationsService.postNotificationPayloadToUserFeed(receiverId, preparedNotification);
  }
}
