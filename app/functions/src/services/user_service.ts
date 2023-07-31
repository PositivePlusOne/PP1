import * as functions from "firebase-functions";
import { ProfileService } from "./profile_service";
import { FlamelinkHelpers } from "../helpers/flamelink_helpers";
import { adminApp } from "..";

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
    const [userProfile, requestProfile] = await Promise.all([
      ProfileService.getProfile(uid),
      ProfileService.getProfile(requestId),
    ]);

    const requestProfileId = FlamelinkHelpers.getFlamelinkIdFromObject(requestProfile);
    if (requestProfileId !== requestId) {
      throw new functions.https.HttpsError("permission-denied", "You do not have permission to call this function");
    }

    const managerReferences = requestProfile?.organisationConfiguration?.members || [];
    const userProfileId = userProfile?.id || "";
    if (!userProfileId) {
      throw new functions.https.HttpsError("permission-denied", "You do not have permission to call this function");
    }

    const firestore = adminApp.firestore();

    // Check if iterable or single
    if (!Array.isArray(managerReferences)) {
      const managerReferenceDoc = firestore.doc(managerReferences.path);
      const managerDocId = managerReferenceDoc.id;
      if (managerDocId === userProfileId) {
        functions.logger.info(`Authenticated as: ${uid}`);
        return uid;
      }
    } else {
      for (const managerReference of managerReferences) {
        const managerReferenceDoc = firestore.doc(managerReference.path);
        const managerDocId = managerReferenceDoc.id;
        if (managerDocId === userProfileId) {
          functions.logger.info(`Authenticated as: ${uid}`);
          return uid;
        }
      }
    }

    throw new functions.https.HttpsError("permission-denied", "You do not have permission to call this function");
  }
}
