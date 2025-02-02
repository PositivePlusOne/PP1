import * as functions from "firebase-functions";

import { FIREBASE_FUNCTION_INSTANCE_DATA, FIREBASE_FUNCTION_INSTANCE_DATA_256 } from "../constants/domain";
import { EndpointRequest, buildEndpointResponse } from "./dto/payloads";
import { UserService } from "../services/user_service";
import { ActivitiesService } from "../services/activities_service";
import { ReactionService } from "../services/reaction_service";
import { ReactionJSON } from "../dto/reactions";
import { FeedService } from "../services/feed_service";
import { CommentHelpers } from "../helpers/comment_helpers";
import { RelationshipService } from "../services/relationship_service";
import { SystemService } from "../services/system_service";
import { ProfileService } from "../services/profile_service";
import { ActivitySecurityConfigurationMode } from "../dto/activities";
import { MentionJSON } from "../dto/mentions";

export namespace ReactionEndpoints {
  export const getReaction = functions
    .region("europe-west3")
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA_256)
    .https.onCall(async (request: EndpointRequest, context) => {
      await SystemService.validateUsingRedisUserThrottle(context);
      const uid = context.auth?.uid || "";
      const reactionId = request.data.reactionId;

      const reaction = await ReactionService.getReaction(reactionId);
      if (!reaction) {
        throw new functions.https.HttpsError("not-found", "Reaction not found");
      }

      return buildEndpointResponse(context, {
        sender: uid,
        data: [reaction],
      });
    });

  export const postReaction = functions
    .region("europe-west3")
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA_256)
    .https.onCall(async (request: EndpointRequest, context) => {
      await SystemService.validateUsingRedisUserThrottle(context);
      const uid = await UserService.verifyAuthenticated(context, request.sender);
      const activityId = request.data.activityId;
      const kind = request.data.kind;
      const text = request.data.text || "";
      const mentions = ((request.data.mentions || []) as MentionJSON[]) || ([] as MentionJSON[]);
      const visibleTo = request.data.visibleTo || ("public" as ActivitySecurityConfigurationMode);

      if (!activityId || !kind) {
        throw new functions.https.HttpsError("invalid-argument", "Invalid reaction");
      }

      // If text is supplied, we need to verify it is not empty and above the maximum length
      if (text) {
        CommentHelpers.verifyCommentLength(text);
      }

      const profile = await ProfileService.getProfile(uid);
      if (!profile) {
        throw new functions.https.HttpsError("not-found", "Profile not found");
      }

      // Activity verification
      const activity = await ActivitiesService.getActivity(activityId);
      const publisher = activity?.publisherInformation?.publisherId || "";
      if (!activity || !publisher) {
        throw new functions.https.HttpsError("not-found", "Activity not found");
      }

      const publisherProfile = await ProfileService.getProfile(publisher);
      if (!publisherProfile) {
        throw new functions.https.HttpsError("not-found", "Publisher profile not found");
      }

      // Prevent likes on your own activity
      if (uid === publisher && kind === "like") {
        throw new functions.https.HttpsError("permission-denied", "Cannot like your own activity");
      }

      // Reaction verification
      const relationship = await RelationshipService.getRelationship([uid, publisher], true);
      await ReactionService.verifyReactionKind(kind, uid, activity, relationship);

      //? For each mentionedUser attempt get the users ID and prepare to notify
      const sanitizedMentions = await ActivitiesService.sanitizeMentions(profile, text, visibleTo, mentions);
      const uniqueMentions = sanitizedMentions.filter((mention, index, self) => self.findIndex((m) => m.label === mention.label) === index);

      // Build reaction
      const reactionJSON = {
        activity_id: activityId,
        target_user_id: publisher,
        reaction_id: "",
        user_id: uid,
        kind: kind,
        text: text,
        mentions: sanitizedMentions,
      } as ReactionJSON;

      const isUniqueReaction = ReactionService.isUniqueReactionKind(kind);
      if (isUniqueReaction) {
        const expectedReactionKey = ReactionService.getExpectedKeyFromOptions(reactionJSON);
        const existingReaction = await ReactionService.getReaction(expectedReactionKey);
        functions.logger.debug("Checking meets unique reaction criteria", { expectedReactionKey, existingReaction });
        if (existingReaction) {
          throw new functions.https.HttpsError("already-exists", "Unique reaction already exists for this activity and user");
        }
      }

      functions.logger.info("Adding reaction", { reactionJSON });
      const streamClient = FeedService.getFeedsClient();
      const [reaction, reactionStats, sourceProfileStats, targetProfileStats] = await ReactionService.addReaction(streamClient, reactionJSON);

      await ReactionService.processNotifications(kind, uid, activity, reaction, reactionStats, uniqueMentions);

      return buildEndpointResponse(context, {
        sender: uid,
        data: [activity, reaction, reactionStats, sourceProfileStats, targetProfileStats],
      });
    });

  export const updateReaction = functions
    .region("europe-west3")
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (request: EndpointRequest, context) => {
      await SystemService.validateUsingRedisUserThrottle(context);
      const uid = await UserService.verifyAuthenticated(context, request.sender);
      const reactionId = request.data.reactionId;
      const text = request.data.text || "";

      // If text is supplied, we need to verify it is not empty and above the maximum length
      if (text) {
        CommentHelpers.verifyCommentLength(text);
      }

      let reaction = await ReactionService.getReaction(reactionId);
      if (!reaction || !reaction.activity_id) {
        throw new functions.https.HttpsError("not-found", "Reaction not found");
      }

      const activity = await ActivitiesService.getActivity(reaction.activity_id);
      if (!activity) {
        throw new functions.https.HttpsError("not-found", "Activity not found");
      }

      if (reaction.user_id !== uid) {
        throw new functions.https.HttpsError("permission-denied", "Reaction does not belong to user");
      }

      reaction = await ReactionService.updateReaction(reactionId, text);
      return buildEndpointResponse(context, {
        sender: uid,
        data: [reaction, activity],
      });
    });

  // Delete Reaction
  export const deleteReaction = functions
    .region("europe-west3")
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (request: EndpointRequest, context) => {
      await SystemService.validateUsingRedisUserThrottle(context);
      const uid = await UserService.verifyAuthenticated(context, request.sender);
      const reactionId = request.data.reactionId;

      const reaction = await ReactionService.getReaction(reactionId);
      if (!reaction || !reaction.activity_id) {
        throw new functions.https.HttpsError("not-found", "Reaction not found");
      }

      const activity = await ActivitiesService.getActivity(reaction.activity_id);
      if (!activity) {
        throw new functions.https.HttpsError("not-found", "Activity not found");
      }

      if (reaction.user_id !== uid) {
        throw new functions.https.HttpsError("permission-denied", "Reaction does not belong to user");
      }

      functions.logger.info("Deleting reaction", { reactionId });
      const streamClient = FeedService.getFeedsClient();
      const [reactionStats, sourceProfileStats, targetProfileStats] = await ReactionService.deleteReaction(streamClient, reaction);

      functions.logger.info("Reaction deleted", { reactionId });
      return buildEndpointResponse(context, {
        sender: uid,
        data: [activity, reactionStats, sourceProfileStats, targetProfileStats],
      });
    });

  export const listReactionsForActivity = functions
    .region("europe-west3")
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (request: EndpointRequest, context) => {
      await SystemService.validateUsingRedisUserThrottle(context);
      const uid = context.auth?.uid || "";
      const activityId = request.data.activityId;
      const kind = request.data.kind;
      const limit = request.limit || 25;
      let cursor = request.cursor;

      const streamClient = FeedService.getFeedsClient();
      const reactions = await ReactionService.listReactionsForActivity(streamClient, kind, activityId, limit, cursor);
      functions.logger.info("Reactions for activity", { activityId, reactions });

      if (reactions.length > 0) {
        const lastReaction = reactions[reactions.length - 1];
        if (lastReaction._fl_meta_ && lastReaction._fl_meta_.fl_id) {
          functions.logger.info("Last reaction", { lastReaction });
          cursor = lastReaction._fl_meta_.fl_id;
        }
      }

      return buildEndpointResponse(context, {
        sender: uid,
        data: [...reactions],
        cursor,
        limit,
      });
    });
}
