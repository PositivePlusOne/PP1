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
import { RelationshipJSON } from "../dto/relationships";
import { RelationshipService } from "../services/relationship_service";

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

    const [genders, interests, hivStatuses, popularTags, topicTags, recentTags, managedRelationships] = await Promise.all([
      LocalizationsService.getDefaultGenders(locale),
      LocalizationsService.getDefaultInterests(locale),
      LocalizationsService.getDefaultHivStatuses(locale),
      TagsService.getPopularTags(locale),
      TagsService.getTopicTags(locale),
      TagsService.getRecentUserTags(locale),
      // uid ? FeedService.getFeedWindow(uid, streamClient.feed("user", uid), DEFAULT_PAGINATION_WINDOW_SIZE, "") : Promise.resolve([]),
      // uid ? FeedService.getFeedWindow(uid, streamClient.feed("timeline", uid), DEFAULT_PAGINATION_WINDOW_SIZE, "") : Promise.resolve([]),
      // uid ? NotificationsService.listNotificationWindow(streamClient, uid, DEFAULT_PAGINATION_WINDOW_SIZE, "") : Promise.resolve([]),
      uid ? RelationshipService.getManagedRelationships(uid) : Promise.resolve([]),
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

    const managedProfileFetchPromises = [];
    if (managedRelationships && managedRelationships.length > 0) {
      for (const relationship of managedRelationships) {
        if (!relationship) {
          continue;
        }

        const members = (relationship as RelationshipJSON).members || [];
        for (const member of members) {
          if (!member?.memberId || supportedProfileIds.includes(member.memberId)) {
            continue;
          }

          supportedProfileIds.push(member.memberId);
          managedProfileFetchPromises.push(ProfileService.getProfile(member.memberId));
        }
      }
    }

    functions.logger.info("Prefetching managed IDs", { supportedProfileIds });

    const managedProfiles = await Promise.all(managedProfileFetchPromises);
    for (const managedProfile of managedProfiles) {
      if (!managedProfile) {
        continue;
      }

      supportedProfiles.push(managedProfile as ProfileJSON);
    }

    functions.logger.info("Fetched managed profiles", { supportedProfiles });

    return buildEndpointResponse(context, {
      sender: uid,
      data: [profile, ...supportedProfiles],
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
      },
    });
  });

  export const submitFeedback = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    await UserService.verifyAuthenticated(context, request.sender);

    const uid = context.auth?.uid || "";
    const feedbackType = request.data.feedbackType || "unknown";
    const reportType = request.data.reportType || "unknown";
    const content = request.data.content || "";

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
