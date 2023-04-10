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
      relationshipSnapshot = await createUserRelationship([uid, target]);
    }

    return relationshipSnapshot;
  }

  /**
   * Creates a relationship between entities.
   * @param {string[]} members the members of the relationship.
   * @return {any} the created relationship.
   */
  export async function createUserRelationship(
    members: string[]
  ): Promise<any> {
    const documentName = StringHelpers.generateDocumentNameFromGuids(members);
    const data = {} as any;

    for (const member of members) {
      data[member] = {
        reports: [],
        hasBlocked: false,
        hasMuted: false,
      };
    }

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
   * @param {string[]} members the members of the relationship.
   * @return {boolean} true if the entity is blocked, false otherwise.
   */
  export async function checkRelationshipBlocked(
    members: string[],
    { sender = "" } = {}
  ): Promise<boolean> {
    functions.logger.info("Checking if relationship is blocked", {
      members,
    });

    const documentName = StringHelpers.generateDocumentNameFromGuids(members);
    const relationship = await DataService.getDocument({
      schemaKey: "relationships",
      entryId: documentName,
    });

    if (!relationship) {
      await createUserRelationship(members);
    }

    if (relationship.members && relationship.members.length > 0) {
      for (const member of relationship.members) {
        if (
          sender.length > 0 &&
          typeof member.memberId === "string" &&
          member.memberId === sender
        ) {
          continue;
        }

        if (member.hasBlocked) {
          return true;
        }
      }
    }

    return false;
  }

  /**
   * Blocks a relationship from the given sender.
   * @param {string} sender the sender of the message.
   * @param {string[]} members the members of the relationship.
   */
  export async function blockRelationship(
    sender: string,
    members: string[]
  ): Promise<void> {
    functions.logger.info("Blocking relationship", {
      members,
    });

    const documentName = StringHelpers.generateDocumentNameFromGuids(members);
    const relationship = await DataService.getDocument({
      schemaKey: "relationships",
      entryId: documentName,
    });

    if (!relationship) {
      await createUserRelationship(members);
    }

    if (relationship.members && relationship.members.length > 0) {
      for (const member of relationship.members) {
        if (typeof member.memberId === "string" && member.memberId === sender) {
          member.hasBlocked = true;
        }
      }
    }

    await DataService.updateDocument({
      schemaKey: "relationships",
      entryId: documentName,
      data: relationship,
    });
  }
}
