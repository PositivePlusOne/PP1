import * as functions from "firebase-functions";

import { ProfileService } from "../services/profile_service";
import { UserService } from "../services/user_service";
import { RelationshipService } from "../services/relationship_service";
import { RelationshipHelpers } from "../helpers/relationship_helpers";

import { ChatConnectionAcceptedNotification } from "../services/builders/notifications/chat/chat_connection_accepted_notification";
import { ChatConnectionReceivedNotification } from "../services/builders/notifications/chat/chat_connection_received_notification";
import { ChatConnectionRejectedNotification } from "../services/builders/notifications/chat/chat_connection_rejected_notification";
import { ChatConnectionSentNotification } from "../services/builders/notifications/chat/chat_connection_sent_notification";

import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";
import { RelationshipUpdatedNotification } from "../services/builders/notifications/relationships/relationship_updated_notification";
import { FeedService } from "../services/feed_service";
import { FeedRequestJSON } from "../dto/feed_dtos";
import { EndpointRequest, buildEndpointResponse } from "./dto/payloads";
import { RelationshipJSON } from "../dto/relationships";
import { ProfileStatisticsService } from "../services/profile_statistics_service";

export namespace RelationshipEndpoints {
  export const getRelationship = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);
    const members = request.data.members || [];

    // Push UID into members array if it's not already there.
    if (!members.includes(uid)) {
      members.push(uid);
    }

    functions.logger.info("Getting relationship", { members });
    const relationship = await RelationshipService.getRelationship(members);
    if (!relationship) {
      throw new functions.https.HttpsError("not-found", "Relationship not found");
    }

    functions.logger.info("Relationship retrieved", {
      members,
      relationship,
    });

    return JSON.stringify({
      relationships: [relationship],
    });
  });

  export const blockRelationship = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);
    const targetUid = request.data.target || "";
    functions.logger.info("Blocking user", { uid, targetUid });

    if (uid === targetUid) {
      throw new functions.https.HttpsError("invalid-argument", "You cannot block yourself");
    }

    const hasCreatedProfile = await ProfileService.getProfile(uid);
    if (!hasCreatedProfile) {
      throw new functions.https.HttpsError("not-found", "User profile not found");
    }

    const targetProfile = await ProfileService.getProfile(targetUid);
    if (!targetProfile) {
      throw new functions.https.HttpsError("not-found", "Target user profile not found");
    }

    const relationship = await RelationshipService.getOrCreateRelationship([uid, targetUid]);

    // Check if we are already blocking this user
    const isAlreadyBlocking = RelationshipHelpers.hasBlockedRelationship(uid, relationship);
    if (isAlreadyBlocking) {
      return buildEndpointResponse(context, {
        sender: uid,
        data: [relationship],
      });
    }

    const newRelationship = await RelationshipService.blockRelationship(uid, relationship);
    functions.logger.info("User blocked", { uid, targetUid });

    await RelationshipUpdatedNotification.sendNotification(newRelationship);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newRelationship],
    });
  });

  export const unblockRelationship = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);
    const targetUid = request.data.target || "";
    functions.logger.info("Unblocking user", { uid, targetUid });

    if (uid === targetUid) {
      throw new functions.https.HttpsError("invalid-argument", "You cannot unblock yourself");
    }

    const hasCreatedProfile = await ProfileService.getProfile(uid);
    if (!hasCreatedProfile) {
      throw new functions.https.HttpsError("not-found", "User profile not found");
    }

    const targetProfile = await ProfileService.getProfile(targetUid);
    if (!targetProfile) {
      throw new functions.https.HttpsError("not-found", "Target profile not found");
    }

    const relationship = await RelationshipService.getOrCreateRelationship([uid, targetUid]);
    const isUnblocked = RelationshipHelpers.hasNotBlockedRelationship(uid, relationship);
    if (isUnblocked) {
      functions.logger.info("User already unblocked", { uid, targetUid });
      
      return buildEndpointResponse(context, {
        sender: uid,
        data: [relationship],
      });
    }

    const newRelationship = await RelationshipService.unblockRelationship(uid, relationship);
    functions.logger.info("User unblocked", { uid, targetUid });

    await RelationshipUpdatedNotification.sendNotification(newRelationship);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newRelationship],
    });
  });

  export const muteRelationship = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);
    const targetUid = request.data.target || "";
    functions.logger.info("Muting user", { uid, targetUid });

    if (uid === targetUid) {
      throw new functions.https.HttpsError("invalid-argument", "You cannot mute yourself");
    }

    const hasCreatedProfile = await ProfileService.getProfile(uid);
    if (!hasCreatedProfile) {
      throw new functions.https.HttpsError("not-found", "User profile not found");
    }

    const relationship = await RelationshipService.getOrCreateRelationship([uid, targetUid]);
    const newRelationship = await RelationshipService.muteRelationship(uid, relationship);

    // Send a ACTION_MUTED data payload as a notification to the target users profiles
    const targetProfile = await ProfileService.getProfile(targetUid);
    if (!targetProfile) {
      throw new functions.https.HttpsError("not-found", "Target profile not found");
    }

    functions.logger.info("User muted", { uid, targetUid });
    await RelationshipUpdatedNotification.sendNotification(newRelationship);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newRelationship],
    });
  });

  export const unmuteRelationship = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);
    const targetUid = request.data.target || "";
    functions.logger.info("Unmuting user", { uid, targetUid });

    if (uid === targetUid) {
      throw new functions.https.HttpsError("invalid-argument", "You cannot unmute yourself");
    }

    const hasCreatedProfile = await ProfileService.getProfile(uid);
    if (!hasCreatedProfile) {
      throw new functions.https.HttpsError("not-found", "User profile not found");
    }

    const relationship = await RelationshipService.getOrCreateRelationship([uid, targetUid]);
    const newRelationship = await RelationshipService.unmuteRelationship(uid, relationship);
    await RelationshipUpdatedNotification.sendNotification(newRelationship);

    functions.logger.info("User unmuted", { uid, targetUid });

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newRelationship],
    });
  });

  export const connectRelationship = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);
    const targetUid = request.data.target || "";
    functions.logger.info("Connecting user", { uid, targetUid });

    if (uid === targetUid) {
      throw new functions.https.HttpsError("invalid-argument", "You cannot connect to yourself");
    }

    const userProfile = await ProfileService.getProfile(uid);
    const targetProfile = await ProfileService.getProfile(targetUid);
    if (!userProfile || !targetProfile) {
      throw new functions.https.HttpsError("not-found", "User profiles not found");
    }

    const oldRelationship = await RelationshipService.getOrCreateRelationship([uid, targetUid]);
    const isUserAlreadyConnected = RelationshipHelpers.isUserConnected(uid, oldRelationship);
    const isTargetAlreadyRequested = RelationshipHelpers.isUserConnected(targetUid, oldRelationship);
    const isNewRelationship = !isUserAlreadyConnected && !isTargetAlreadyRequested;

    if (isUserAlreadyConnected) {
      functions.logger.info("User already connected", { uid, targetUid });
      return buildEndpointResponse(context, {
        sender: uid,
        data: [oldRelationship],
      });
    }

    const canActionRelationship = RelationshipHelpers.canActionRelationship(uid, oldRelationship);
    if (!canActionRelationship) {
      throw new functions.https.HttpsError("permission-denied", "You cannot connect with this user");
    }

    const newRelationship = await RelationshipService.connectRelationship(uid, oldRelationship);
    functions.logger.info("User connected, sending notifications", { uid, targetUid, isUserAlreadyConnected, isTargetAlreadyRequested });
    
    if (isTargetAlreadyRequested && !isUserAlreadyConnected) {
      await ChatConnectionAcceptedNotification.sendNotification(userProfile, targetProfile);
    } else if (isNewRelationship) {
      await ChatConnectionSentNotification.sendNotification(targetProfile, userProfile);
      await ChatConnectionReceivedNotification.sendNotification(userProfile, targetProfile);
    }

    await RelationshipUpdatedNotification.sendNotification(newRelationship);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newRelationship],
    });
  });

  export const disconnectRelationship = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);
    const targetUid = request.data.target || "";
    functions.logger.info("Disconnecting user", { uid, targetUid });

    if (uid === targetUid) {
      throw new functions.https.HttpsError("invalid-argument", "You cannot disconnect yourself");
    }

    const userProfile = await ProfileService.getProfile(uid);
    const targetProfile = await ProfileService.getProfile(targetUid);
    if (!userProfile || !targetProfile) {
      throw new functions.https.HttpsError("not-found", "User profile not found");
    }

    const oldRelationship = await RelationshipService.getOrCreateRelationship([uid, targetUid]) as RelationshipJSON;
    if (!oldRelationship.connected) {
      functions.logger.info("User already disconnected", { uid, targetUid });
      return buildEndpointResponse(context, {
        sender: uid,
        data: [oldRelationship],
      });
    }
    
    const canReject = RelationshipHelpers.canRejectConnectionRequest(uid, oldRelationship);
    const newRelationship = await RelationshipService.disconnectRelationship(uid, oldRelationship);

    if (canReject) {
      await ChatConnectionRejectedNotification.sendNotification(userProfile, targetProfile);
    }

    await RelationshipUpdatedNotification.sendNotification(newRelationship);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newRelationship],
    });
  });

  export const followRelationship = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);
    const targetUid = request.data.target || "";
    functions.logger.info("Following relationship", { uid, targetUid });

    if (uid === targetUid) {
      throw new functions.https.HttpsError("invalid-argument", "You cannot follow yourself");
    }

    const userProfile = await ProfileService.getProfile(uid);
    const targetProfile = await ProfileService.getProfile(targetUid);
    if (!userProfile || !targetProfile) {
      throw new functions.https.HttpsError("not-found", "User profile not found");
    }

    const relationship = await RelationshipService.getOrCreateRelationship([uid, targetUid]);
    const canActionRelationship = RelationshipHelpers.canActionRelationship(uid, relationship);

    if (!canActionRelationship) {
      throw new functions.https.HttpsError("permission-denied", "You cannot follow this user");
    }

    const isFollowing = RelationshipHelpers.isUserFollowing(uid, relationship);
    if (isFollowing) {
      functions.logger.info("User already following", { uid, targetUid });
      return buildEndpointResponse(context, {
        sender: uid,
        data: [relationship],
      });
    }

    // Create two feed requests and follow the target user
    const sourceFeed = { targetSlug: "timeline", targetUserId: uid } as FeedRequestJSON;
    const targetFeed = { targetSlug: "user", targetUserId: targetUid } as FeedRequestJSON;
    const feedClient = FeedService.getFeedsClient();

    await FeedService.followFeed(feedClient, sourceFeed, targetFeed);

    const newRelationship = await RelationshipService.followRelationship(uid, relationship);

    const newSourceStats = await ProfileStatisticsService.updateReactionCountForProfile(uid, "follow", 1);
    const newTargetStats = await ProfileStatisticsService.updateReactionCountForProfile(targetUid, "follower", 1);
    await RelationshipUpdatedNotification.sendNotification(newRelationship);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newRelationship, newSourceStats, newTargetStats],
    });
  });

  export const unfollowRelationship = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);
    const targetUid = request.data.target || "";
    functions.logger.info("Unfollowing relationship", { uid, targetUid });

    if (uid === targetUid) {
      throw new functions.https.HttpsError("invalid-argument", "You cannot unfollow yourself");
    }

    const userProfile = await ProfileService.getProfile(uid);
    const targetProfile = await ProfileService.getProfile(targetUid);
    if (!userProfile || !targetProfile) {
      throw new functions.https.HttpsError("not-found", "User profile not found");
    }

    const relationship = await RelationshipService.getOrCreateRelationship([uid, targetUid]);

    const isFollowing = RelationshipHelpers.isUserFollowing(uid, relationship);
    if (!isFollowing) {
      functions.logger.info("User already unfollowed", { uid, targetUid });
      return buildEndpointResponse(context, {
        sender: uid,
        data: [relationship],
      });
    }

    const sourceFeed = { targetSlug: "timeline", targetUserId: uid } as FeedRequestJSON;
    const targetFeed = { targetSlug: "user", targetUserId: targetUid } as FeedRequestJSON;
    const feedClient = FeedService.getFeedsClient();

    await FeedService.unfollowFeed(feedClient, sourceFeed, targetFeed);

    const newRelationship = await RelationshipService.unfollowRelationship(uid, relationship);

    const newSourceStats = await ProfileStatisticsService.updateReactionCountForProfile(uid, "follow", -1);
    const newTargetStats = await ProfileStatisticsService.updateReactionCountForProfile(targetUid, "follower", -1);
    await RelationshipUpdatedNotification.sendNotification(newRelationship);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newRelationship, newSourceStats, newTargetStats],
    });
  });

  export const hideRelationship = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);
    const targetUid = request.data.target || "";
    functions.logger.info("Hiding relationship", { uid, targetUid });

    if (uid === targetUid) {
      throw new functions.https.HttpsError("invalid-argument", "You cannot hide yourself");
    }

    const userProfile = await ProfileService.getProfile(uid);
    const targetProfile = await ProfileService.getProfile(targetUid);
    if (!userProfile || !targetProfile) {
      throw new functions.https.HttpsError("not-found", "User profile not found");
    }

    const relationship = await RelationshipService.getOrCreateRelationship([uid, targetUid]);
    const newRelationship = await RelationshipService.hideRelationship(uid, relationship);

    await RelationshipUpdatedNotification.sendNotification(newRelationship);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newRelationship],
    });
  });

  export const unhideRelationship = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);
    const targetUid = request.data.target || "";
    functions.logger.info("Unhiding relationship", { uid, targetUid });

    if (uid === targetUid) {
      throw new functions.https.HttpsError("invalid-argument", "You cannot unhide yourself");
    }

    const userProfile = await ProfileService.getProfile(uid);
    const targetProfile = await ProfileService.getProfile(targetUid);
    if (!userProfile || !targetProfile) {
      throw new functions.https.HttpsError("not-found", "User profile not found");
    }

    const relationship = await RelationshipService.getOrCreateRelationship([uid, targetUid]);
    const newRelationship = await RelationshipService.unhideRelationship(uid, relationship);

    await RelationshipUpdatedNotification.sendNotification(newRelationship);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newRelationship],
    });
  });

  export const listConnectedRelationships = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);

    const cursor = request.cursor || "";
    const limit = request.limit || 30;

    const paginationResult = await RelationshipService.getConnectedRelationships(uid, { cursor, limit });
    const profileIds = [] as string[];

    for (const relationship of paginationResult.data) {
      for (const member of relationship.members || []) {
        if (member.memberId && member.memberId !== uid) {
          profileIds.push(member.memberId);
        }
      }
    }

    const profiles = await ProfileService.getMultipleProfiles(profileIds);
    return buildEndpointResponse(context, {
      sender: uid,
      data: profiles,
      cursor: paginationResult.pagination.cursor,
      limit: paginationResult.pagination.limit,
      seedData: {
        relationships: paginationResult.data,
      },
    });
  });

  export const listFollowRelationships = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);

    const cursor = request.cursor || "";
    const limit = request.limit || 30;

    const paginationResult = await RelationshipService.getFollowedRelationships(uid, { cursor, limit });
    const profileIds = [] as string[];

    for (const relationship of paginationResult.data) {
      for (const member of relationship.members || []) {
        if (member.memberId && member.memberId !== uid) {
          profileIds.push(member.memberId);
        }
      }
    }

    const profiles = await ProfileService.getMultipleProfiles(profileIds);
    return buildEndpointResponse(context, {
      sender: uid,
      data: profiles,
      cursor: paginationResult.pagination.cursor,
      limit: paginationResult.pagination.limit,
      seedData: {
        relationships: paginationResult.data,
      },
    });
  });

  export const listFollowingRelationships = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);

    const cursor = request.cursor || "";
    const limit = request.limit || 30;

    const paginationResult = await RelationshipService.getFollowRelationships(uid, { cursor, limit });
    const profileIds = [] as string[];

    for (const relationship of paginationResult.data) {
      for (const member of relationship.members || []) {
        if (member.memberId && member.memberId !== uid) {
          profileIds.push(member.memberId);
        }
      }
    }

    const profiles = await ProfileService.getMultipleProfiles(profileIds);
    return buildEndpointResponse(context, {
      sender: uid,
      data: profiles,
      cursor: paginationResult.pagination.cursor,
      limit: paginationResult.pagination.limit,
      seedData: {
        relationships: paginationResult.data,
      },
    });
  });

  export const listBlockedRelationships = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);

    const cursor = request.cursor || "";
    const limit = request.limit || 30;

    const paginationResult = await RelationshipService.getBlockedRelationships(uid, { cursor, limit });
    const profileIds = [] as string[];

    for (const relationship of paginationResult.data) {
      for (const member of relationship.members || []) {
        if (member.memberId && member.memberId !== uid) {
          profileIds.push(member.memberId);
        }
      }
    }

    const profiles = await ProfileService.getMultipleProfiles(profileIds);
    return buildEndpointResponse(context, {
      sender: uid,
      data: profiles,
      cursor: paginationResult.pagination.cursor,
      limit: paginationResult.pagination.limit,
      seedData: {
        relationships: paginationResult.data,
      },
    });
  });

  export const listManagedRelationships = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);

    const cursor = request.cursor || "";
    const limit = request.limit || 30;

    const paginationResult = await RelationshipService.getManagedRelationships(uid, { cursor, limit });
    const profileIds = [] as string[];

    functions.logger.info("Managed relationships", { paginationResult });

    for (const relationship of paginationResult.data) {
      for (const member of relationship.members || []) {
        if (member.memberId && member.memberId !== uid) {
          profileIds.push(member.memberId);
        }
      }
    }

    const profiles = await ProfileService.getMultipleProfiles(profileIds);
    return buildEndpointResponse(context, {
      sender: uid,
      data: profiles,
      cursor: paginationResult.pagination.cursor,
      limit: paginationResult.pagination.limit,
      seedData: {
        relationships: paginationResult.data,
      },
    });
  });
}
