import * as functions from "firebase-functions";

import { ProfileService } from "../services/profile_service";
import { UserService } from "../services/user_service";

export namespace ProfileEndpoints {
  export const hasProfile = functions.https.onCall(async (_, context) => {
    await UserService.verifyAuthenticated(context);
    return await ProfileService.hasCreatedProfile(context.auth?.uid || "");
  });

  export const getProfile = functions.https.onCall(async (_, context) => {
    await UserService.verifyAuthenticated(context);

    functions.logger.info("Getting user profile", { structuredData: true });
    const uid = context.auth?.uid || "";
    const hasCreatedProfile = await ProfileService.hasCreatedProfile(uid);

    if (!hasCreatedProfile) {
      throw new functions.https.HttpsError(
        "not-found",
        "User profile not found"
      );
    }

    const userProfile = await ProfileService.getUserProfile(uid);
    functions.logger.info("User profile", { userProfile });

    return JSON.stringify(userProfile);
  });

  export const createProfile = functions.https.onCall(async (_, context) => {
    await UserService.verifyAuthenticated(context);

    const uid = context.auth?.uid || "";
    const name = context.auth?.token.name || "";
    const email = context.auth?.token.email || "";
    const phone = context.auth?.token.phone_number || "";

    functions.logger.info("Creating user profile", {
      uid,
      name,
      email,
      phone,
    });

    const currentUserProfile = await ProfileService.getUserProfile(uid);
    if (currentUserProfile) {
      functions.logger.info("User profile already exists");
      return JSON.stringify(currentUserProfile);
    }

    const newUserRecord = await ProfileService.createInitialUserProfile(
      uid,
      name,
      email,
      phone
    );

    functions.logger.info("User profile created", { newUserRecord });
    return JSON.stringify(newUserRecord);
  });

  export const updateFcmToken = functions.https.onCall(
    async (data, context) => {
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

      const hasCreatedProfile = await ProfileService.getUserProfile(uid);
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
    }
  );
}
