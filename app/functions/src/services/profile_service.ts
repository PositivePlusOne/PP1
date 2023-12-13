import * as functions from "firebase-functions";

import { adminApp } from "..";

import { DataService } from "./data_service";

import { SystemService } from "./system_service";
import { Keys } from "../constants/keys";
import { ProfileJSON } from "../dto/profile";
import { FlamelinkHelpers } from "../helpers/flamelink_helpers";
import { MediaJSON } from "../dto/media";
import { StorageService } from "./storage_service";
import { SearchService } from "./search_service";

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
   * Updates the promoted post counts for the profile.
   * @param {ProfileJSON} profile The profile to update the promoted counts for.
   * @param {number} offset The offset to add to the promoted counts.
   */
  export async function increaseAvailablePromotedCountsForProfile(profile: ProfileJSON, offset: number): Promise<void> {
    const profileId = FlamelinkHelpers.getFlamelinkIdFromObject(profile);
    if (!profileId) {
      throw new functions.https.HttpsError("invalid-argument", "Invalid user ID");
    }

    const newAvailablePromotionsCount = (profile.availablePromotionsCount ?? 0) + offset;
    const newActivePromotionsCount = (profile.activePromotionsCount ?? 0) - offset;
    return await DataService.updateDocument({
      schemaKey: "users",
      entryId: profileId,
      data: {
        availablePromotionsCount: newAvailablePromotionsCount,
        activePromotionsCount: newActivePromotionsCount,
      },
    });
  }


  /**
   * Gets the user profile.
   * @param {string} uid The FL ID of the user.
   * @return {Promise<any>} The user profile.
   */
  export async function getProfile(uid: string, skipCacheLookup = false): Promise<any> {
    functions.logger.info(`Getting user profile for user: ${uid}`);

    return await DataService.getDocument({
      schemaKey: "users",
      entryId: uid,
    }, skipCacheLookup) as ProfileJSON;
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
   * Creates a profile from the current users auth data.
   * @param {string} uid The user ID of the user to create the profile for.
   * @param {string} email The email of the user.
   * @param {string} phone The phone number of the user.
   * @param {string} locale The locale of the user.
   * @return {Promise<any>} The user profile.
   */
  export async function createProfile(uid: string, email: string, phone: string, locale: string): Promise<any> {
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
    await adminApp.firestore().runTransaction(async (transaction: any) => {
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
  export async function getProfilesByDisplayName(displayName: string, resultLength = 1): Promise<ProfileJSON[]> {
    // functions.logger.info(`Getting user profile for user: ${displayName}`);

    // return await DataService.getDocumentByField({
    //   schemaKey: "users",
    //   field: "displayName",
    //   value: displayName,
    // });

    functions.logger.info(`Getting user profile for user: ${displayName}`);
    const searchClient = SearchService.getAlgoliaClient();
    const index = SearchService.getIndex(searchClient, "users");

    // Add a facet filter to match the display name excluding case, only if the request is for a single result
    if (resultLength === 1) {
      const displayNameFacetFilter = `displayName:${displayName}`;
      return SearchService.search(index, "", 0, resultLength, [], [displayNameFacetFilter]);
    }

    return SearchService.search(index, "", 0, resultLength, [], []);
  }

  /**
   * Deletes the user profile.
   * @param {string} uid The user ID of the user to delete the profile for.
   * @return {Promise<void>} The user profile.
   * @throws {functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.HttpsError} If the user profile does not exist.
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
   * @throws {functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.HttpsError} If the name is already up to date.
   */
  export async function updateEmail(uid: string, email: string): Promise<any> {
    functions.logger.info(`Updating email for profile: ${email}`);

    return await DataService.updateDocument({
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
  export async function updatePhoneNumber(uid: string, phoneNumber: string): Promise<any> {
    functions.logger.info(`Updating phone number for user: ${phoneNumber}`);

    return await DataService.updateDocument({
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
  export async function updateVisibilityFlags(uid: string, visibilityFlags: string[]): Promise<any> {
    functions.logger.info(`Updating visibility flags for user: ${uid}`);

    return await DataService.updateDocument({
      schemaKey: "users",
      entryId: uid,
      data: {
        visibilityFlags: [...new Set(visibilityFlags)],
      },
    });
  }

  export async function removeAccountFlags(profile: ProfileJSON, accountFlags: string[]): Promise<any> {
    const entryId = FlamelinkHelpers.getFlamelinkIdFromObject(profile);
    if (!entryId) {
      throw new functions.https.HttpsError("invalid-argument", "Invalid user ID");
    }

    const currentAccountFlags = [...profile.accountFlags ?? []] as string[];
    const missingAccountFlags = accountFlags.filter((accountFlag) => !currentAccountFlags.includes(accountFlag));
    if (missingAccountFlags.length > 0) {
      return profile;
    }

    functions.logger.info(`Removing account flags for user: ${entryId}`);
    const newAccountFlags = [...profile.accountFlags ?? []] as string[];
    for (const accountFlag of accountFlags) {
      const index = newAccountFlags.indexOf(accountFlag);
      if (index > -1) {
        newAccountFlags.splice(index, 1);
      }
    }

    return await DataService.updateDocument({
      schemaKey: "users",
      entryId: entryId,
      data: {
        accountFlags: [...new Set(newAccountFlags)],
      },
    });
  }

  export async function updateAccountFlags(uid: string, accountFlags: string[]): Promise<any> {
    functions.logger.info(`Updating account flags for user: ${uid}`);

    return await DataService.updateDocument({
      schemaKey: "users",
      entryId: uid,
      data: {
        accountFlags: [...new Set(accountFlags)],
      },
    });
  }

  /**
   * Updates the feature flags of the user.
   * @param {string} uid The user ID of the user to update the visibility flags for.
   * @param {string[]} featureFlags The visibility flags to update.
   * @return {Promise<any>} The user profile.
   */
  export async function updateFeatureFlags(uid: string, featureFlags: string[]): Promise<any> {
    functions.logger.info(`Updating features flags for user: ${uid}`);

    return await DataService.updateDocument({
      schemaKey: "users",
      entryId: uid,
      data: {
        featureFlags: [...new Set(featureFlags)],
      },
    });
  }

  /**
   * Updates the name of the user.
   * @param {string} uid The user ID of the user to update the name for.
   * @param {string} name The name to update.
   * @return {Promise<any>} The user profile.
   * @throws {functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.HttpsError} If the name is already up to date.
   */
  export async function updateName(uid: string, name: string): Promise<any> {
    functions.logger.info(`Updating name for user: ${name}`);

    return await DataService.updateDocument({
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
  export async function updateBirthday(uid: string, birthday: string): Promise<any> {
    functions.logger.info(`Updating birthday for user: ${birthday}`);

    return await DataService.updateDocument({
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
   * @throws {functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.HttpsError} If the display name is already up to date.
   */
  export async function updateDisplayName(uid: string, displayName: string): Promise<any> {
    const firestore = adminApp.firestore();

    const displayNameCheck = await firestore.collection("fl_content").where("displayName", "==", displayName).get();
    if (displayNameCheck.size > 0) {
      throw new functions.https.HttpsError("already-exists", `Display name ${displayName} is already taken by another user`);
    }

    return await DataService.updateDocument({
      schemaKey: "users",
      entryId: uid,
      data: {
        displayName,
      },
    });
  }

  /**
   * Updates the interests for the user.
   * @param {string} uid The user ID of the user to update the interests for.
   * @param {string[]} interests The interests to update.
   */
  export async function updateInterests(uid: string, interests: string[]): Promise<any> {
    functions.logger.info(`Updating interests for user: ${uid}`);

    return await DataService.updateDocument({
      schemaKey: "users",
      entryId: uid,
      data: {
        interests: [...new Set(interests)],
      },
    });
  }

  /**
   * Updates the Hiv status for the user.
   * @param {string} uid The user ID of the user to update the status for.
   * @param {string} status The status to update.
   */
  export async function updateHivStatus(uid: string, status: string): Promise<any> {
    functions.logger.info(`Updating status for user: ${uid}`);

    return await DataService.updateDocument({
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
   * @param {string} place The place to update.
   */
  export async function updatePlace(uid: string, description: string, placeId: string, optOut: boolean, latitudeCoordinates: number | null, longitudeCoordinates: number | null): Promise<any> {
    functions.logger.info(`Updating place for user: ${uid}`);

    return await DataService.updateDocument({
      schemaKey: "users",
      entryId: uid,
      data: {
        place: {
          placeId,
          optOut,
          description,
          latitudeCoordinates,
          longitudeCoordinates,
        },
      },
    });
  }

  /**
   * Updates the FCM token of the user.
   * @param {string} uid The user ID of the user to update the FCM token for.
   * @param {string} fcmToken The FCM token to update.
   * @return {Promise<any>} The user profile.
   */
  export async function updateProfileFcmToken(uid: string, fcmToken: string): Promise<any> {
    functions.logger.info(`Updating FCM token for user: ${uid} to ${fcmToken}`);

    const userProfile = await getProfile(uid);
    if (userProfile && userProfile.fcmToken === fcmToken) {
      functions.logger.info("FCM token is already up to date");
      return;
    }

    return await DataService.updateDocument({
      schemaKey: "users",
      entryId: uid,
      data: {
        fcmToken: fcmToken,
      },
    });
  }

  /**
   * Updates the gender profile of the user.
   * @param {string} uid The UserId of the user to update
   * @param {string[]} genders
   */
  export async function updateGenders(uid: string, genders: string[]): Promise<any> {
    functions.logger.info(`Updating gender for user: ${uid}`);

    return await DataService.updateDocument({
      schemaKey: "users",
      entryId: uid,
      data: {
        genders: [...new Set(genders)],
      },
    });
  }

  /**
   * Updates the biography profile of the user.
   * @param {string} uid The UserId of the user to update
   * @param {string} biography
   * @return {Promise<any>} The user profile.
   */
  export async function updateBiography(uid: string, biography: string): Promise<any> {
    functions.logger.info(`Updating biography for user: ${uid}`);

    return await DataService.updateDocument({
      schemaKey: "users",
      entryId: uid,
      data: {
        biography: biography,
      },
    });
  }

  /**
   * Updates the companysector profile of the user.
   * @param {string} uid The UserId of the user to update
   * @param {string[]} companySectors
   */
  export async function updateCompanySectors(uid: string, companySectors: string[]): Promise<any> {
    functions.logger.info(`Updating company sectors for user: ${uid}`);

    return await DataService.updateDocument({
      schemaKey: "users",
      entryId: uid,
      data: {
        companySectors: [...new Set(companySectors)],
      },
    });
  }

  /**
   * Updates the accent colour profile of the user.
   * @param {string} uid The UserId of the user to update
   * @param {string} accentColor The accent colour to use.
   * @return {Promise<any>} The user profile.
   */
  export async function updateAccentColor(uid: string, accentColor: string): Promise<any> {
    functions.logger.info(`Updating accent colour for user: ${uid}`);

    return await DataService.updateDocument({
      schemaKey: "users",
      entryId: uid,
      data: {
        accentColor: accentColor,
      },
    });
  }

  /**
   * Adds media to the user profile.
   * @param {ProfileJSON} profile The profile to add the media to.
   * @param {any[]} media The media to add.
   * @return {Promise<ProfileJSON>} The updated profile.
   */
  export async function addMedia(profile: ProfileJSON, media: MediaJSON[]): Promise<ProfileJSON> {
    // If the media array is empty, return the profile
    if (!profile._fl_meta_?.fl_id || !media || media.length === 0) {
      functions.logger.error("Media array is empty");
      return profile;
    }

    const bucket = adminApp.storage().bucket();
    const mediaPromises = [] as Promise<any>[];
    for (const mediaItem of media) {
      if (mediaItem?.type !== "bucket_path" || !mediaItem?.bucketPath || mediaItem?.url) {
        continue;
      }

      const formattedBucketPath = StorageService.formatBucketPath(mediaItem.bucketPath);
      const file = bucket.file(formattedBucketPath);
      const [exists] = await file.exists();
      if (!exists) {
        throw new functions.https.HttpsError("not-found", `Media item ${formattedBucketPath} does not exist`);
      }
    }

    await Promise.all(mediaPromises);

    const newMedia = [...media ?? []] as MediaJSON[];
    for (const mediaItem of profile.media ?? []) {
      // we don't want to add the old one that this is replacing - either the name is identical
      // or they both start with 'profile' or 'reference' as they are new
      const existingMediaItem = media.find((m) =>
        m.name === mediaItem.name ||
        (mediaItem.name?.startsWith('profile') && m.name?.startsWith('profile')) ||
        (mediaItem.name?.startsWith('reference') && m.name?.startsWith('reference')) ||
        (mediaItem.name?.startsWith('cover') && m.name?.startsWith('cover')));

      if (existingMediaItem) {
        continue;
      }

      newMedia.push(mediaItem);
    }

    functions.logger.info(`Updating media for user: ${profile._fl_meta_.fl_id}`, newMedia, media, profile.media);

    return await DataService.updateDocument({
      schemaKey: "users",
      entryId: profile._fl_meta_.fl_id,
      data: {
        media: newMedia,
      },
    });
  }

  export async function createMediaFromBytes(profile: ProfileJSON, bytes: ArrayBuffer, folder: string, name: string, contentType: string): Promise<MediaJSON> {
    const bucket = adminApp.storage().bucket();
    const profileID = FlamelinkHelpers.getFlamelinkIdFromObject(profile);
    if (!profileID) {
      throw new functions.https.HttpsError("invalid-argument", "Invalid user ID");
    }

    if (!folder || !name) {
      throw new functions.https.HttpsError("invalid-argument", "Invalid folder or name");
    }

    const mediaPath = `users/${profileID}/${folder}/${name}`;
    const file = bucket.file(mediaPath);

    const bufferFromArr = Buffer.from(bytes);
    await file.save(bufferFromArr, {
      contentType: contentType,
      public: true,
      metadata: {
        cacheControl: "public, max-age=31536000",
      },
    });

    const media = {
      name: name,
      bucketPath: mediaPath,
      isPrivate: false,
      priority: 0,
      type: "bucket_path",
    } as MediaJSON;

    return media;
  }

  /**
   * Removes media from the user profile.
   * @param {ProfileJSON} profile The profile to remove the media from.
   * @param {any[]} media The media to remove.
   * @return {Promise<ProfileJSON>} The updated profile.
   */
  export async function removeMedia(profile: ProfileJSON, media: MediaJSON[]): Promise<ProfileJSON> {
    const uid = FlamelinkHelpers.getFlamelinkIdFromObject(profile);
    if (!uid) {
      throw new functions.https.HttpsError("invalid-argument", "Invalid user ID");
    }

    // If the media array is empty, return the profile
    if (!media || media.length === 0) {
      functions.logger.error("Media array is empty");
      return profile;
    }

    // If the profile already has media, add the new media to the existing media
    if (!profile.media) {
      profile.media = [];
    }

    profile.media = profile.media.filter((m) => {
      return !media.find((mediaItem) => mediaItem.bucketPath === m.bucketPath);
    });

    return await DataService.updateDocument({
      schemaKey: "users",
      entryId: uid,
      data: {
        media: [...profile.media],
      },
    });
  }
}
