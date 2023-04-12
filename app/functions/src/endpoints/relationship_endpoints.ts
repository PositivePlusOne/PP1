import * as functions from "firebase-functions";
import { ProfileService } from "../services/profile_service";
import { UserService } from "../services/user_service";
import { RelationshipService } from "../services/relationship_service";
import { ConversationService } from "../services/conversation_service";
import { RelationshipHelpers } from "../helpers/relationship_helpers";
import { ChatConnectionAcceptedNotification } from "../services/builders/notifications/chat_connection_accepted_notification";
import { ChatConnectionReceivedNotification } from "../services/builders/notifications/chat_connection_received_notification";

export namespace RelationshipEndpoints {
  export const getBlockedUsers = functions.https.onCall(
    async (_data, context) => {
      await UserService.verifyAuthenticated(context);

      const uid = context.auth?.uid || "";
      functions.logger.info("Getting blocked users", { uid });

      const blockedUsers = await RelationshipService.getBlockedRelationships(
        uid
      );

      functions.logger.info("Blocked users retrieved", {
        uid,
        blockedUsers,
      });

      return JSON.stringify({
        users: blockedUsers,
      });
    }
  );

  export const blockUser = functions.https.onCall(async (data, context) => {
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

    const relationship = await RelationshipService.getRelationship([uid, targetUid]);
    await RelationshipService.blockRelationship(uid, relationship);

    functions.logger.info("User blocked", { uid, targetUid });

    return JSON.stringify({ success: true });
  });

  export const unblockUser = functions.https.onCall(async (data, context) => {
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

    const relationship = await RelationshipService.getRelationship([uid, targetUid]);
    await RelationshipService.unblockRelationship(uid, relationship);

    functions.logger.info("User unblocked", { uid, targetUid });

    return JSON.stringify({ success: true });
  });

  export const muteUser = functions.https.onCall(async (data, context) => {
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

    const relationship = await RelationshipService.getRelationship([uid, targetUid]);
    await RelationshipService.muteRelationship(uid, relationship);

    functions.logger.info("User muted", { uid, targetUid });

    return JSON.stringify({ success: true });
  });

  export const unmuteUser = functions.https.onCall(async (data, context) => {
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

    const relationship = await RelationshipService.getRelationship([uid, targetUid]);
    await RelationshipService.unmuteRelationship(uid, relationship);

    functions.logger.info("User unmuted", { uid, targetUid });

    return JSON.stringify({ success: true });
  });

  export const connectUser = functions.https.onCall(async (data, context) => {
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

    let relationship = await RelationshipService.getRelationship([
      uid,
      targetUid,
    ]);

    relationship = await RelationshipService.connectRelationship(uid, relationship);

    functions.logger.info("User connected, sending notifications", { uid, targetUid });

    const connectionAcceptanceNotificationTargets = RelationshipHelpers.getConnectionAcceptedNotificationTargets(
      uid,
      relationship,
    );

    const connectionRequestNotificationTargets = RelationshipHelpers.getRequestConnectionNotificationTargets(
      uid,
      relationship,
    );

    for (const target of connectionAcceptanceNotificationTargets) {
      const targetProfile = await ProfileService.getUserProfile(target);
      await ChatConnectionAcceptedNotification.sendNotification(targetProfile);
    }

    for (const {} of connectionRequestNotificationTargets) {
      await ChatConnectionReceivedNotification.sendNotification(userProfile);
    }

    return JSON.stringify({ success: true });
  });

  export const disconnectUser = functions.https.onCall(
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

      const hasCreatedProfile = await ProfileService.getUserProfile(uid);
      if (!hasCreatedProfile) {
        throw new functions.https.HttpsError(
          "not-found",
          "User profile not found"
        );
      }

      const relationship = await RelationshipService.getRelationship([uid, targetUid]);
      await RelationshipService.disconnectRelationship(uid, relationship);

      functions.logger.info("User disconnected", { uid, targetUid });

      return JSON.stringify({ success: true });
    }
  );
}
