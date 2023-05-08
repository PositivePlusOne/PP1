import * as functions from "firebase-functions";

import { ProfileService } from "../services/profile_service";
import { ConversationService } from "../services/conversation_service";
import { UserService } from "../services/user_service";
import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";
import { FeedService } from "../services/feed_service";
import { DataService } from "../services/data_service";

import { v4 as uuidv4 } from "uuid";

export namespace StreamEndpoints {
  export const getChatToken = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (_, context) => {
      let uid = context.auth?.uid || "";
      functions.logger.info("Getting user chat token", { uid });

      // If the user is not logged in, generate a new user id using the uuid package.
      if (uid.length === 0) {
        uid = uuidv4();

        // Store the temp user id in a collection to ensure it is not used again.
        const document = await DataService.getDocument({
          schemaKey: "guid",
          entryId: uid,
        });

        if (document) {
          throw new functions.https.HttpsError(
            "already-exists",
            "User already exists"
          );
        }

        await DataService.updateDocument({
          schemaKey: "guid",
          entryId: uid,
          data: {
            guid: uid,
            description: "Temporary feed ID for an anonymous user",
          },
        });
      }

      const chatClient = ConversationService.getStreamChatInstance();
      const userChatToken = ConversationService.getUserToken(chatClient, uid);
      functions.logger.info("User chat token", { userChatToken });

      return userChatToken;
    });

  export const getFeedsToken = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (_, context) => {
      await UserService.verifyAuthenticated(context);

      const uid = context.auth?.uid || "";
      functions.logger.info("Getting user feeds token", { uid });

      const hasCreatedProfile = await ProfileService.hasCreatedProfile(uid);
      if (!hasCreatedProfile) {
        throw new functions.https.HttpsError(
          "not-found",
          "User profile not found"
        );
      }

      const feedsClient = await FeedService.getFeedsClient();
      const userFeedsToken = await FeedService.getUserToken(feedsClient, uid);
      functions.logger.info("User feeds token", { userFeedsToken });

      return userFeedsToken;
    });
}

