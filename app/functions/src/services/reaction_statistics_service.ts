import * as functions from "firebase-functions";

import { ActivityJSON } from "../dto/activities";

import { DataService } from "./data_service";
import { FlamelinkHelpers } from "../helpers/flamelink_helpers";

import { ReactionStatistics, ReactionStatisticsJSON, reactionStatisticsSchemaKey } from "../dto/reaction_statistics";

export namespace ReactionStatisticsService {
    export const REACTION_COUNT_TARGETS = ["like", "bookmark", "comment"];

    export function getExpectedKeyFromOptions(activity_id?: string): string {
        return `statistics:activity:${activity_id ?? ""}`;
    }

    export async function getReactionStatisticsForActivityArray(activities: ActivityJSON[]): Promise<ReactionStatisticsJSON[]> {
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

            const key = getExpectedKeyFromOptions(id);
            expectedKeys.push(key);
        }

        functions.logger.info("Getting reaction statistics for activity array", { expectedKeys });

        return await DataService.getBatchDocuments({
            schemaKey: reactionStatisticsSchemaKey,
            entryIds: expectedKeys,
        }) as ReactionStatisticsJSON[];
    }

    export async function getReactionStatisticsForActivity(activity_id: string): Promise<ReactionStatisticsJSON> {
        const expectedStats = new ReactionStatistics({
            activity_id,
            counts: {},
        });

        const expectedKey = getExpectedKeyFromOptions(activity_id);
        return await DataService.getOrCreateDocument(expectedStats, {
            schemaKey: reactionStatisticsSchemaKey,
            entryId: expectedKey,
        }) as ReactionStatisticsJSON;
    }

    export async function updateReactionCountForActivity(feed: string, activity_id: string, kind: string, offset: number): Promise<ReactionStatisticsJSON> {
        functions.logger.info(`Updating reaction count for activity`, { feed, activity_id, kind, offset });
        if (!REACTION_COUNT_TARGETS.includes(kind)) {
            functions.logger.error(`Invalid reaction kind: ${kind}`);
            return {};
        }

        const stats = await getReactionStatisticsForActivity(activity_id);
        stats.counts ??= {};
        stats.counts[kind] = (stats.counts[kind] ?? 0) + offset;
        functions.logger.info(`Kind: ${kind}, offset: ${offset}, new count: ${stats.counts[kind]}`);

        // This should never happen, but to be safe; lets clamp the value to 0.
        if (stats.counts[kind] < 0) {
            stats.counts[kind] = 0;
        }

        const expectedKey = getExpectedKeyFromOptions(stats.activity_id);
        functions.logger.info(`Updating reaction statistics`, { stats, expectedKey });

        return await DataService.updateDocument({
            schemaKey: reactionStatisticsSchemaKey,
            entryId: expectedKey,
            data: stats,
        });
    }
}