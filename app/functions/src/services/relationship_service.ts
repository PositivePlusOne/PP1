import * as functions from "firebase-functions";

import { StringHelpers } from "../helpers/string_helpers";
import { DataService } from "./data_service";
import { adminApp } from "..";
import { FlamelinkHelpers } from "../helpers/flamelink_helpers";
import { RelationshipHelpers } from "../helpers/relationship_helpers";
import { Pagination, PaginationResult } from "../helpers/pagination";
import { ConversationService } from "./conversation_service";
import { RelationshipJSON, RelationshipMemberJSON } from "../dto/relationships";
import { CacheService } from "./cache_service";

// Used for interrogating information between two users.
// For example: checking if a user is blocked from sending messages to another user.
export namespace RelationshipService {
  export const FOLLOWING_CACHE_KEY_PREFIX = "following:";
  export const FOLLOWERS_CACHE_KEY_PREFIX = "followers:";
  export const MUTED_CACHE_KEY_PREFIX = "muted:";
  export const BLOCKED_CACHE_KEY_PREFIX = "blocked:";
  export const HIDDEN_CACHE_KEY_PREFIX = "hidden:";
  export const CONNECTED_CACHE_KEY_PREFIX = "connected:";

  /**
   * Gets the relationship between entities.
   * @param {string[]} members the members of the relationship.
   * @return {any} the relationship between the two users.
   */
  export async function getRelationship(members: string[]): Promise<any> {
    const documentName = StringHelpers.generateDocumentNameFromGuids(members);

    // Check if members is empty or contains duplicates
    if (members.length === 0 || new Set(members).size !== members.length) {
      throw new Error("Invalid members");
    }

    return await DataService.getDocument({
      schemaKey: "relationships",
      entryId: documentName,
    });
  }

  /**
   * Checks if the given relationship is connected.
   * @param {any} relationship the relationship to check.
   * @return {boolean} true if the relationship is connected.
   */
  export async function isConnected(members: string[]): Promise<boolean> {
    const relationship = await RelationshipService.getRelationship(members);
    return relationship && relationship.connected;
  }

