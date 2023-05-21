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

export namespace RelationshipEndpoints {
  // Note: Intention is for this to sit behind a cache layer (e.g. Redis) to prevent abuse.
  export const getRelationship = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(
    async (data, context) => {
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
    }
  );

  // Note: Intention is for this to sit behind a cache layer (e.g. Redis) to prevent abuse.
  export const getRelationships = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(
    async (_data, context) => {
      await UserService.verifyAuthenticated(context);

      const uid = context.auth?.uid || "";
      functions.logger.info("Getting relationships", { uid });

      const relationships = await RelationshipService.getRelationships(uid);
      functions.logger.info("Relationships retrieved", {
        uid,
        relationships,
      });

      return JSON.stringify({
        relationships,
      });
    }
  );
  
  // Deprecated: Use getRelationships instead
  export const getBlockedRelationships = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(
    async (_data, context) => {
      await UserService.verifyAuthenticated(context);

      const uid = context.auth?.uid || "";
      functions.logger.info("Getting blocked relationships", { uid });

      const blockedRelationships =
        await RelationshipService.getBlockedRelationships(uid);

      functions.logger.info("Blocked relationships retrieved", {
        uid,
        blockedRelationships,
      });

      return JSON.stringify({
        relationships: blockedRelationships,
      });
    }
  );

  // Deprecated: Use getRelationships instead
  export const getConnectedRelationships = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(
    async (_data, context) => {
      await UserService.verifyAuthenticated(context);

      const uid = context.auth?.uid || "";
      functions.logger.info("Getting connected relationships", { uid });

      const connectedRelationships =
        await RelationshipService.getConnectedRelationships(uid);

      functions.logger.info("Connected relationships retrieved", {
        uid,
        connectedRelationships,
      });

      return JSON.stringify({
        relationships: connectedRelationships,
      });
    }
  );

  // Deprecated: Use getRelationships instead
  export const getPendingConnectionRequests = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(
    async (_data, context) => {
      await UserService.verifyAuthenticated(context);

      const uid = context.auth?.uid || "";
      functions.logger.info("Getting pending connection requests", { uid });

      const pendingConnectionRequests =
        await RelationshipService.getPendingConnectionRequests(uid);

      functions.logger.info("Pending connection requests retrieved", {
        uid,
        pendingConnectionRequests,
      });

      return JSON.stringify({
        relationships: pendingConnectionRequests,
      });
    }
  );

  // Deprecated: Use getRelationships instead
  export const getFollowingRelationships = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(
    async (_data, context) => {
      await UserService.verifyAuthenticated(context);

      const uid = context.auth?.uid || "";
      functions.logger.info("Getting followers", { uid });

      const followers = await RelationshipService.getFollowingRelationships(
        uid
      );

      functions.logger.info("Followers retrieved", {
        uid,
        followers,
      });

      return JSON.stringify({
        relationships: followers,
      });
    }
  );

  // Deprecated: Use getRelationships instead
  export const getMutedRelationships = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(
    async (_data, context) => {
      await UserService.verifyAuthenticated(context);

      const uid = context.auth?.uid || "";
      functions.logger.info("Getting muted relationships", { uid });

      const mutedRelationships =
        await RelationshipService.getMutedRelationships(uid);

      functions.logger.info("Muted relationships retrieved", {
        uid,
        mutedRelationships,
      });

      return JSON.stringify({
        relationships: mutedRelationships,
      });
    }
  );

  // Deprecated: Use getRelationships instead
  export const getHiddenRelationships = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(
    async (_data, context) => {
      await UserService.verifyAuthenticated(context);

      const uid = context.auth?.uid || "";
      functions.logger.info("Getting hidden relationships", { uid });

      const hiddenRelationships =
        await RelationshipService.getHiddenRelationships(uid);

      functions.logger.info("Hidden relationships retrieved", {
        uid,
        hiddenRelationships,
      });

      return JSON.stringify({
        relationships: hiddenRelationships,
      });
    }
  );

  export const blockRelationship = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(
    async (data, context) => {
      await UserService.verifyAuthenticated(context);

      const uid = context.auth?.uid || "";
      const targetUid = data.target || "";
      functions.logger.info("Blocking user", { uid, targetUid });

      if (uid === targetUid) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "You cannot block yourself"
        );
      }

      const hasCreatedProfile = await ProfileService.getProfile(uid);
      if (!hasCreatedProfile) {
        throw new functions.https.HttpsError(
          "not-found",
          "User profile not found"
        );
      }

      const targetProfile = await ProfileService.getProfile(targetUid);
      if (!targetProfile) {
        throw new functions.https.HttpsError(
          "not-found",
          "Target user profile not found"
        );
      }

      const relationship = await RelationshipService.getRelationship([
        uid,
        targetUid,
      ]);

      const newRelationship = await RelationshipService.blockRelationship(uid, relationship);

      functions.logger.info("User blocked", { uid, targetUid });
      await RelationshipUpdatedNotification.sendNotification(newRelationship);

