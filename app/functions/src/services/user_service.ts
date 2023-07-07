import * as functions from "firebase-functions";
import { ProfileService } from "./profile_service";
import { FlamelinkHelpers } from "../helpers/flamelink_helpers";

export namespace UserService {
  /**
   * Verifies the application is authenticated by a user.
   * @param {functions.https.CallableContext} context The context from a https onCall function
   * @throws {functions.https.HttpsError} If the user is not authenticated.
   * @returns {Promise<String>} The user's uid
   */
  export async function verifyAuthenticated(context: functions.https.CallableContext, requestId = ""): Promise<string> {
    functions.logger.info("Verifying authentication");
    const uid = context.auth?.uid || "";
    if (!(typeof uid === "string") || uid.length === 0) {
      throw new functions.https.HttpsError("unauthenticated", "You must be authenticated to call this function");
    }

    if (!requestId || uid === requestId) {
      functions.logger.info(`Authenticated as: ${uid}`);
      return uid;
    }

    // Attempt to get the profile and check the managers
    const requestProfile = await ProfileService.getProfile(requestId);
    const requestProfileId = FlamelinkHelpers.getFlamelinkIdFromObject(requestProfile);
    if (requestProfileId !== requestId) {
      throw new functions.https.HttpsError("permission-denied", "You do not have permission to call this function");
    }

    const managers = requestProfile?.managers || [];
    for (const manager of managers) {
      const managerId = manager.manager || "";
      if (managerId === uid) {
        return requestProfileId;
      }
    }

    throw new functions.https.HttpsError("permission-denied", "You do not have permission to call this function");
  }
}
