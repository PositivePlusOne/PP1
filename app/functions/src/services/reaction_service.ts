import * as functions from "firebase-functions";

import { ReactionJSON, reactionSchemaKey } from "../dto/reactions";
import { DataService } from "./data_service";
import { StreamClient, DefaultGenerics, ReactionFilterConditions } from "getstream";
import { ReactionEntryJSON } from "../dto/stream";
import { ReactionStatisticsService } from "./reaction_statistics_service";
import { StreamHelpers } from "../helpers/stream_helpers";
import { FlamelinkHelpers } from "../helpers/flamelink_helpers";
import { RelationshipJSON } from "../dto/relationships";
import { ActivityJSON } from "../dto/activities";
import { RelationshipService } from "./relationship_service";
import { RelationshipState } from "./types/relationship_state";
import { ReactionCommentNotification } from "./builders/notifications/activities/reaction_comment_notification";
import { ProfileService } from "./profile_service";
import { ProfileJSON } from "../dto/profile";
import { ReactionLikeNotification } from "./builders/notifications/activities/reaction_like_notification";

export namespace ReactionService {
    
    export const VALID_FEEDS = ["user", "timeline", "notification", "tags", "aggregated", "notification_aggregated"];
    export const VALID_REACTIONS = ["like", "bookmark", "comment", "share"];
    export const UNIQUE_REACTIONS = ["like", "bookmark"];

    export function isUniqueReactionKind(kind: string) {
        return UNIQUE_REACTIONS.includes(kind);
    }

    export async function verifyReactionKind(kind: string, userId: string, activity: ActivityJSON, relationship: RelationshipJSON) : Promise<void> {
        if (!VALID_REACTIONS.includes(kind)) {
            throw new functions.https.HttpsError("invalid-argument", "Invalid reaction kind");
        }

        const publisherId = activity?.publisherInformation?.publisherId || "";
        if (!publisherId) {
            throw new functions.https.HttpsError("not-found", "Activity publisher not found");
        }

        // Skip verification if the user is the publisher
        if (userId === publisherId) {
            return;
        }

        // Check flags on the activity 
        const relationshipStates = RelationshipService.relationshipStatesForEntity(userId, relationship);
        const viewMode = activity?.securityConfiguration?.viewMode || "public";
        const likesMode = activity?.securityConfiguration?.likesMode || "public";
        const commentMode = activity?.securityConfiguration?.commentMode || "public";
        const shareMode = activity?.securityConfiguration?.shareMode || "public";
        const bookmarksMode = activity?.securityConfiguration?.bookmarksMode || "public";

        const isFullyConnected = relationshipStates.has(RelationshipState.sourceConnected) && relationshipStates.has(RelationshipState.targetConnected);
        const isBlocked = relationshipStates.has(RelationshipState.targetBlocked);
        const isFollowing = relationshipStates.has(RelationshipState.sourceFollowed);

        // Check if we are blocked (find targetBlocked in the set of relationship states)
        if (isBlocked) {
            throw new functions.https.HttpsError("permission-denied", "You cannot react to this activity, you are blocked");
        }

        if (viewMode === "private") {
            throw new functions.https.HttpsError("permission-denied", "You cannot react to this activity, view mode is private");
        }

        // Check the different mode flags
        let currentMode = "public";
        switch (kind) {
            case "like":
                currentMode = likesMode;
                break;
            case "comment":
                currentMode = commentMode;
                break;
            case "share":
                currentMode = shareMode;
                break;
            case "bookmark":
                currentMode = bookmarksMode;
                break;
        }

        if (currentMode === "private") {
            throw new functions.https.HttpsError("permission-denied", "You cannot react to this activity, it is private");
        }

        // Check if we are following (find sourceFollowed in the set of relationship states)
        if (currentMode == "followers_and_connections" && (!isFollowing || !isFullyConnected)) {
            throw new functions.https.HttpsError("permission-denied", "You cannot react to this activity, you are not following the publisher");
        }

        // Check if we are connected (find sourceConnected in the set of relationship states)
        if (currentMode == "connections" && !isFullyConnected) {
            throw new functions.https.HttpsError("permission-denied", "You cannot react to this activity, you are not connected to the publisher");
        }
    }

    export async function processNotifications(kind: string, userId: string, activity: ActivityJSON, reaction: ReactionJSON): Promise<void> {
        functions.logger.info("Processing notifications", { kind, userId, activity });

        const publisherId = activity?.publisherInformation?.publisherId || "";
        const profiles = await ProfileService.getMultipleProfiles([userId, publisherId]);

        const userProfile = profiles.find((profile: ProfileJSON) => profile?._fl_meta_?.fl_id === userId);
        const publisherProfile = profiles.find((profile: ProfileJSON) => profile?._fl_meta_?.fl_id === publisherId);

        if (!userProfile || !publisherProfile) {
            functions.logger.error("Unable to find user or publisher profile", { userId, publisherId, userProfile, publisherProfile });
            return;
        }

        // TODO, add publisher check as to not send notifications to the publisher
        if (userProfile._fl_meta_.fl_id === publisherProfile._fl_meta_.fl_id) {
            functions.logger.info("Cannot send content notifications to yourself", { userId, publisherId, userProfile, publisherProfile });
            return;
        }

        switch (kind) {
            case "comment":
                await ReactionCommentNotification.sendNotification(userProfile, publisherProfile, activity, reaction);
                break;
            case "like":
                await ReactionLikeNotification.sendNotification(userProfile, publisherProfile, activity, reaction);
                break;
            default:
                break;
        }

        functions.logger.info("Finished processing notifications", { kind, userId, activity });
    }

