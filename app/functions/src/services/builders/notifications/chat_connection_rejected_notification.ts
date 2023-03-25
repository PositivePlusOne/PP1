import { LocalizationsService } from "../../localizations_service";
import { NotificationsService } from "../../notifications_service";

export namespace ChatConnectionRejectedNotification {
  /**
   * Sends a notification to the user that a connection request has been rejected.
   * @param {any} profile The user profile to send the notification to.
   */
  export async function sendNotification(profile: any): Promise<void> {
    await LocalizationsService.changeLanguageToProfile(profile);
    const displayName = profile.displayName || "";
    const title = await LocalizationsService.getLocalizedString(
      "notifications.connection_rejected.title"
    );
    
    const body = await LocalizationsService.getLocalizedString(
      "notifications.connection_rejected.body", { displayName },
    );

    await NotificationsService.sendNotificationToUser(profile, {
      title,
      body,
      action: NotificationsService.ACTION_RESYNC_CONNECTIONS,
    });
  }
}
