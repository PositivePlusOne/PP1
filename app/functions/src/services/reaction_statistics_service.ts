import * as functions from "firebase-functions";

import { ReactionStatistics, ReactionStatisticsJSON, reactionStatisticsSchemaKey } from "../dto/reactions";

import { DataService } from "./data_service";
import { StreamFeed } from "getstream";
import { ReactionService } from "./reaction_service";
import { ActivityJSON } from "../dto/activities";
import { FlamelinkHelpers } from "../helpers/flamelink_helpers";

export namespace ReactionStatisticsService {
    export const REACTION_COUNT_TARGETS = ["like", "bookmark", "comment"];

    export function getExpectedKeyFromOptions(origin: string, activity_id?: string, reaction_id?: string, user_id?: string): string {
        if (!origin) {
            throw new Error(`Invalid feed: ${origin} cannot generate expected key.`);
        }

        return `${origin}:${activity_id ?? ""}:${reaction_id ?? ""}:${user_id ?? ""}`;
    }

    export async function getReactionStatisticsForActivityArray(activities: ActivityJSON[]): Promise<ReactionStatisticsJSON[]> {
        if (!activities || activities.length === 0) {
            return [];
        }

        const expectedKeys = [];
        for (const activity of activities) {
            const id = FlamelinkHelpers.getFlamelinkIdFromObject(activity);
            if (!id || !activity.publisherInformation?.originFeed) {
                functions.logger.error("Invalid activity", { activity });
                continue;
            }

            const key = getExpectedKeyFromOptions(activity.publisherInformation!.originFeed!, id);
            expectedKeys.push(key);
        }

        functions.logger.info("Getting reaction statistics for activity array", { expectedKeys });

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

        functions.logger.info("Enriching reaction statistics with user information", { activityIds });

        const uniqueReactions = await ReactionService.listUniqueReactionsForActivitiesAndUser(feed, activityIds as string[], userId);
        functions.logger.info("Unique reactions", { uniqueReactions });

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

        functions.logger.info("Enriched reaction statistics with user information", { reactionStatistics });
        return reactionStatistics;
    }

    export async function updateReactionCountForActivity(feed: string, activity_id: string, kind: string, offset: number): Promise<void> {
        functions.logger.info(`Updating reaction count for activity`, { feed, activity_id, kind, offset });

        if (!REACTION_COUNT_TARGETS.includes(kind)) {
            functions.logger.error(`Invalid reaction kind: ${kind}`);
            return;
        }

        const stats = await getReactionStatisticsForActivity(feed, activity_id);
        stats.counts ??= {};
        stats.counts[kind] = (stats.counts[kind] ?? 0) + offset;
        functions.logger.info(`Kind: ${kind}, offset: ${offset}, new count: ${stats.counts[kind]}`);

        // This should never happen, but to be safe; lets clamp the value to 0.
        if (stats.counts[kind] < 0) {
            stats.counts[kind] = 0;
        }

        const expectedKey = getExpectedKeyFromOptions(feed, stats.activity_id, stats.reaction_id, stats.user_id);
        functions.logger.info(`Updating reaction statistics`, { stats, expectedKey });

        await DataService.updateDocument({
            schemaKey: reactionStatisticsSchemaKey,
            entryId: expectedKey,
            data: stats,
        });
    }
}