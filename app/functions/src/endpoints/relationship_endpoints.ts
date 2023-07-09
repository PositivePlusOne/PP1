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
import { FeedRequest } from "../dto/feed_dtos";

export namespace RelationshipEndpoints {
  // Note: Intention is for this to sit behind a cache layer (e.g. Redis) to prevent abuse.
  export const getRelationship = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data, context) => {
    await UserService.verifyAuthenticated(context);

    const uid = context.auth?.uid || "";
    const members = data.members || [];

    // Push UID into members array if it's not already there.
    if (!members.includes(uid)) {
      members.push(uid);
    }

    functions.logger.info("Getting relationship", { members });
    const relationship = await RelationshipService.getRelationship(members);

    functions.logger.info("Relationship retrieved", {
      members,
      relationship,
    });

    return JSON.stringify({
      relationships: [relationship],
    });
  });

  export const blockRelationship = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data, context) => {
    await UserService.verifyAuthenticated(context);

    const uid = context.auth?.uid || "";
    const targetUid = data.target || "";
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

    const relationship = await RelationshipService.getRelationship([uid, targetUid]);
    const newRelationship = await RelationshipService.blockRelationship(uid, relationship);

    functions.logger.info("User blocked", { uid, targetUid });
    await RelationshipUpdatedNotification.sendNotification(newRelationship);

    return JSON.stringify({
      relationships: [newRelationship],
    });
  });

  export const unblockRelationship = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data, context) => {
    await UserService.verifyAuthenticated(context);

    const uid = context.auth?.uid || "";
    const targetUid = data.target || "";
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

    const relationship = await RelationshipService.getRelationship([uid, targetUid]);

    const newRelationship = await RelationshipService.unblockRelationship(uid, relationship);

    functions.logger.info("User unblocked", { uid, targetUid });
    await RelationshipUpdatedNotification.sendNotification(newRelationship);

    return JSON.stringify({
      relationships: [newRelationship],
    });
  });

  export const muteRelationship = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data, context) => {
    await UserService.verifyAuthenticated(context);

    const uid = context.auth?.uid || "";
    const targetUid = data.target || "";
    functions.logger.info("Muting user", { uid, targetUid });

    if (uid === targetUid) {
      throw new functions.https.HttpsError("invalid-argument", "You cannot mute yourself");
    }

    const hasCreatedProfile = await ProfileService.getProfile(uid);
    if (!hasCreatedProfile) {
      throw new functions.https.HttpsError("not-found", "User profile not found");
    }

    const relationship = await RelationshipService.getRelationship([uid, targetUid]);

    const newRelationship = await RelationshipService.muteRelationship(uid, relationship);

    // Send a ACTION_MUTED data payload as a notification to the target users profiles
    const targetProfile = await ProfileService.getProfile(targetUid);
    if (!targetProfile) {
      throw new functions.https.HttpsError("not-found", "Target profile not found");
    }

    functions.logger.info("User muted", { uid, targetUid });
    await RelationshipUpdatedNotification.sendNotification(newRelationship);

    return JSON.stringify({
      relationships: [newRelationship],
    });
  });

  export const unmuteRelationship = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data, context) => {
    await UserService.verifyAuthenticated(context);

    const uid = context.auth?.uid || "";
    const targetUid = data.target || "";
    functions.logger.info("Unmuting user", { uid, targetUid });

    if (uid === targetUid) {
      throw new functions.https.HttpsError("invalid-argument", "You cannot unmute yourself");
    }

    const hasCreatedProfile = await ProfileService.getProfile(uid);
    if (!hasCreatedProfile) {
      throw new functions.https.HttpsError("not-found", "User profile not found");
    }

    const relationship = await RelationshipService.getRelationship([uid, targetUid]);

    const newRelationship = await RelationshipService.unmuteRelationship(uid, relationship);
    await RelationshipUpdatedNotification.sendNotification(newRelationship);

    functions.logger.info("User unmuted", { uid, targetUid });

    return JSON.stringify({
      relationships: [newRelationship],
    });
  });

  export const connectRelationship = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data, context) => {
    await UserService.verifyAuthenticated(context);

    const uid = context.auth?.uid || "";
    const targetUid = data.target || "";
    functions.logger.info("Connecting user", { uid, targetUid });

    if (uid === targetUid) {
      throw new functions.https.HttpsError("invalid-argument", "You cannot connect to yourself");
    }

    const userProfile = await ProfileService.getProfile(uid);
    if (!userProfile) {
      throw new functions.https.HttpsError("not-found", "User profile not found");
    }

    const relationship = await RelationshipService.getRelationship([uid, targetUid]);
    const canActionRelationship = RelationshipHelpers.canActionRelationship(uid, relationship);

    if (!canActionRelationship) {
      throw new functions.https.HttpsError("permission-denied", "You cannot connect with this user");
    }

    const connectionAcceptanceNotificationTargets = RelationshipHelpers.getConnectionAcceptedNotificationTargets(uid, relationship);
    const connectionRequestNotificationTargets = RelationshipHelpers.getRequestConnectionNotificationTargets(uid, relationship);
    const newRelationship = await RelationshipService.connectRelationship(uid, relationship);

    functions.logger.info("User connected, sending notifications", {
      uid,
      targetUid,
      newRelationship,
    });

    for (const memberId of connectionRequestNotificationTargets) {
      const memberProfile = await ProfileService.getProfile(memberId);
      if (!memberProfile) {
        continue;
      }

      await ChatConnectionSentNotification.sendNotification(memberProfile, userProfile);
      await ChatConnectionReceivedNotification.sendNotification(userProfile, memberProfile);
    }

    for (const memberId of connectionAcceptanceNotificationTargets) {
      const memberProfile = await ProfileService.getProfile(memberId);
      if (!memberProfile) {
        continue;
      }

      await ChatConnectionAcceptedNotification.sendNotification(userProfile, memberProfile);
    }

    await RelationshipUpdatedNotification.sendNotification(newRelationship);

    return JSON.stringify({
      relationships: [newRelationship],
    });
  });

  export const disconnectRelationship = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data, context) => {
    await UserService.verifyAuthenticated(context);

    const uid = context.auth?.uid || "";
    const targetUid = data.target || "";
    functions.logger.info("Disconnecting user", { uid, targetUid });

    if (uid === targetUid) {
      throw new functions.https.HttpsError("invalid-argument", "You cannot disconnect yourself");
    }

    const userProfile = await ProfileService.getProfile(uid);
    const targetProfile = await ProfileService.getProfile(targetUid);
    if (!userProfile || !targetProfile) {
      throw new functions.https.HttpsError("not-found", "User profile not found");
    }

    const relationship = await RelationshipService.getRelationship([uid, targetUid]);
    
    const canReject = RelationshipHelpers.canRejectConnectionRequest(uid, relationship);
    const canCancel = RelationshipHelpers.canCancelConnectionRequest(uid, relationship);

    let newRelationship = { ...relationship };
    if (canReject) {
      newRelationship = await RelationshipService.rejectRelationship(uid, relationship);
      await ChatConnectionRejectedNotification.sendNotification(userProfile, targetProfile);
    } else if (canCancel) {
      newRelationship = await RelationshipService.rejectRelationship(uid, relationship);
    } else {
      newRelationship = await RelationshipService.disconnectRelationship(uid, relationship);
    }

    await RelationshipUpdatedNotification.sendNotification(newRelationship);

    return JSON.stringify({
      relationships: [newRelationship],
    });
  });

  export const followRelationship = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data, context) => {
    await UserService.verifyAuthenticated(context);

    const uid = context.auth?.uid || "";
    const targetUid = data.target || "";
    functions.logger.info("Following relationship", { uid, targetUid });

    if (uid === targetUid) {
      throw new functions.https.HttpsError("invalid-argument", "You cannot follow yourself");
    }

    const userProfile = await ProfileService.getProfile(uid);
    const targetProfile = await ProfileService.getProfile(targetUid);
    if (!userProfile || !targetProfile) {
      throw new functions.https.HttpsError("not-found", "User profile not found");
    }

    const relationship = await RelationshipService.getRelationship([uid, targetUid]);

    const canActionRelationship = RelationshipHelpers.canActionRelationship(uid, relationship);

    if (!canActionRelationship) {
      throw new functions.https.HttpsError("permission-denied", "You cannot follow this user");
    }

    // Create two feed requests and follow the target user
    const sourceFeed = { feed: "timeline", id: uid } as FeedRequest;
    const targetFeed = { feed: "user", id: targetUid } as FeedRequest;
    const feedClient = await FeedService.getFeedsClient();

    await FeedService.followFeed(feedClient, sourceFeed, targetFeed);

    const newRelationship = await RelationshipService.followRelationship(uid, relationship);

    await RelationshipUpdatedNotification.sendNotification(newRelationship);

    return JSON.stringify({
      relationships: [newRelationship],
    });
  });

  export const unfollowRelationship = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data, context) => {
    await UserService.verifyAuthenticated(context);

    const uid = context.auth?.uid || "";
    const targetUid = data.target || "";
    functions.logger.info("Unfollowing relationship", { uid, targetUid });

    if (uid === targetUid) {
      throw new functions.https.HttpsError("invalid-argument", "You cannot unfollow yourself");
    }

    const userProfile = await ProfileService.getProfile(uid);
    const targetProfile = await ProfileService.getProfile(targetUid);
    if (!userProfile || !targetProfile) {
      throw new functions.https.HttpsError("not-found", "User profile not found");
    }

    const relationship = await RelationshipService.getRelationship([uid, targetUid]);

    const sourceFeed = { feed: "timeline", id: uid } as FeedRequest;
    const targetFeed = { feed: "user", id: targetUid } as FeedRequest;
    const feedClient = await FeedService.getFeedsClient();

    await FeedService.unfollowFeed(feedClient, sourceFeed, targetFeed);

    const newRelationship = await RelationshipService.unfollowRelationship(uid, relationship);

    await RelationshipUpdatedNotification.sendNotification(newRelationship);

    return JSON.stringify({
      relationships: [newRelationship],
    });
  });

  export const hideRelationship = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data, context) => {
    await UserService.verifyAuthenticated(context);

    const uid = context.auth?.uid || "";
    const targetUid = data.target || "";
    functions.logger.info("Hiding relationship", { uid, targetUid });

    if (uid === targetUid) {
      throw new functions.https.HttpsError("invalid-argument", "You cannot hide yourself");
    }

    const userProfile = await ProfileService.getProfile(uid);
    const targetProfile = await ProfileService.getProfile(targetUid);
    if (!userProfile || !targetProfile) {
      throw new functions.https.HttpsError("not-found", "User profile not found");
    }

    const relationship = await RelationshipService.getRelationship([uid, targetUid]);

    const newRelationship = await RelationshipService.hideRelationship(uid, relationship);
    await RelationshipUpdatedNotification.sendNotification(newRelationship);

    return JSON.stringify({
      relationships: [newRelationship],
    });
  });

  export const unhideRelationship = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data, context) => {
    await UserService.verifyAuthenticated(context);

    const uid = context.auth?.uid || "";
    const targetUid = data.target || "";
    functions.logger.info("Unhiding relationship", { uid, targetUid });

    if (uid === targetUid) {
      throw new functions.https.HttpsError("invalid-argument", "You cannot unhide yourself");
    }

    const userProfile = await ProfileService.getProfile(uid);
    const targetProfile = await ProfileService.getProfile(targetUid);
    if (!userProfile || !targetProfile) {
      throw new functions.https.HttpsError("not-found", "User profile not found");
    }

    const relationship = await RelationshipService.getRelationship([uid, targetUid]);

    const newRelationship = await RelationshipService.unhideRelationship(uid, relationship);
    await RelationshipUpdatedNotification.sendNotification(newRelationship);

    return JSON.stringify({
      relationships: [newRelationship],
    });
  });
}
