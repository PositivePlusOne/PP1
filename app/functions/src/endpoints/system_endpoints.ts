import * as functions from "firebase-functions";

import { SystemService } from "../services/system_service";
import { UserService } from "../services/user_service";
import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";

export namespace SystemEndpoints {
  export const submitFeedback = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(
    async (data, context) => {
      await UserService.verifyAuthenticated(context);

      const uid = context.auth?.uid || "";
      const feedback = data.feedback;

      functions.logger.info("Submitting feedback", { uid, feedback });
      await SystemService.submitFeedback(uid, feedback);

      return JSON.stringify({ success: true });
    }
  );
}
