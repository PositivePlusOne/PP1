import * as functions from "firebase-functions";
import { DataService } from "./data_service";

import { SystemService } from "./system_service";

export namespace ProfileService {
  /**
   * Checks if the user has created a profile.
   * @param {string} uid The user ID of the user to verify.
   * @return {Promise<boolean>} True if the user has created a profile, false otherwise.
   */
  export async function hasCreatedProfile(uid: string): Promise<boolean> {
    const flamelinkApp = SystemService.getFlamelinkApp();
    functions.logger.info(`Checking if user has created profile: ${uid}`);

    return (
      (await flamelinkApp.content.get({
        schemaKey: "users",
        entryId: uid,
      })) !== null
    );
  }

  /**
   * Gets the user profile.
   * @param {string} uid The user ID of the user to get the profile for.
   * @return {Promise<any>} The user profile.
   */
  export async function getUserProfile(uid: string): Promise<any> {
    functions.logger.info(`Getting user profile for user: ${uid}`);

    return await DataService.getDocument({
      schemaKey: "users",
      entryId: uid,
    });
  }

  /**
   * Creates the initial user profile.
   * @param {string} uid The user ID of the user to create the profile for.
   * @param {string} name The name of the user.
   * @param {string} email The email of the user.
   * @param {string} phone The phone number of the user.
   * @return {Promise<any>} The user profile.
   */
  export async function createInitialUserProfile(
    uid: string,
    name: string,
    email: string,
    phone: string
  ): Promise<any> {
    const flamelinkApp = SystemService.getFlamelinkApp();
    functions.logger.info(
      `Creating initial user profile for user: ${uid} with name: ${name}, email: ${email}, phone: ${phone}`
    );

    return await flamelinkApp.content.add({
      schemaKey: "users",
      entryId: uid,
      data: {
        name: name,
        email: email,
        phoneNumber: phone,
      },
    });
  }

  /**
   * Updates the display name of the user.
   * @param {string} uid The user ID of the user to update the display name for.
   * @param {string} displayName The display name to update.
   * @return {Promise<any>} The user profile.
   * @throws {functions.https.HttpsError} If the display name is already up to date.
   */
  export async function updateDisplayName(
    uid: string,
    displayName: string
  ): Promise<void> {
    const flamelinkApp = SystemService.getFlamelinkApp();
    functions.logger.info(`Updating display name for user: ${displayName}`);

    const userProfile = await getUserProfile(uid);
    if (userProfile.displayName === displayName) {
      functions.logger.info("Display name is already up to date");
      return;
    }

    await flamelinkApp.content.update({
      schemaKey: "users",
      entryId: uid,
      data: {
        displayName: displayName,
      },
    });
  }

  /**
   * Updates the reference image URL of the user.
   * @param {string} uid The user ID of the user to update the reference image URL for.
   * @param {string} referenceImageUrl The reference image URL to update.
   * @return {Promise<any>} The user profile.
   * @throws {functions.https.HttpsError} If the reference image URL is already up to date.
   */
  export async function updateReferenceImageUrl(
    uid: string,
    referenceImageUrl: string
  ): Promise<void> {
    functions.logger.info(
      `Updating reference image url: ${uid} to ${referenceImageUrl}`
    );

    const userProfile = await getUserProfile(uid);
    if (userProfile && userProfile.referenceImageUrl === referenceImageUrl) {
      functions.logger.info("");
      return;
    }

    await DataService.updateDocument({
      schemaKey: "users",
      entryId: uid,
      data: {
        referenceImageUrl: referenceImageUrl,
      },
    });

    functions.logger.info(
      `Updated reference image url for user: ${uid} to ${referenceImageUrl}`
    );
  }

  /**
   * Updates the FCM token of the user.
   * @param {string} uid The user ID of the user to update the FCM token for.
   * @param {string} fcmToken The FCM token to update.
   * @return {Promise<any>} The user profile.
   */
  export async function updateProfileFcmToken(
    uid: string,
    fcmToken: string
  ): Promise<void> {
    functions.logger.info(`Updating FCM token for user: ${uid} to ${fcmToken}`);

    const userProfile = await getUserProfile(uid);
    if (userProfile && userProfile.fcmToken === fcmToken) {
      functions.logger.info("FCM token is already up to date");
      return;
    }

    await DataService.updateDocument({
      schemaKey: "users",
      entryId: uid,
      data: {
        fcmToken: fcmToken,
      },
    });

    functions.logger.info(`Updated FCM token for user: ${uid} to ${fcmToken}`);
  }
}
