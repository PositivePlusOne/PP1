import * as functions from "firebase-functions";

import { adminApp } from "..";

import { DataService } from "./data_service";

import { SystemService } from "./system_service";
import { GeoPoint } from "firebase-admin/firestore";
import { StorageService } from "./storage_service";
import { UploadType } from "./types/upload_type";
import { GeoLocation } from "../dto/shared";
import { Keys } from "../constants/keys";

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
   * @param {string} uid The FL ID of the user.
   * @return {Promise<any>} The user profile.
   */
  export async function getProfile(uid: string): Promise<any> {
    functions.logger.info(`Getting user profile for user: ${uid}`);

    return await DataService.getDocument({
      schemaKey: "users",
      entryId: uid,
    });
  }

  // /**
  //  * Get analytics for a user profile.
  //  * @param {string} uid The FL ID of the user.
  //   * @return {Promise<any>} The user profile analytics.
  //  */
  // export async function getProfileAnalytics(uid: string): Promise<any> {
  //   functions.logger.info(`Getting user profile analytics for user: ${uid}`);
  //   const result = {
  //     totalFollowing: 0,
  //     totalFollowers: 0,
  //   };

  //   const promises = [] as Promise<any>[];

  //   // Get the users stream feed
  //   const feedsClient = await FeedService.getFeedsClient();
  //   const streamFeed = feedsClient.feed("user", uid);

  //   // Get the users followers
  //   promises.push(
  //     streamFeed.followStats().then((response) => {
  //       result.totalFollowers = response.results.followers.count;
  //       result.totalFollowing = response.results.following.count;
  //     })
  //   );

  //   // TODO: See if their is a nice way to get post / reaction count

  //   await Promise.all(promises);

  //   return result;
  // }

  /**
   * Gets multiple profiles.
   */
  export async function getMultipleProfiles(profileIds: string[]): Promise<any> {
    functions.logger.info(`Getting multiple user profiles for users`);

    return DataService.getBatchDocuments({
      schemaKey: "users",
      entryIds: profileIds,
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
  export async function createUserProfile(uid: string, email: string, phone: string, locale: string): Promise<any> {
    const flamelinkApp = SystemService.getFlamelinkApp();
    functions.logger.info(`Creating initial user profile for user: ${uid} with email: ${email}, phone: ${phone}`);

    return await flamelinkApp.content.add({
      schemaKey: "users",
      entryId: uid,
      data: {
        email: email,
        phoneNumber: phone,
        locale: locale,
        locationSkipped: false,
      },
    });
  }

  /**
   * Creates an organisation profile with the supplied members.
   * @param {string} entryId The entry ID of the organisation.
   * @param {string} displayName The display name of the organisation.
   * @param {string[]} members The members to add to the organisation.
   * @return {Promise<any>} The organisation profile.
   */
  export async function createOrganisationProfile(entryId: string, displayName: string, members: string[]): Promise<void> {
    const flamelinkApp = SystemService.getFlamelinkApp();
    const firestore = adminApp.firestore();
    functions.logger.info(`Creating organisation profile for organisation: ${displayName} with members: ${members}`);

    // Check if the profile key is available
    await adminApp.firestore().runTransaction(async (transaction) => {
      const querySnapshot = await transaction.get(firestore.collection("fl_content").where("displayName", "==", displayName));

      if (querySnapshot.size > 0) {
        throw new functions.https.HttpsError("already-exists", `Display name ${displayName} is already taken by another user`);
      }

      return await flamelinkApp.content.add({
        schemaKey: "users",
        entryId: entryId,
        data: {
          displayName: displayName,
          members: members,
          featureFlags: [Keys.FeatureFlagManagedOrganisation],
        },
      });
    });
  }

  /**
   * Gets the user profile by display name.
   * @param {string} displayName The display name of the user.
   * @return {Promise<any>} The user profile.
   */
  export async function getProfileByDisplayName(displayName: string): Promise<any> {
    functions.logger.info(`Getting user profile for user: ${displayName}`);

    return await DataService.getDocumentByField({
      schemaKey: "users",
      field: "displayName",
      value: displayName,
    });
  }

  /**
   * Deletes the user profile.
   * @param {string} uid The user ID of the user to delete the profile for.
   * @return {Promise<void>} The user profile.
   * @throws {functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.HttpsError} If the user profile does not exist.
   */
  export async function deleteProfile(uid: string): Promise<void> {
    functions.logger.info(`Deleting user profile for user: ${uid}`);

    return await DataService.deleteDocument({
      schemaKey: "users",
      entryId: uid,
    });
  }

  /**
   * Updates the email address of the user profile.
   * @param {string} uid The user ID of the user to update the name for.
   * @param {string} email The email to update.
   * @return {Promise<any>} The user profile.
   * @throws {functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.HttpsError} If the name is already up to date.
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
  export async function updateVisibilityFlags(uid: string, visibilityFlags: string[]): Promise<void> {
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
  export async function updateFeatureFlags(uid: string, featureFlags: string[]): Promise<void> {
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
   * @throws {functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.HttpsError} If the name is already up to date.
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
  export async function updateBirthday(uid: string, birthday: string): Promise<void> {
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
   * @throws {functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.HttpsError} If the display name is already up to date.
   */
  export async function updateDisplayName(uid: string, displayName: string): Promise<void> {
    functions.logger.info(`Updating display name for user: ${displayName}`);
    const firestore = adminApp.firestore();

    const firestoreReference = await DataService.getDocumentReference({
      schemaKey: "users",
      entryId: uid,
    });

    await adminApp.firestore().runTransaction(async (transaction) => {
      const displayNameCheck = await firestore.collection("fl_content").where("displayName", "==", displayName).get();
      if (displayNameCheck.size > 0) {
        throw new functions.https.HttpsError("already-exists", `Display name ${displayName} is already taken by another user`);
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
  export async function updateInterests(uid: string, interests: string[]): Promise<void> {
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
   * Updates the Hiv status for the user.
   * @param {string} uid The user ID of the user to update the location for.
   * @param {string} location The location to update.
   */
  export async function updateLocation(uid: string, location?: GeoLocation) {
    functions.logger.info(`Updating location for user: ${uid}`);
    let geoPoint: GeoPoint | null;
    if (location) {
      geoPoint = new GeoPoint(location.latitude, location.longitude);
    } else {
      geoPoint = null;
    }

    await DataService.updateDocument({
      schemaKey: "users",
      entryId: uid,
      data: {
        locationSkipped: !location,
        location: geoPoint,
      },
    });
  }

  /**
   * Updates the profile image of the user.
   * @param {string} uid The user ID of the user to update the reference image URL for.
   * @param {string} profileImageBase64 The base64 encoded image to update.
   * @return {Promise<any>} The user profile.
   * @throws {functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.HttpsError} If the reference image URL is already up to date.
   */
  export async function updateProfileImage(uid: string, profileImageBase64: string): Promise<void> {
    functions.logger.info(`Updating reference image for user: ${uid}`);
    const fileBuffer = Buffer.from(profileImageBase64, "base64");
    if (!fileBuffer || fileBuffer.length === 0) {
      throw new functions.https.HttpsError("invalid-argument", `Invalid base64 encoded image`);
    }

    // Upload the image to the storage bucket
    const imagePath = await StorageService.uploadImageForUser(fileBuffer, uid, {
      contentType: "image/jpeg",
      fileName: "original",
      extension: "jpeg",
      uploadType: UploadType.ProfileImage,
    });

    // Update the user with a new array of references containing the new one
    await DataService.updateDocument({
      schemaKey: "users",
      entryId: uid,
      data: {
        profileImage: imagePath,
      },
    });

    functions.logger.info(`Updated profile image for user: ${uid}`);
  }

  /**
   * Updates the reference image of the user.
   * @param {string} uid The user ID of the user to update the reference image URL for.
   * @param {string} referenceImageBase64 The base64 encoded image to update.
   * @return {Promise<any>} The user profile.
   * @throws {functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.HttpsError} If the reference image URL is already up to date.
   */
  export async function updateReferenceImage(uid: string, referenceImageBase64: string): Promise<void> {
    functions.logger.info(`Updating reference image for user: ${uid}`);
    const fileBuffer = Buffer.from(referenceImageBase64, "base64");
    if (!fileBuffer || fileBuffer.length === 0) {
      throw new functions.https.HttpsError("invalid-argument", "Invalid base64 data");
    }

    // Upload the image to the storage bucket
    const imagePath = await StorageService.uploadImageForUser(fileBuffer, uid, {
      contentType: "image/jpeg",
      extension: "jpeg",
      fileName: "original",
      uploadType: UploadType.ReferenceImage,
    });

    // Update the user with a new array of references containing the new one
    await DataService.updateDocument({
      schemaKey: "users",
      entryId: uid,
      data: {
        referenceImage: imagePath,
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
  export async function updateProfileFcmToken(uid: string, fcmToken: string): Promise<void> {
    functions.logger.info(`Updating FCM token for user: ${uid} to ${fcmToken}`);

    const userProfile = await getProfile(uid);
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

  /**
   * Updates the biography profile of the user.
   * @param {string} uid The UserId of the user to update
   * @param {string} biography
   * @return {Promise<any>} The user profile.
   */
  export async function updateBiography(uid: string, biography: string) {
    functions.logger.info(`Updating biography for user: ${uid}`);

    await DataService.updateDocument({
      schemaKey: "users",
      entryId: uid,
      data: {
        biography: biography,
      },
    });
  }

  /**
   * Updates the accent colour profile of the user.
   * @param {string} uid The UserId of the user to update
   * @param {string} accentColor The accent colour to use.
   * @return {Promise<any>} The user profile.
   */
  export async function updateAccentColor(uid: string, accentColor: string): Promise<void> {
    functions.logger.info(`Updating accent colour for user: ${uid}`);

    await DataService.updateDocument({
      schemaKey: "users",
      entryId: uid,
      data: {
        accentColor: accentColor,
      },
    });
  }
}
