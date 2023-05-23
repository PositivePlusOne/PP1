import * as functions from "firebase-functions";

import { ProfileMapper } from "../mappers/profile_mappers";
import { AuthorizationTarget } from "../services/enumerations/authorization_target";
import { PermissionsService } from "../services/permissions_service";
import { ProfileService } from "../services/profile_service";
import { UserService } from "../services/user_service";
import { ProfileLocationDto } from "../dto/profile_location_dto";
import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";

export namespace ProfileEndpoints {
  export const hasProfile = functions.https.onCall(async (_, context) => {
    await UserService.verifyAuthenticated(context);
    return await ProfileService.hasCreatedProfile(context.auth?.uid || "");
  });

  export const getProfile = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (data, context) => {
      functions.logger.info("Getting user profile", { structuredData: true });

      const targetUid = data.uid || "";
      if (targetUid.length === 0) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "The function must be called with a valid uid"
        );
      }

      const userProfile = await ProfileService.getProfile(targetUid);
      if (!userProfile) {
        throw new functions.https.HttpsError(
          "not-found",
          "The user profile does not exist"
        );
      }

      const permissionContext = PermissionsService.getPermissionContext(
        context,
        AuthorizationTarget.Profile,
        targetUid
      );

      return ProfileMapper.convertProfileToResponse(
        userProfile,
        permissionContext
      );
    });

  export const createProfile = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (data, context) => {
      await UserService.verifyAuthenticated(context);

      const uid = context.auth?.uid || "";
      const email = context.auth?.token.email || "";
      const phone = context.auth?.token.phone_number || "";
      const locale = data.locale || "en";

      functions.logger.info("Creating user profile", {
        uid,
        email,
        phone,
        locale,
      });

      const currentUserProfile = await ProfileService.getProfile(uid);
      if (currentUserProfile) {
        functions.logger.info("User profile already exists");
        return JSON.stringify(currentUserProfile);
      }

      const newUserRecord = await ProfileService.createUserProfile(
        uid,
        email,
        phone,
        locale
      );

      functions.logger.info("User profile created", { newUserRecord });
      return JSON.stringify(newUserRecord);
    });

  export const deleteProfile = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (_, context) => {
      await UserService.verifyAuthenticated(context);
      functions.logger.info("Deleting user profile", { structuredData: true });

      const uid = context.auth?.uid || "";

      await ProfileService.deleteProfile(uid);
      functions.logger.info("User profile deleted");

      return JSON.stringify({ success: true });
    });

  export const updateFcmToken = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (data, context) => {
      await UserService.verifyAuthenticated(context);

      const fcmToken = data.fcmToken || "";
      const uid = context.auth?.uid || "";
      functions.logger.info("Updating user profile fcm token", {
        uid,
        fcmToken,
      });

      if (!(typeof fcmToken === "string") || fcmToken.length === 0) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "You must provide a valid fcmToken"
        );
      }

      const hasCreatedProfile = await ProfileService.getProfile(uid);
      if (!hasCreatedProfile) {
        throw new functions.https.HttpsError(
          "not-found",
          "User profile not found"
        );
      }

      await ProfileService.updateProfileFcmToken(uid, fcmToken);
      functions.logger.info("User profile fcm token updated", {
        uid,
        fcmToken,
      });

      return JSON.stringify({ success: true });
    });

  export const updateEmailAddress = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (data, context) => {
      await UserService.verifyAuthenticated(context);

      const email = data.email || "";
      const uid = context.auth?.uid || "";
      functions.logger.info("Updating user email address", {
        uid,
        email,
      });

      if (!(typeof email === "string") || email.length < 1) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "You must provide a valid email"
        );
      }

      const hasCreatedProfile = await ProfileService.getProfile(uid);
      if (!hasCreatedProfile) {
        throw new functions.https.HttpsError(
          "not-found",
          "User profile not found"
        );
      }

      await ProfileService.updateEmail(uid, email);

      functions.logger.info("User profile email updated", {
        uid,
        email,
      });

      return JSON.stringify({ success: true });
    });

  export const updatePhoneNumber = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (data, context) => {
      await UserService.verifyAuthenticated(context);

      const phoneNumber = data.phoneNumber || "";
      const uid = context.auth?.uid || "";
      functions.logger.info("Updating user phone number", {
        uid,
        phoneNumber,
      });

      if (!(typeof phoneNumber === "string") || phoneNumber.length < 1) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "You must provide a valid phone"
        );
      }

      const hasCreatedProfile = await ProfileService.getProfile(uid);
      if (!hasCreatedProfile) {
        throw new functions.https.HttpsError(
          "not-found",
          "User profile not found"
        );
      }

      await ProfileService.updatePhoneNumber(uid, phoneNumber);

      functions.logger.info("User profile phone number updated", {
        uid,
        phoneNumber,
      });

      return JSON.stringify({ success: true });
    });

  export const updateName = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (data, context) => {
      await UserService.verifyAuthenticated(context);

      const name = data.name || "";
      const visibilityFlags = data.visibilityFlags || [];
      const uid = context.auth?.uid || "";
      functions.logger.info("Updating user profile name", {
        uid,
        name,
      });

      if (!(typeof name === "string") || name.length < 1) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "You must provide a valid name"
        );
      }

      const hasCreatedProfile = await ProfileService.getProfile(uid);
      if (!hasCreatedProfile) {
        throw new functions.https.HttpsError(
          "not-found",
          "User profile not found"
        );
      }

      await ProfileService.updateVisibilityFlags(uid, visibilityFlags);
      await ProfileService.updateName(uid, name);

      functions.logger.info("User profile name updated", {
        uid,
        name,
      });

      return JSON.stringify({ success: true });
    });

  export const updateDisplayName = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (data, context) => {
      await UserService.verifyAuthenticated(context);

      const displayName = data.displayName || "";
      const uid = context.auth?.uid || "";
      functions.logger.info("Updating user profile display name", {
        uid,
        displayName,
      });

      if (!(typeof displayName === "string") || displayName.length < 3) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "You must provide a valid display name"
        );
      }

      const hasCreatedProfile = await ProfileService.getProfile(uid);
      if (!hasCreatedProfile) {
        throw new functions.https.HttpsError(
          "not-found",
          "User profile not found"
        );
      }

      await ProfileService.updateDisplayName(uid, displayName);

      functions.logger.info("User profile display name updated", {
        uid,
        displayName,
      });

      return JSON.stringify({ success: true });
    });

  export const updateBirthday = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (data, context) => {
      await UserService.verifyAuthenticated(context);

      const birthday = data.birthday || "";
      const visibilityFlags = data.visibilityFlags || [];
      const uid = context.auth?.uid || "";
      functions.logger.info("Updating user profile birthday", {
        uid,
        birthday,
      });

      if (!(typeof birthday === "string") || birthday.length < 1) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "You must provide a valid birthday"
        );
      }

      const hasCreatedProfile = await ProfileService.getProfile(uid);
      if (!hasCreatedProfile) {
        throw new functions.https.HttpsError(
          "not-found",
          "User profile not found"
        );
      }

      await ProfileService.updateVisibilityFlags(uid, visibilityFlags);
      await ProfileService.updateBirthday(uid, birthday);

      functions.logger.info("User profile birthday updated", {
        uid,
        birthday,
      });

      return JSON.stringify({ success: true });
    });

  export const updateInterests = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (data, context) => {
      await UserService.verifyAuthenticated(context);

      const interests = data.interests || [];
      const visibilityFlags = data.visibilityFlags || [];
      const uid = context.auth?.uid || "";
      functions.logger.info("Updating user profile interests", {
        uid,
        interests,
      });

      if (!(interests instanceof Array)) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "You must provide a valid interests"
        );
      }

      const hasCreatedProfile = await ProfileService.getProfile(uid);
      if (!hasCreatedProfile) {
        throw new functions.https.HttpsError(
          "not-found",
          "User profile not found"
        );
      }

      await ProfileService.updateVisibilityFlags(uid, visibilityFlags);
      await ProfileService.updateInterests(uid, interests);

      functions.logger.info("User profile interests updated", {
        uid,
        interests,
      });

      return JSON.stringify({ success: true });
    });

  export const updateGenders = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (data, context) => {
      await UserService.verifyAuthenticated(context);

      const genders = data.genders || [];
      const visibilityFlags = data.visibilityFlags || [];
      const uid = context.auth?.uid || "";
      functions.logger.info("Updating user profile genders", {
        uid,
        genders,
      });

      if (!(genders instanceof Array)) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "You must provide a valid list of genders"
        );
      }

      const hasCreatedProfile = await ProfileService.getProfile(uid);
      if (!hasCreatedProfile) {
        throw new functions.https.HttpsError(
          "not-found",
          "User profile not found"
        );
      }

      await ProfileService.updateVisibilityFlags(uid, visibilityFlags);
      await ProfileService.updateGenders(uid, genders);

      functions.logger.info("User profile genders updated", {
        uid,
        genders,
      });

      return JSON.stringify({ success: true });
    });

  export const updateLocation = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (data: ProfileLocationDto, context) => {
      await UserService.verifyAuthenticated(context);

      const location = data.location;

      const visibilityFlags = data.visibilityFlags || [];
      console.log("visibilityFlags", visibilityFlags);
      const uid = context.auth?.uid || "";
      functions.logger.info("Updating user profile location", {
        uid,
        location,
      });

      const hasCreatedProfile = await ProfileService.getProfile(uid);
      if (!hasCreatedProfile) {
        throw new functions.https.HttpsError(
          "not-found",
          "User profile not found"
        );
      }

      await ProfileService.updateVisibilityFlags(uid, visibilityFlags);
      await ProfileService.updateLocation(uid, location);

      functions.logger.info("User profile genders updated", {
        uid,
        location,
      });

      return JSON.stringify({ success: true });
    });
  export const updateHivStatus = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (data, context) => {
      await UserService.verifyAuthenticated(context);

      const status = data.status;
      const visibilityFlags = data.visibilityFlags || [];
      const uid = context.auth?.uid || "";
      functions.logger.info("Updating user profile hiv status", {
        uid,
        status,
      });

      if (typeof status !== "string") {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "You must provide a valid status"
        );
      }

      const hasCreatedProfile = await ProfileService.getProfile(uid);
      if (!hasCreatedProfile) {
        throw new functions.https.HttpsError(
          "not-found",
          "User profile not found"
        );
      }

      await ProfileService.updateVisibilityFlags(uid, visibilityFlags);
      await ProfileService.updateHivStatus(uid, status);

      functions.logger.info("User profile hiv status updated", {
        uid,
        status,
      });

      return JSON.stringify({ success: true });
    });

  export const updateReferenceImage = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (data, context) => {
      await UserService.verifyAuthenticated(context);

      const referenceImage = data.referenceImage || "";
      const uid = context.auth?.uid || "";
      functions.logger.info("Updating user profile reference image");

      if (referenceImage.length === 0) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "You must provide valid reference images"
        );
      }

      const hasCreatedProfile = await ProfileService.getProfile(uid);
      if (!hasCreatedProfile) {
        throw new functions.https.HttpsError(
          "not-found",
          "User profile not found"
        );
      }

      await ProfileService.updateReferenceImage(uid, referenceImage);
      functions.logger.info("User profile reference image updated");

      return JSON.stringify({ success: true });
    });

  export const updateProfileImage = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (data, context) => {
      await UserService.verifyAuthenticated(context);

      const profileImage = data.profileImage || "";
      const uid = context.auth?.uid || "";
      functions.logger.info("Added user profile profile image");

      if (profileImage.length === 0) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "You must provide a valid profile images"
        );
      }

      const hasCreatedProfile = await ProfileService.getProfile(uid);
      if (!hasCreatedProfile) {
        throw new functions.https.HttpsError(
          "not-found",
          "User profile not found"
        );
      }

      await ProfileService.updateProfileImage(uid, profileImage);
      functions.logger.info("User profile images added");

      return JSON.stringify({ success: true });
    });

  export const updateBiography = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (data, context) => {
      await UserService.verifyAuthenticated(context);

      const biography = data.biography || "";
      const uid = context.auth?.uid || "";

      functions.logger.info("Updating user profile biography", {
        uid,
        biography,
      });

      if (biography.length === 0) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "You must provide a valid biography"
        );
      }

      const hasCreatedProfile = await ProfileService.getProfile(uid);
      if (!hasCreatedProfile) {
        throw new functions.https.HttpsError(
          "not-found",
          "User profile not found"
        );
      }

      await ProfileService.updateBiography(uid, biography);

      functions.logger.info("User profile biography updated", {
        uid,
        biography,
      });

      return JSON.stringify({ success: true });
    });

  export const updateAccentColor = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (data, context) => {
      await UserService.verifyAuthenticated(context);

      const accentColor = data.accentColor || "";
      const uid = context.auth?.uid || "";

      functions.logger.info("Updating user profile accent colour", {
        uid,
        accentColor,
      });

      if (accentColor.length === 0) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "You must provide a valid accent colour"
        );
      }

      const hasCreatedProfile = await ProfileService.getProfile(uid);
      if (!hasCreatedProfile) {
        throw new functions.https.HttpsError(
          "not-found",
          "User profile not found"
        );
      }

      await ProfileService.updateAccentColor(uid, accentColor);

      functions.logger.info("User profile accent colour updated", {
        uid,
        accentColor,
      });

      return JSON.stringify({ success: true });
    });

  export const updateFeatureFlags = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (data, context) => {
      await UserService.verifyAuthenticated(context);

      const featureFlags = data.featureFlags || [];
      const uid = context.auth?.uid || "";
      functions.logger.info("Updating user profile feature flags", {
        uid,
        featureFlags,
      });

      if (!(featureFlags instanceof Array)) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "You must provide a valid list of feature flags"
        );
      }

      const hasCreatedProfile = await ProfileService.getProfile(uid);
      if (!hasCreatedProfile) {
        throw new functions.https.HttpsError(
          "not-found",
          "User profile not found"
        );
      }

      // TODO(ryan): Add checks around the new feature flags (Can they toggle them?)
      await ProfileService.updateFeatureFlags(uid, featureFlags);

      functions.logger.info("User profile feature flags updated", {
        uid,
        featureFlags,
      });

      return JSON.stringify({ success: true });
    });

    export const updateVisibilityFlags = functions
      .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
      .https.onCall(async (data, context) => {
        await UserService.verifyAuthenticated(context);
  
        const visibilityFlags = data.visibilityFlags || [];
        const uid = context.auth?.uid || "";
        functions.logger.info("Updating user profile visibility flags", {
          uid,
          visibilityFlags,
        });
  
        if (!(visibilityFlags instanceof Array)) {
          throw new functions.https.HttpsError(
            "invalid-argument",
            "You must provide a valid list of visibility flags"
          );
        }
  
        const hasCreatedProfile = await ProfileService.getProfile(uid);
        if (!hasCreatedProfile) {
          throw new functions.https.HttpsError(
            "not-found",
            "User profile not found"
          );
        }
  
        // TODO(ryan): Add checks around the new visibility flags (Can they toggle them?)
        await ProfileService.updateVisibilityFlags(uid, visibilityFlags);
  
        functions.logger.info("User profile visibility flags updated", {
          uid,
          visibilityFlags,
        });
  
        return JSON.stringify({ success: true });
      });
}
