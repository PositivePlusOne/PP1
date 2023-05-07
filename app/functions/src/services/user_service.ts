import * as functions from "firebase-functions";
import { adminApp } from "..";

export namespace UserService {
  /**
   * Verifies the application is authenticated by a user.
   * @param {functions.https.CallableContext} context The context from a https onCall function
   * @throws {functions.https.HttpsError} If the user is not authenticated.
   */
  export async function verifyAuthenticated(
    context: functions.https.CallableContext
  ): Promise<void> {
    functions.logger.info("Verifying authentication");
    const uid = context.auth?.uid || "";
    if (!(typeof uid === "string") || uid.length === 0) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "You must be authenticated to call this function"
      );
    }

    // Check the user is not disabled or contains an anonymous provider
    const user = await adminApp.auth().getUser(uid);
    const isAnonymous = user.providerData.some((p) => p.providerId === "anonymous");
    const hasNonAnonymousProvider = user.providerData.some((p) => p.providerId !== "anonymous");

    if (user.disabled || isAnonymous || !hasNonAnonymousProvider) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "You must be authenticated to call this function"
      );
    }
  }
}
