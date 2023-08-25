import * as functions from "firebase-functions";

import { FlamelinkHelpers } from "../../../../helpers/flamelink_helpers";
import { NotificationsService } from "../../../notifications_service";
import { NotificationPayload } from "../../../types/notification_payload";
import { NotificationTopic } from "../../../../constants/notification_topics";
import { NotificationAction } from "../../../../constants/notification_actions";

export namespace RelationshipUpdatedNotification {
  /**
   * Sends a notification to the user that a connection request has been accepted.
   * @param {any} relationship the relationship which has updated.
   */
  export async function sendNotification(relationship: any): Promise<void> {
    if (relationship.members && relationship.members.length > 0) {
      for (const member of relationship.members) {
        if (typeof member.memberId !== "string") {
          continue;
        }

        const id = `relationship_updated_${relationship.id}_${member.memberId}`;
        const receiverId = FlamelinkHelpers.getFlamelinkIdFromObject(member);

        if (!receiverId) {
          functions.logger.error("Could not get receiver id", { id, receiverId, relationship, member });
          continue;
        }

        const payload = new NotificationPayload({
          id,
          sender: receiverId,
          topic: NotificationTopic.OTHER,
          action: NotificationAction.RELATIONSHIP_UPDATED,
          extra_data: {
            relationship: relationship,
          },
        });

        await NotificationsService.sendPayloadToUser(member.fcmToken, payload);
      }
    }
  }
}
