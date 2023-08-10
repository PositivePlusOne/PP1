import * as functions from "firebase-functions";

import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";
import { EndpointRequest, buildEndpointResponse } from "./dto/payloads";
import { UserService } from "../services/user_service";
import { ActivitiesService } from "../services/activities_service";
import { ReactionService } from "../services/reaction_service";

export namespace ReactionEndpoints {
    
    // Post Reaction
    export const postReaction = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
        const uid = await UserService.verifyAuthenticated(context, request.sender);
        const activityId = request.data.activityId;
        const reactionType = request.data.reactionType;

        // Activity verification
        await ActivitiesService.verifyActivityExists(activityId);

        // Reaction verification
        ReactionService.verifyReactionType(reactionType);

        // Build reaction
        const reactionJSON = {
            activityId: activityId,
            senderId: uid,
            reactionType: reactionType,
        };

        // Check if reaction exists
        if (ReactionService.UNIQUE_REACTIONS.includes(reactionType)) {
            const exists = await ReactionService.checkReactionExistsForSenderAndActivity(uid, activityId, reactionType);
            if (exists) {
                throw new Error(`Reaction already exists for activity: ${activityId} and reaction type: ${reactionType}`);
            }
        }

        // Create and response
        const responseReaction = await ReactionService.addReaction(reactionJSON);
        return buildEndpointResponse(context, {
            sender: uid,
            data: [responseReaction],
        });
    });

    // Update Reaction
    export const updateReaction = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
        const uid = await UserService.verifyAuthenticated(context, request.sender);
        const reactionId = request.data.reactionId;
        const reactionType = request.data.reactionType;

        // Reaction verification
        ReactionService.verifyReactionType(reactionType);

        const updatedReaction = {
            reactionId: reactionId,
            senderId: uid,
            reactionType: reactionType,
        };

        await ReactionService.updateReaction(updatedReaction, reactionId);
        return buildEndpointResponse(context, {
            sender: uid,
            data: [updatedReaction],
        });
    });

    // Delete Reaction
    export const deleteReaction = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
        const uid = await UserService.verifyAuthenticated(context, request.sender);
        const reactionId = request.data.reactionId;

        await ReactionService.deleteReaction(reactionId);
        return buildEndpointResponse(context, {
            sender: uid,
            data: [],
        });
    });

    // List Reactions
    export const listReactionsForActivity = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
        const uid = await UserService.verifyAuthenticated(context, request.sender);
        const activityId = request.data.activityId;

        const reactions = await ReactionService.listReactions(activityId);

        let cursor = "";
        if (reactions.length > 0) {
            const lastComment = reactions[reactions.length - 1];
            if (lastComment._fl_meta_ && lastComment._fl_meta_.fl_id) {
                cursor = lastComment._fl_meta_.fl_id;
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
