import * as functions from "firebase-functions";

import { Keys } from "../constants/keys";
import { ChatConnectionAcceptedNotification } from "../services/builders/notifications/chat_connection_accepted_notification";
import { ChatConnectionReceivedNotification } from "../services/builders/notifications/chat_connection_received_notification";
import { ChatConnectionRejectedNotification } from "../services/builders/notifications/chat_connection_rejected_notification";
import { ChatConnectionSentNotification } from "../services/builders/notifications/chat_connection_sent_notification";

import { ProfileService } from "../services/profile_service";
import { StreamService } from "../services/stream_service";
import { UserService } from "../services/user_service";
import { StringHelpers } from "../helpers/string_helpers";

export namespace StreamEndpoints {
  export const getToken = functions
    .runWith({ secrets: [Keys.StreamApiKey, Keys.StreamApiSecret] })
    .https.onCall(async (_, context) => {
      await UserService.verifyAuthenticated(context);

      const uid = context.auth?.uid || "";
      functions.logger.info("Getting user chat token", { uid });

      const hasCreatedProfile = await ProfileService.hasCreatedProfile(uid);
      if (!hasCreatedProfile) {
        throw new functions.https.HttpsError(
          "not-found",
          "User profile not found"
        );
      }

      const userChatToken = StreamService.getUserToken(uid);
      functions.logger.info("User chat token", { userChatToken });

      return userChatToken;
    });

  export const requestConnection = functions
    .runWith({ secrets: [Keys.StreamApiKey, Keys.StreamApiSecret] })
    .https.onCall(async (data, context) => {
      await UserService.verifyAuthenticated(context);

      const uid = context.auth?.uid || "";
      const targetUid = data.uid || "";
      functions.logger.info("Requesting connection between users", {
        uid,
        targetUid,
      });

      if (uid === targetUid) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "Cannot connect to self"
        );
      }

      const channelName = StringHelpers.generateDocumentNameFromGuids(
        [uid, targetUid],
      );

      await StreamService.requestConnection(channelName, uid, targetUid);
      await ChatConnectionSentNotification.sendNotification(uid);
      await ChatConnectionReceivedNotification.sendNotification(targetUid);

      return { success: true };
    });

  export const acceptConnection = functions
    .runWith({ secrets: [Keys.StreamApiKey, Keys.StreamApiSecret] })
    .https.onCall(async (data, context) => {
      await UserService.verifyAuthenticated(context);

      const uid = context.auth?.uid || "";
      const targetUid = data.uid || "";
      functions.logger.info("Accepting connection between users", {
        uid,
        targetUid,
      });

      if (uid === targetUid) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "Cannot connect to self"
        );
      }

      const userProfile = await ProfileService.getUserProfile(uid);
      if (!userProfile) {
        throw new functions.https.HttpsError(
          "not-found",
          "User profile not found"
        );
      }

      const channelName = StringHelpers.generateDocumentNameFromGuids(
        [uid, targetUid],
      );

      const channel = await StreamService.acceptInvitation(channelName, uid);
      const members = channel.state.members;

      for (const member of Object.values(members)) {
        if (member.user_id == uid) {
          continue;
        }

        await ChatConnectionAcceptedNotification.sendNotification(userProfile);
      }

      return { success: true };
    });

  export const rejectConnection = functions
    .runWith({ secrets: [Keys.StreamApiKey, Keys.StreamApiSecret] })
    .https.onCall(async (data, context) => {
      await UserService.verifyAuthenticated(context);

      const uid = context.auth?.uid || "";
      const targetUid = data.uid || "";
      functions.logger.info("Rejecting connection between users", {
        uid,
        targetUid,
      });

      const userProfile = await ProfileService.getUserProfile(uid);
      if (!userProfile) {
        throw new functions.https.HttpsError(
          "not-found",
          "User profile not found"
        );
      }

      const channelName = StringHelpers.generateDocumentNameFromGuids(
        [uid, targetUid],
      );

      const channel = await StreamService.rejectInvitation(channelName, userProfile);
      const members = channel.state.members;

      for (const member of Object.values(members)) {
        if (member.user_id == uid) {
          continue;
        }

        await ChatConnectionRejectedNotification.sendNotification(userProfile);
      }

      return { success: true };
    });
}
