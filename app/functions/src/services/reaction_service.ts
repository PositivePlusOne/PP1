import * as functions from "firebase-functions";

import { ReactionJSON, reactionSchemaKey } from "../dto/reactions";
import { DataService } from "./data_service";
import { StreamClient, DefaultGenerics, ReactionFilterConditions } from "getstream";
import { FeedService } from "./feed_service";
import { ReactionEntryJSON } from "../dto/stream";

export namespace ReactionService {
    
    export const VALID_REACTIONS = ["like", "dislike", "bookmark"];
    export const UNIQUE_REACTIONS = ["like", "dislike", "bookmark"];

    export function isUniqueReaction(kind: string) {
        return UNIQUE_REACTIONS.includes(kind);
    }

    export function verifyReactionKind(kind: string) {
        if (!VALID_REACTIONS.includes(kind)) {
            throw new Error(`Invalid reaction type: ${kind}`);
        }
    }

    export async function getUniqueReactionForSenderAndActivity(kind: string, senderId: string, activity_id: string): Promise<ReactionJSON | null> {
        const client: StreamClient<DefaultGenerics> = FeedService.getFeedsClient();
        const activityParams: ReactionFilterConditions = {
            activity_id: activity_id,
            filter_user_id: senderId,
            kind: kind,
            limit : 1,
        };

        const response = await client.reactions.filter(activityParams);

        if (response.results.length > 0) {
            functions.logger.info(`getUniqueReactionForSenderAndActivity`, { activity_id, senderId, response });
            return response.results[0].data as ReactionJSON;
        }

        return null;
    }

    export async function addReaction(client: StreamClient<DefaultGenerics>, reaction: ReactionJSON): Promise<any> {
        if (!reaction.activity_id || !reaction.origin || !reaction.kind) {
            throw new Error(`Invalid reaction: ${JSON.stringify(reaction)}`);
        }

        const reactionEntry = {
            kind: reaction.kind,
            activity_id: reaction.activity_id,
            user_id: reaction.user_id,
        } as ReactionEntryJSON;

        const response = await client.reactions.add(reaction.kind!, reaction.activity_id!, reactionEntry, {
            userId: reaction.user_id,
        });

        return await DataService.updateDocument({
            schemaKey: reactionSchemaKey,
            entryId: response.id,
            data: reaction,
        });
    }

    export async function getReaction(reactionId: string): Promise<ReactionJSON> {
        return DataService.getDocument({
            schemaKey: reactionSchemaKey,
            entryId: reactionId,
        }) as ReactionJSON;
    }

    export async function updateReaction(client: StreamClient<DefaultGenerics>, reaction: ReactionJSON, reactionId: string): Promise<void> {
        await client.reactions.update(reactionId, {...reaction});
        await DataService.updateDocument({
            schemaKey: reactionSchemaKey,
            entryId: reactionId,
            data: reaction,
        });
    }

    export async function deleteReaction(client: StreamClient<DefaultGenerics>, reactionId: string): Promise<void> {
        await client.reactions.delete(reactionId);
        await DataService.deleteDocument({
            schemaKey: reactionSchemaKey,
            entryId: reactionId,
        });
    }

    export async function listReactionsForActivity(client: StreamClient<DefaultGenerics>, kind: string, activity_id: string): Promise<ReactionJSON[]> {
        const params: any = {
            activity_id: activity_id,
            kind: kind,
            limit: 100,
        };

        const response = await client.reactions.filter(params);

        functions.logger.info(`listReactionsForActivity`, { activity_id, response });

        return response.results.map((reaction: any) => reaction.data as ReactionJSON);
    }

    export async function listReactionsForUser(client: StreamClient<DefaultGenerics>, userId: string): Promise<ReactionJSON[]> {
        const params: any = {
            user_id: userId,
            kind: 'reaction',
            limit: 100,
        };

        const response = await client.reactions.filter(params);

        return response.results.map((reaction: any) => reaction.data as ReactionJSON);
    }
}
