import * as functions from "firebase-functions";

import { ReactionStatistics, ReactionStatisticsJSON, reactionStatisticsSchemaKey } from "../dto/reactions";

import { DataService } from "./data_service";
import { DefaultGenerics, StreamClient, StreamFeed } from "getstream";
import { ReactionService } from "./reaction_service";

export namespace ReactionStatisticsService {
    export const REACTION_COUNT_TARGETS = ["like", "bookmark", "comment"];

    export function getExpectedKeyFromOptions(feed: string, activity_id?: string, reaction_id?: string, user_id?: string): string {
        return `${feed}:${activity_id}:${reaction_id}:${user_id}`;
    }

    export async function getReactionStatisticsForActivityArray(feed: string, activity_ids: string[]): Promise<ReactionStatisticsJSON[]> {
        const expectedKeys = activity_ids.map((activity_id) => getExpectedKeyFromOptions(feed, activity_id));
        return await DataService.getBatchDocuments({
            schemaKey: reactionStatisticsSchemaKey,
            entryIds: expectedKeys,
        }) as ReactionStatisticsJSON[];
    }

    export async function getReactionStatisticsForActivity(feed: string, activity_id: string): Promise<ReactionStatisticsJSON> {
        functions.logger.info("Getting reaction statistics", { feed, activity_id });
        const expectedStats = new ReactionStatistics({
            feed,
            activity_id,
            counts: {},
        });

        const expectedKey = getExpectedKeyFromOptions(feed, activity_id);
        return await DataService.getOrCreateDocument(expectedStats, {
            schemaKey: reactionStatisticsSchemaKey,
            entryId: expectedKey,
        }) as ReactionStatisticsJSON;
    }

    export async function enrichReactionStatisticsWithUserInformation(feed: StreamFeed, userId: string, reactionStatistics: ReactionStatisticsJSON[]): Promise<ReactionStatisticsJSON[]> {
        const activityIds = reactionStatistics.map((stats) => stats?.activity_id ?? null);
        activityIds.filter((activityId) => typeof activityId === "string" && activityId.length > 0);

        if (activityIds.length === 0) {
            functions.logger.info("No activity ids to enrich with user information");
            return reactionStatistics;
        }

        const uniqueReactions = await ReactionService.listUniqueReactionsForActivitiesAndUser(feed, activityIds as string[], userId);
        for (const stats of reactionStatistics) {
            if (!stats) {
                continue;
            }
            
            stats.unique_user_reactions ??= {};
            for (const reaction of uniqueReactions) {
                if (reaction.kind && reaction.activity_id === stats.activity_id) {
                    stats.unique_user_reactions[reaction.kind] = true;
                }
            }
        }

        return reactionStatistics;
    }

    export async function updateReactionCountForActivity(client: StreamClient<DefaultGenerics>, feed: string, activity_id: string, kind: string, offset: number): Promise<void> {
        if (!REACTION_COUNT_TARGETS.includes(kind)) {
            functions.logger.error(`Invalid reaction kind: ${kind}`);
            return;
        }

        const stats = await getReactionStatisticsForActivity(feed, activity_id);
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