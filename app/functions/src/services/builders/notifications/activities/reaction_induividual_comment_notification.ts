import { ACTIVITY_NOTIFICATION_TRUNSCATE_LENGTH, NotificationAction } from "../../../../constants/notification_actions";
import { NotificationTopic } from "../../../../constants/notification_topics";
import { ActivityJSON } from "../../../../dto/activities";
import { ProfileJSON } from "../../../../dto/profile";
import { ReactionJSON } from "../../../../dto/reactions";
import { FlamelinkHelpers } from "../../../../helpers/flamelink_helpers";
import { StringHelpers } from "../../../../helpers/string_helpers";
import { LocalizationsService } from "../../../localizations_service";
import { NotificationsService } from "../../../notifications_service";
import { NotificationPayload } from "../../../types/notification_payload";

export namespace ReactionInduividualCommentNotification {
  export const TAG = "ReactionInduividualCommentNotification";

  /**
   * Sends a notification to the user that a connection request has been accepted.
   * @param {any} userProfile the user profile of the current user.
   * @param {any} targetProfile the target of the notification.
   */
  export async function sendNotification(userProfile: ProfileJSON, targetProfile: ProfileJSON, activity: ActivityJSON, reaction: ReactionJSON): Promise<void> {
    await LocalizationsService.changeLanguageToProfile(targetProfile);

    let activityContent = activity?.generalConfiguration?.content ?? "";
    const hasActivityContent = activityContent.length > 0;
    if (activityContent.length > ACTIVITY_NOTIFICATION_TRUNSCATE_LENGTH) {
      activityContent = activityContent.substring(0, ACTIVITY_NOTIFICATION_TRUNSCATE_LENGTH) + "...";
    }

    const displayName = StringHelpers.asHandle(userProfile.displayName || "");
    const title = await LocalizationsService.getLocalizedString("notifications.post_comment.title");
    const body = hasActivityContent ? await LocalizationsService.getLocalizedString("notifications.post_comment.body", { displayName, shortBody: activityContent }) : await LocalizationsService.getLocalizedString("notifications.post_comment.body_empty", { displayName });
    const origin = activity.publisherInformation?.originFeed ?? "";

    const senderId = FlamelinkHelpers.getFlamelinkIdFromObject(userProfile);
    const receiverId = FlamelinkHelpers.getFlamelinkIdFromObject(targetProfile);
    const activityId = FlamelinkHelpers.getFlamelinkIdFromObject(activity);
    const reactionId = FlamelinkHelpers.getFlamelinkIdFromObject(reaction) || "";

    if (!senderId || !receiverId || !activityId) {
      throw new Error("Unable to generate notification payload");
    }

    const identifierParts = [NotificationAction.POST_COMMENTED_GROUP, receiverId, activityId, senderId];

    const id = FlamelinkHelpers.generateIdentifier();
    const groupId = FlamelinkHelpers.generateIdentifierFromStrings(identifierParts);

    const payload = new NotificationPayload({
      id,
      group_id: groupId,
      sender: senderId,
      user_id: receiverId,
      title,
      body,
      extra_data: {
        activity_id: activityId,
        reaction_id: reactionId,
        origin,
      },
      topic: NotificationTopic.NEW_COMMENT,
      action: NotificationAction.POST_COMMENTED,
    });

    const preparedNotification = NotificationsService.prepareNewNotification(payload);
    await NotificationsService.sendPayloadToUserIfTokenSet(targetProfile.fcmToken ?? "", preparedNotification);
    await NotificationsService.postNotificationPayloadToUserFeed(receiverId, preparedNotification);
  }
}
