import * as functions from "firebase-functions";
import { ProfileService } from "../services/profile_service";
import { UserService } from "../services/user_service";
import { RelationshipService } from "../services/relationship_service";
import { RelationshipHelpers } from "../helpers/relationship_helpers";
import { ChatConnectionAcceptedNotification } from "../services/builders/notifications/chat_connection_accepted_notification";
import { ChatConnectionReceivedNotification } from "../services/builders/notifications/chat_connection_received_notification";
import { ChatConnectionRejectedNotification } from "../services/builders/notifications/chat_connection_rejected_notification";
import { ChatConnectionSentNotification } from "../services/builders/notifications/chat_connection_sent_notification";
import { NotificationsService } from "../services/notifications_service";
import { Keys } from "../constants/keys";
import { NotificationActions } from "../constants/notification_actions";

export namespace RelationshipEndpoints {
  export const getBlockedRelationships = functions.https.onCall(
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

  export const getConnectedRelationships = functions.https.onCall(
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

  export const getPendingConnectionRequests = functions.https.onCall(
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

  export const getFollowingRelationships = functions.https.onCall(
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

  export const getMutedRelationships = functions.https.onCall(
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

  export const getHiddenRelationships = functions.https.onCall(
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

  export const blockRelationship = functions.https.onCall(
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

      const hasCreatedProfile = await ProfileService.getUserProfile(uid);
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

      await RelationshipService.blockRelationship(uid, relationship);

      // Send a ACTION_BLOCKED data payload as a notification to the target users profiles
      const targetUserProfile = await ProfileService.getUserProfile(targetUid);
      if (targetUserProfile) {
        await NotificationsService.sendPayloadToUser(
          targetUserProfile,
          { uid },
          { action: NotificationActions.ACTION_BLOCKED },
        );
      }

      functions.logger.info("User blocked", { uid, targetUid });

      return JSON.stringify({ success: true });
    }
  );

  export const unblockRelationship = functions.https.onCall(
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

      const hasCreatedProfile = await ProfileService.getUserProfile(uid);
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

      await RelationshipService.unblockRelationship(uid, relationship);

      functions.logger.info("User unblocked", { uid, targetUid });

      // Send a ACTION_UNBLOCKED data payload as a notification to the target users profiles
      const targetUserProfile = await ProfileService.getUserProfile(targetUid);
      if (targetUserProfile) {
        await NotificationsService.sendPayloadToUser(
          targetUserProfile,
          { uid },
          { action: NotificationActions.ACTION_UNBLOCKED },
        );
      }

      return JSON.stringify({ success: true });
    }
  );

  export const muteRelationship = functions.https.onCall(
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

      const hasCreatedProfile = await ProfileService.getUserProfile(uid);
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

      await RelationshipService.muteRelationship(uid, relationship);

      // Send a ACTION_MUTED data payload as a notification to the target users profiles
      const targetUserProfile = await ProfileService.getUserProfile(targetUid);
      if (targetUserProfile) {
        await NotificationsService.sendPayloadToUser(
          targetUserProfile,
          { uid },
          { action: NotificationActions.ACTION_MUTED },
        );
      }

      functions.logger.info("User muted", { uid, targetUid });

      return JSON.stringify({ success: true });
    }
  );

  export const unmuteRelationship = functions.https.onCall(
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

      const hasCreatedProfile = await ProfileService.getUserProfile(uid);
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

      await RelationshipService.unmuteRelationship(uid, relationship);

      // Send a ACTION_UNMUTED data payload as a notification to the target users profiles
      const targetUserProfile = await ProfileService.getUserProfile(targetUid);
      if (targetUserProfile) {
        await NotificationsService.sendPayloadToUser(
          targetUserProfile,
          { uid },
          { action: NotificationActions.ACTION_UNMUTED },
        );
      }

      functions.logger.info("User unmuted", { uid, targetUid });

      return JSON.stringify({ success: true });
    }
  );

  export const connectRelationship = functions
    .runWith({ secrets: [Keys.StreamApiKey, Keys.StreamApiSecret] })
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

      const userProfile = await ProfileService.getUserProfile(uid);
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

      await RelationshipService.connectRelationship(uid, relationship);

      functions.logger.info("User connected, sending notifications", {
        uid,
        targetUid,
      });

      for (const memberId of connectionRequestNotificationTargets) {
        const memberProfile = await ProfileService.getUserProfile(memberId);
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
        const memberProfile = await ProfileService.getUserProfile(memberId);
        if (!memberProfile) {
          continue;
        }

        await ChatConnectionAcceptedNotification.sendNotification(
          userProfile,
          memberProfile
        );
      }

      // Send a ACTION_CONNECTED data payload as a notification to the target users profiles
      const targetUserProfile = await ProfileService.getUserProfile(targetUid);
      if (targetUserProfile) {
        await NotificationsService.sendPayloadToUser(
          targetUserProfile,
          { uid },
          { action: NotificationActions.ACTION_CONNECTED },
        );
      }

      return JSON.stringify({ success: true });
    });

