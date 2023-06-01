import * as functions from "firebase-functions";

export namespace UserService {
  /**
   * Verifies the application is authenticated by a user.
   * @param {functions.https.CallableContext} context The context from a https onCall function
   * @throws {functions.https.HttpsError} If the user is not authenticated.
   */
  export async function verifyAuthenticated(context: functions.https.CallableContext): Promise<void> {
    functions.logger.info("Verifying authentication");
    const uid = context.auth?.uid || "";
    if (!(typeof uid === "string") || uid.length === 0) {
      throw new functions.https.HttpsError("unauthenticated", "You must be authenticated to call this function");
    }
  }
}
