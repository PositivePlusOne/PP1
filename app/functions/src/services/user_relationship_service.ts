import * as functions from "firebase-functions";

import { StringHelpers } from "../helpers/string_helpers";
import { DataService } from "./data_service";
import { adminApp } from "..";

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
    const memberData = [] as any;

    for (const member of members) {
      memberData.push({
        memberId: member,
        hasBlocked: false,
        hasMuted: false,
        reports: [],
      });
    }

    await DataService.updateDocument({
      schemaKey: "relationships",
      entryId: documentName,
      data: {
        blocked: false,
        muted: false,
        members: memberData,
      },
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
    let relationship = await DataService.getDocument({
      schemaKey: "relationships",
      entryId: documentName,
    });

    if (!relationship) {
      relationship = await createUserRelationship(members);
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
   * Gets the blocked relationships for the given user.
   * @param {string} uid the user to get the blocked relationships for.
   * @return {string[]} the blocked relationships as GUIDs.
   */
  export async function getBlockedRelationships(
    uid: string
  ): Promise<string[]> {
    const adminFirestore = adminApp.firestore();
    const relationships = [] as string[];

    const relationshipsSnapshot = await adminFirestore
      .collection("fl_content")
      .where("_fl_meta_.schema", "==", "relationships")
      .where("_fl_meta_.fl_id", ">=", uid)
      .where("_fl_meta_.fl_id", "<=", uid + "\uf8ff")
      .where("blocked", "==", true)
      .get();

    relationshipsSnapshot.docs.forEach((doc) => {
      const data = doc.data();

      if (data.members && data.members.length > 0) {
        let hasBlocked = false;
        for (const member of data.members) {
          if (typeof member.memberId === "string" && member.memberId === uid) {
            hasBlocked = member.hasBlocked;
            break;
          }
        }

        if (hasBlocked) {
          for (const member of data.members) {
            if (
              typeof member.memberId === "string" &&
              member.memberId !== uid
            ) {
              relationships.push(member.memberId);
            }
          }
        }
      }
    });

    functions.logger.info("Blocked relationships", {
      relationships,
    });

    return relationships;
  }

  /**
   * Unblocks a relationship from the given sender.
   * @param {string} sender the sender of the message.
   * @param {string[]} members the members of the relationship.
   */
  export async function unblockRelationship(
    sender: string,
    members: string[]
  ): Promise<void> {
    functions.logger.info("Unblocking relationship", {
      members,
    });

    const documentName = StringHelpers.generateDocumentNameFromGuids(members);
    let relationship = await DataService.getDocument({
      schemaKey: "relationships",
      entryId: documentName,
    });

    if (!relationship) {
      relationship = await createUserRelationship(members);
    }

    for (const member of relationship.members) {
      if (
        typeof member.memberId === "string" &&
        member.memberId !== sender &&
        member.hasBlocked
      ) {
        throw new functions.https.HttpsError(
          "permission-denied",
          "The user has blocked you."
        );
      }

      if (typeof member.memberId === "string" && member.memberId === sender) {
        member.hasBlocked = false;
      }
    }

    // Remove the blocked flag if all members have unblocked.
    relationship.blocked = false;

    await DataService.updateDocument({
      schemaKey: "relationships",
      entryId: documentName,
      data: relationship,
    });
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
    let relationship = await DataService.getDocument({
      schemaKey: "relationships",
      entryId: documentName,
    });

    if (!relationship) {
      relationship = await createUserRelationship(members);
    }

    if (relationship.members && relationship.members.length > 0) {
      for (const member of relationship.members) {
        if (typeof member.memberId === "string" && member.memberId === sender) {
          member.hasBlocked = true;
        }
      }
    }

    // Sets a flag on the relationship to indicate that it is blocked.
    relationship.blocked = true;

    await DataService.updateDocument({
      schemaKey: "relationships",
      entryId: documentName,
      data: relationship,
    });
  }
}
