import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

import { StringHelpers } from "../helpers/string_helpers";
import { DataService } from "./data_service";
import { adminApp } from "..";
import { ConversationService } from "./conversation_service";
import { FlamelinkHelpers } from "../helpers/flamelink_helpers";
import { RelationshipHelpers } from "../helpers/relationship_helpers";

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
      .where("searchIndexRelationshipBlocks", ">=", uid)
      .where("searchIndexRelationshipBlocks", "<=", uid + "\uf8ff")
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
   * Gets the connected relationships for the given user.
   * @param {string} uid the user to get the connected relationships for.
   * @return {string[]} the connected relationships as GUIDs.
   */
  export async function getConnectedRelationships(
    uid: string
  ): Promise<string[]> {
    const adminFirestore = adminApp.firestore();
    const relationships = [] as string[];

    const relationshipsSnapshot = await adminFirestore
      .collection("fl_content")
      .where("_fl_meta_.schema", "==", "relationships")
      .where("searchIndexRelationshipConnections", ">=", uid)
      .where("searchIndexRelationshipConnections", "<=", uid + "\uf8ff")
      .where("connected", "==", true)
      .get();

    relationshipsSnapshot.docs.forEach((doc) => {
      const data = doc.data();

      if (data.members && data.members.length > 0) {
        let hasConnected = false;
        for (const member of data.members) {
          if (typeof member.memberId === "string" && member.memberId === uid) {
            hasConnected = member.hasConnected;
            break;
          }
        }

        if (hasConnected) {
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

    functions.logger.info("Connected relationships", {
      relationships,
    });

    return relationships;
  }

  /**
   * Gets the followed relationships for the given user.
   * @param {string} uid the user to get the followed relationships for.
   * @return {string[]} the followed relationships as GUIDs.
   */
  export async function getPendingConnectionRequests(
    uid: string
  ): Promise<string[]> {
    const adminFirestore = adminApp.firestore();
    const relationships = [] as string[];

    const relationshipsSnapshot = await adminFirestore
      .collection("fl_content")
      .where("_fl_meta_.schema", "==", "relationships")
      .where("searchIndexRelationshipConnections", ">=", uid)
      .where("searchIndexRelationshipConnections", "<=", uid + "\uf8ff")
      .where("connected", "==", true)
      .get();

    relationshipsSnapshot.docs.forEach((doc) => {
      const data = doc.data();

      if (data.members && data.members.length > 0) {
        let hasConnected = false;
        for (const member of data.members) {
          if (typeof member.memberId === "string" && member.memberId === uid) {
            hasConnected = member.hasConnected;
            break;
          }
        }

        if (!hasConnected) {
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

    functions.logger.info("Pending connection requests", {
      relationships,
    });

    return relationships;
  }

  /**
   * Gets the followed relationships for the given user.
   * @param {string} uid the user to get the followed relationships for.
   * @return {string[]} the followed relationships as GUIDs.
   */
  export async function getFollowingRelationships(
    uid: string
  ): Promise<string[]> {
    const adminFirestore = adminApp.firestore();
    const relationships = [] as string[];

    const relationshipsSnapshot = await adminFirestore
      .collection("fl_content")
      .where("_fl_meta_.schema", "==", "relationships")
      .where("searchIndexRelationshipFollows", ">=", uid)
      .where("searchIndexRelationshipFollows", "<=", uid + "\uf8ff")
      .where("following", "==", true)
      .get();

    relationshipsSnapshot.docs.forEach((doc) => {
      const data = doc.data();

      if (data.members && data.members.length > 0) {
        for (const member of data.members) {
          if (typeof member.memberId === "string" && member.memberId === uid) {
            continue;
          }

          if (typeof member.memberId === "string") {
            relationships.push(member.memberId);
          }
        }
      }
    });

    functions.logger.info("Following relationships", {
      relationships,
    });

    return relationships;
  }

  /**
   * Gets the muted relationships for the given user.
   * @param {string} uid the user to get the muted relationships for.
   * @return {string[]} the muted relationships as GUIDs.
   */
  export async function getMutedRelationships(uid: string): Promise<string[]> {
    const adminFirestore = adminApp.firestore();
    const relationships = [] as string[];

    const relationshipsSnapshot = await adminFirestore
      .collection("fl_content")
      .where("_fl_meta_.schema", "==", "relationships")
      .where("searchIndexRelationshipMutes", ">=", uid)
      .where("searchIndexRelationshipMutes", "<=", uid + "\uf8ff")
      .where("muted", "==", true)
      .get();

    relationshipsSnapshot.docs.forEach((doc) => {
      const data = doc.data();

      if (data.members && data.members.length > 0) {
        for (const member of data.members) {
          if (typeof member.memberId === "string" && member.memberId === uid) {
            continue;
          }

          if (typeof member.memberId === "string") {
            relationships.push(member.memberId);
          }
        }
      }

      relationships.push(data._fl_meta_.fl_id);
    });

    functions.logger.info("Muted relationships", {
      relationships,
    });

    return relationships;
  }

  /**
   * Gets the hidden relationships for the given user.
   * @param {string} uid the user to get the hidden relationships for.
   * @return {string[]} the hidden relationships as GUIDs.
   */
  export async function getHiddenRelationships(uid: string): Promise<string[]> {
    const adminFirestore = adminApp.firestore();
    const relationships = [] as string[];

    const relationshipsSnapshot = await adminFirestore
      .collection("fl_content")
      .where("_fl_meta_.schema", "==", "relationships")
      .where("searchIndexRelationshipHides", ">=", uid)
      .where("searchIndexRelationshipHides", "<=", uid + "\uf8ff")
      .where("hidden", "==", true)
      .get();

    relationshipsSnapshot.docs.forEach((doc) => {
      const data = doc.data();

      if (data.members && data.members.length > 0) {
        for (const member of data.members) {
          if (typeof member.memberId === "string" && member.memberId === uid) {
            continue;
          }

          if (typeof member.memberId === "string") {
            relationships.push(member.memberId);
          }
        }
      }

      relationships.push(data._fl_meta_.fl_id);
    });

    functions.logger.info("Hidden relationships", {
      relationships,
    });

    return relationships;
  }

  /**
   * Unblocks a relationship from the given sender.
   * @param {string} sender the sender of the message.
   * @param {any} relationship the relationship to unblock.
   * @return {any} the updated relationship.
   */
  export async function unblockRelationship(
    sender: string,
    relationship: any
  ): Promise<any> {
    functions.logger.info("Unblocking relationship", {
      sender,
      relationship,
    });

    let hasRemainingBlockers = false;
    for (const member of relationship.members) {
      if (typeof member.memberId === "string" && member.memberId === sender) {
        member.hasBlocked = false;
      }

      if (member.hasBlocked) {
        hasRemainingBlockers = true;
      }
    }

    // Remove the blocked flag if all members have unblocked.
    relationship.blocked = hasRemainingBlockers;

    relationship =
      RelationshipHelpers.updateRelationshipWithIndexes(relationship);

    await DataService.updateDocument({
      schemaKey: "relationships",
      entryId: FlamelinkHelpers.getFlamelinkIdFromObject(relationship),
      data: relationship,
    });

    return relationship;
  }

  /**
   * Blocks a relationship from the given sender.
   * @param {string} sender the sender of the message.
   * @param {any} relationship the relationship to block.
   * @return {any} the updated relationship.
   */
  export async function blockRelationship(
    sender: string,
    relationship: any
  ): Promise<any> {
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

    relationship =
      RelationshipHelpers.updateRelationshipWithIndexes(relationship);

    await DataService.updateDocument({
      schemaKey: "relationships",
      entryId: FlamelinkHelpers.getFlamelinkIdFromObject(relationship),
      data: relationship,
    });

    return relationship;
  }

  /**
   * Unmutes a relationship from the given sender.
   * @param {string} sender the sender of the message.
   * @param {any} relationship the relationship to unmute.
   * @return {any} the updated relationship.
   */
  export async function muteRelationship(
    sender: string,
    relationship: any
  ): Promise<any> {
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

    relationship =
      RelationshipHelpers.updateRelationshipWithIndexes(relationship);

    await DataService.updateDocument({
      schemaKey: "relationships",
      entryId: FlamelinkHelpers.getFlamelinkIdFromObject(relationship),
      data: relationship,
    });

    return relationship;
  }

  /**
   * Unmutes a relationship from the given sender.
   * @param {string} sender the sender of the message.
   * @param {any} relationship the relationship.
   * @return {any} the updated relationship.
   */
  export async function unmuteRelationship(
    sender: string,
    relationship: any
  ): Promise<any> {
    functions.logger.info("Unmuting relationship", {
      sender,
      relationship,
    });

    let hasRemainingMuters = false;
    if (relationship.members && relationship.members.length > 0) {
      for (const member of relationship.members) {
        if (typeof member.memberId === "string" && member.memberId === sender) {
          member.hasMuted = false;
        }

        if (member.hasMuted) {
          hasRemainingMuters = true;
        }
      }
    }

    // Remove the muted flag if all members have unmuted.
    relationship.muted = hasRemainingMuters;

    relationship =
      RelationshipHelpers.updateRelationshipWithIndexes(relationship);

    await DataService.updateDocument({
      schemaKey: "relationships",
      entryId: FlamelinkHelpers.getFlamelinkIdFromObject(relationship),
      data: relationship,
    });

    return relationship;
  }

  /**
   * Connects a relationship from the given sender.
   * @param {string} sender the sender of the message.
   * @param {any} relationship the relationship to connect.
   * @return {Promise<any>} the updated relationship.
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
    if (relationship.members && relationship.members.length === 2 && !relationship.channelId) {
      const memberIds = relationship.members.map((member: any) => member.memberId);
      const channelId = await ConversationService.createConversation(sender, memberIds);

      relationship.channelId = channelId;
      relationship.connectionStarted = admin.firestore.Timestamp.fromDate(
        new Date()
      );
    }

    relationship.connected = true;

    relationship =
      RelationshipHelpers.updateRelationshipWithIndexes(relationship);

    await DataService.updateDocument({
      schemaKey: "relationships",
      entryId: FlamelinkHelpers.getFlamelinkIdFromObject(relationship),
      data: relationship,
    });

    return relationship;
  }

  /**
   * Rejects a relationship from the given sender.
   * @param {string} sender the sender of the message.
   * @param {any} relationship the relationship to reject.
   * @return {Promise<any>} the updated relationship.
   */
  export async function rejectRelationship(
    sender: string,
    relationship: any
  ): Promise<void> {
    functions.logger.info("Rejecting relationship", {
      sender,
      relationship,
    });

    if (relationship.members && relationship.members.length > 0) {
      for (const member of relationship.members) {
        member.hasConnected = false;
      }
    }

    // Sets a flag on the relationship to indicate that has been rejected by the sender.
    relationship.connected = false;

    relationship =
      RelationshipHelpers.updateRelationshipWithIndexes(relationship);

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
   * @return {Promise<any>} the updated relationship.
   */
  export async function disconnectRelationship(
    sender: string,
    relationship: any
  ): Promise<any> {
    functions.logger.info("Disconnecting relationship", {
      sender,
      relationship,
    });

    let hasRemainingConnections = false;
    if (relationship.members && relationship.members.length > 0) {
      for (const member of relationship.members) {
        if (typeof member.memberId === "string" && member.memberId === sender) {
          member.hasConnected = false;
        }

        if (member.hasConnected === true) {
          hasRemainingConnections = true;
        }
      }
    }

    // Remove the connected flag if all members have disconnected.
    relationship.connected = hasRemainingConnections;

    relationship =
      RelationshipHelpers.updateRelationshipWithIndexes(relationship);

    await DataService.updateDocument({
      schemaKey: "relationships",
      entryId: FlamelinkHelpers.getFlamelinkIdFromObject(relationship),
      data: relationship,
    });

    return relationship;
  }

  /**
   * Follows a relationship from the given sender.
   * @param {string} sender the sender of the message.
   * @param {any} relationship the relationship to follow.
   * @return {Promise<any>} the updated relationship.
   */
  export async function followRelationship(
    sender: string,
    relationship: any
  ): Promise<any> {
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

    relationship =
      RelationshipHelpers.updateRelationshipWithIndexes(relationship);

    await DataService.updateDocument({
      schemaKey: "relationships",
      entryId: FlamelinkHelpers.getFlamelinkIdFromObject(relationship),
      data: relationship,
    });

    return relationship;
  }

  /**
   * Unfollows a relationship from the given sender.
   * @param {string} sender the sender of the message.
   * @param {any} relationship the relationship to unfollow.
   * @return {Promise<any>} the updated relationship.
   */
  export async function unfollowRelationship(
    sender: string,
    relationship: any
  ): Promise<any> {
    functions.logger.info("Unfollowing relationship", {
      sender,
      relationship,
    });

    let hasRemainingFollowers = false;
    if (relationship.members && relationship.members.length > 0) {
      for (const member of relationship.members) {
        if (typeof member.memberId === "string" && member.memberId === sender) {
          member.hasFollowed = false;
        }

        if (member.hasFollowed === true) {
          hasRemainingFollowers = true;
        }
      }
    }

    // Remove the followed flag if all members have unfollowed.
    relationship.followed = hasRemainingFollowers;

    relationship =
      RelationshipHelpers.updateRelationshipWithIndexes(relationship);

    await DataService.updateDocument({
      schemaKey: "relationships",
      entryId: FlamelinkHelpers.getFlamelinkIdFromObject(relationship),
      data: relationship,
    });

    return relationship;
  }

  /**
   * Hides a relationship from the given sender.
   * @param {string} sender the sender of the message.
   * @param {any} relationship the relationship to hide.
   * @return {Promise<any>} the updated relationship.
   */
  export async function hideRelationship(
    sender: string,
    relationship: any
  ): Promise<any> {
    functions.logger.info("Hiding relationship", {
      sender,
      relationship,
    });

    if (relationship.members && relationship.members.length > 0) {
      for (const member of relationship.members) {
        if (typeof member.memberId === "string" && member.memberId === sender) {
          member.hasHidden = true;
        }
      }
    }

    // Sets a flag on the relationship to indicate that it is hidden.
    relationship.hidden = true;

    relationship =
      RelationshipHelpers.updateRelationshipWithIndexes(relationship);

    await DataService.updateDocument({
      schemaKey: "relationships",
      entryId: FlamelinkHelpers.getFlamelinkIdFromObject(relationship),
      data: relationship,
    });

    return relationship;
  }

  /**
   * Unhides a relationship from the given sender.
   * @param {string} sender the sender of the message.
   * @param {any} relationship the relationship to unhide.
   * @return {Promise<any>} the updated relationship.
   */
  export async function unhideRelationship(
    sender: string,
    relationship: any
  ): Promise<any> {
    functions.logger.info("Unhiding relationship", {
      sender,
      relationship,
    });

    let hasRemainingHidden = false;
    if (relationship.members && relationship.members.length > 0) {
      for (const member of relationship.members) {
        if (typeof member.memberId === "string" && member.memberId === sender) {
          member.hasHidden = false;
        }

        if (member.hasHidden === true) {
          hasRemainingHidden = true;
        }
      }
    }

    // Remove the hidden flag if all members have unhidden.
    relationship.hidden = hasRemainingHidden;

    relationship =
      RelationshipHelpers.updateRelationshipWithIndexes(relationship);

    await DataService.updateDocument({
      schemaKey: "relationships",
      entryId: FlamelinkHelpers.getFlamelinkIdFromObject(relationship),
      data: relationship,
    });

    return relationship;
  }
}
