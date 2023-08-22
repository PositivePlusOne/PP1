import * as functions from "firebase-functions";

import { DefaultGenerics, FlatActivityEnriched, NewActivity, StreamClient, StreamFeed, connect } from "getstream";
import { FeedEntry, GetFeedWindowResult } from "../dto/stream";
import { FeedRequest } from "../dto/feed_dtos";
import { DEFAULT_USER_TIMELINE_FEED_SUBSCRIPTION_SLUGS } from "../constants/default_feeds";
import { ActivityActionVerb } from "../dto/activities";

export namespace FeedService {

  /**
   * Returns a StreamClient instance with the API key and secret.
   * @return {StreamClient<DefaultGenerics>} instance of StreamClient
   * @see https://getstream.io/chat/docs/node/tokens_and_authentication/?language=javascript
   */
  export function getFeedsClient(): StreamClient<DefaultGenerics> {
    functions.logger.info("Connecting to feeds", { structuredData: true });
    const apiKey = process.env.STREAM_API_KEY;
    const apiSecret = process.env.STREAM_API_SECRET;

    if (!apiKey || !apiSecret) {
      throw new Error("Missing Stream Feeds API key or secret");
    }

    return connect(apiKey, apiSecret, undefined, {
      browser: false,
    });
  }

  export function getFeedsUserClient(userId: string): StreamClient<DefaultGenerics> {
    const feedsServerClient = getFeedsClient();
    functions.logger.info("Connecting to feeds as user", { structuredData: true });

    const apiKey = process.env.STREAM_API_KEY;
    const apiSecret = process.env.STREAM_API_SECRET;
    const appId = process.env.STREAM_FEEDS_APP_ID;

    if (!apiKey || !apiSecret || !appId) {
      throw new Error("Missing Stream Feeds API key or secret");
    }

    const userToken = feedsServerClient.createUserToken(userId);

    return connect(apiKey, userToken, appId);
  }

  /**
   * Creates a user token for GetStream.
   * @param {string} userId the user's ID.
   * @return {string} a promise that resolves to the user's token.
   * @see https://getstream.io/chat/docs/node/tokens_and_authentication/?language=javascript
   */
  export function getUserToken(userId: string): string {
    functions.logger.info(`Creating user token ${userId}`);
    return getFeedsClient().createUserToken(userId);
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
  export async function getFeedWindow(uid: string, feed: StreamFeed<DefaultGenerics>, windowSize: number, next: string): Promise<GetFeedWindowResult> {
    functions.logger.info("Getting feed window", { feed, windowSize, next });

    const response = await feed.get({
      limit: windowSize,
      id_lt: next,
      user_id: uid,
      enrich: true,
      withReactionCounts: true,
      withOwnChildren: true,
      withOwnReactions: true,
      reactionKindsFilter: "like,bookmark,share,comment",
    });

    functions.logger.info("Got feed window", { feed, windowSize, next, response });

    const results = (response.results as FlatActivityEnriched<DefaultGenerics>[]).map((activity) => {
      functions.logger.info("Origin map", { activity, origin: activity.origin });

      return {
        id: activity?.id ?? "",
        foreign_id: activity?.foreign_id ?? "",
        object: activity?.object ?? "",
        actor: activity?.actor ?? "",
        reaction_counts: activity.reaction_counts,
        verb: activity?.verb ?? "",
      };
    }) as FeedEntry[];

    functions.logger.info("Mapped feed window", { feed, windowSize, next, results });

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

  /**
   * Adds an activity to a feed.
   * @param {StreamFeed<DefaultGenerics>} feed the feed to add the activity to.
   */
  export async function shareActivityToFeed(uid: string, senderUserFeed: StreamFeed<DefaultGenerics>, activityId: string): Promise<any> {
    const getStreamActivity: NewActivity<DefaultGenerics> = {
      actor: uid,
      verb: ActivityActionVerb.Share,
      object: activityId,
      foreign_id: activityId,
    };
    
    return senderUserFeed.addActivity(getStreamActivity);
  }
}
