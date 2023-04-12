import { LocalizationsService } from "../../localizations_service";
import { NotificationsService } from "../../notifications_service";

export namespace ChatConnectionReceivedNotification {
  /**
   * Sends a notification to the user that a connection request has been sent.
   * @param {any} userProfile the user profile of the current user.
   * @param {any} target the target of the notification.
   */
  export async function sendNotification(userProfile: any, target: any): Promise<void> {
    await LocalizationsService.changeLanguageToProfile(target);
    const displayName = userProfile.displayName || "";

    const title = await LocalizationsService.getLocalizedString(
      "notifications.connection_received.title"
    );

    const body = await LocalizationsService.getLocalizedString(
      "notifications.connection_received.body", { displayName },
    );

    await NotificationsService.sendNotificationToUser(target, {
      title,
      body,
      action: NotificationsService.ACTION_RESYNC_CONNECTIONS,
    });
  }
}
