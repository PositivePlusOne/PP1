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
import { TestNotification } from "../services/builders/notifications/test/test_notification";
import { DataService } from "../services/data_service";
import { AdminScheduledActionJSON, adminScheduledActionsSchemaKey } from "../dto/admin";
import { StreamHelpers } from "../helpers/stream_helpers";

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

  /**
   * Cron handler for scheduled actions.
   * This is set to run every 5 minutes to allow for a reasonable level of precision and to prevent cron overlap.
   * 
   * @see https://firebase.google.com/docs/functions/schedule-functions
   */
  export const cronHandler = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).pubsub.schedule("*/5 * * * *").onRun(async (context) => {
    functions.logger.info("Cron handler executed", { context });

    const scheduledActions = await DataService.getBatchDocumentsBySchema({
      schemaKey: adminScheduledActionsSchemaKey,
    }) as AdminScheduledActionJSON[];

    functions.logger.info("Found scheduled actions", { count: scheduledActions.length });
    if (!scheduledActions || scheduledActions.length === 0) {
      return;
    }

    const currentTimeEpoch = StreamHelpers.getCurrentUnixTimestamp();
    
    // Loop through each scheduled action and check if it should be executed.
    for (const scheduledAction of scheduledActions) {
      const documentId = FlamelinkHelpers.getFlamelinkIdFromObject(scheduledAction);
      if (!scheduledAction || !scheduledAction.cron || !scheduledAction.actionJson || !documentId) {
        functions.logger.warn("Invalid scheduled action", { scheduledAction });
        continue;
      }

      const cron = scheduledAction.cron;
      const lastRunDate = scheduledAction.lastRunDate || "";

      if (!documentId) {
        functions.logger.warn("Invalid scheduled action", { scheduledAction });
        continue;
      }

      // Check if the cron should be executed.
      const shouldExecute = SystemService.shouldExecuteCron(cron, lastRunDate, currentTimeEpoch);
      if (!shouldExecute) {
        continue;
      }

      // Update the last run date.
      scheduledAction.lastRunDate = currentTimeEpoch;
      // scheduledAction.lastRunActionId = actionId;

      await DataService.updateDocument({
        schemaKey: adminScheduledActionsSchemaKey,
        entryId: documentId,
        data: scheduledAction,
      });
    }
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

  export const sendTestNotification = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);
    functions.logger.info("Sending test notification", { uid });

    const profile = await ProfileService.getProfile(uid) as ProfileJSON;
    const fcmToken = profile.fcmToken || "";

    if (!fcmToken) {
      throw new functions.https.HttpsError("failed-precondition", "No FCM token found");
    }

    await TestNotification.sendNotification(profile);
    
    return buildEndpointResponse(context, {
      sender: uid,
    });
  });
}
