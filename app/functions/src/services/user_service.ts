import * as functions from "firebase-functions";
import { ProfileService } from "./profile_service";
import { FlamelinkHelpers } from "../helpers/flamelink_helpers";
import { adminApp } from "..";
import { RelationshipService } from "./relationship_service";
import { ProfileJSON } from "../dto/profile";

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

    const [relationship, targetProfile] = await Promise.all([
      RelationshipService.getRelationship([uid, requestId]),
      ProfileService.getProfile(requestId)
    ]);

    if (!relationship || !targetProfile) {
      functions.logger.info(`Authenticated as: ${uid}`);
      return uid;
    }

    const isManageRelationshipFlag = relationship?.flags?.includes("managedRelationship") || false;
    const hasManageTargetFlag = targetProfile?.featureFlags?.includes("manageTarget") || false;

    if (isManageRelationshipFlag && hasManageTargetFlag) {
      functions.logger.info(`Authenticated as: ${uid}`);
      return uid;
    }

    throw new functions.https.HttpsError("permission-denied", "You do not have permission to call this function");
  }
}