    export function getOriginFromFeedStringAndUserId(feed: string, userId: string): string {
        if (!feed || !userId) {
            throw new Error(`Invalid feed or user ID: ${feed}, ${userId}`);
        }

        // Check the feed is valid
        if (!VALID_FEEDS.includes(feed)) {
            throw new Error(`Invalid feed: ${feed}`);
        }

        // We convert the timeline feed to a user feed as having two feeds for the same user is confusing.
        if (feed === "timeline") {
            feed = "user";
        }

        return `${feed}:${userId}`;
    }

    export async function addReaction(client: StreamClient<DefaultGenerics>, reaction: ReactionJSON): Promise<ReactionJSON> {
        if (!reaction.activity_id || !reaction.origin || !reaction.kind) {
            throw new Error(`Invalid reaction: ${JSON.stringify(reaction)}`);
        }

        const reactionEntry = {
            kind: reaction.kind,
            activity_id: reaction.activity_id,
            user_id: reaction.user_id,
            time: StreamHelpers.getCurrentTimestamp(),
        } as ReactionEntryJSON;

        const response = await client.reactions.add(reaction.kind!, reaction.activity_id!, reactionEntry, {
            userId: reaction.user_id,
        });

        functions.logger.info("Added reaction", { response });
        await ReactionStatisticsService.updateReactionCountForActivity(reaction.origin, reaction.activity_id, reaction.kind, 1);

        return DataService.updateDocument({
            schemaKey: reactionSchemaKey,
            entryId: response.id,
            data: reaction,
        }) as ReactionJSON;
    }

    export async function getReaction(reactionId: string): Promise<ReactionJSON> {
        return DataService.getDocument({
            schemaKey: reactionSchemaKey,
            entryId: reactionId,
        }) as ReactionJSON;
    }

    export async function updateReaction(reactionId: string, text: string): Promise<ReactionJSON> {
        return DataService.updateDocument({
            schemaKey: reactionSchemaKey,
            entryId: reactionId,
            data: {
                text,
            },
        }) as ReactionJSON;
    }

    export async function deleteReaction(client: StreamClient<DefaultGenerics>, reaction: ReactionJSON): Promise<void> {
        const id = FlamelinkHelpers.getFlamelinkIdFromObject(reaction);
        if (!id || !reaction.activity_id || !reaction.origin || !reaction.kind) {
            throw new Error(`Invalid reaction: ${JSON.stringify(reaction)}`);
        }

        await client.reactions.delete(id);
        await ReactionStatisticsService.updateReactionCountForActivity(reaction.origin, reaction.activity_id, reaction.kind, -1);

        await DataService.deleteDocument({
            schemaKey: reactionSchemaKey,
            entryId: id,
        });
    }

    export async function listReactionsForActivity(client: StreamClient<DefaultGenerics>, kind: string, activity_id: string, limit = 25, cursor = ""): Promise<ReactionJSON[]> {
        const params: any = {
            activity_id: activity_id,
            kind: kind,
            limit: limit,
            id_lt: cursor,
        } as ReactionFilterConditions;

        const response = await client.reactions.filter(params);
        const results = response.results;
        const reactionIds = results.map((reaction: any) => reaction.id);

        return DataService.getBatchDocuments({
            schemaKey: reactionSchemaKey,
            entryIds: reactionIds,
        }) as Promise<ReactionJSON[]>;
    }

    /**
     * Fetches the unique reactions for a list of activities and a user.
     * 
     * @param feed The feed to use for the origin.
     * @param activityIds The activity IDs to fetch reactions for.
     * @param userId The user ID to fetch reactions for.
     * @returns The unique reactions for the activities and user.
     */
    export async function listUniqueReactionsForActivitiesAndUser(origin: string, activityIds: string[], userId: string): Promise<ReactionJSON[]> {
        const reactions = [] as ReactionJSON[];
        const windowPromises: Promise<ReactionJSON[]>[] = [];
        if (!activityIds || activityIds.length === 0 || !userId || !origin) {
            functions.logger.info("No activities or user ID provided", { activityIds, userId });
            return reactions;
        }

        for (let index = 0; index < UNIQUE_REACTIONS.length; index++) {
            const kind = UNIQUE_REACTIONS[index];
            if (!kind) {
                continue;
            }

            // We probably need to find a way to make this less read hungry.
            // But for now, we'll just fetch the first reaction for each kind.
            functions.logger.info("Generating expected key for unique reaction kind", { kind });
            windowPromises.push(DataService.getDocumentWindowRaw({
                schemaKey: reactionSchemaKey,
                limit: 1,
                where: [
                    { fieldPath: "kind", op: "==", value: kind },
                    { fieldPath: "user_id", op: "==", value: userId },
                    { fieldPath: "activity_id", op: "in", value: activityIds },
                    { fieldPath: "origin", op: "==", value: origin },
                ],
            }));
        }

        const reactionWindows = await Promise.all(windowPromises);
        for (let index = 0; index < reactionWindows.length; index++) {
            const window = reactionWindows[index] as ReactionJSON[];
            if (!window || window.length === 0) {
                continue;
            }

            // Push all from the window to the reactions array if it is valid
            for (let index = 0; index < window.length; index++) {
                const reaction = window[index] as ReactionJSON;
                if (!reaction) {
                    continue;
                }

                reactions.push(reaction);
            }
        }

        functions.logger.info("Unique reactions for activities and user", { activityIds, userId, reactions });
        return reactions;
    }
}
