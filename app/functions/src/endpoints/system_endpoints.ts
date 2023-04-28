import * as functions from "firebase-functions";

import { SystemService } from "../services/system_service";
import { UserService } from "../services/user_service";
import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";
import { DataHandlerRegistry } from "../handlers/data_handler_registry";
import { FlamelinkHelpers } from "../helpers/flamelink_helpers";
import { getDataChangeSchema, getDataChangeType } from "../handlers/data_change_type";

export namespace SystemEndpoints {
  export const dataChangeHandler = functions.firestore
    .document("fl_content/{documentId}")
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

      const isRecursive = FlamelinkHelpers.arePayloadsEqual(
        beforeData,
        afterData
      );

      if (isRecursive) {
        functions.logger.info("Data change ignored (recursive)", {
          changeType,
        });

        return;
      }

      await DataHandlerRegistry.executeChangeHandlers(
        changeType,
        schema,
        context.params.documentId,
        beforeData,
        afterData
      );
    });

  export const submitFeedback = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (data, context) => {
      await UserService.verifyAuthenticated(context);

      const uid = context.auth?.uid || "";
      const feedback = data.feedback;

      functions.logger.info("Submitting feedback", { uid, feedback });
      await SystemService.submitFeedback(uid, feedback);

      return JSON.stringify({ success: true });
    });
}