      return newRelationship;
    }
  );

  export const unblockRelationship = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(
    async (data, context) => {
      await UserService.verifyAuthenticated(context);

      const uid = context.auth?.uid || "";
      const targetUid = data.target || "";
      functions.logger.info("Unblocking user", { uid, targetUid });

      if (uid === targetUid) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "You cannot unblock yourself"
        );
      }

      const hasCreatedProfile = await ProfileService.getProfile(uid);
      if (!hasCreatedProfile) {
        throw new functions.https.HttpsError(
          "not-found",
          "User profile not found"
        );
      }

      const targetProfile = await ProfileService.getProfile(targetUid);
      if (!targetProfile) {
        throw new functions.https.HttpsError(
          "not-found",
          "Target profile not found"
        );
      }

      const relationship = await RelationshipService.getRelationship([
        uid,
        targetUid,
      ]);

      const newRelationship = await RelationshipService.unblockRelationship(uid, relationship);

      functions.logger.info("User unblocked", { uid, targetUid });
      await RelationshipUpdatedNotification.sendNotification(newRelationship);

      return JSON.stringify({ success: true });
    }
  );

  export const muteRelationship = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(
    async (data, context) => {
      await UserService.verifyAuthenticated(context);

      const uid = context.auth?.uid || "";
      const targetUid = data.target || "";
      functions.logger.info("Muting user", { uid, targetUid });

      if (uid === targetUid) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "You cannot mute yourself"
        );
      }

      const hasCreatedProfile = await ProfileService.getProfile(uid);
      if (!hasCreatedProfile) {
        throw new functions.https.HttpsError(
          "not-found",
          "User profile not found"
        );
      }

      const relationship = await RelationshipService.getRelationship([
        uid,
        targetUid,
      ]);

      const newRelationship = await RelationshipService.muteRelationship(uid, relationship);

      // Send a ACTION_MUTED data payload as a notification to the target users profiles
      const targetProfile = await ProfileService.getProfile(targetUid);
      if (!targetProfile) {
        throw new functions.https.HttpsError(
          "not-found",
          "Target profile not found"
        );
      }

      functions.logger.info("User muted", { uid, targetUid });
      await RelationshipUpdatedNotification.sendNotification(newRelationship);

      return JSON.stringify({ success: true });
    }
  );

  export const unmuteRelationship = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(
    async (data, context) => {
      await UserService.verifyAuthenticated(context);

      const uid = context.auth?.uid || "";
      const targetUid = data.target || "";
      functions.logger.info("Unmuting user", { uid, targetUid });

      if (uid === targetUid) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "You cannot unmute yourself"
        );
      }

      const hasCreatedProfile = await ProfileService.getProfile(uid);
      if (!hasCreatedProfile) {
        throw new functions.https.HttpsError(
          "not-found",
          "User profile not found"
        );
      }

      const relationship = await RelationshipService.getRelationship([
        uid,
        targetUid,
      ]);

      const newRelationship = await RelationshipService.unmuteRelationship(uid, relationship);
      await RelationshipUpdatedNotification.sendNotification(newRelationship);

      functions.logger.info("User unmuted", { uid, targetUid });

      return JSON.stringify({ success: true });
    }
  );

  export const connectRelationship = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (data, context) => {
      await UserService.verifyAuthenticated(context);

      const uid = context.auth?.uid || "";
      const targetUid = data.target || "";
      functions.logger.info("Connecting user", { uid, targetUid });

      if (uid === targetUid) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "You cannot connect yourself"
        );
      }

      const userProfile = await ProfileService.getProfile(uid);
      if (!userProfile) {
        throw new functions.https.HttpsError(
          "not-found",
          "User profile not found"
        );
      }

      const relationship = await RelationshipService.getRelationship([
        uid,
        targetUid,
      ]);

      const canActionRelationship = RelationshipHelpers.canActionRelationship(
        uid,
        relationship
      );

      if (!canActionRelationship) {
        throw new functions.https.HttpsError(
          "permission-denied",
          "You cannot connect with this user"
        );
      }

      const connectionAcceptanceNotificationTargets =
        RelationshipHelpers.getConnectionAcceptedNotificationTargets(
          uid,
          relationship
        );

      const connectionRequestNotificationTargets =
        RelationshipHelpers.getRequestConnectionNotificationTargets(
          uid,
          relationship
        );

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

        await ChatConnectionSentNotification.sendNotification(
          userProfile,
          memberProfile
        );

        await ChatConnectionReceivedNotification.sendNotification(
          userProfile,
          memberProfile
        );
      }

      for (const memberId of connectionAcceptanceNotificationTargets) {
        const memberProfile = await ProfileService.getProfile(memberId);
        if (!memberProfile) {
          continue;
        }

        await ChatConnectionAcceptedNotification.sendNotification(
          userProfile,
          memberProfile
        );
      }

      await RelationshipUpdatedNotification.sendNotification(newRelationship);

      return JSON.stringify({ success: true });
    });

  export const disconnectRelationship = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(
    async (data, context) => {
      await UserService.verifyAuthenticated(context);

      const uid = context.auth?.uid || "";
      const targetUid = data.target || "";
      functions.logger.info("Disconnecting user", { uid, targetUid });

      if (uid === targetUid) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "You cannot disconnect yourself"
        );
      }

      const userProfile = await ProfileService.getProfile(uid);
      const targetProfile = await ProfileService.getProfile(targetUid);
      if (!userProfile || !targetProfile) {
        throw new functions.https.HttpsError(
          "not-found",
          "User profile not found"
        );
      }

      const relationship = await RelationshipService.getRelationship([
        uid,
        targetUid,
      ]);

      const canReject = RelationshipHelpers.canRejectConnectionRequest(
        uid,
        relationship
      );

      const canCancel = RelationshipHelpers.canCancelConnectionRequest(
        uid,
        relationship
      );

      let newRelationship = {...relationship};
      if (canReject) {
        newRelationship = await RelationshipService.rejectRelationship(uid, relationship);
        await ChatConnectionRejectedNotification.sendNotification(
          userProfile,
          targetProfile
        );
      } else if (canCancel) {
        newRelationship = await RelationshipService.rejectRelationship(uid, relationship);
      } else {
        newRelationship = await RelationshipService.disconnectRelationship(uid, relationship);
      }

      await RelationshipUpdatedNotification.sendNotification(newRelationship);

      return JSON.stringify({ success: true });
    }
  );

  export const followRelationship = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(
    async (data, context) => {
      await UserService.verifyAuthenticated(context);

      const uid = context.auth?.uid || "";
      const targetUid = data.target || "";
      functions.logger.info("Following relationship", { uid, targetUid });

      if (uid === targetUid) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "You cannot follow yourself"
        );
      }

      const userProfile = await ProfileService.getProfile(uid);
      const targetProfile = await ProfileService.getProfile(targetUid);
      if (!userProfile || !targetProfile) {
        throw new functions.https.HttpsError(
          "not-found",
          "User profile not found"
        );
      }

      const relationship = await RelationshipService.getRelationship([
        uid,
        targetUid,
      ]);

      const canActionRelationship = RelationshipHelpers.canActionRelationship(
        uid,
        relationship
      );

      if (!canActionRelationship) {
        throw new functions.https.HttpsError(
          "permission-denied",
          "You cannot follow this user"
        );
      }

      const newRelationship = await RelationshipService.followRelationship(uid, relationship);
      await RelationshipUpdatedNotification.sendNotification(newRelationship);

      return JSON.stringify({ success: true });
    }
  );

  export const unfollowRelationship = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(
    async (data, context) => {
      await UserService.verifyAuthenticated(context);

      const uid = context.auth?.uid || "";
      const targetUid = data.target || "";
      functions.logger.info("Unfollowing relationship", { uid, targetUid });

      if (uid === targetUid) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "You cannot unfollow yourself"
        );
      }

      const userProfile = await ProfileService.getProfile(uid);
      const targetProfile = await ProfileService.getProfile(targetUid);
      if (!userProfile || !targetProfile) {
        throw new functions.https.HttpsError(
          "not-found",
          "User profile not found"
        );
      }

      const relationship = await RelationshipService.getRelationship([
        uid,
        targetUid,
      ]);

      const newRelationship = await RelationshipService.unfollowRelationship(uid, relationship);
      await RelationshipUpdatedNotification.sendNotification(newRelationship);

      return JSON.stringify({ success: true });
    }
  );

  export const hideRelationship = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(
    async (data, context) => {
      await UserService.verifyAuthenticated(context);

      const uid = context.auth?.uid || "";
      const targetUid = data.target || "";
      functions.logger.info("Hiding relationship", { uid, targetUid });

      if (uid === targetUid) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "You cannot hide yourself"
        );
      }

      const userProfile = await ProfileService.getProfile(uid);
      const targetProfile = await ProfileService.getProfile(targetUid);
      if (!userProfile || !targetProfile) {
        throw new functions.https.HttpsError(
          "not-found",
          "User profile not found"
        );
      }

      const relationship = await RelationshipService.getRelationship([
        uid,
        targetUid,
      ]);

      const newRelationship = await RelationshipService.hideRelationship(uid, relationship);
      await RelationshipUpdatedNotification.sendNotification(newRelationship);

      return JSON.stringify({ success: true });
    }
  );

  export const unhideRelationship = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(
    async (data, context) => {
      await UserService.verifyAuthenticated(context);

      const uid = context.auth?.uid || "";
      const targetUid = data.target || "";
      functions.logger.info("Unhiding relationship", { uid, targetUid });

      if (uid === targetUid) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "You cannot unhide yourself"
        );
      }

      const userProfile = await ProfileService.getProfile(uid);
      const targetProfile = await ProfileService.getProfile(targetUid);
      if (!userProfile || !targetProfile) {
        throw new functions.https.HttpsError(
          "not-found",
          "User profile not found"
        );
      }

      const relationship = await RelationshipService.getRelationship([
        uid,
        targetUid,
      ]);

      const newRelationship = await RelationshipService.unhideRelationship(uid, relationship);
      await RelationshipUpdatedNotification.sendNotification(newRelationship);

      return JSON.stringify({ success: true });
    }
  );
}
