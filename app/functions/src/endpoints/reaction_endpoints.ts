import * as functions from "firebase-functions";

import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";
import { EndpointRequest, buildEndpointResponse } from "./dto/payloads";
import { UserService } from "../services/user_service";
import { ActivitiesService } from "../services/activities_service";
import { ReactionService } from "../services/reaction_service";
import { FeedName } from "../constants/default_feeds";
import { ReactionJSON } from "../dto/reactions";

export namespace ReactionEndpoints {
    export const postReaction = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
        const uid = await UserService.verifyAuthenticated(context, request.sender);
        const feed = request.data.feed || FeedName.User;
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
            originFeed: `${feed}:${uid}`,
        } as ReactionJSON;

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

    export const listReactionsForActivity = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
        const uid = await UserService.verifyAuthenticated(context, request.sender);
        const activityId = request.data.activityId;
        const reactions = await ReactionService.listReactionsForActivity(activityId);

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

    export const listReactionsForUser = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
        const uid = await UserService.verifyAuthenticated(context, request.sender);
        const reactions = await ReactionService.listReactionsForUser(uid);

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
