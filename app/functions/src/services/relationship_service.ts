import * as functions from "firebase-functions";

import { StringHelpers } from "../helpers/string_helpers";
import { DataService } from "./data_service";
import { adminApp } from "..";
import { ConversationService } from "./conversation_service";
import { FlamelinkHelpers } from "../helpers/flamelink_helpers";

// Used for interrogating information between two users.
// For example: checking if a user is blocked from sending messages to another user.
export namespace RelationshipService {
  /**
   * Gets the relationship between entities.
   * @param {string[]} members the members of the relationship.
   * @return {any} the relationship between the two users.
   */
  export async function getRelationship(members: string[]): Promise<any> {
    const documentName = StringHelpers.generateDocumentNameFromGuids(members);
    let relationshipSnapshot = await DataService.getDocument({
      schemaKey: "relationships",
      entryId: documentName,
    });

    //* Create a new relationship if one doesn't exist.
    if (!relationshipSnapshot) {
      relationshipSnapshot = await createRelationship(members);
    }

    return relationshipSnapshot;
  }

  /**
   * Creates a relationship between entities.
   * @param {string[]} members the members of the relationship.
   * @return {any} the created relationship.
   */
  export async function createRelationship(members: string[]): Promise<any> {
    const documentName = StringHelpers.generateDocumentNameFromGuids(members);
    const memberData = [] as any;

    for (const member of members) {
      memberData.push({
        memberId: member,
        hasBlocked: false,
        hasMuted: false,
        hasConnected: false,
        hasFollowed: false,
        hasHidden: false,
      });
    }

    await DataService.updateDocument({
      schemaKey: "relationships",
      entryId: documentName,
      data: {
        members: memberData,
        blocked: false,
        muted: false,
        connected: false,
        followed: false,
        hidden: false,
      },
    });

    return await DataService.getDocument({
      schemaKey: "relationships",
      entryId: documentName,
    });
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
   * @param {any} relationship the relationship to unblock.
   */
  export async function unblockRelationship(
    sender: string,
    relationship: any
  ): Promise<void> {
    functions.logger.info("Unblocking relationship", {
      sender,
      relationship,
    });

    for (const member of relationship.members) {
      if (typeof member.memberId === "string" && member.memberId === sender) {
        member.hasBlocked = false;
      }
    }

    // Remove the blocked flag if all members have unblocked.
    relationship.blocked = false;

    await DataService.updateDocument({
      schemaKey: "relationships",
      entryId: FlamelinkHelpers.getFlamelinkIdFromObject(relationship),
      data: relationship,
    });
  }

  /**
   * Blocks a relationship from the given sender.
   * @param {string} sender the sender of the message.
   * @param {any} relationship the relationship to block.
   */
  export async function blockRelationship(
    sender: string,
    relationship: any
  ): Promise<void> {
    functions.logger.info("Blocking relationship", {
      sender,
      relationship,
    });

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
      entryId: FlamelinkHelpers.getFlamelinkIdFromObject(relationship),
      data: relationship,
    });
  }

  /**
   * Unmutes a relationship from the given sender.
   * @param {string} sender the sender of the message.
   * @param {any} relationship the relationship to unmute.
   */
  export async function muteRelationship(
    sender: string,
    relationship: any
  ): Promise<void> {
    functions.logger.info("Muting relationship", {
      sender,
      relationship,
    });

    if (relationship.members && relationship.members.length > 0) {
      for (const member of relationship.members) {
        if (typeof member.memberId === "string" && member.memberId === sender) {
          member.hasMuted = true;
        }
      }
    }

    // Sets a flag on the relationship to indicate that it is muted.
    relationship.muted = true;

    await DataService.updateDocument({
      schemaKey: "relationships",
      entryId: FlamelinkHelpers.getFlamelinkIdFromObject(relationship),
      data: relationship,
    });
  }

  /**
   * Unmutes a relationship from the given sender.
   * @param {string} sender the sender of the message.
   * @param {any} relationship the relationship.
   */
  export async function unmuteRelationship(
    sender: string,
    relationship: any
  ): Promise<void> {
    functions.logger.info("Unmuting relationship", {
      sender,
      relationship,
    });

    if (relationship.members && relationship.members.length > 0) {
      for (const member of relationship.members) {
        if (typeof member.memberId === "string" && member.memberId === sender) {
          member.hasMuted = false;
        }
      }
    }

    // Remove the muted flag if all members have unmuted.
    relationship.muted = false;

    await DataService.updateDocument({
      schemaKey: "relationships",
      entryId: FlamelinkHelpers.getFlamelinkIdFromObject(relationship),
      data: relationship,
    });
  }

  /**
   * Connects a relationship from the given sender.
   * @param {string} sender the sender of the message.
   * @param {any} relationship the relationship to connect.
   * @returns {Promise<any>} the updated relationship.
   */
  export async function connectRelationship(
    sender: string,
    relationship: any
  ): Promise<any> {
    functions.logger.info("Connecting relationship", {
      sender,
      relationship,
    });

    if (relationship.members && relationship.members.length > 0) {
      for (const member of relationship.members) {
        if (typeof member.memberId === "string" && member.memberId === sender) {
          member.hasConnected = true;
        }
      }
    }

    // If the relationship has two members, create a conversation.
    if (relationship.members && relationship.members.length === 2) {
      const channelId = await ConversationService.createConversation(
        relationship.members
      );

      relationship.channelId = channelId;
    }

    // Sets a flag on the relationship to indicate that it is connected.
    relationship.connected = true;

    await DataService.updateDocument({
      schemaKey: "relationships",
      entryId: FlamelinkHelpers.getFlamelinkIdFromObject(relationship),
      data: relationship,
    });

    return relationship;
  }

  /**
   * Disconnects a relationship from the given sender.
   * @param {string} sender the sender of the message.
   * @param {any} relationship the relationship to disconnect.
   */
  export async function disconnectRelationship(
    sender: string,
    relationship: any
  ): Promise<void> {
    functions.logger.info("Disconnecting relationship", {
      sender,
      relationship,
    });

    if (relationship.members && relationship.members.length > 0) {
      for (const member of relationship.members) {
        if (typeof member.memberId === "string" && member.memberId === sender) {
          member.hasConnected = false;
        }
      }
    }

    // Remove the connected flag if all members have disconnected.
    relationship.connected = false;

    await DataService.updateDocument({
      schemaKey: "relationships",
      entryId: FlamelinkHelpers.getFlamelinkIdFromObject(relationship),
      data: relationship,
    });
  }

  /**
   * Follows a relationship from the given sender.
   * @param {string} sender the sender of the message.
   * @param {any} relationship the relationship to follow.
   */
  export async function followRelationship(
    sender: string,
    relationship: any
  ): Promise<void> {
    functions.logger.info("Following relationship", {
      sender,
      relationship,
    });

    if (relationship.members && relationship.members.length > 0) {
      for (const member of relationship.members) {
        if (typeof member.memberId === "string" && member.memberId === sender) {
          member.hasFollowed = true;
        }
      }
    }

    // Sets a flag on the relationship to indicate that it is followed.
    relationship.followed = true;

    await DataService.updateDocument({
      schemaKey: "relationships",
      entryId: FlamelinkHelpers.getFlamelinkIdFromObject(relationship),
      data: relationship,
    });
  }

  /**
   * Unfollows a relationship from the given sender.
   * @param {string} sender the sender of the message.
   * @param {any} relationship the relationship to unfollow.
   */
  export async function unfollowRelationship(
    sender: string,
    relationship: any
  ): Promise<void> {
    functions.logger.info("Unfollowing relationship", {
      sender,
      relationship,
    });

    if (relationship.members && relationship.members.length > 0) {
      for (const member of relationship.members) {
        if (typeof member.memberId === "string" && member.memberId === sender) {
          member.hasFollowed = false;
        }
      }
    }

    // Remove the followed flag if all members have unfollowed.
    relationship.followed = false;

    await DataService.updateDocument({
      schemaKey: "relationships",
      entryId: FlamelinkHelpers.getFlamelinkIdFromObject(relationship),
      data: relationship,
    });
  }
}
