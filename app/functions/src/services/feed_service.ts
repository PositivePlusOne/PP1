import * as functions from "firebase-functions";

import { DefaultGenerics, EnrichedActivity, StreamClient, StreamFeed, connect } from "getstream";
import { FeedEntry, GetFeedWindowResult } from "../dto/stream";
import { FeedRequest } from "../dto/feed_dtos";
import { DEFAULT_USER_TIMELINE_FEED_SUBSCRIPTION_SLUGS } from "../constants/default_feeds";

export namespace FeedService {
  /**
   * Returns a StreamClient instance with the API key and secret.
   * @return {StreamClient<DefaultGenerics>} instance of StreamClient
   * @see https://getstream.io/chat/docs/node/tokens_and_authentication/?language=javascript
   */
  export async function getFeedsClient(): Promise<StreamClient<DefaultGenerics>> {
    functions.logger.info("Connecting to feeds", { structuredData: true });
    const apiKey = process.env.STREAM_API_KEY;
    const apiSecret = process.env.STREAM_API_SECRET;

    if (!apiKey || !apiSecret) {
      throw new Error("Missing Stream Feeds API key or secret");
    }

    const client = connect(apiKey, apiSecret, undefined, {
      browser: false,
    });

    client.enrichByDefault = true;
    client.replaceReactionOptions({ withOwnChildren: true, withOwnReactions: true, withRecentReactions: true, withReactionCounts: true });

    return client;
  }

  /**
   * Creates a user token for GetStream.
   * @param {string} userId the user's ID.
   * @return {Promise<string>} a promise that resolves to the user's token.
   * @see https://getstream.io/chat/docs/node/tokens_and_authentication/?language=javascript
   */
  export async function getUserToken(client: StreamClient<DefaultGenerics>, userId: string): Promise<string> {
    functions.logger.info("Creating user token", { userId });

    const token = client.createUserToken(userId);
    functions.logger.info("User token", { token });

    return token;
  }

  /**
   * Verifies the integrity of the user's default timeline feed subscriptions.
   * @param {StreamClient<DefaultGenerics>} client the StreamClient instance.
   * @param {string} userId the user's ID.
   * @return {Promise<void>} a promise that resolves when the integrity check is complete.
   */
  export async function verifyDefaultFeedSubscriptionsForUser(client: StreamClient<DefaultGenerics>, userId: string): Promise<void> {
    functions.logger.info("Verifying default feed subscriptions for user", { userId });
    const userTimelineFeed = client.feed("timeline", userId);

    try {
      // Assumption check: The users flat feed should include predefined feeds including their own user feed.
      functions.logger.info("Verifying default timeline feed subscriptions for user", { userId });
      const expectedFeeds = [...DEFAULT_USER_TIMELINE_FEED_SUBSCRIPTION_SLUGS, { feed: "user", id: userId }];
      for (const expectedFeed of expectedFeeds) {
        const userTimelineFeedFollowing = await userTimelineFeed.following();
        const isFollowing = userTimelineFeedFollowing.results.some((feed) => feed.feed_id === expectedFeed.feed && feed.target_id === expectedFeed.id);

        if (!isFollowing) {
          functions.logger.info("Following feed", { feed: expectedFeed });
          await userTimelineFeed.follow(expectedFeed.feed, expectedFeed.id);
        }
      }
    } catch (error) {
      functions.logger.error("Error verifying default feed subscriptions for user", { userId, error });
      throw new Error("Error verifying default feed subscriptions for user");
    }

    functions.logger.info("Verified default feed subscriptions for user", { userId });
  }

