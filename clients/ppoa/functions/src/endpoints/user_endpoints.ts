import * as functions from "firebase-functions";

import { SystemService } from "../services/system_service";

export namespace UserEndpoints {
  /**
   * Verifies a user has the correct documents available to start using the application.
   */
  export const verifyUserCreated = functions.region("europe-west1").https.onCall(
    async (data, context) => {
      await SystemService.verifyAuthenticated(context);
      const flamelinkApp = await SystemService.getFlamelinkApp(data.environment);

      const uid = context.auth!.uid;

      await flamelinkApp.users.addToDB({
        uid: uid,
        data: {
          permissions: "user",
        },
      });
    }
  );
}
