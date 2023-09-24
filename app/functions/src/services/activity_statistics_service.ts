import * as functions from "firebase-functions";

import { ActivityJSON, ActivityStatistics, ActivityStatisticsJSON, activityStatisticsSchemaKey } from "../dto/activities";

import { DataService } from "./data_service";
import { FlamelinkHelpers } from "../helpers/flamelink_helpers";
import { ReactionJSON } from "../dto/reactions";

export namespace ActivityStatisticsService {
    export const REACTION_COUNT_TARGETS = ["like", "bookmark", "comment"];

    export function getExpectedKeyFromOptions(origin: string, activity_id?: string, reaction_id?: string, user_id?: string): string {
        if (!origin) {
            throw new Error(`Invalid feed: ${origin} cannot generate expected key.`);
        }

        return `statistics:activity:${origin}:${activity_id ?? ""}:${reaction_id ?? ""}:${user_id ?? ""}`;
    }

    export async function getReactionStatisticsForActivityArray(activities: ActivityJSON[]): Promise<ActivityStatisticsJSON[]> {
        if (!activities || activities.length === 0) {
            return [];
        }

        const expectedKeys = [];
        for (const activity of activities) {
            if (!activity) {
                continue;
            }

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
            schemaKey: activityStatisticsSchemaKey,
            entryIds: expectedKeys,
        }) as ActivityStatisticsJSON[];
    }

    export function enrichStatisticsWithUniqueUserReactions(stats: ActivityStatisticsJSON[], reactions: ReactionJSON[]): ActivityStatisticsJSON[] {
        if (!reactions || reactions.length === 0) {
            functions.logger.info("No reactions to enrich statistics with unique user reactions");
            return stats;
        }

        return stats.map((stat) => {
            const id = FlamelinkHelpers.getFlamelinkIdFromObject(stat);
            if (!id) {
                functions.logger.error("Invalid reaction statistics", { stat });
                return stat;
            }

            stat.unique_user_reactions ??= {};
            for (let index = 0; index < reactions.length; index++) {
                const reaction = reactions[index] as ReactionJSON;
                if (!reaction || !reaction.activity_id || reaction.activity_id !== id) {
                    functions.logger.error("Invalid reaction", { reaction });
                    continue;
                }

                const reactionType = reaction.kind;
                if (!reactionType) {
                    functions.logger.error("Invalid reaction type", { reactionType });
                    continue;
                }

                stat.unique_user_reactions ??= {};
                stat.unique_user_reactions[reactionType] = true;
            }

            return stat;
        }).filter((stat) => stat);
    }

    export async function getActivityStatisticsForActivity(feed: string, activity_id: string): Promise<ActivityStatisticsJSON> {
        const expectedStats = new ActivityStatistics({
            feed,
            activity_id,
            counts: {},
        });

        const expectedKey = getExpectedKeyFromOptions(feed, activity_id);
        return await DataService.getOrCreateDocument(expectedStats, {
            schemaKey: activityStatisticsSchemaKey,
            entryId: expectedKey,
        }) as ActivityStatisticsJSON;
    }

    export async function updateReactionCountForActivity(feed: string, activity_id: string, kind: string, offset: number): Promise<ActivityStatisticsJSON> {
        functions.logger.info(`Updating reaction count for activity`, { feed, activity_id, kind, offset });
        if (!REACTION_COUNT_TARGETS.includes(kind)) {
            functions.logger.error(`Invalid reaction kind: ${kind}`);
            return {};
        }

        const stats = await getActivityStatisticsForActivity(feed, activity_id);
        stats.counts ??= {};
        stats.counts[kind] = (stats.counts[kind] ?? 0) + offset;
        functions.logger.info(`Kind: ${kind}, offset: ${offset}, new count: ${stats.counts[kind]}`);

        // This should never happen, but to be safe; lets clamp the value to 0.
        if (stats.counts[kind] < 0) {
            stats.counts[kind] = 0;
        }

        const expectedKey = getExpectedKeyFromOptions(feed, stats.activity_id);
        functions.logger.info(`Updating reaction statistics`, { stats, expectedKey });

        return await DataService.updateDocument({
            schemaKey: activityStatisticsSchemaKey,
            entryId: expectedKey,
            data: stats,
        });
    }
}