import * as functions from "firebase-functions";

import { ProfileService } from "../services/profile_service";
import { UserService } from "../services/user_service";
import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";
import { EndpointRequest, buildEndpointResponse } from "./dto/payloads";
import { CacheService } from "../services/cache_service";
import { MediaJSON } from "../dto/media";
import { ProfileJSON } from "../dto/profile";
import { DataService } from "../services/data_service";
import { EmailHelpers } from "../helpers/email_helpers";

export namespace ProfileEndpoints {

  /**
   * helper function to determine if a profile is completed now
   * @param profileUid is the UID of the profile we are checking
   * @param profile is the profile to check
   */
  export function isProfileComplete(profileUid: string, profile: any): boolean {
    if (!profile || !profile.data || !profile.data.email) {
      // just to make this robust - if we don't have enough of a picture of the profile, we will get a better one
      profile = ProfileService.getProfile(profileUid);
    }
    //!TODO what constitues a completed profile - so we don't send hundreds of emails as they type in each bit for the first time
    //! probably something to do with the color being set - or whatever is the last required thing...
    return profile && profile.data && profile.data.accentColor;
  }

  /**
   * helper to send an update email when they change something about the profile
   * @param profileUid is the UID of the profile we are checking
   * @param profile is the profile they just changed
   * @returns promise of true if sent, else false
   */
  export function sendRequiredAccountUpdateEmail(profileUid: string, profile: any): Promise<boolean> {
    if (!profile || !profile.data || !profile.data.email) {
      // just to make this robust - if we don't have enough of a picture of the profile, we will get a better one
      profile = ProfileService.getProfile(profileUid);
    }
    if (isProfileComplete(profileUid, profile)) {
      // the new profile is complete - but they just updated it, send an email please
      return EmailHelpers.sendEmail(
        profile.data.email,
        "Account Updated", 
        "Some details have been updated in your Positive+1 account settings<br/>" +
        "If this wasn’t you, please check your account and get in touch at email:support@positiveplusone.com",
        "Return to Positive+1");
    } else {
      // return that this failed
      return Promise.resolve(false);
    }
  }

  export const getProfiles = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    functions.logger.info("Getting user profiles", { structuredData: true });
    const uid = request.sender || context.auth?.uid || "";

    let targets = request.data.targets || [] as string[];
    targets = [...new Set(targets.filter((target: string) => target.length > 0))];

    if (targets.length === 0) {
      throw new functions.https.HttpsError("invalid-argument", "The function must be called with a valid array of targets");
    }

    const profiles = await CacheService.getMultipleFromCache(targets) || [] as ProfileJSON[];
    const cachedProfileIds = profiles.map((profile: ProfileJSON) => profile._fl_meta_?.fl_id || "");
    const uncachedProfileIds = targets.filter((target: string) => !cachedProfileIds.includes(target));
    
    if (uncachedProfileIds.length > 0) {
      let uncachedProfiles = await DataService.getBatchDocuments({
        entryIds: uncachedProfileIds,
        schemaKey: "users",
      }) || [] as ProfileJSON[];

      // Remove any profiles that don't exist
      uncachedProfiles = uncachedProfiles.filter((profile: ProfileJSON) => !!profile);

      // Add the fetched profiles lisr
      profiles.push(...uncachedProfiles);
    }
    
