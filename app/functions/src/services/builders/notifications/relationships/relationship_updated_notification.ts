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
    functions.logger.log("Sending relationship updated notification.", { relationship });

    if (relationship.members && relationship.members.length > 0) {
      for (const member of relationship.members) {
        if (typeof member.memberId !== "string") {
          continue;
        }

        const id = FlamelinkHelpers.generateIdentifier();
        const memberId = member.memberId;

        const payload = new NotificationPayload({
          id,
          sender: memberId,
          topic: NotificationTopic.OTHER,
          action: NotificationAction.RELATIONSHIP_UPDATED,
          extra_data: {
            relationship: relationship,
          },
        });

        const preparedNotification = NotificationsService.prepareNewNotification(payload);
        await NotificationsService.sendPayloadToUserIfTokenSet(member.fcmToken, preparedNotification);
      }
    }
  }
}
