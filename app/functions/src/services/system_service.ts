import * as admin from "firebase-admin";
import * as functions from "firebase-functions";

import { adminApp } from "..";
import flamelink from "flamelink";

export namespace SystemService {
  /**
   * The structure of a custom user claim
   */
  export type CustomUserClaims = {
    level: string;
  };

  /**
   * 
   * @return {flamelink.app.App} a flamelink app instance.
   */
  export async function getFlamelinkApp(): Promise<flamelink.app.App> {
    functions.logger.info("Getting flamelink app instance");
    return flamelink({
      firebaseApp: adminApp,
      dbType: "cf",
      precache: false,
      env: "production", // We use multiple Firebase projects, so this is always production.
    });
  }

  /**
   * Verifies the application passed a valid context through to the function.
   * This is used to verify the AppCheck integrity of the caller.
   * @param {functions.https.CallableContext} context The context from a https onCall function
   */
  export async function verifyAppCheck(
    context: functions.https.CallableContext
  ): Promise<void> {
    functions.logger.info("Verifying app check");
    if (context.app == undefined) {
      throw new functions.https.HttpsError(
        "failed-precondition",
        "The function must be called from an App Check verified app."
      );
    }
  }

  /**
   * Updates user access claims in Firebase Authentication.
   * @param {string} accessId The user access ID
   * @param {CustomUserClaims} customClaims The new claims for the user
   */
  export async function updateUserClaims(
    accessId: string,
    customClaims: CustomUserClaims
  ): Promise<void> {
    functions.logger.info(`Updating user claims in Firebase Authentication for ${accessId} to ${JSON.stringify(customClaims)}`);
    await admin.auth().setCustomUserClaims(accessId, customClaims);
  }
}