  /**
   * Gets a feed window for a given feed.
   * @param {StreamFeed<DefaultGenerics>} feed the feed to get the window for.
   * @param {number} windowSize the size of the window.
   * @param {string} next the next token.
   * @return {Promise<GetFeedWindowResult>} a promise that resolves to the feed window.
   */
  export async function getFeedWindow(client: StreamClient<DefaultGenerics>, feed: StreamFeed<DefaultGenerics>, windowSize: number, next: string): Promise<GetFeedWindowResult> {
    functions.logger.info("Getting feed window", { feed, windowSize, next });

    const response = await feed.get({
      enrich: true,
      limit: windowSize,
      id_lt: next,
      withOwnChildren: true,
      withOwnReactions: true,
      withRecentReactions: true,
      withReactionCounts: true,
      ownReactions: true,
    });

    functions.logger.info("Got feed window", { feed, windowSize, next, response });

    const originMap = new Map<string, string>();
    const results = (response.results as EnrichedActivity<DefaultGenerics>[]).map((activity) => {
      originMap.set(activity.id, activity.origin ?? "");
      return {
        id: activity?.id ?? "",
        foreign_id: activity?.foreign_id ?? "",
        object: activity?.object ?? "",
        actor: activity?.actor ?? "",
        reaction_counts: activity.reaction_counts,
      };
    }) as FeedEntry[];

    // Add activity detail for each activity if not from the source feed
    for (const result of results) {
      const originFeedStr = originMap.get(result.id);
      const originFeed = originFeedStr?.split(":") ?? [];
      if (originFeed.length !== 2) {
        continue;
      }

      const originFeedSlug = originFeed[0];
      const originFeedUserId = originFeed[1];
      const originFeedInstance = client.feed(originFeedSlug, originFeedUserId);

      const activityDetailResponse = await originFeedInstance.getActivityDetail(result.object, {
        enrich: true,
        withOwnChildren: true,
        withOwnReactions: true,
        withRecentReactions: true,
        withReactionCounts: true,
        ownReactions: true,
        recentReactionsLimit: 3,
      });

      const activityCommentsResponse = await client.reactions.filter({
        activity_id: result.id,
        kind: "comment",
        limit: 3,
      });

      functions.logger.info("Got activity detail", { result, activityDetailResponse, originFeedSlug, originFeedUserId, activityCommentsResponse });
    }

    return {
      results,
      next: response?.next ?? "",
      unread: response?.unread ?? 0,
      unseen: response?.unseen ?? 0,
    };
  }

  /**
   * Follows a feed.
   * @param {StreamClient<DefaultGenerics>} client the Stream client.
   * @param {FeedRequest} source the source feed.
   * @param {FeedRequest} target the target feed.
   * @return {Promise<void>} a promise that resolves when the feed is followed.
   */
  export async function followFeed(client: StreamClient<DefaultGenerics>, source: FeedRequest, target: FeedRequest): Promise<void> {
    functions.logger.info("Following feed", { source, target });

    // Get the source and targets user feeds
    const sourceFeed = client.feed(source.feed, source.id);
    const targetFeed = client.feed(target.feed, target.id);

    // Follow the target feed
    await sourceFeed.follow(targetFeed.slug, targetFeed.userId);
    functions.logger.info("Feed followed", { source, target });
  }

  /**
   * Unfollows a feed.
   * @param {StreamClient<DefaultGenerics>} client the Stream client.
   * @param {FeedRequest} source the source feed.
   * @param {FeedRequest} target the target feed.
   * @return {Promise<void>} a promise that resolves when the feed is unfollowed.
   */
  export async function unfollowFeed(client: StreamClient<DefaultGenerics>, source: FeedRequest, target: FeedRequest): Promise<void> {
    functions.logger.info("Unfollowing feed", { source, target });

    if (!source || !target) {
      throw new Error("Missing source or target");
    }

    // Get the source and targets user feeds
    const sourceFeed = client.feed(source.feed, source.id);
    const targetFeed = client.feed(target.feed, target.id);

    // Follow the target feed
    await sourceFeed.unfollow(targetFeed.slug, targetFeed.userId);
    functions.logger.info("Feed unfollowed", { source, target });
  }
}
