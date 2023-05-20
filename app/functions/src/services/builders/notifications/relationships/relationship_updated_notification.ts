import { NotificationActions } from "../../../../constants/notification_actions";
import { NotificationsService } from "../../../notifications_service";

export namespace RelationshipUpdatedNotification {
    /**
     * Sends a notification to the user that a connection request has been accepted.
     * @param {any} relationship the relationship which has updated.
     */
    export async function sendNotification(
        relationship: any,
    ): Promise<void> {
        if (relationship.members && relationship.members.length > 0) {
            for (const member of relationship.members) {
                if (typeof member.memberId !== "string") {
                    continue;
                }

                await NotificationsService.sendPayloadToUser(
                    member.memberId,
                    relationship,
                    { action: NotificationActions.ACTION_RELATIONSHIP_UPDATED }
                );
            }
        }
    }
}
