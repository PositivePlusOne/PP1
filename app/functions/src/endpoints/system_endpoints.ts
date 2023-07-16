import * as functions from "firebase-functions";

import { SystemService } from "../services/system_service";
import { UserService } from "../services/user_service";
import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";
import { FlamelinkHelpers } from "../helpers/flamelink_helpers";
import { getDataChangeSchema, getDataChangeType } from "../handlers/data_change_type";

import { DataHandlerRegistry } from "../handlers/data_change_handler";
import { LocalizationsService } from "../services/localizations_service";
import { ProfileService } from "../services/profile_service";

import { CacheService } from "../services/cache_service";
import { EndpointRequest, buildEndpointResponse } from "./dto/payloads";
import { ConversationService } from "../services/conversation_service";
import { FeedService } from "../services/feed_service";

export namespace SystemEndpoints {
  export const dataChangeHandler = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .firestore.document("fl_content/{documentId}")
    .onWrite(async (change, context) => {
      functions.logger.info("Data change detected", { change, context });
      const beforeData = change.before.exists ? change.before.data() : null;
      const afterData = change.after.exists ? change.after.data() : null;

      const changeType = getDataChangeType(beforeData, afterData);
      const schema = getDataChangeSchema(beforeData, afterData);

      if (!changeType || !schema) {
        functions.logger.info("Data change ignored (no change type or schema)", {
          changeType,
          schema,
        });

        return;
      }

      const isRecursive = FlamelinkHelpers.arePayloadsEqual(beforeData, afterData);

      if (isRecursive) {
        functions.logger.info("Data change ignored (recursive)", {
          changeType,
        });

        return;
      }

      await DataHandlerRegistry.executeChangeHandlers(changeType, schema, context.params.documentId, beforeData, afterData);
    });

  export const getSystemConfiguration = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const locale = request.data.locale || "en";
    const [genders, interests, hivStatuses] = await Promise.all([
      LocalizationsService.getDefaultGenders(locale),
      LocalizationsService.getDefaultInterests(locale),
      LocalizationsService.getDefaultHivStatuses(locale),
    ]);

    const interestResponse = {} as any;
    interests.forEach((value, key) => {
      interestResponse[key] = value;
    });

    let profile = {};
    const uid = context.auth?.uid || "";
    const supportedProfiles = [];

    if (typeof uid === "string" && uid.length > 0) {
      supportedProfiles.push(uid);
      
      let managedProfiles = [];
      let userProfile = await ProfileService.getProfile(uid);

      functions.logger.info("Checking if managed profiles should be loaded", { uid, userProfile });
      const docId = FlamelinkHelpers.getFlamelinkDocIdFromObject(userProfile || {});
      
      if (docId) {
        functions.logger.info("Getting managed profiles", { docId });
        managedProfiles = await ProfileService.getManagedProfiles(docId);
      }

      for (const managedProfile of managedProfiles) {
        const managedProfileUid = FlamelinkHelpers.getFlamelinkIdFromObject(managedProfile);
        if (managedProfileUid) {
          supportedProfiles.push(managedProfileUid);
        }
      }

      if (!userProfile) {
        functions.logger.info("Profile not found, creating...", { uid });

        const email = context.auth?.token.email || "";
        const phone = context.auth?.token.phone_number || "";

        userProfile = await ProfileService.createProfile(uid, email, phone, locale);
      }

      profile = userProfile;
    }

    return buildEndpointResponse(context, {
      sender: uid,
      data: [profile],
      seedData: {
        genders,
        medicalConditions: hivStatuses,
        interests: interestResponse,
        supportedProfiles,
      },
    });
  });

  export const submitFeedback = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data, context) => {
    await UserService.verifyAuthenticated(context);

    const uid = context.auth?.uid || "";
    const feedbackType = data.feedbackType || "unknown";
    const reportType = data.reportType || "unknown";
    const content = data.content || "";

    functions.logger.info("Submitting feedback", { uid, feedbackType, reportType, content });
    await SystemService.submitFeedback(uid, feedbackType, reportType, content);

    return JSON.stringify({ success: true });
  });

  export const getStreamToken = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);
    functions.logger.info("Getting chat token", { uid });

    const chatClient = ConversationService.getStreamChatInstance();
    const chatToken = ConversationService.getUserToken(chatClient, uid);

    // We should check here the integrity of the user's feeds.
    // Note: Subscribed follower feeds integrity will be checked on the relationship endpoints.
    const feedsClient = await FeedService.getFeedsClient();
    await FeedService.verifyDefaultFeedSubscriptionsForUser(feedsClient, uid);

    return JSON.stringify({ token: chatToken });
  });

  export const clearEntireCache = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data, context) => {
    await UserService.verifyAuthenticated(context);

    functions.logger.info("Clearing entire cache");
    await CacheService.deleteAllFromCache();

    return JSON.stringify({ success: true });
  });
}
