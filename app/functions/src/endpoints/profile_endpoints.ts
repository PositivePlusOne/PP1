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
import { StringHelpers } from "../helpers/string_helpers";
import { SystemService } from "../services/system_service";
import { ProfileHelpers } from "../helpers/profile_helpers";

export namespace ProfileEndpoints {
  export const getProfiles = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    await SystemService.validateUsingRedisUserThrottle(context);
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
    await SystemService.validateUsingRedisUserThrottle(context);
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


  export const getProfileByDisplayName = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    await SystemService.validateUsingRedisUserThrottle(context);
    functions.logger.info("Getting user profile", { structuredData: true });

    const uid = request.sender || context.auth?.uid || "";
    const targeDisplayName = request.data.displayName || "";
    if (targeDisplayName.length === 0) {
      throw new functions.https.HttpsError("invalid-argument", "The function must be called with a valid uid");
    }

    const userProfiles = await ProfileService.getProfilesByDisplayName(targeDisplayName, 1);
    
    if (!userProfiles) {
      throw new functions.https.HttpsError("not-found", "The user profile does not exist");
    }
    
    const userProfile = userProfiles[0];
    
    return buildEndpointResponse(context, {
      sender: uid,
      data: [userProfile],
    });
  });

  export const toggleProfileDeletion = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    await SystemService.validateUsingRedisUserThrottle(context);
    const uid = await UserService.verifyAuthenticated(context, request.sender);
    functions.logger.info("Deleting user profile", { structuredData: true });

    let profile = await ProfileService.getProfile(uid);
    const profileId = profile?._fl_meta_?.fl_id || "";

    if (!profile || profileId.length === 0) {
      throw new functions.https.HttpsError("not-found", "The user profile does not exist");
    }

    let accountFlags = [...profile?.accountFlags ?? []];
    const isPendingDeletion = accountFlags?.includes('pending_deletion') ?? false;

    if (isPendingDeletion) {
      accountFlags = accountFlags.filter((flag: string) => flag !== 'pending_deletion');
      functions.logger.info("User profile deletion cancelled");
      profile = await ProfileService.updateAccountFlags(profileId, accountFlags);
    } else {
      accountFlags.push('pending_deletion');
      functions.logger.info("User profile deletion requested");
      profile = await ProfileService.updateAccountFlags(profileId, accountFlags);
    }

    return buildEndpointResponse(context, {
      sender: uid,
      data: [profile],
    });
  });

  export const updateFcmToken = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    await SystemService.validateUsingRedisUserThrottle(context);
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
    await SystemService.validateUsingRedisUserThrottle(context);
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

    //!TODO the email address is intrinsicly connected to their account - so this is a new account by setting this?
    // await EmailHelpers.sendEmail(
    //   emailAddress,
    //   "Positive+1 Account Created",
    //   "Account Created",
    //   `Welcome to the beginning of your Positive+1 experience. An account has been started with ${emailAddress}.`,
    //   "If you did not finish your registration, you can continue on your mobile app, or by tapping below.",
    //   "Return to Positive+1",
    //   "https://www.positiveplusone.com");

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newProfile],
    });
  });

  export const updatePhoneNumber = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    await SystemService.validateUsingRedisUserThrottle(context);
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

    //TODO we might want to send an update email here
    // await sendRequiredAccountUpdateEmail(uid, newProfile);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newProfile],
    });
  });

  export const updateName = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    await SystemService.validateUsingRedisUserThrottle(context);
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

    const isValid = name.length > 3 && name.length < 30 && StringHelpers.isValidRealName(name);
    if (!isValid) {
      throw new functions.https.HttpsError("invalid-argument", "You must provide a valid name");
    }

    let profile = await ProfileService.getProfile(uid);
    if (!profile) {
      throw new functions.https.HttpsError("not-found", "The user profile does not exist");
    }

    profile = await ProfileService.removeAccountFlags(profile, ["name_offensive"]);
    await CacheService.setInCache(profile._fl_meta_.fl_id, profile);

    profile = await ProfileService.updateVisibilityFlags(uid, visibilityFlags);
    await CacheService.setInCache(profile._fl_meta_.fl_id, profile);

    profile = await ProfileService.updateName(uid, name);

    functions.logger.info("Profile name updated", {
      profile,
    });

    //TODO we might want to send an update email here
    // await sendRequiredAccountUpdateEmail(uid, newProfile);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [profile],
    });
  });

  export const updateDisplayName = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    await SystemService.validateUsingRedisUserThrottle(context);
    const uid = await UserService.verifyAuthenticated(context, request.sender);
    const displayName = request.data.displayName || "";
    functions.logger.info("Updating profile display name", {
      uid,
      displayName,
    });

    if (!(typeof displayName === "string") || displayName.length < 3) {
      throw new functions.https.HttpsError("invalid-argument", "You must provide a valid display name");
    }

    const isFirebaseUIDFormat = StringHelpers.isFirebaseUID(displayName);
    if (isFirebaseUIDFormat) {
      throw new functions.https.HttpsError("invalid-argument", "You must provide a valid display name");
    }

    const isValid = displayName.length > 3 && displayName.length < 15 && StringHelpers.isAlphanumericWithSpecialChars(displayName);
    if (!isValid) {
      throw new functions.https.HttpsError("invalid-argument", "You must provide a valid display name");
    }

    const newProfile = await ProfileService.updateDisplayName(uid, displayName);

    // Remove the display_name_offensive flag if it exists
    await ProfileService.removeAccountFlags(newProfile, ["display_name_offensive"]);

    functions.logger.info("User profile display name updated", {
      uid,
      displayName,
    });

    //TODO we might want to send an update email here
    // await sendRequiredAccountUpdateEmail(uid, newProfile);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newProfile],
    });
  });

  export const updateBirthday = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    await SystemService.validateUsingRedisUserThrottle(context);
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

    let newProfile = await ProfileService.updateVisibilityFlags(uid, visibilityFlags);
    await CacheService.setInCache(newProfile._fl_meta_.fl_id, newProfile);

    newProfile = await ProfileService.updateBirthday(uid, birthday);

    functions.logger.info("Profile birthday updated", {
      uid,
      birthday,
    });

    //TODO we might want to send an update email here
    // await sendRequiredAccountUpdateEmail(uid, newProfile);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newProfile],
    });
  });

  export const updateInterests = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    await SystemService.validateUsingRedisUserThrottle(context);
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

    //TODO we might want to send an update email here
    // await sendRequiredAccountUpdateEmail(uid, newProfile);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newProfile],
    });
  });

  export const updateGenders = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    await SystemService.validateUsingRedisUserThrottle(context);
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

    let newProfile = await ProfileService.updateVisibilityFlags(uid, visibilityFlags);
    await CacheService.setInCache(newProfile._fl_meta_.fl_id, newProfile);

    newProfile = await ProfileService.updateGenders(uid, genders);

    functions.logger.info("Profile genders updated", {
      uid,
      genders,
    });

    //TODO we might want to send an update email here
    // await sendRequiredAccountUpdateEmail(uid, newProfile);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newProfile],
    });
  });

  export const updateCompanySectors = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    await SystemService.validateUsingRedisUserThrottle(context);
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

    let newProfile = await ProfileService.updateVisibilityFlags(uid, visibilityFlags);
    await CacheService.setInCache(newProfile._fl_meta_.fl_id, newProfile);

    newProfile = await ProfileService.updateCompanySectors(uid, companySectors);

    functions.logger.info("Profile company sectors updated", {
      uid,
      companySectors,
    });

    //TODO we might want to send an update email here
    // await sendRequiredAccountUpdateEmail(uid, newProfile);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newProfile],
    });
  });

  export const updatePlace = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    await SystemService.validateUsingRedisUserThrottle(context);
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

    let newProfile = await ProfileService.updateVisibilityFlags(uid, visibilityFlags);
    await CacheService.setInCache(newProfile._fl_meta_.fl_id, newProfile);

    newProfile = await ProfileService.updatePlace(uid, description, placeId, optOut, latitude, longitude);

    functions.logger.info("Profile place updated", {
      uid,
      placeId,
    });

    //TODO we might want to send an update email here
    // await sendRequiredAccountUpdateEmail(uid, newProfile);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newProfile],
    });
  });

  export const updateHivStatus = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    await SystemService.validateUsingRedisUserThrottle(context);
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

    let newProfile = await ProfileService.updateVisibilityFlags(uid, visibilityFlags);
    await CacheService.setInCache(newProfile._fl_meta_.fl_id, newProfile);

    newProfile = await ProfileService.updateHivStatus(uid, status);

    functions.logger.info("Profile hiv status updated", {
      uid,
      status,
    });

    //TODO we might want to send an update email here
    // await sendRequiredAccountUpdateEmail(uid, newProfile);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newProfile],
    });
  });

  export const updateBiography = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    await SystemService.validateUsingRedisUserThrottle(context);
    const uid = await UserService.verifyAuthenticated(context, request.sender);
    const biography = request.data.biography || "";

    functions.logger.info("Updating profile biography", {
      uid,
      biography,
    });

    const newProfile = await ProfileService.updateBiography(uid, biography);
    functions.logger.info("Profile biography updated");

    //TODO we might want to send an update email here
    // await sendRequiredAccountUpdateEmail(uid, newProfile);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newProfile],
    });
  });

  export const updateAccentColor = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    await SystemService.validateUsingRedisUserThrottle(context);
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

    const isProfileComplete = await ProfileHelpers.isProfileComplete(uid, profile);

    let wasWelcomeEmailSent = false;
    if (!isProfileComplete && !profile.suppressEmailNotifications) {
      // not suppressing email, send one informing the user they have deleted their profile) {
      // this is the first time we will set the profile colour which signifies the end of the account creation process
      //TODO we need to send a different email if a company account
      //TODO somewhere as well a user is invited to a company account and that's different too
      // wasWelcomeEmailSent = await EmailHelpers.sendEmail(
      //   profile.email,
      // "Positive+1 Company Account Invite",
      // "Your company has been created on Positive+1",
      // "A new company has been created for you on Positive+1. Please check your Positive+1 app for your invitation to post and manage content on behalf of your company.",
      // "",
      // "Return to Positive+1",
      // "https://www.positiveplusone.com");

      // else we are a normal profile created
      wasWelcomeEmailSent = await EmailHelpers.sendEmail(
        profile.email,
        "Positive+1 Account Setup",
        "You Are All Set",
        "Your account has been fully set up. Welcome to the community!",
        "",
        "Return to Positive+1",
        "https://www.positiveplusone.com");
    }

    const newProfile = await ProfileService.updateAccentColor(uid, accentColor);
    functions.logger.info("Profile accent colour updated", {
      uid,
      accentColor,
    });

    if (!wasWelcomeEmailSent) {
      // we might want to send an update email here as didn't send a welcome email
      // await sendRequiredAccountUpdateEmail(uid, newProfile);
    }

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newProfile],
    });
  });

  export const updateFeatureFlags = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    await SystemService.validateUsingRedisUserThrottle(context);
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

    //TODO we might want to send an update email here
    // await sendRequiredAccountUpdateEmail(uid, newProfile);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newProfile],
    });
  });

  export const updateVisibilityFlags = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    await SystemService.validateUsingRedisUserThrottle(context);
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

    //TODO we might want to send an update email here
    // await sendRequiredAccountUpdateEmail(uid, newProfile);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newProfile],
    });
  });

  export const addMedia = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    await SystemService.validateUsingRedisUserThrottle(context);
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

    //TODO we might want to send an update email here
    // await sendRequiredAccountUpdateEmail(uid, newProfile);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newProfile],
    });
  });

  export const removeMedia = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    await SystemService.validateUsingRedisUserThrottle(context);
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

    //TODO we might want to send an update email here
    // await sendRequiredAccountUpdateEmail(uid, newProfile);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newProfile],
    });
  });
}