  /**
   * Gets the relationship between entities.
   * @param {string[]} members the members of the relationship.
   * @return {any} the relationship between the two users.
   */
  export async function getOrCreateRelationship(members: string[]): Promise<any> {
    const relationship = await RelationshipService.getRelationship(members);
    if (relationship) {
      return relationship;
    }

    return await RelationshipService.createRelationship(members);
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
        searchIndexRelationships: members,
      },
    });

    return await DataService.getDocument({
      schemaKey: "relationships",
      entryId: documentName,
    });
  }

  /**
   * Resets the relationship pagination cache for the given relationship.
   * @param {RelationshipJSON} data the relationship data.
   * @return {Promise<void>} a promise that resolves when the cache has been reset.
   */
  export async function resetRelationshipPaginationCache(data: RelationshipJSON): Promise<void> {
    const members = data.members ?? [];
    await Promise.all([
      members.map((member: RelationshipMemberJSON) => {
        if (typeof member.memberId !== "string" || !member.memberId) {
          return [];
        }

        return [
          CacheService.deletePrefixedFromCache(FOLLOWING_CACHE_KEY_PREFIX + member.memberId),
          CacheService.deletePrefixedFromCache(FOLLOWERS_CACHE_KEY_PREFIX + member.memberId),
          CacheService.deletePrefixedFromCache(MUTED_CACHE_KEY_PREFIX + member.memberId),
          CacheService.deletePrefixedFromCache(BLOCKED_CACHE_KEY_PREFIX + member.memberId),
          CacheService.deletePrefixedFromCache(HIDDEN_CACHE_KEY_PREFIX + member.memberId),
          CacheService.deletePrefixedFromCache(CONNECTED_CACHE_KEY_PREFIX + member.memberId),
        ];
      }),
    ]);
  }

  /**
  * Gets the blocked relationships for the given user.
  * @param {string} uid the user to get the blocked relationships for.
  * @param {Pagination} pagination the pagination.
  * @return {RelationshipJSON[]} the blocked relationships as GUIDs.
  */
  export async function getBlockedRelationships(uid: string, pagination: Pagination): Promise<PaginationResult<RelationshipJSON>> {
    const adminFirestore = adminApp.firestore();
    const cacheKey = BLOCKED_CACHE_KEY_PREFIX + uid + ":" + pagination.cursor;
    let data = await CacheService.getFromCache(cacheKey);

    if (!data) {
      const relationshipsSnapshot = await adminFirestore
        .collection("fl_content")
        .orderBy("searchIndexRelationshipBlocks")
        .where("_fl_meta_.schema", "==", "relationships")
        .where("searchIndexRelationshipBlocks", ">=", uid)
        .where("searchIndexRelationshipBlocks", "<=", uid + "\uf8ff")
        .where("blocked", "==", true)
        .limit(pagination.limit ?? 10)
        .startAfter(pagination.cursor)
        .get();

      data = relationshipsSnapshot.docs.map((doc) => doc.data());
    }

    const hasData = data.length !== 0;
    const responsePagination = {
      limit: pagination.limit,
      cursor: '',
    } as Pagination;

    if (!hasData) {
      return { data: [], pagination: responsePagination };
    }

    CacheService.setInCache(cacheKey, data);

    const last = data[data.length - 1];
    const lastId = FlamelinkHelpers.getFlamelinkIdFromObject(last) ?? '';
    responsePagination.cursor = lastId;

    return {
      data: data,
      pagination: responsePagination,
    };
  }

  /**
   * Gets the connected relationships for the given user.
   * @param {string} uid the user to get the connected relationships for.
   * @param {Pagination} pagination the pagination.
   * @return {RelationshipJSON[]} the connected relationships as GUIDs.
   */
  export async function getConnectedRelationships(uid: string, pagination: Pagination): Promise<PaginationResult<RelationshipJSON>> {
    const adminFirestore = adminApp.firestore();
    const cacheKey = CONNECTED_CACHE_KEY_PREFIX + uid + ":" + pagination.cursor;
    let data = await CacheService.getFromCache(cacheKey);

    if (!data) {
      const relationshipsSnapshot = await adminFirestore
        .collection("fl_content")
        .orderBy("searchIndexRelationshipConnections")
        .where("_fl_meta_.schema", "==", "relationships")
        .where("searchIndexRelationshipConnections", ">=", uid)
        .where("searchIndexRelationshipConnections", "<=", uid + "\uf8ff")
        .where("connected", "==", true)
        .limit(pagination.limit ?? 10)
        .startAfter(pagination.cursor)
        .get();

      data = relationshipsSnapshot.docs.map((doc) => doc.data());
    }

    const hasData = data.length !== 0;
    const responsePagination = {
      limit: pagination.limit,
      cursor: '',
    } as Pagination;

    if (!hasData) {
      return { data: [], pagination: responsePagination };
    }

    CacheService.setInCache(cacheKey, data);

    const last = data[data.length - 1];
    const lastId = FlamelinkHelpers.getFlamelinkIdFromObject(last) ?? '';
    responsePagination.cursor = lastId;

    return {
      data: data,
      pagination: responsePagination,
    };
  }

  /**
   * Gets the followed relationships for the given user.
   * @param {string} uid the user to get the followed relationships for.
   * @return {string[]} the followed relationships as GUIDs.
   */
  export async function getFollowRelationships(uid: string, pagination: Pagination): Promise<PaginationResult<RelationshipJSON>> {
    const adminFirestore = adminApp.firestore();
    const cacheKey = FOLLOWING_CACHE_KEY_PREFIX + uid + ":" + pagination.cursor;
    let data = await CacheService.getFromCache(cacheKey);

    if (!data) {
      const relationshipsSnapshot = await adminFirestore
        .collection("fl_content")
        .orderBy("searchIndexRelationshipFollows")
        .where("_fl_meta_.schema", "==", "relationships")
        .where("searchIndexRelationshipFollows", ">=", uid)
        .where("searchIndexRelationshipFollows", "<=", uid + "\uf8ff")
        .limit(pagination.limit ?? 10)
        .startAfter(pagination.cursor)
        .get();

      data = relationshipsSnapshot.docs.map((doc) => doc.data());
    }

    const hasData = data.length !== 0;
    const responsePagination = {
      limit: pagination.limit,
      cursor: '',
    } as Pagination;

    if (!hasData) {
      return { data: [], pagination: responsePagination };
    }

    CacheService.setInCache(cacheKey, data);

    const last = data[data.length - 1];
    const lastId = FlamelinkHelpers.getFlamelinkIdFromObject(last) ?? '';
    responsePagination.cursor = lastId;

    return {
      data: data,
      pagination: responsePagination,
    };
  }

  export async function getFollowedRelationships(uid: string, pagination: Pagination): Promise<PaginationResult<RelationshipJSON>> {
    const adminFirestore = adminApp.firestore();
    const cacheKey = FOLLOWERS_CACHE_KEY_PREFIX + uid + ":" + pagination.cursor;
    let data = await CacheService.getFromCache(cacheKey);

    if (!data) {
      const relationshipsSnapshot = await adminFirestore
        .collection("fl_content")
        .orderBy("searchIndexRelationshipFollowers")
        .where("_fl_meta_.schema", "==", "relationships")
        .where("searchIndexRelationshipFollowers", ">=", uid)
        .where("searchIndexRelationshipFollowers", "<=", uid + "\uf8ff")
        .limit(pagination.limit ?? 10)
        .startAfter(pagination.cursor)
        .get();

      data = relationshipsSnapshot.docs.map((doc) => doc.data());
    }

    const hasData = data.length !== 0;
    const responsePagination = {
      limit: pagination.limit,
      cursor: '',
    } as Pagination;

    if (!hasData) {
      return { data: [], pagination: responsePagination };
    }

    CacheService.setInCache(cacheKey, data);

    const last = data[data.length - 1];
    const lastId = FlamelinkHelpers.getFlamelinkIdFromObject(last) ?? '';
    responsePagination.cursor = lastId;

    return {
      data: data,
      pagination: responsePagination,
    };
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
  export async function unblockRelationship(sender: string, relationship: any): Promise<any> {
    functions.logger.info("Unblocking relationship", {
      sender,
      relationship,
    });

    const flamelinkId = FlamelinkHelpers.getFlamelinkIdFromObject(relationship);
    if (!flamelinkId) {
      throw new Error("Relationship does not have a flamelink id");
    }

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
    relationship = RelationshipHelpers.updateRelationshipWithIndexes(relationship);
    resetRelationshipPaginationCache(relationship);

    await DataService.updateDocument({
      schemaKey: "relationships",
      entryId: flamelinkId,
      data: relationship,
    });

    return relationship;
  }

  /**
   * Blocks a relationship from the given sender.
   * @param {string} sender the sender of the message.
   * @param {RelationshipJSON} relationship the relationship to block.
   * @return {any} the updated relationship.
   */
  export async function blockRelationship(sender: string, relationship: RelationshipJSON): Promise<any> {
    functions.logger.info("Blocking relationship", {
      sender,
      relationship,
    });

    const flamelinkId = FlamelinkHelpers.getFlamelinkIdFromObject(relationship);
    if (!flamelinkId) {
      throw new Error("Relationship does not have a flamelink id");
    }

    let isRelationshipConnectedAfterBlock = false;
    if (relationship.members && relationship.members.length > 0) {
      for (const member of relationship.members) {
        if (typeof member.memberId === "string" && member.memberId === sender) {
          member.hasBlocked = true;
          member.hasConnected = false;
        }

        if (member.hasConnected) {
          isRelationshipConnectedAfterBlock = true;
        }
      }
    }

    relationship.blocked = true;
    relationship.connected = isRelationshipConnectedAfterBlock;
    relationship = RelationshipHelpers.updateRelationshipWithIndexes(relationship);
    resetRelationshipPaginationCache(relationship);

    return await DataService.updateDocument({
      schemaKey: "relationships",
      entryId: flamelinkId,
      data: relationship,
    });
  }

  /**
   * Unmutes a relationship from the given sender.
   * @param {string} sender the sender of the message.
   * @param {any} relationship the relationship to unmute.
   * @return {any} the updated relationship.
   */
  export async function muteRelationship(sender: string, relationship: any): Promise<any> {
    functions.logger.info("Muting relationship", {
      sender,
      relationship,
    });

    const flamelinkId = FlamelinkHelpers.getFlamelinkIdFromObject(relationship);
    if (!flamelinkId) {
      throw new Error("Relationship does not have a flamelink id");
    }

    if (relationship.members && relationship.members.length > 0) {
      for (const member of relationship.members) {
        if (typeof member.memberId === "string" && member.memberId === sender) {
          member.hasMuted = true;
        }
      }
    }

    // Sets a flag on the relationship to indicate that it is muted.
    relationship.muted = true;
    relationship = RelationshipHelpers.updateRelationshipWithIndexes(relationship);
    resetRelationshipPaginationCache(relationship);

    return await DataService.updateDocument({
      schemaKey: "relationships",
      entryId: flamelinkId,
      data: relationship,
    });
  }

  /**
   * Unmutes a relationship from the given sender.
   * @param {string} sender the sender of the message.
   * @param {any} relationship the relationship.
   * @return {any} the updated relationship.
   */
  export async function unmuteRelationship(sender: string, relationship: any): Promise<any> {
    functions.logger.info("Unmuting relationship", {
      sender,
      relationship,
    });

    const flamelinkId = FlamelinkHelpers.getFlamelinkIdFromObject(relationship);
    if (!flamelinkId) {
      throw new Error("Relationship does not have a flamelink id");
    }

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
    relationship = RelationshipHelpers.updateRelationshipWithIndexes(relationship);
    resetRelationshipPaginationCache(relationship);

    return await DataService.updateDocument({
      schemaKey: "relationships",
      entryId: flamelinkId,
      data: relationship,
    });
  }

  /**
   * Connects a relationship from the given sender.
   * @param {string} sender the sender of the message.
   * @param {any} relationship the relationship to connect.
   * @return {Promise<any>} the updated relationship.
   */
  export async function connectRelationship(sender: string, relationship: any): Promise<any> {
    functions.logger.info("Connecting relationship", {
      sender,
      relationship,
    });

    const flamelinkId = FlamelinkHelpers.getFlamelinkIdFromObject(relationship);
    if (!flamelinkId) {
      throw new Error("Relationship does not have a flamelink id");
    }

    const memberIds = [];
    for (const member of relationship.members) {
      if (typeof member.memberId !== "string") {
        continue;
      }

      memberIds.push(member.memberId);
      if (member.memberId === sender) {
        member.hasConnected = true;
      }
    }

    relationship.connected = true;
    relationship = RelationshipHelpers.updateRelationshipWithIndexes(relationship);
    resetRelationshipPaginationCache(relationship);

    if (!relationship.channelId) {
      functions.logger.info("Creating conversation for newly connected relationship");
      const chatClient = ConversationService.getStreamChatInstance();
      const conversationId = await ConversationService.createConversation(chatClient, sender, memberIds);
      relationship.channelId = conversationId;
    } else {
      functions.logger.info("Conversation already exists for newly connected relationship");
    }

    return DataService.updateDocument({
      schemaKey: "relationships",
      entryId: flamelinkId,
      data: relationship,
    });
  }

  /**
   * Disconnects a relationship from the given sender.
   * @param {string} sender the sender of the message.
   * @param {any} relationship the relationship to disconnect.
   * @return {Promise<any>} the updated relationship.
   */
  export async function disconnectRelationship(sender: string, relationship: any): Promise<any> {
    functions.logger.info("Disconnecting relationship", {
      sender,
      relationship,
    });

    const flamelinkId = FlamelinkHelpers.getFlamelinkIdFromObject(relationship);
    if (!flamelinkId) {
      throw new Error("Relationship does not have a flamelink id");
    }

    if (relationship.members && relationship.members.length > 0) {
      for (const member of relationship.members) {
        if (!member) {
          continue;
        }

        member.hasConnected = false;
      }
    }

    // Remove the connected flag if all members have disconnected.
    relationship.connected = false;
    relationship = RelationshipHelpers.updateRelationshipWithIndexes(relationship);
    resetRelationshipPaginationCache(relationship);

    return DataService.updateDocument({
      schemaKey: "relationships",
      entryId: flamelinkId,
      data: relationship,
    });
  }

  /**
   * Gets the members for the given relationship.
   * @param {any} relationship the relationship.
   * @return {string[]} the members.
   */
  export function getMembersForRelationship(relationship: any): string[] {
    const members: string[] = [];

    if (relationship.members && relationship.members.length > 0) {
      for (const member of relationship.members) {
        if (typeof member.memberId === "string") {
          members.push(member.memberId);
        }
      }
    }

    return members;
  }

  /**
   * Follows a relationship from the given sender.
   * @param {string} sender the sender of the message.
   * @param {any} relationship the relationship to follow.
   * @return {Promise<any>} the updated relationship.
   */
  export async function followRelationship(sender: string, relationship: any): Promise<any> {
    functions.logger.info("Following relationship", {
      sender,
      relationship,
    });

    const flamelinkId = FlamelinkHelpers.getFlamelinkIdFromObject(relationship);
    if (!flamelinkId) {
      throw new Error("Relationship does not have a flamelink id");
    }

    if (relationship.members && relationship.members.length > 0) {
      for (const member of relationship.members) {
        if (typeof member.memberId === "string" && member.memberId === sender) {
          member.hasFollowed = true;
        }
      }
    }

    // Sets a flag on the relationship to indicate that it is followed.
    relationship.following = true;
    relationship = RelationshipHelpers.updateRelationshipWithIndexes(relationship);
    resetRelationshipPaginationCache(relationship);

    return await DataService.updateDocument({
      schemaKey: "relationships",
      entryId: flamelinkId,
      data: relationship,
    });
  }

  /**
   * Unfollows a relationship from the given sender.
   * @param {string} sender the sender of the message.
   * @param {any} relationship the relationship to unfollow.
   * @return {Promise<any>} the updated relationship.
   */
  export async function unfollowRelationship(sender: string, relationship: any): Promise<any> {
    functions.logger.info("Unfollowing relationship", {
      sender,
      relationship,
    });

    const flamelinkId = FlamelinkHelpers.getFlamelinkIdFromObject(relationship);
    if (!flamelinkId) {
      throw new Error("Relationship does not have a flamelink id");
    }

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
    relationship = RelationshipHelpers.updateRelationshipWithIndexes(relationship);
    resetRelationshipPaginationCache(relationship);

    return await DataService.updateDocument({
      schemaKey: "relationships",
      entryId: flamelinkId,
      data: relationship,
    });
  }

  /**
   * Hides a relationship from the given sender.
   * @param {string} sender the sender of the message.
   * @param {any} relationship the relationship to hide.
   * @return {Promise<any>} the updated relationship.
   */
  export async function hideRelationship(sender: string, relationship: any): Promise<any> {
    functions.logger.info("Hiding relationship", {
      sender,
      relationship,
    });

    const flamelinkId = FlamelinkHelpers.getFlamelinkIdFromObject(relationship);
    if (!flamelinkId) {
      throw new Error("Relationship does not have a flamelink id");
    }

    if (relationship.members && relationship.members.length > 0) {
      for (const member of relationship.members) {
        if (typeof member.memberId === "string" && member.memberId === sender) {
          member.hasHidden = true;
        }
      }
    }

    // Sets a flag on the relationship to indicate that it is hidden.
    relationship.hidden = true;
    relationship = RelationshipHelpers.updateRelationshipWithIndexes(relationship);
    resetRelationshipPaginationCache(relationship);

    return await DataService.updateDocument({
      schemaKey: "relationships",
      entryId: flamelinkId,
      data: relationship,
    });
  }

  /**
   * Unhides a relationship from the given sender.
   * @param {string} sender the sender of the message.
   * @param {any} relationship the relationship to unhide.
   * @return {Promise<any>} the updated relationship.
   */
  export async function unhideRelationship(sender: string, relationship: any): Promise<any> {
    functions.logger.info("Unhiding relationship", {
      sender,
      relationship,
    });

    const flamelinkId = FlamelinkHelpers.getFlamelinkIdFromObject(relationship);
    if (!flamelinkId) {
      throw new Error("Relationship does not have a flamelink id");
    }

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
    relationship = RelationshipHelpers.updateRelationshipWithIndexes(relationship);
    resetRelationshipPaginationCache(relationship);

    return await DataService.updateDocument({
      schemaKey: "relationships",
      entryId: flamelinkId,
      data: relationship,
    });
  }

  /**
   * Grabs all relationships for the given user, removing any which cannot be seen by the user.
   * @param {string} uid the user id.
   * @param {string[]} foreignKeys the foreign keys to sanitize.
   * @return {Promise<string[]>} the sanitized relationships.
   */
  export async function sanitizeRelationships(uid: string, foreignKeys: string[]): Promise<string[]> {
    const sanitizedRelationships: string[] = [];
    functions.logger.info("Sanitizing relationships", {
      uid,
      foreignKeys,
    });

    for (const foreignKey of foreignKeys) {
      if (typeof foreignKey !== "string") {
        throw new Error("Invalid foreign key");
      }

      const relationship = await getRelationship([uid, foreignKey]);
      if (!relationship) {
        continue;
      }

      const canAction = RelationshipHelpers.canActionRelationship(uid, relationship);
      if (canAction) {
        sanitizedRelationships.push(foreignKey);
      }
    }

    functions.logger.info("Sanitized relationships", {
      uid,
      foreignKeys,
      sanitizedRelationships,
    });

    return sanitizedRelationships;
  }
}
