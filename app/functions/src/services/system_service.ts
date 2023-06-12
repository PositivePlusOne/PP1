import * as admin from "firebase-admin";
import * as functions from "firebase-functions";

import { adminApp } from "..";
import flamelink from "flamelink";

export namespace SystemService {
  let flamelinkApp: flamelink.app.App;

  /**
 * Lazy loads a Flamelink app instance.
 *
 * @returns {Promise<flamelink.app.App>} A promise that resolves with a Flamelink app instance.
 */
  export function getFlamelinkApp(): flamelink.app.App {
    // Check if the Flamelink app instance has already been loaded.
    if (typeof flamelinkApp === "undefined") {
      // Initialize the Flamelink app instance.
      functions.logger.info("Initializing Flamelink app instance");
      flamelinkApp = flamelink({
        firebaseApp: adminApp,
        dbType: "cf",
        precache: false,
        env: "production", // We use multiple Firebase projects, so this is always production.
      });
    }

    // Return the Flamelink app instance.
    return flamelinkApp;
  }

  /**
   * Verifies the application passed a valid context through to the function.
   * This is used to verify the AppCheck integrity of the caller.
   * @param {functions.https.CallableContext} context The context from a https onCall function
   */
  export async function verifyAppCheck(context: functions.https.CallableContext): Promise<void> {
    functions.logger.info("Verifying app check");
    if (context.app == undefined) {
      throw new functions.https.HttpsError("failed-precondition", "The function must be called from an App Check verified app.");
    }
  }

  /**
   * Updates user access claims in Firebase Authentication.
   * @param {string} accessId The user access ID
   * @param {CustomUserClaims} customClaims The new claims for the user
   */
  export async function updateUserClaims(accessId: string, customClaims: object | null): Promise<void> {
    functions.logger.info(`Updating user claims in Firebase Authentication for ${accessId} to ${JSON.stringify(customClaims)}`);

    const adminAuth = admin.auth();
    const userRecord = await adminAuth.getUser(accessId);

    // Check if the claims have changed.
    if (!customClaims || JSON.stringify(userRecord.customClaims) === JSON.stringify(customClaims)) {
      functions.logger.info("User claims have not changed or are empty, skipping update");
      return;
    }

    await admin.auth().setCustomUserClaims(accessId, customClaims);
  }

  /**
   * Submits feedback from the user to the database.
   * @param {string} uid The user ID of the user submitting the feedback.
   * @param {string} feedbackType The type of feedback being submitted.
   * @param {string} reportType The type of report being submitted.
   * @param {string} content The content of the feedback.
   */
  export async function submitFeedback(uid: string, feedbackType: string, reportType: string, content: string): Promise<void> {
    functions.logger.info("Submitting feedback", { uid, feedbackType, reportType, content });
    await getFlamelinkApp().content.add({
      schemaKey: "feedback",
      data: {
        createdBy: uid,
        feedbackType,
        reportType,
        content,
      },
    });
  }
}
