import * as functions from "firebase-functions";
import * as functions_v2 from "firebase-functions/v2";

import { ProfileService } from "../services/profile_service";
import { UserService } from "../services/user_service";
import { EndpointRequest, buildEndpointResponse } from "./dto/payloads";
import { CacheService } from "../services/cache_service";
import { MediaJSON } from "../dto/media";
import { ProfileJSON } from "../dto/profile";
import { DataService } from "../services/data_service";

export namespace ProfileEndpoints {
  export const getProfiles = functions_v2.https.onCall(async (payload) => {
    const request = payload.data as EndpointRequest;
    functions.logger.info("Getting user profiles", { structuredData: true });
    const uid = await UserService.verifyAuthenticatedV2(payload, request.sender);

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
    
    return buildEndpointResponse({
      sender: uid,
      data: profiles,
    });
  });

  export const getProfile = functions_v2.https.onCall(async (payload) => {
    const request = payload.data as EndpointRequest;
    functions.logger.info("Getting user profile", { structuredData: true });

    const uid = await UserService.verifyAuthenticatedV2(payload, request.sender);
    const targetUid = request.data.uid || "";
    if (targetUid.length === 0) {
      throw new functions.https.HttpsError("invalid-argument", "The function must be called with a valid uid");
    }

    const userProfile = await ProfileService.getProfile(targetUid);
    if (!userProfile) {
      throw new functions.https.HttpsError("not-found", "The user profile does not exist");
    }

    return buildEndpointResponse({
      sender: uid,
      data: [userProfile],
    });
  });

  export const deleteProfile = functions_v2.https.onCall(async (payload) => {
    const request = payload.data as EndpointRequest;
    const uid = await UserService.verifyAuthenticatedV2(payload, request.sender);
    functions.logger.info("Deleting user profile", { structuredData: true });

    await ProfileService.deleteProfile(uid);
    functions.logger.info("User profile deleted");

    return JSON.stringify({ success: true });
  });

  export const updateFcmToken = functions_v2.https.onCall(async (payload) => {
    const request = payload.data as EndpointRequest;
    const uid = await UserService.verifyAuthenticatedV2(payload, request.sender);
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

    return buildEndpointResponse({
      sender: uid,
      data: [newProfile],
    });
  });

  export const updateEmailAddress = functions_v2.https.onCall(async (payload) => {
    const request = payload.data as EndpointRequest;
    const uid = await UserService.verifyAuthenticatedV2(payload, request.sender);
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

    return buildEndpointResponse({
      sender: uid,
      data: [newProfile],
    });
  });

  export const updatePhoneNumber = functions_v2.https.onCall(async (payload) => {
    const request = payload.data as EndpointRequest;
    const uid = await UserService.verifyAuthenticatedV2(payload, request.sender);

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

    return buildEndpointResponse({
      sender: uid,
      data: [newProfile],
    });
  });

  export const updateName = functions_v2.https.onCall(async (payload) => {
    const request = payload.data as EndpointRequest;
    const uid = await UserService.verifyAuthenticatedV2(payload, request.sender);

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

    return buildEndpointResponse({
      sender: uid,
      data: [newProfile],
    });
  });

  export const updateDisplayName = functions_v2.https.onCall(async (payload) => {
    const request = payload.data as EndpointRequest;
    const uid = await UserService.verifyAuthenticatedV2(payload, request.sender);
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

    return buildEndpointResponse({
      sender: uid,
      data: [newProfile],
    });
  });

  export const updateBirthday = functions_v2.https.onCall(async (payload) => {
    const request = payload.data as EndpointRequest;
    const uid = await UserService.verifyAuthenticatedV2(payload, request.sender);

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

    return buildEndpointResponse({
      sender: uid,
      data: [newProfile],
    });
  });

  export const updateInterests = functions_v2.https.onCall(async (payload) => {
    const request = payload.data as EndpointRequest;
    const uid = await UserService.verifyAuthenticatedV2(payload, request.sender);

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

    return buildEndpointResponse({
      sender: uid,
      data: [newProfile],
    });
  });

  export const updateGenders = functions_v2.https.onCall(async (payload) => {
    const request = payload.data as EndpointRequest;
    const uid = await UserService.verifyAuthenticatedV2(payload, request.sender);
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

    return buildEndpointResponse({
      sender: uid,
      data: [newProfile],
    });
  });

