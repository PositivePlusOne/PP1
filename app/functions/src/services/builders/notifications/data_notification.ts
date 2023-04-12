import { LocalizationsService } from "../../localizations_service";
import { NotificationsService } from "../../notifications_service";

export namespace DataNotification {
  /**
    * Sends a data payload to the user.
   * @param {any} target the target of the notification.
   * @param {string} action the action to take when the users device receives the notification.
   * @param {any} payload the payload of the notification.
   */
  export async function sendNotification(
    target: any,
    action: string,
    payload: any
  ): Promise<void> {
    await LocalizationsService.changeLanguageToProfile(target);

    await NotificationsService.sendPayloadToUser(target, {
        action,
        payload
    });
  }
}
