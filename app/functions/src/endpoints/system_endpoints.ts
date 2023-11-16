import * as functions from "firebase-functions";

import { SystemService } from "../services/system_service";
import { UserService } from "../services/user_service";
import { FIREBASE_FUNCTION_INSTANCE_DATA, FIREBASE_FUNCTION_INSTANCE_DATA_256 } from "../constants/domain";
import { FlamelinkHelpers } from "../helpers/flamelink_helpers";
import { getDataChangeSchema, getDataChangeType } from "../handlers/data_change_type";

import { DataHandlerRegistry } from "../handlers/data_change_handler";
import { LocalizationsService } from "../services/localizations_service";
import { ProfileService } from "../services/profile_service";

import { EndpointRequest, buildEndpointResponse } from "./dto/payloads";
import { ConversationService } from "../services/conversation_service";
import { FeedService } from "../services/feed_service";
import { TagsService } from "../services/tags_service";
import { ProfileJSON } from "../dto/profile";
import { RelationshipJSON } from "../dto/relationships";
import { RelationshipService } from "../services/relationship_service";
import { Pagination } from "../helpers/pagination";
import { PromotionsService } from "../services/promotions_service";

export namespace SystemEndpoints {
  export const dataChangeHandler = functions
    .region('europe-west3')
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA_256)
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

  export const getSystemConfiguration = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    await SystemService.validateUsingRedisUserThrottle(context);
    const locale = request.data.locale || "en";
    const uid = context.auth?.uid || "";

    const pagination = {
      windowSize: request.data.windowSize || 10,
      cursor: request.data.cursor || "",
    } as Pagination;

    const [genders, interests, hivStatuses, popularTags, topicTags, recentTags, managingRelationships, companySectors, promotions] = await Promise.all([
      LocalizationsService.getDefaultGenders(locale),
      LocalizationsService.getDefaultInterests(locale),
      LocalizationsService.getDefaultHivStatuses(locale),
      TagsService.getPopularTags(locale),
      TagsService.getTopicTags(locale),
      TagsService.getRecentUserTags(locale),
      // uid ? FeedService.getFeedWindow(uid, streamClient.feed("user", uid), DEFAULT_PAGINATION_WINDOW_SIZE, "") : Promise.resolve([]),
      // uid ? FeedService.getFeedWindow(uid, streamClient.feed("timeline", uid), DEFAULT_PAGINATION_WINDOW_SIZE, "") : Promise.resolve([]),
      // uid ? NotificationsService.listNotificationWindow(streamClient, uid, DEFAULT_PAGINATION_WINDOW_SIZE, "") : Promise.resolve([]),
      uid ? RelationshipService.getManagingRelationships(uid, pagination) : Promise.resolve({ data: [], pagination: {} }),
      LocalizationsService.getDefaultCompanySectors(locale),
      PromotionsService.getActivePromotionWindow("", 30),
    ]);

    const joinRecords = [] as string[];
    const interestResponse = {} as any;

    interests.forEach((value, key) => {
      interestResponse[key] = value;
    });

    let profile = {} as ProfileJSON;
    const supportedProfileIds = [] as string[];
    const supportedProfiles = [] as ProfileJSON[];

    if (typeof uid === "string" && uid.length > 0) {
      supportedProfileIds.push(uid);

      let userProfile = await ProfileService.getProfile(uid);
      if (!userProfile) {
        functions.logger.info("Profile not found, creating...", { uid });

        const email = context.auth?.token.email || "";
        const phone = context.auth?.token.phone_number || "";

        userProfile = await ProfileService.createProfile(uid, email, phone, locale);
      }

      profile = userProfile as ProfileJSON;
    }

    const managingProfileFetchPromises = [];
    for (const relationship of managingRelationships?.data || []) {
      if (!relationship) {
        continue;
      }

      const members = (relationship as RelationshipJSON).members || [];
      for (const member of members) {
        if (!member?.memberId || supportedProfileIds.includes(member.memberId)) {
          continue;
        }

        supportedProfileIds.push(member.memberId);
        managingProfileFetchPromises.push(ProfileService.getProfile(member.memberId));
      }
    }

    const managingProfiles = await Promise.all(managingProfileFetchPromises);
    for (const managingProfile of managingProfiles) {
      if (!managingProfile) {
        continue;
      }

      supportedProfiles.push(managingProfile as ProfileJSON);
    }

    const ownedPromotions = await PromotionsService.getOwnedPromotionsForManagedAccounts(supportedProfileIds);
    return buildEndpointResponse(context, {
      sender: uid,
      data: [profile, ...supportedProfiles, ...promotions, ...ownedPromotions],
      joins: joinRecords,
      seedData: {
        genders,
        medicalConditions: hivStatuses,
        interests: interestResponse,
        popularTags,
        topicTags,
        recentTags,
        supportedProfiles: supportedProfileIds,
        // userFeedRecords: userFeedRecords,
        // timelineFeeduserFeedRecords: timelineFeedRecords,
        companySectors: companySectors,
      },
    });
  });

  export const submitFeedback = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    await SystemService.validateUsingRedisUserThrottle(context);
    await UserService.verifyAuthenticated(context, request.sender);

    const uid = context.auth?.uid || "";
    const feedbackType = request.data.feedbackType || "unknown";
    const reportType = request.data.reportType || "unknown";
    const content = request.data.content || "";

    const profile = await ProfileService.getProfile(uid);
    functions.logger.info("Submitting feedback", { uid, feedbackType, reportType, content });

    await SystemService.submitFeedback(profile, feedbackType, reportType, content);

    return JSON.stringify({ success: true });
  });

  export const getStreamToken = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    await SystemService.validateUsingRedisUserThrottle(context);
    const uid = await UserService.verifyAuthenticated(context, request.sender);
    functions.logger.info("Getting chat token", { uid });

    const chatClient = ConversationService.getStreamChatInstance();
    const chatToken = ConversationService.getUserToken(chatClient, uid);

    // We should check here the integrity of the user's feeds.
    // Note: Subscribed follower feeds integrity will be checked on the relationship endpoints.
    const feedsClient = FeedService.getFeedsClient();

    const profile = await ProfileService.getProfile(uid);
    await FeedService.verifyDefaultFeedSubscriptionsForUser(feedsClient, profile);

    return buildEndpointResponse(context, {
      sender: uid,
      seedData: {
        token: chatToken,
      },
    });
  });
}
