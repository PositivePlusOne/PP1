import * as functions from "firebase-functions";

import { ReactionStatistics, ReactionStatisticsJSON, reactionStatisticsSchemaKey } from "../dto/reactions";

import { DataService } from "./data_service";
import { DefaultGenerics, StreamClient } from "getstream";
import { ReactionService } from "./reaction_service";

export namespace ReactionStatisticsService {
    export const REACTION_COUNT_TARGETS = ["like", "bookmark", "comment"];

    export function getExpectedKeyFromOptions(feed: string, activity_id?: string, reaction_id?: string, user_id?: string): string {
        return `${feed}:${activity_id}:${reaction_id}:${user_id}`;
    }

    export async function getReactionStatisticsForSenderAndActivity(client: StreamClient<DefaultGenerics>, feed: string, activity_id?: string, reaction_id?: string, user_id?: string): Promise<ReactionStatisticsJSON> {
        functions.logger.info("Getting reaction statistics", { feed, activity_id, reaction_id, user_id });

        // Once we have more and just the timeline feed, we should update this to be more generic.
        if (feed.startsWith("timeline:")) {
            functions.logger.debug("Swapping timeline feed for user feed in reaction statistics");
            feed = feed.replace("timeline:", "user:");
        }
        
        const expectedStats = new ReactionStatistics({
            feed,
            activity_id,
            reaction_id,
            user_id,
            counts: {},
        });

        const expectedKey = getExpectedKeyFromOptions(feed, activity_id, reaction_id, user_id);
        const statistics = await DataService.getOrCreateDocument(expectedStats, {
            schemaKey: reactionStatisticsSchemaKey,
            entryId: expectedKey,
        }) as ReactionStatisticsJSON;

        const uniqueReactionFutures = ReactionService.UNIQUE_REACTIONS.map((kind) => {
            return client.reactions.filter({
                activity_id,
                kind,
                limit: 1,
                user_id,
            });
        });

        const uniqueReactions = await Promise.all(uniqueReactionFutures);
        functions.logger.debug("Got unique reactions in activity enrichment", { uniqueReactions });

        if (!statistics.unique_user_reactions) {
            statistics.unique_user_reactions = {};
        }

        uniqueReactions.forEach((results, index) => {
            statistics.unique_user_reactions![ReactionService.UNIQUE_REACTIONS[index]] = results.results.length > 0;
        });

        return statistics;
    }

    export async function updateReactionCountForActivity(client: StreamClient<DefaultGenerics>, feed: string, activity_id: string, kind: string, offset: number): Promise<void> {
        if (!REACTION_COUNT_TARGETS.includes(kind)) {
            functions.logger.error(`Invalid reaction kind: ${kind}`);
            return;
        }

        const stats = await getReactionStatisticsForSenderAndActivity(client, feed, activity_id);
        stats.counts[kind] = (stats.counts[kind] ?? 0) + offset;

        // This should never happen, but to be safe; lets clamp the value to 0.
        if (stats.counts[kind] < 0) {
            stats.counts[kind] = 0;
        }

        functions.logger.info(`Updating reaction statistics`, { stats });

        const expectedKey = getExpectedKeyFromOptions(stats.feed, stats.activity_id, stats.reaction_id, stats.user_id);
        await DataService.updateDocument({
            schemaKey: reactionStatisticsSchemaKey,
            entryId: expectedKey,
            data: stats,
        });
    }
}