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

export namespace ReactionEndpoints {
    export const postReaction = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
        const uid = await UserService.verifyAuthenticated(context, request.sender);
        const feed = request.data.feed || FeedName.User;
        const activityId = request.data.activityId;
        const reactionType = request.data.reactionType;

        // Activity verification
        await ActivitiesService.verifyActivityExists(activityId);

        // Reaction verification
        ReactionService.verifyReactionKind(reactionType);

        // Build reaction
        const reactionJSON = {
            activity_id: activityId,
            origin: `${feed}:${uid}`,
            reaction_id: "",
            user_id: uid,
            kind: reactionType,
        } as ReactionJSON;

        const isUniqueReaction = ReactionService.isUniqueReaction(reactionType);
        if (isUniqueReaction) {
            functions.logger.info("Checking for unique reaction", { activityId, uid, reactionType });
            const uniqueReaction = await ReactionService.getUniqueReactionForSenderAndActivity(reactionType, uid, activityId);
            if (uniqueReaction) {
                throw new functions.https.HttpsError("already-exists", "Reaction already exists");
            }
        } else {
            functions.logger.info("Reaction is not unique", { activityId, uid, reactionType });
        }

        functions.logger.info("Adding reaction", { reactionJSON });
        const streamClient = FeedService.getFeedsUserClient(uid);
        const responseReaction = await ReactionService.addReaction(streamClient, reactionJSON);

        return buildEndpointResponse(context, {
            sender: uid,
            data: [responseReaction],
        });
    });

    // Update Reaction
    // export const updateReaction = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
        // const uid = await UserService.verifyAuthenticated(context, request.sender);
        // const reactionId = request.data.reactionId;
        // const reactionType = request.data.reactionType;

        // TODO
        // Reaction verification
        // ReactionService.verifyVerb(reactionType);

        // const updatedReaction = {
        //     activity_id: "",
        //     senderId: uid,
        //     reactionType: reactionType,
        // } as ReactionJSON;

        // await ReactionService.updateReaction(updatedReaction, reactionId);
        // return buildEndpointResponse(context, {
        //     sender: uid,
        //     data: [updatedReaction],
        // });
    // });

    // Delete Reaction
    export const deleteReaction = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
        const uid = await UserService.verifyAuthenticated(context, request.sender);
        const reactionId = request.data.reactionId;

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

        const streamClient = FeedService.getFeedsUserClient(uid);
        const reactions = await ReactionService.listReactionsForActivity(streamClient, kind, activityId);

        let cursor = "";
        if (reactions.length > 0) {
            const lastReaction = reactions[reactions.length - 1];
            if (lastReaction._fl_meta_ && lastReaction._fl_meta_.fl_id) {
                cursor = lastReaction._fl_meta_.fl_id;
            }
        }

        // Get the profiles from the reactions
        const profiles = await ProfileService.getMultipleProfiles(reactions.map((reaction) => reaction.user_id || "").filter((userId) => userId !== ""));

        return buildEndpointResponse(context, {
            sender: uid,
            cursor: cursor,
            limit: request.limit,
            data: [reactions, profiles],
        });
    });

    export const listReactionsForUser = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
        const uid = await UserService.verifyAuthenticated(context, request.sender);
        const streamClient = FeedService.getFeedsUserClient(uid);
        const reactions = await ReactionService.listReactionsForUser(streamClient, uid);

        let cursor = "";
        if (reactions.length > 0) {
            const lastReaction = reactions[reactions.length - 1];
            if (lastReaction._fl_meta_ && lastReaction._fl_meta_.fl_id) {
                cursor = lastReaction._fl_meta_.fl_id;
            }
        }

        return buildEndpointResponse(context, {
            sender: uid,
            cursor: cursor,
            limit: request.limit,
            data: reactions,
        });
    });
}
