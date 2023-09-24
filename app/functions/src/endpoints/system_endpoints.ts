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
import { TagsService } from "../services/tags_service";
import { ProfileJSON } from "../dto/profile";
import { NotificationsService } from "../services/notifications_service";
import { DEFAULT_PAGINATION_WINDOW_SIZE } from "../helpers/pagination";
import { NotificationPayloadResponse } from "../services/types/notification_payload";

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
    const uid = context.auth?.uid || "";
    const streamClient = FeedService.getFeedsClient();

    const [genders, interests, hivStatuses, popularTags, topicTags, recentTags, notificationFeed] = await Promise.all([
      LocalizationsService.getDefaultGenders(locale),
      LocalizationsService.getDefaultInterests(locale),
      LocalizationsService.getDefaultHivStatuses(locale),
      TagsService.getPopularTags(locale),
      TagsService.getTopicTags(locale),
      TagsService.getRecentUserTags(locale),
      // uid ? FeedService.getFeedWindow(uid, streamClient.feed("user", uid), DEFAULT_PAGINATION_WINDOW_SIZE, "") : Promise.resolve([]),
      // uid ? FeedService.getFeedWindow(uid, streamClient.feed("timeline", uid), DEFAULT_PAGINATION_WINDOW_SIZE, "") : Promise.resolve([]),
      uid ? NotificationsService.listNotificationWindow(streamClient, uid, DEFAULT_PAGINATION_WINDOW_SIZE, "") : Promise.resolve([]),
    ]);


    const joinRecords = [] as string[];
    const interestResponse = {} as any;

    interests.forEach((value, key) => {
      interestResponse[key] = value;
    });

    let profile = {};
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

      functions.logger.info("Getting profile", { uid, userProfile });

      profile = userProfile as ProfileJSON;
    }

    const notificationFeedRecords = [];
    // const userFeedRecords = [];
    // const timelineFeedRecords = [];

    let unreadCount = 0;
    let unseenCount = 0;

    if (uid) {
      // If we are logged in, we add enough data to the endpoint for the client to be able to pre-populate the app rather than waiting for the first API call to complete.
      // This makes the experience on the app slightly smoother, but we should measure the impact on this endpoint's performance.
      const notificationResult = notificationFeed as NotificationPayloadResponse;
      unreadCount = notificationResult.unread_count;
      unseenCount = notificationResult.unseen_count;
      notificationFeedRecords.push(...notificationResult.payloads);

      const profileIds = notificationResult.payloads.map((notification) => notification.sender).filter((sender) => sender.length > 0);
      if (profileIds.length > 0) {
        joinRecords.push(...profileIds);
      }

      // const userFeedResult = userFeed as GetFeedWindowResult;
      // const timelineFeedResult = timelineFeed as GetFeedWindowResult;

      // joinRecords.push(...userFeedActivities);
      // joinRecords.push(...timelineFeedActivities);

      // // Add the FL IDs of each activity to the feed records so we can identify them later.
      // for (const activity of userFeedActivities) {
      //   const flamelinkId = FlamelinkHelpers.getFlamelinkIdFromObject(activity);
      //   if (flamelinkId) {
      //     userFeedRecords.push(flamelinkId);
      //   }
      // }

      // for (const activity of timelineFeedActivities) {
      //   const flamelinkId = FlamelinkHelpers.getFlamelinkIdFromObject(activity);
      //   if (flamelinkId) {
      //     timelineFeedRecords.push(flamelinkId);
      //   }
      // }
    }

    return buildEndpointResponse(context, {
      sender: uid,
      data: [profile],
      joins: joinRecords,
      seedData: {
        genders,
        medicalConditions: hivStatuses,
        interests: interestResponse,
        popularTags,
        topicTags,
        recentTags,
        supportedProfiles,
        unreadNotificationCount: unreadCount,
        unseenNotificationCount: unseenCount,
        notifications: notificationFeedRecords,
        // userFeedRecords: userFeedRecords,
        // timelineFeeduserFeedRecords: timelineFeedRecords,
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
    const feedsClient = FeedService.getFeedsClient();
    await FeedService.verifyDefaultFeedSubscriptionsForUser(feedsClient, uid);

    return buildEndpointResponse(context, {
      sender: uid,
      seedData: {
        token: chatToken,
      },
    });
  });

  export const clearEntireCache = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data, context) => {
    await UserService.verifyAuthenticated(context);

    functions.logger.info("Clearing entire cache");
    await CacheService.deleteAllFromCache();

    return JSON.stringify({ success: true });
  });

  // This is a dangerous endpoint and should only be used in development.
  // export const clearGetStreamContentFromSystem = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async () => {
  //   const firestore = adminApp.firestore();
  //   const storage = adminApp.storage();

  //   // Get the firebase application name
  //   const appName = process.env.GCLOUD_PROJECT || "";
    
  //   // Verify the app name if not positiveplusone-production
  //   if (appName === "positiveplusone-production") {
  //     throw new Error("Nice try.");
  //   }

  //   // Within the fl_content collection, delete all documents with the _fl_meta_.schema property set to the value of the schema parameter.
  //   const targetSchemas = [
  //     "activities",
  //     "reactions",
  //     "reactionStatistics",
  //     "tags",
  //   ];

  //   for (const schema of targetSchemas) {
  //     const query = firestore.collection("fl_content").where("_fl_meta_.schema", "==", schema);
  //     const querySnapshot = await query.get();

  //     for (const doc of querySnapshot.docs) {
  //       const docId = doc.id;
  //       const docData = doc.data();

  //       functions.logger.info("Deleting document", { docId, docData });

  //       await doc.ref.delete();
  //     }
  //   }

  //   // Delete the /users folder in storage.
  //   const usersFolder = storage.bucket().file("users");
  //   const usersFolderExists = await usersFolder.exists();

  //   if (usersFolderExists[0]) {
  //     functions.logger.info("Deleting users folder");
  //     await usersFolder.delete();
  //   }

  //   // Clearing feed data has to be manual :(

  //   return JSON.stringify({ success: true });
  // });
}
