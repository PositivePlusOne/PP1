import * as functions from "firebase-functions";

import { DataService } from "./data_service";

import { FeedStatistics, FeedStatisticsJSON, feedStatisticsSchemaKey } from "../dto/feed_statistics";

export namespace FeedStatisticsService {
  export const FEED_COUNT_TARGETS = ["total_posts"];

  export function getExpectedKeyFromOptions(targetSlug?: string, targetUserId?: string): string {
    return `statistics:feed:${targetSlug ?? ""}:${targetUserId ?? ""}`;
  }

  export async function getFeedStatisticsForFeed(targetSlug: string, targetUserId: string): Promise<FeedStatisticsJSON> {
    const expectedStats = new FeedStatistics({
      target_slug: targetSlug,
      target_user_id: targetUserId,
      counts: {},
    });

    const expectedKey = getExpectedKeyFromOptions(targetSlug, targetUserId);
    return (await DataService.getOrCreateDocument(expectedStats, {
      schemaKey: feedStatisticsSchemaKey,
      entryId: expectedKey,
    })) as FeedStatisticsJSON;
  }

  export async function updateCountForFeedStatistics(target_slug: string, target_user_id: string, kind: string, offset: number): Promise<FeedStatisticsJSON> {
    functions.logger.info(`Updating counts for feed statistics`, { target_slug, target_user_id, offset });
    if (!FEED_COUNT_TARGETS.includes(kind)) {
      functions.logger.error(`Invalid feed kind: ${kind}`);
      return {
        target_slug,
        target_user_id,
        counts: {},
      };
    }

    const stats = await getFeedStatisticsForFeed(target_slug, target_user_id);
    stats.counts ??= {};
    stats.counts[kind] = (stats.counts[kind] ?? 0) + offset;
    functions.logger.info(`Kind: ${kind}, offset: ${offset}, new count: ${stats.counts[kind]}`);

    // This should never happen, but to be safe; lets clamp the value to 0.
    if (stats.counts[kind] < 0) {
      stats.counts[kind] = 0;
    }

    const expectedKey = getExpectedKeyFromOptions(stats.target_slug, stats.target_user_id);
    functions.logger.info(`Updating feed statistics`, { stats, expectedKey });

    return await DataService.updateDocument({
      schemaKey: feedStatisticsSchemaKey,
      entryId: expectedKey,
      data: stats,
    });
  }
}
