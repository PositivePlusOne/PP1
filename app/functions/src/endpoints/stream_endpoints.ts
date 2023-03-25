import * as functions from "firebase-functions";
import safeJsonStringify from "safe-json-stringify";
import { Keys } from "../constants/keys";
import { ChatConnectionAcceptedNotification } from "../services/builders/notifications/chat_connection_accepted_notification";
import { ChatConnectionReceivedNotification } from "../services/builders/notifications/chat_connection_received_notification";
import { ChatConnectionSentNotification } from "../services/builders/notifications/chat_connection_sent_notification";

import { ProfileService } from "../services/profile_service";
import { StreamService } from "../services/stream_service";
import { UserService } from "../services/user_service";

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

      const channelName = StreamService.generatePrivateChannelName(
        uid,
        targetUid
      );

      await StreamService.requestConnection(channelName, uid, targetUid);
      await ChatConnectionSentNotification.sendNotification(uid);
      await ChatConnectionReceivedNotification.sendNotification(targetUid);

      return { success: true };
    });

  export const getPendingInvitations = functions
    .runWith({ secrets: [Keys.StreamApiKey, Keys.StreamApiSecret] })
    .https.onCall(async (_, context) => {
      await UserService.verifyAuthenticated(context);

      const uid = context.auth?.uid || "";
      functions.logger.info("Getting pending invitations for user", { uid });

      const invitations = await StreamService.getPendingInvitations(uid);
      functions.logger.info("Pending invitations", { invitations });

      return safeJsonStringify(invitations);
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

      const channelName = StreamService.generatePrivateChannelName(
        uid,
        targetUid
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
}
