import * as functions from "firebase-functions";

import { ReactionJSON, reactionSchemaKey } from "../dto/reactions";
import { DataService } from "./data_service";
import { StreamClient, DefaultGenerics, StreamFeed, ReactionFilterConditions } from "getstream";
import { ReactionEntryJSON } from "../dto/stream";
import { ReactionStatisticsService } from "./reaction_statistics_service";
import { FlamelinkHelpers } from "../helpers/flamelink_helpers";
import { StreamHelpers } from "../helpers/stream_helpers";

export namespace ReactionService {
    
    export const VALID_REACTIONS = ["like", "dislike", "bookmark", "comment", "share"];
    export const UNIQUE_REACTIONS = ["like", "dislike", "bookmark", "share"];

    export function isUniqueReactionKind(kind: string) {
        return UNIQUE_REACTIONS.includes(kind);
    }

    export function verifyReactionKind(kind: string) {
        if (!VALID_REACTIONS.includes(kind)) {
            throw new Error(`Invalid reaction type: ${kind}`);
        }
    }

    export function getOriginFromFeedStringAndUserId(feed: string, userId: string): string {
        if (!feed || !userId) {
            throw new Error(`Invalid feed or user ID: ${feed}, ${userId}`);
        }

        // We convert the timeline feed to a user feed as having two feeds for the same user is confusing.
        if (feed === "timeline") {
            feed = "user";
        }

        return `${feed}:${userId}`;
    }

    export function generateReactionId(reaction: ReactionJSON): string {
        if (!reaction.kind || !reaction.activity_id || !reaction.user_id) {
            throw new Error(`Invalid reaction, cannot generate ID.`);
        }

        // Unique reactions have a fixed ID.
        // This way we can check if a user has already reacted to an activity without relying on the Stream API.
        if (isUniqueReactionKind(reaction.kind)) {
            return `${reaction.kind}:${reaction.activity_id ?? ""}:${reaction.user_id ?? ""}:${reaction.reaction_id ?? ""}:${reaction.origin ?? ""}`;
        }
        
        return FlamelinkHelpers.generateIdentifier();
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

        const reactionId = generateReactionId(reaction);
        const response = await client.reactions.add(reaction.kind!, reaction.activity_id!, reactionEntry, {
            userId: reaction.user_id,
            id: reactionId,
        });

        functions.logger.info("Added reaction", { response, reactionId });
        await ReactionStatisticsService.updateReactionCountForActivity(reaction.origin, reaction.activity_id, reaction.kind, 1);

        return DataService.updateDocument({
            schemaKey: reactionSchemaKey,
            entryId: reactionId,
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
        if (!reaction.activity_id || !reaction.origin || !reaction.kind || !reaction.reaction_id) {
            throw new Error(`Invalid reaction: ${JSON.stringify(reaction)}`);
        }

        await client.reactions.delete(reaction.reaction_id);
        await ReactionStatisticsService.updateReactionCountForActivity(reaction.origin, reaction.activity_id, reaction.kind, -1);

        await DataService.deleteDocument({
            schemaKey: reactionSchemaKey,
            entryId: reaction.reaction_id,
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
    export async function listUniqueReactionsForActivitiesAndUser(feed: StreamFeed, activityIds: string[], userId: string): Promise<ReactionJSON[]> {
        const reactionIds: string[] = [];
        for (const kind in UNIQUE_REACTIONS) {
            for (const activityId in activityIds) {
                const origin = StreamHelpers.getOriginFromFeed(feed);
                const expectedReactionJson = {
                    kind,
                    activity_id: activityId,
                    user_id: userId,
                    origin,
                    reaction_id: "",
                } as ReactionJSON;

                const reactionId = generateReactionId(expectedReactionJson);
                reactionIds.push(reactionId);
            }
        }

        return await DataService.getBatchDocuments({
            schemaKey: reactionSchemaKey,
            entryIds: reactionIds,
        }) as ReactionJSON[];
    }
}