    return buildEndpointResponse(context, {
      sender: uid,
      data: profiles,
    });
  });

  export const getProfile = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    functions.logger.info("Getting user profile", { structuredData: true });

    const uid = request.sender || context.auth?.uid || "";
    const targetUid = request.data.uid || "";
    if (targetUid.length === 0) {
      throw new functions.https.HttpsError("invalid-argument", "The function must be called with a valid uid");
    }

    const userProfile = await ProfileService.getProfile(targetUid);
    if (!userProfile) {
      throw new functions.https.HttpsError("not-found", "The user profile does not exist");
    }

    return buildEndpointResponse(context, {
      sender: uid,
      data: [userProfile],
    });
  });

  export const deleteProfile = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const targetUid = await UserService.verifyAuthenticated(context, request.sender);
    functions.logger.info("Deleting user profile", { structuredData: true });

    const userProfile = await ProfileService.getProfile(targetUid);
    if (!userProfile) {
      throw new functions.https.HttpsError("not-found", "The user profile does not exist so cannot be deleted");
    }

    await ProfileService.deleteProfile(targetUid);
    functions.logger.info("User profile deleted");

    await EmailHelpers.sendEmail(
      userProfile.data.email,
      "Account Deleted",
      //!TODO this copy needs to change when designed
      "Welcome to the beginning of your Positive+1 experience<br/>" +
      `An account has been started with ${userProfile.data.email}<br/>` +
      "If this wasn’t you, please get in touch at mail:support@positiveplusone.com<br/>" +
      "If you did not finish your registration, you can continue on your mobile app, or by tapping below.",
      "Return to Positive+1");

    return JSON.stringify({ success: true });
  });

  export const updateFcmToken = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);
    const fcmToken = request.data.fcmToken || "";

    functions.logger.info("Updating user profile fcm token", {
      uid,
      fcmToken,
    });

    if (!(typeof fcmToken === "string") || fcmToken.length === 0) {
      throw new functions.https.HttpsError("invalid-argument", "You must provide a valid fcmToken");
    }

    const newProfile = await ProfileService.updateProfileFcmToken(uid, fcmToken);
    functions.logger.info("User profile fcm token updated", {
      uid,
      fcmToken,
    });

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newProfile],
    });
  });

  export const updateEmailAddress = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);
    const emailAddress = request.data.emailAddress || "";

    functions.logger.info("Updating email address", {
      uid,
      emailAddress,
    });

    if (!(typeof emailAddress === "string") || emailAddress.length < 1) {
      throw new functions.https.HttpsError("invalid-argument", "You must provide a valid email");
    }

    const newProfile = await ProfileService.updateEmail(uid, emailAddress);
    functions.logger.info("User profile email updated", {
      uid,
      emailAddress,
    });

    // the email address is intrinsicly connected to their account - so this is a new account by setting this?
    await EmailHelpers.sendEmail(
      emailAddress,
      "Account Created",
      "Welcome to the beginning of your Positive+1 experience<br/>" +
      `An account has been started with ${emailAddress}<br/>` +
      "If this wasn’t you, please get in touch at mail:support@positiveplusone.com<br/>" +
      "If you did not finish your registration, you can continue on your mobile app, or by tapping below.",
      "Return to Positive+1");

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newProfile],
    });
  });

  export const updatePhoneNumber = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);

    const phoneNumber = request.data.phoneNumber || "";
    functions.logger.info("Updating profile phone number", {
      uid,
      phoneNumber,
    });

    if (!(typeof phoneNumber === "string") || phoneNumber.length < 1) {
      throw new functions.https.HttpsError("invalid-argument", "You must provide a valid phone");
    }

    const newProfile = await ProfileService.updatePhoneNumber(uid, phoneNumber);
    functions.logger.info("Profile phone number updated", {
      uid,
      phoneNumber,
    });

    // we might want to send an update email here
    await sendRequiredAccountUpdateEmail(uid, newProfile);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newProfile],
    });
  });

  export const updateName = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);

    const name = request.data.name || "";
    const visibilityFlags = request.data.visibilityFlags || [];
    functions.logger.info("Updating profile name", {
      uid,
      name,
    });

    if (!(typeof name === "string") || name.length < 1) {
      throw new functions.https.HttpsError("invalid-argument", "You must provide a valid name");
    }

    const profile = await ProfileService.getProfile(uid);
    if (!profile) {
      throw new functions.https.HttpsError("not-found", "The user profile does not exist");
    }

    await ProfileService.updateVisibilityFlags(uid, visibilityFlags);
    const newProfile = await ProfileService.updateName(uid, name);

    // Remove the name_offensive flag if it exists
    await ProfileService.removeAccountFlags(profile, ["name_offensive"]);
    
    functions.logger.info("Profile name updated", {
      uid,
      name,
    });

    // we might want to send an update email here
    await sendRequiredAccountUpdateEmail(uid, newProfile);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newProfile],
    });
  });

  export const updateDisplayName = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);
    const displayName = request.data.displayName || "";
    functions.logger.info("Updating profile display name", {
      uid,
      displayName,
    });

    if (!(typeof displayName === "string") || displayName.length < 3) {
      throw new functions.https.HttpsError("invalid-argument", "You must provide a valid display name");
    }

    const newProfile = await ProfileService.updateDisplayName(uid, displayName);
    
    // Remove the display_name_offensive flag if it exists
    await ProfileService.removeAccountFlags(newProfile, ["display_name_offensive"]);

    functions.logger.info("User profile display name updated", {
      uid,
      displayName,
    });

    // we might want to send an update email here
    await sendRequiredAccountUpdateEmail(uid, newProfile);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newProfile],
    });
  });

  export const updateBirthday = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);

    const birthday = request.data.birthday || "";
    const visibilityFlags = request.data.visibilityFlags || [];
    functions.logger.info("Updating profile birthday", {
      uid,
      birthday,
    });

    if (!(typeof birthday === "string") || birthday.length < 1) {
      throw new functions.https.HttpsError("invalid-argument", "You must provide a valid birthday");
    }

    await ProfileService.updateVisibilityFlags(uid, visibilityFlags);
    const newProfile = await ProfileService.updateBirthday(uid, birthday);

    functions.logger.info("Profile birthday updated", {
      uid,
      birthday,
    });

    // we might want to send an update email here
    await sendRequiredAccountUpdateEmail(uid, newProfile);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newProfile],
    });
  });

  export const updateInterests = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);

    const interests = request.data.interests || [];
    const visibilityFlags = request.data.visibilityFlags || [];
    functions.logger.info("Updating profile interests", {
      uid,
      interests,
    });

    if (!(interests instanceof Array)) {
      throw new functions.https.HttpsError("invalid-argument", "You must provide a valid interests");
    }

    await ProfileService.updateVisibilityFlags(uid, visibilityFlags);
    const newProfile = await ProfileService.updateInterests(uid, interests);
    functions.logger.info("Profile interests updated", {
      uid,
      interests,
    });

    // we might want to send an update email here
    await sendRequiredAccountUpdateEmail(uid, newProfile);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newProfile],
    });
  });

  export const updateGenders = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);
    const genders = request.data.genders || [];
    const visibilityFlags = request.data.visibilityFlags || [];
    functions.logger.info("Updating profile genders", {
      uid,
      genders,
    });

    if (!(genders instanceof Array)) {
      throw new functions.https.HttpsError("invalid-argument", "You must provide a valid list of genders");
    }

    await ProfileService.updateVisibilityFlags(uid, visibilityFlags);
    const newProfile = await ProfileService.updateGenders(uid, genders);

    functions.logger.info("Profile genders updated", {
      uid,
      genders,
    });

    // we might want to send an update email here
    await sendRequiredAccountUpdateEmail(uid, newProfile);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newProfile],
    });
  });

  export const updateCompanySectors = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    //TODO! @Ryan - need to check your new auth for users who are allowed to edit company data
    const uid = await UserService.verifyAuthenticated(context, request.sender);
    const companySectors = request.data.companySectors || [];
    const visibilityFlags = request.data.visibilityFlags || [];
    functions.logger.info("Updating profile company sectors", {
      uid,
      companySectors,
    });

    if (!(companySectors instanceof Array)) {
      throw new functions.https.HttpsError("invalid-argument", "You must provide a valid list of company sectors");
    }

    await ProfileService.updateVisibilityFlags(uid, visibilityFlags);
    const newProfile = await ProfileService.updateCompanySectors(uid, companySectors);

    functions.logger.info("Profile company sectors updated", {
      uid,
      companySectors,
    });

    // we might want to send an update email here
    await sendRequiredAccountUpdateEmail(uid, newProfile);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newProfile],
    });
  });

  export const updatePlace = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);

    const description = request.data?.description || "";
    const placeId = request.data?.placeId || "";
    const latitude = request.data?.latitude;
    const longitude = request.data?.longitude;
    const optOut = request.data?.optOut || false;
    const visibilityFlags = request.data.visibilityFlags || [];

    functions.logger.info("Updating profile place", {
      uid,
      placeId,
    });

    await ProfileService.updateVisibilityFlags(uid, visibilityFlags);
    const newProfile = await ProfileService.updatePlace(uid, description, placeId, optOut, latitude, longitude);

    functions.logger.info("Profile place updated", {
      uid,
      placeId,
    });

    // we might want to send an update email here
    await sendRequiredAccountUpdateEmail(uid, newProfile);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newProfile],
    });
  });
  
  export const updateHivStatus = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);
    const status = request.data.status;
    const visibilityFlags = request.data.visibilityFlags || [];
    functions.logger.info("Updating profile hiv status", {
      uid,
      status,
    });

    if (typeof status !== "string") {
      throw new functions.https.HttpsError("invalid-argument", "You must provide a valid status");
    }

    await ProfileService.updateVisibilityFlags(uid, visibilityFlags);
    const newProfile = await ProfileService.updateHivStatus(uid, status);

    functions.logger.info("Profile hiv status updated", {
      uid,
      status,
    });

    // we might want to send an update email here
    await sendRequiredAccountUpdateEmail(uid, newProfile);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newProfile],
    });
  });

  export const updateBiography = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);
    const biography = request.data.biography || "";

    functions.logger.info("Updating profile biography", {
      uid,
      biography,
    });

    const newProfile = await ProfileService.updateBiography(uid, biography);
    functions.logger.info("Profile biography updated");

    // we might want to send an update email here
    await sendRequiredAccountUpdateEmail(uid, newProfile);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newProfile],
    });
  });

  export const updateAccentColor = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);
    const accentColor = request.data.accentColor || "";

    functions.logger.info("Updating profile accent colour", {
      uid,
      accentColor,
    });

    if (accentColor.length === 0) {
      throw new functions.https.HttpsError("invalid-argument", "You must provide a valid accent colour");
    }

    const profile = await ProfileService.getProfile(uid);
    if (!profile) {
      throw new functions.https.HttpsError("not-found", "The existing user profile does not exist");
    }

    let wasWelcomeEmailSent = false;
    if (!isProfileComplete(uid, profile)) {
      // this is the first time we will set the profile colour which signifies the end of the account creation process
      //TODO we need to send a different email if a company account
      //TODO somewhere as well a user is invited to a company account and that's different too
      // wasWelcomeEmailSent = await EmailHelpers.sendEmail(
      //   profile.data.email,
      // "Your company has been created on Positive+1",
      // "A new company has been created for you on Positive+1.<br/>Please check your Positive+1 app for your invitation to post and manage content on behalf of your company.",
      // "Return to Positive+1");
      //else we are a normal profile created
      wasWelcomeEmailSent = await EmailHelpers.sendEmail(
        profile.data.email,
      "You Are All set",
      "Your account has been fully set up. Welcome to the community!<br/>" +
      "If this wasn’t you, please get in touch at mail:support@positiveplusone.com<br/>",
      "Return to Positive+1");
    }

    const newProfile = await ProfileService.updateAccentColor(uid, accentColor);
    functions.logger.info("Profile accent colour updated", {
      uid,
      accentColor,
    });

    if (!wasWelcomeEmailSent) {
      // we might want to send an update email here as didn't send a welcome email
      await sendRequiredAccountUpdateEmail(uid, newProfile);
    }

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newProfile],
    });
  });

  export const updateFeatureFlags = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);
    const featureFlags = request.data.featureFlags || [];
    functions.logger.info("Updating profile feature flags", {
      uid,
      featureFlags,
    });

    if (!(featureFlags instanceof Array)) {
      throw new functions.https.HttpsError("invalid-argument", "You must provide a valid list of feature flags");
    }

    const newProfile = await ProfileService.updateFeatureFlags(uid, featureFlags);
    functions.logger.info("User profile feature flags updated", {
      uid,
      featureFlags,
    });

    // we might want to send an update email here
    await sendRequiredAccountUpdateEmail(uid, newProfile);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newProfile],
    });
  });

  export const updateVisibilityFlags = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);
    const visibilityFlags = request.data.visibilityFlags || [];
    functions.logger.info("Updating profile visibility flags", {
      uid,
      visibilityFlags,
    });

    if (!(visibilityFlags instanceof Array)) {
      throw new functions.https.HttpsError("invalid-argument", "You must provide a valid list of visibility flags");
    }

    const newProfile = await ProfileService.updateVisibilityFlags(uid, visibilityFlags);
    functions.logger.info("Profile visibility flags updated", {
      uid,
      visibilityFlags,
    });

    // we might want to send an update email here
    await sendRequiredAccountUpdateEmail(uid, newProfile);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newProfile],
    });
  });

  export const addMedia = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);
    const media = (request.data.media || []) as MediaJSON[];

    if (!(media instanceof Array)) {
      throw new functions.https.HttpsError("invalid-argument", "You must provide a valid list of media");
    }

    const profile = await ProfileService.getProfile(uid);
    if (!profile) {
      throw new functions.https.HttpsError("not-found", "The user profile does not exist");
    }

    const newProfile = await ProfileService.addMedia(profile, media);

    // we might want to send an update email here
    await sendRequiredAccountUpdateEmail(uid, newProfile);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newProfile],
    });
  });

  export const removeMedia = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);

    const mediaId = request.data.mediaId || "";
    if (mediaId.length === 0) {
      throw new functions.https.HttpsError("invalid-argument", "You must provide valid media");
    }

    const profile = await ProfileService.getProfile(uid);
    if (!profile) {
      throw new functions.https.HttpsError("not-found", "The user profile does not exist");
    }

    const newProfile = await ProfileService.removeMedia(profile, mediaId);

    // we might want to send an update email here
    await sendRequiredAccountUpdateEmail(uid, newProfile);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newProfile],
    });
  });
}