  export const updateCompanySectors = functions_v2.https.onCall(async (context) => {
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

    return buildEndpointResponse({
      sender: uid,
      data: [newProfile],
    });
  });

  export const updatePlace = functions_v2.https.onCall(async (context) => {
    const request = context.data as EndpointRequest;
    const uid = await UserService.verifyAuthenticatedV2(context, request.sender);

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

    return buildEndpointResponse({
      sender: uid,
      data: [newProfile],
    });
  });
  
  export const updateHivStatus = functions_v2.https.onCall(async (payload) => {
    const request = payload.data as EndpointRequest;
    const uid = await UserService.verifyAuthenticatedV2(payload, request.sender);
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

    return buildEndpointResponse({
      sender: uid,
      data: [newProfile],
    });
  });

  export const updateBiography = functions_v2.https.onCall(async (payload) => {
    const request = payload.data as EndpointRequest;
    const uid = await UserService.verifyAuthenticatedV2(payload, request.sender);
    const biography = request.data.biography || "";

    functions.logger.info("Updating profile biography", {
      uid,
      biography,
    });

    const newProfile = await ProfileService.updateBiography(uid, biography);
    functions.logger.info("Profile biography updated");

    return buildEndpointResponse({
      sender: uid,
      data: [newProfile],
    });
  });

  export const updateAccentColor = functions_v2.https.onCall(async (payload) => {
    const request = payload.data as EndpointRequest;
    const uid = await UserService.verifyAuthenticatedV2(payload, request.sender);
    const accentColor = request.data.accentColor || "";

    functions.logger.info("Updating profile accent colour", {
      uid,
      accentColor,
    });

    if (accentColor.length === 0) {
      throw new functions.https.HttpsError("invalid-argument", "You must provide a valid accent colour");
    }

    const newProfile = await ProfileService.updateAccentColor(uid, accentColor);
    functions.logger.info("Profile accent colour updated", {
      uid,
      accentColor,
    });

    return buildEndpointResponse({
      sender: uid,
      data: [newProfile],
    });
  });

  export const updateFeatureFlags = functions_v2.https.onCall(async (payload) => {
    const request = payload.data as EndpointRequest;
    const uid = await UserService.verifyAuthenticatedV2(payload, request.sender);
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

    return buildEndpointResponse({
      sender: uid,
      data: [newProfile],
    });
  });

  export const updateVisibilityFlags = functions_v2.https.onCall(async (payload) => {
    const request = payload.data as EndpointRequest;
    const uid = await UserService.verifyAuthenticatedV2(payload, request.sender);
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

    return buildEndpointResponse({
      sender: uid,
      data: [newProfile],
    });
  });

  export const addMedia = functions_v2.https.onCall(async (payload) => {
    const request = payload.data as EndpointRequest;
    const uid = await UserService.verifyAuthenticatedV2(payload, request.sender);
    const media = (request.data.media || []) as MediaJSON[];

    if (!(media instanceof Array)) {
      throw new functions.https.HttpsError("invalid-argument", "You must provide a valid list of media");
    }

    const profile = await ProfileService.getProfile(uid);
    if (!profile) {
      throw new functions.https.HttpsError("not-found", "The user profile does not exist");
    }

    const newProfile = await ProfileService.addMedia(profile, media);
    return buildEndpointResponse({
      sender: uid,
      data: [newProfile],
    });
  });

  export const removeMedia = functions_v2.https.onCall(async (payload) => {
    const request = payload.data as EndpointRequest;
    const uid = await UserService.verifyAuthenticatedV2(payload, request.sender);

    const mediaId = request.data.mediaId || "";
    if (mediaId.length === 0) {
      throw new functions.https.HttpsError("invalid-argument", "You must provide valid media");
    }

    const profile = await ProfileService.getProfile(uid);
    if (!profile) {
      throw new functions.https.HttpsError("not-found", "The user profile does not exist");
    }

    const newProfile = await ProfileService.removeMedia(profile, mediaId);
    return buildEndpointResponse({
      sender: uid,
      data: [newProfile],
    });
  });
}
