import * as admin from "firebase-admin";
import * as functions from "firebase-functions";

export namespace SystemService {
  /**
   * The structure of a custom user claim
   */
  export type CustomUserClaims = {
    level: string;
  };

  /**
   * Verifies the application passed a valid context through to the function.
   * This is used to verify the AppCheck integrity of the caller.
   * @param {functions.https.CallableContext} context The context from a https onCall function
   */
  export async function verifyAppCheck(
    context: functions.https.CallableContext
  ): Promise<void> {
    if (context.app == undefined) {
      throw new functions.https.HttpsError(
        "failed-precondition",
        "The function must be called from an App Check verified app."
      );
    }
  }

  /**
   * Verifies the application is authenticated by a user.
   * @param {functions.https.CallableContext} context The context from a https onCall function
   */
  export async function verifyAuthenticated(
    context: functions.https.CallableContext
  ): Promise<void> {
    const uid = context.auth?.uid || "";
    if (!(typeof uid === "string") || uid.length === 0) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "You must be authenticated to call this function"
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
    await admin.auth().setCustomUserClaims(accessId, customClaims);
  }
}
