import * as admin from "firebase-admin";
import { DecodedIdToken } from "firebase-admin/lib/auth/token-verifier";
import * as functions from "firebase-functions";

export namespace SystemService {
  /**
   * The structure of a custom user claim
   */
  export type CustomUserClaims = {
    level: string;
  };

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

  /**
   * Attempts to get a users bearer token from a HTTPS function and authenticate that user.
   * @param {functions.https.Request} request The Firebase request, containing an authorisation header.
   * @param {functions.Response<any>} response The response, used to throw an error back to the user upon failure.
   * @return {DecodedIdToken} A decoded token, containing the users scopes and unique identifier.
   */
  export async function authenticateHttpsUser(
    request: functions.https.Request,
    response: functions.Response<any>
  ): Promise<DecodedIdToken> {
    try {
      const idToken = request.headers.authorization!.split("Bearer ")[1];
      const verifiedToken = await admin.auth().verifyIdToken(idToken);
      return verifiedToken;
    } catch (e) {
      response.status(403).send("Unauthorized");
      throw e;
    }
  }

  /**
   * Verifies the AppCheckData context exists for the application.
   * If the parameter does not exist, then it is being called from an unknown source.
   *
   * @param {functions.https.CallableContext} context The context from the Firebase onCall function
   */
  export function verifyAppContext(
    context: functions.https.CallableContext
  ): void {
    if (context.app == undefined) {
      throw new functions.https.HttpsError(
        "failed-precondition",
        "The function must be called from an App Check verified app."
      );
    }
  }

  /**
   * Verifies the Auth context exists for the application.
   * If the parameter does not exist, then it is being called from an unauthenticated user.
   *
   * @param {functions.https.CallableContext} context The context from the Firebase onCall function
   */
  export function verifyAuthContext(
    context: functions.https.CallableContext
  ): void {
    if (context.auth == undefined) {
      throw new functions.https.HttpsError(
        "failed-precondition",
        "The function must be called from an authenticated user."
      );
    }
  }
}
