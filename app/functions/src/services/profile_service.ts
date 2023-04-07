import * as functions from "firebase-functions";

import { adminApp } from "..";

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
   * Deletes the user profile.
   * @param {string} uid The user ID of the user to delete the profile for.
   * @return {Promise<void>} The user profile.
   * @throws {functions.https.HttpsError} If the user profile does not exist.
   */
  export async function deleteUserProfile(uid: string): Promise<void> {
    functions.logger.info(`Deleting user profile for user: ${uid}`);

    return await DataService.deleteDocument({
      schemaKey: "users",
      entryId: uid,
    });
  }

  /**
   * Creates the initial user profile.
   * @param {string} uid The user ID of the user to create the profile for.
   * @param {string} email The email of the user.
   * @param {string} phone The phone number of the user.
   * @param {string} locale The locale of the user.
   * @return {Promise<any>} The user profile.
   */
  export async function createInitialUserProfile(
    uid: string,
    email: string,
    phone: string,
    locale: string
  ): Promise<any> {
    const flamelinkApp = SystemService.getFlamelinkApp();
    functions.logger.info(
      `Creating initial user profile for user: ${uid} with email: ${email}, phone: ${phone}`
    );

    return await flamelinkApp.content.add({
      schemaKey: "users",
      entryId: uid,
      data: {
        email: email,
        phoneNumber: phone,
        locale: locale,
      },
    });
  }

  /**
   * Updates the email address of the user profile.
   * @param {string} uid The user ID of the user to update the name for.
   * @param {string} email The email to update.
   * @return {Promise<any>} The user profile.
   * @throws {functions.https.HttpsError} If the name is already up to date.
   */
  export async function updateEmail(uid: string, email: string): Promise<void> {
    functions.logger.info(`Updating email for user: ${email}`);

    await DataService.updateDocument({
      schemaKey: "users",
      entryId: uid,
      data: {
        email: email,
      },
    });
  }

  /**
   * Updates the phone number of the user profile.
   * @param {string} uid The user ID of the user to update the name for.
   * @param {string} phoneNumber The phone number to update.
   * @return {Promise<any>} The user profile.
   */
  export async function updatePhoneNumber(uid: string, phoneNumber: string): Promise<void> {
    functions.logger.info(`Updating phone number for user: ${phoneNumber}`);

    await DataService.updateDocument({
      schemaKey: "users",
      entryId: uid,
      data: {
        phoneNumber: phoneNumber,
      },
    });
  }

  /**
   * Updates the visibility flags of the user.
   * @param {string} uid The user ID of the user to update the visibility flags for.
   * @param {string[]} visibilityFlags The visibility flags to update.
   * @return {Promise<any>} The user profile.
   */
  export async function updateVisibilityFlags(
    uid: string,
    visibilityFlags: string[]
  ): Promise<void> {
    functions.logger.info(`Updating visibility flags for user: ${uid}`);

    return await DataService.updateDocument({
      schemaKey: "users",
      entryId: uid,
      data: {
        visibilityFlags,
      },
    });
  }

  /**
   * Updates the feature flags of the user.
   * @param {string} uid The user ID of the user to update the visibility flags for.
   * @param {string[]} featureFlags The visibility flags to update.
   * @return {Promise<any>} The user profile.
   */
  export async function updateFeatureFlags(
    uid: string,
    featureFlags: string[]
  ): Promise<void> {
    functions.logger.info(`Updating features flags for user: ${uid}`);

    return await DataService.updateDocument({
      schemaKey: "users",
      entryId: uid,
      data: {
        featureFlags,
      },
    });
  }

  /**
   * Updates the name of the user.
   * @param {string} uid The user ID of the user to update the name for.
   * @param {string} name The name to update.
   * @return {Promise<any>} The user profile.
   * @throws {functions.https.HttpsError} If the name is already up to date.
   */
  export async function updateName(uid: string, name: string): Promise<void> {
    functions.logger.info(`Updating name for user: ${name}`);

    await DataService.updateDocument({
      schemaKey: "users",
      entryId: uid,
      data: {
        name: name,
      },
    });
  }

  /**
   * Updates the birthday of the user.
   * @param {string} uid The user ID of the user to update the birthday for.
   * @param {string} birthday The birthday to update.
   * @return {Promise<any>} The user profile.
   */
  export async function updateBirthday(
    uid: string,
    birthday: string
  ): Promise<void> {
    functions.logger.info(`Updating birthday for user: ${birthday}`);

    await DataService.updateDocument({
      schemaKey: "users",
      entryId: uid,
      data: {
        birthday: birthday,
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
    functions.logger.info(`Updating display name for user: ${displayName}`);
    const firestore = adminApp.firestore();

    const firestoreReference = await DataService.getDocumentReference({
      schemaKey: "users",
      entryId: uid,
    });

    await adminApp.firestore().runTransaction(async (transaction) => {
      const querySnapshot = await transaction.get(
        firestore
          .collection("fl_content")
          .where("displayName", "==", displayName)
      );

      if (querySnapshot.size > 0) {
        throw new functions.https.HttpsError(
          "already-exists",
          `Display name ${displayName} is already taken by another user`
        );
      }

      transaction.update(firestoreReference, {
        displayName: displayName,
      });
    });
  }

  /**
   * Updates the interests for the user.
   * @param {string} uid The user ID of the user to update the interests for.
   * @param {string[]} interests The interests to update.
   */
  export async function updateInterests(
    uid: string,
    interests: string[]
  ): Promise<void> {
    functions.logger.info(`Updating interests for user: ${uid}`);

    await DataService.updateDocument({
      schemaKey: "users",
      entryId: uid,
      data: {
        interests,
      },
    });
  }

  /**
   * Updates the Hiv status for the user.
   * @param {string} uid The user ID of the user to update the status for.
   * @param {string} status The status to update.
   */
  export async function updateHivStatus(uid: string, status: string) {
    functions.logger.info(`Updating status for user: ${uid}`);

    await DataService.updateDocument({
      schemaKey: "users",
      entryId: uid,
      data: {
        hivStatus: status,
      },
    });
  }
  /**
   * Updates the reference image URL of the user.
   * @param {string} uid The user ID of the user to update the reference image URL for.
   * @param {string} referenceImage The base64 encoded image to update.
   * @return {Promise<any>} The user profile.
   * @throws {functions.https.HttpsError} If the reference image URL is already up to date.
   */
  export async function updateReferenceImage(
    uid: string,
    referenceImage: string
  ): Promise<void> {
    functions.logger.info(`Updating reference image for user: ${uid}`);

    // Remove the prefix to extract the base64 encoded string
    const base64String = referenceImage.replace(/^data:image\/png;base64,/, "");

    // Decode the base64 string to binary data
    const binaryData = Buffer.from(base64String, "base64");

    // Upload the image to the storage bucket
    const flamelinkApp = SystemService.getFlamelinkApp();
    const flamelinkUploadResult = await flamelinkApp.storage.upload(
      binaryData,
      {}
    );

    const fileId = flamelinkUploadResult.id as string;
    const firestoreReference = adminApp
      .firestore()
      .collection("fl_files")
      .doc(fileId);

    // Update the user with a new array of references containing the new one
    await DataService.updateDocument({
      schemaKey: "users",
      entryId: uid,
      data: {
        referenceImages: [firestoreReference],
      },
    });

    functions.logger.info(`Updated reference image for user: ${uid}`);
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

  /**
   * Updates the gender profile of the user.
   * @param {string} uid The UserId of the user to update
   * @param {string[]} genders
   */
  export async function updateGenders(uid: string, genders: string[]) {
    functions.logger.info(`Updating gender for user: ${uid}`);

    await DataService.updateDocument({
      schemaKey: "users",
      entryId: uid,
      data: {
        genders: genders,
      },
    });
  }
}
