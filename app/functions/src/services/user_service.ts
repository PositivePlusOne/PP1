import * as functions from "firebase-functions";
import { RelationshipService } from "./relationship_service";
import { RelationshipJSON, RelationshipMemberJSON } from "../dto/relationships";

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

    const relationship = await RelationshipService.getRelationship([uid, requestId]) as RelationshipJSON | null;
    if (!relationship) {
      functions.logger.info(`Authenticated as: ${uid}`);
      return uid;
    }

    const relationshipMember = relationship?.members?.find((m: RelationshipMemberJSON) => m.memberId === uid);
    if (!relationshipMember) {
      functions.logger.info(`Authenticated as: ${uid}`);
      return uid;
    }

    if (!relationshipMember?.canManage) {
      throw new functions.https.HttpsError("permission-denied", "You do not have permission to call this function");
    }

    functions.logger.info(`Authenticated as: ${requestId} (via ${uid})`);
    return requestId;
  }
}
