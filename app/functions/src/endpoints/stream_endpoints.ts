import * as functions from "firebase-functions";

import { Keys } from "../constants/keys";
import { ChatConnectionAcceptedNotification } from "../services/builders/notifications/chat_connection_accepted_notification";
import { ChatConnectionReceivedNotification } from "../services/builders/notifications/chat_connection_received_notification";
import { ChatConnectionRejectedNotification } from "../services/builders/notifications/chat_connection_rejected_notification";
import { ChatConnectionSentNotification } from "../services/builders/notifications/chat_connection_sent_notification";

import { ProfileService } from "../services/profile_service";
import { ConversationService } from "../services/conversation_service";
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

      const userChatToken = ConversationService.getUserToken(uid);
      functions.logger.info("User chat token", { userChatToken });

      return userChatToken;
    });
}
