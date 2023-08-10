import { ReactionJSON, reactionSchemaKey } from "../dto/reactions";
import { DataService } from "./data_service";
import { StreamClient, DefaultGenerics } from "getstream";
import { FeedService } from "./feed_service";

export namespace ReactionService {
    
    const VALID_REACTIONS = ["like", "dislike"];

    export function verifyReactionType(reactionType: string) {
        if (!VALID_REACTIONS.includes(reactionType)) {
            throw new Error(`Invalid reaction type: ${reactionType}`);
        }
    }

    export async function addReaction(reaction: ReactionJSON): Promise<any> {
        const client: StreamClient<DefaultGenerics> = await FeedService.getFeedsClient();
        const response = await client.reactions.add(reaction.reactionType!, reaction.activityId!, {
            ...reaction,
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

    export async function updateReaction(reaction: ReactionJSON, reactionId: string): Promise<void> {
        const client: StreamClient<DefaultGenerics> = await FeedService.getFeedsClient();
        await client.reactions.update(reactionId, {
            ...reaction,
        });

        await DataService.updateDocument({
            schemaKey: reactionSchemaKey,
            entryId: reactionId,
            data: reaction,
        });
    }

    export async function deleteReaction(reactionId: string): Promise<void> {
        const client: StreamClient<DefaultGenerics> = await FeedService.getFeedsClient();
        await client.reactions.delete(reactionId);
        await DataService.deleteDocument({
            schemaKey: reactionSchemaKey,
            entryId: reactionId,
        });
    }

    export async function listReactions(activityId: string): Promise<ReactionJSON[]> {
        const client: StreamClient<DefaultGenerics> = await FeedService.getFeedsClient();
        const params: any = {
            activity_id: activityId,
            kind: 'reaction',
            limit: 100, // you might want to paginate this or adjust the number
        };

        const response = await client.reactions.filter(params);

        return response.results.map(reaction => reaction.data as ReactionJSON);
    }
}
