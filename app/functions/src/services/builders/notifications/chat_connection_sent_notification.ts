import { LocalizationsService } from "../../localizations_service";
import { NotificationsService } from "../../notifications_service";

export namespace ChatConnectionSentNotification {
  /**
   * Sends a notification to the user that a connection request has been sent.
    * @param {any} userProfile the user profile of the current user.
    * @param {any} target the target of the connection sent notification.
   */
  export async function sendNotification(userProfile: any, target: any): Promise<void> {
    await LocalizationsService.changeLanguageToProfile(userProfile);
    const displayName = target.displayName || "";
    const title = await LocalizationsService.getLocalizedString(
      "notifications.connection_sent.title"
    );
    
    const body = await LocalizationsService.getLocalizedString(
      "notifications.connection_sent.body", { displayName },
    );

    await NotificationsService.sendNotificationToUser(userProfile, {
      title,
      body,
      action: NotificationsService.ACTION_RESYNC_CONNECTIONS,
    });
  }
}