  export const disconnectRelationship = functions.https.onCall(
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

      const userProfile = await ProfileService.getUserProfile(uid);
      const targetUserProfile = await ProfileService.getUserProfile(targetUid);
      if (!userProfile || !targetUserProfile) {
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

      if (canReject) {
        await RelationshipService.rejectRelationship(uid, relationship);
        await ChatConnectionRejectedNotification.sendNotification(
          userProfile,
          targetUserProfile
        );
      } else if (canCancel) {
        await RelationshipService.rejectRelationship(uid, relationship);
      } else {
        await RelationshipService.disconnectRelationship(uid, relationship);
      }

      // Send a ACTION_DISCONNECTED data payload as a notification to the target users profiles
      if (targetUserProfile) {
        await NotificationsService.sendPayloadToUser(
          targetUserProfile,
          { uid },
          { action: NotificationActions.ACTION_DISCONNECTED },
        );
      }

      return JSON.stringify({ success: true });
    }
  );

  export const followRelationship = functions.https.onCall(
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

      const userProfile = await ProfileService.getUserProfile(uid);
      const targetUserProfile = await ProfileService.getUserProfile(targetUid);
      if (!userProfile || !targetUserProfile) {
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

      await RelationshipService.followRelationship(uid, relationship);

      // Send a ACTION_FOLLOWED data payload as a notification to the target users profiles
      await NotificationsService.sendPayloadToUser(
        targetUserProfile,
        { uid },
        { action: NotificationActions.ACTION_FOLLOWED },
      );

      return JSON.stringify({ success: true });
    }
  );

  export const unfollowRelationship = functions.https.onCall(
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

      const userProfile = await ProfileService.getUserProfile(uid);
      const targetUserProfile = await ProfileService.getUserProfile(targetUid);
      if (!userProfile || !targetUserProfile) {
        throw new functions.https.HttpsError(
          "not-found",
          "User profile not found"
        );
      }

      const relationship = await RelationshipService.getRelationship([
        uid,
        targetUid,
      ]);

      await RelationshipService.unfollowRelationship(uid, relationship);

      // Send a ACTION_UNFOLLOWED data payload as a notification to the target users profiles
      await NotificationsService.sendPayloadToUser(
        targetUserProfile,
        { uid },
        { action: NotificationActions.ACTION_UNFOLLOWED },
      );

      return JSON.stringify({ success: true });
    }
  );

  export const hideRelationship = functions.https.onCall(
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

      const userProfile = await ProfileService.getUserProfile(uid);
      const targetUserProfile = await ProfileService.getUserProfile(targetUid);
      if (!userProfile || !targetUserProfile) {
        throw new functions.https.HttpsError(
          "not-found",
          "User profile not found"
        );
      }

      const relationship = await RelationshipService.getRelationship([
        uid,
        targetUid,
      ]);

      await RelationshipService.hideRelationship(uid, relationship);

      // Send a ACTION_HIDDEN data payload as a notification to the target users profiles
      await NotificationsService.sendPayloadToUser(
        targetUserProfile,
        { uid },
        { action: NotificationActions.ACTION_HIDDEN },
      );

      return JSON.stringify({ success: true });
    }
  );

  export const unhideRelationship = functions.https.onCall(
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

      const userProfile = await ProfileService.getUserProfile(uid);
      const targetUserProfile = await ProfileService.getUserProfile(targetUid);
      if (!userProfile || !targetUserProfile) {
        throw new functions.https.HttpsError(
          "not-found",
          "User profile not found"
        );
      }

      const relationship = await RelationshipService.getRelationship([
        uid,
        targetUid,
      ]);

      await RelationshipService.unhideRelationship(uid, relationship);

      // Send a ACTION_UNHIDDEN data payload as a notification to the target users profiles
      await NotificationsService.sendPayloadToUser(
        targetUserProfile,
        { uid },
        { action: NotificationActions.ACTION_UNHIDDEN },
      );

      return JSON.stringify({ success: true });
    }
  );
}
