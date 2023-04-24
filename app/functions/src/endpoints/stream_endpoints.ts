import * as functions from "firebase-functions";

import { ProfileService } from "../services/profile_service";
import { ConversationService } from "../services/conversation_service";
import { UserService } from "../services/user_service";
import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";

export namespace StreamEndpoints {
  export const getToken = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
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
