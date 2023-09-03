import * as functions from "firebase-functions";

import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";
import { EndpointRequest, buildEndpointResponse } from "./dto/payloads";
import { UserService } from "../services/user_service";
import { ActivitiesService } from "../services/activities_service";
import { ReactionService } from "../services/reaction_service";
import { FeedName } from "../constants/default_feeds";
import { ReactionJSON } from "../dto/reactions";
import { FeedService } from "../services/feed_service";
import { ProfileService } from "../services/profile_service";
import { CommentHelpers } from "../helpers/comment_helpers";

export namespace ReactionEndpoints {
    export const postReaction = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
        const uid = await UserService.verifyAuthenticated(context, request.sender);
        const feed = request.data.feed || FeedName.User;
        const activityId = request.data.activityId;
        const kind = request.data.kind;
        const text = request.data.text || "";

        // If text is supplied, we need to verify it is not empty and above the maximum length
        if (text) {
            CommentHelpers.verifyCommentLength(text);
        }

        // Activity verification
        await ActivitiesService.verifyActivityExists(activityId);

        // Reaction verification
        ReactionService.verifyReactionKind(kind);

        // Build reaction
        const origin = ReactionService.getOriginFromFeedStringAndUserId(feed, uid);
        const reactionJSON = {
            activity_id: activityId,
            origin,
            reaction_id: "",
            user_id: uid,
            kind: kind,
            text: text,
        } as ReactionJSON;

        const isUniqueReaction = ReactionService.isUniqueReactionKind(kind);
        if (isUniqueReaction) {
            functions.logger.debug("Checking meets unique reaction criteria");
            const uniqueReactions = await ReactionService.listUniqueReactionsForActivitiesAndUser(feed, [activityId], uid);
            const uniqueReactionKind = uniqueReactions.find((reaction) => reaction.kind === kind);
            if (uniqueReactionKind) {
                throw new functions.https.HttpsError("already-exists", "Reaction already exists");
            }
        } else {
            functions.logger.debug("Reaction is not unique, skipping unique reaction check");
        } 

        const streamClient = FeedService.getFeedsUserClient(uid);
        const responseReaction = await ReactionService.addReaction(streamClient, reactionJSON);

        return buildEndpointResponse(context, {
            sender: uid,
            data: [responseReaction],
        });
    });

    export const updateReaction = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
        const uid = await UserService.verifyAuthenticated(context, request.sender);
        const reactionId = request.data.reactionId;
        const text = request.data.text || "";

        // If text is supplied, we need to verify it is not empty and above the maximum length
        if (text) {
            CommentHelpers.verifyCommentLength(text);
        }

        let reaction = await ReactionService.getReaction(reactionId);
        if (!reaction) {
            throw new functions.https.HttpsError("not-found", "Reaction not found");
        }

        if (reaction.user_id !== uid) {
            throw new functions.https.HttpsError("permission-denied", "Reaction does not belong to user");
        }

        reaction = await ReactionService.updateReaction(reactionId, text);
        return buildEndpointResponse(context, {
            sender: uid,
            data: [reaction],
        });
    });

    // Delete Reaction
    export const deleteReaction = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
        const uid = await UserService.verifyAuthenticated(context, request.sender);
        const reactionId = request.data.reactionId;

        const reaction = await ReactionService.getReaction(reactionId);
        if (!reaction) {
            throw new functions.https.HttpsError("not-found", "Reaction not found");
        }

        if (reaction.user_id !== uid) {
            throw new functions.https.HttpsError("permission-denied", "Reaction does not belong to user");
        }

        functions.logger.info("Deleting reaction", { reactionId });
        const streamClient = FeedService.getFeedsUserClient(uid);
        await ReactionService.deleteReaction(streamClient, reactionId);

        functions.logger.info("Reaction deleted", { reactionId });
        return buildEndpointResponse(context, {
            sender: uid,
            data: [],
        });
    });

    export const listReactionsForActivity = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
        const uid = await UserService.verifyAuthenticated(context, request.sender);
        const activityId = request.data.activityId;
        const kind = request.data.kind;
        const limit = request.limit || 25;
        let cursor = request.cursor;

        const streamClient = FeedService.getFeedsUserClient(uid);
        const reactions = await ReactionService.listReactionsForActivity(streamClient, kind, activityId, limit, cursor);
        functions.logger.info("Reactions for activity", { activityId, reactions });

        if (reactions.length > 0) {
            const lastReaction = reactions[reactions.length - 1];
            if (lastReaction._fl_meta_ && lastReaction._fl_meta_.fl_id) {
                functions.logger.info("Last reaction", { lastReaction });
                cursor = lastReaction._fl_meta_.fl_id;
            }
        }

        // Get the profiles from the reactions
        // We should move this into the buildEndpointResponse function
        const profiles = await ProfileService.getMultipleProfiles(reactions.map((reaction) => reaction.user_id || "").filter((userId) => userId !== ""));
        functions.logger.info("Profiles for reactions", { profiles });

        return buildEndpointResponse(context, {
            sender: uid,
            data: [reactions, profiles],
            cursor,
            limit,
        });
    });
}
