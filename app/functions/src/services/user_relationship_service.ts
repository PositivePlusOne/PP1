import * as functions from "firebase-functions";

import { StringHelpers } from "../helpers/string_helpers";
import { DataService } from "./data_service";

// Used for interrogating information between two users.
// For example: checking if a user is blocked from sending messages to another user.
export namespace UserRelationshipService {
  /**
   * Gets the relationship between two users.
   * @param {string} uid the first user.
   * @param {string} target the second user.
   * @return {any} the relationship between the two users.
   */
  export async function getUserRelationship(
    uid: string,
    target: string
  ): Promise<any> {
    const documentName = StringHelpers.generateDocumentNameFromGuids([
      uid,
      target,
    ]);

    let relationshipSnapshot = await DataService.getDocument({
      schemaKey: "relationships",
      entryId: documentName,
    });

    //* Create a new relationship if one doesn't exist.
    if (!relationshipSnapshot) {
      relationshipSnapshot = await createUserRelationship(uid, target);
    }

    return relationshipSnapshot;
  }

  /**
   * Creates a relationship between two users.
   * @param {string} uid the first user.
   * @param {string} target the second user.
   * @return {any} the created relationship.
   */
  export async function createUserRelationship(
    uid: string,
    target: string
  ): Promise<any> {
    const documentName = StringHelpers.generateDocumentNameFromGuids([
      uid,
      target,
    ]);

    const data = {
      blockedBy: "",
    };

    await DataService.updateDocument({
      schemaKey: "relationships",
      entryId: documentName,
      data,
    });

    return await DataService.getDocument({
      schemaKey: "relationships",
      entryId: documentName,
    });
  }

  /**
   * Checks if the given relationship is blocked
   * @param {string} documentName the name of the relationship document.
   * @return {boolean} true if the user is blocked, false otherwise.
   */
  export async function checkRelationshipBlocked(
    documentName: string
  ): Promise<boolean> {
    functions.logger.info("Checking if relationship is blocked", {
      documentName,
    });

    const relationship = await DataService.getDocument({
      schemaKey: "relationships",
      entryId: documentName,
    });

    if (!relationship) {
      throw new functions.https.HttpsError(
        "not-found",
        "Relationship not found"
      );
    }

    const blockedBy = relationship.blockedBy;
    return typeof blockedBy === "string" && blockedBy.length > 0;
  }

  /**
   * Blocks a user from sending messages to the given profile.
   * @param {string} documentName the name of the relationship document.
   */
  export async function blockRelationship(
    sender: string,
    documentName: string
  ): Promise<void> {
    functions.logger.info("Blocking relationship", { documentName });

    const data = {
      blockedBy: sender,
    };

    await DataService.updateDocument({
      schemaKey: "relationships",
      entryId: documentName,
      data,
    });
  }
}
