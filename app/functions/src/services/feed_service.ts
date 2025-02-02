import * as functions from "firebase-functions";

import { DefaultGenerics, PersonalizationAPIResponse, StreamClient, StreamFeed, connect } from "getstream";
import { FeedEntry, GetFeedWindowResult } from "../dto/stream";
import { FeedRequestJSON } from "../dto/feed_dtos";
import { DEFAULT_USER_TIMELINE_FEED_SUBSCRIPTION_SLUGS } from "../constants/default_feeds";
import { StreamHelpers } from "../helpers/stream_helpers";
import { ProfileJSON } from "../dto/profile";
import { FlamelinkHelpers } from "../helpers/flamelink_helpers";
import { TagsService } from "./tags_service";

export namespace FeedService {
  let streamClient = null as StreamClient<DefaultGenerics> | null;

  /**
   * Returns a StreamClient instance with the API key and secret.
   * @return {StreamClient<DefaultGenerics>} instance of StreamClient
   * @see https://getstream.io/chat/docs/node/tokens_and_authentication/?language=javascript
   */
  export function getFeedsClient(): StreamClient<DefaultGenerics> {
    if (streamClient) {
      return streamClient;
    }

    functions.logger.info("Connecting to feeds", { structuredData: true });
    const apiKey = process.env.STREAM_API_KEY;
    const apiSecret = process.env.STREAM_API_SECRET;

    if (!apiKey || !apiSecret) {
      throw new Error("Missing Stream Feeds API key or secret");
    }

    streamClient = connect(apiKey, apiSecret, undefined, {
      browser: false,
      keepAlive: true,
    });

    return streamClient;
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
  export async function verifyDefaultFeedSubscriptionsForUser(client: StreamClient<DefaultGenerics>, profile: ProfileJSON): Promise<void> {
    functions.logger.info("Verifying default feed subscriptions for user", { profile });
    const userId = FlamelinkHelpers.getFlamelinkIdFromObject(profile);
    if (!userId) {
      functions.logger.error("Missing user ID");
      return;
    }

    // We add the feed promotion tag to the user's tags to ensure that the user's timeline feed is subscribed to the feed promotion feed.
    const additionalTags = [...(profile.tags ?? [])].map((tag) => TagsService.formatTag(tag));

    try {
      // Assumption check: The users flat feed should include predefined feeds including their own user feed.
      functions.logger.info("Verifying default timeline feed subscriptions for user", { userId });
      const expectedFeeds = [...DEFAULT_USER_TIMELINE_FEED_SUBSCRIPTION_SLUGS, { targetSlug: "user", targetUserId: userId }] as FeedRequestJSON[];
      for (const additionalTag of additionalTags) {
        if (additionalTag.length === 0) {
          continue;
        }

        expectedFeeds.push({ targetSlug: "tags", targetUserId: additionalTag });
      }

      try {
        const userTimelineFeed = client.feed("timeline", userId);
        const userTimelineFeedFollowing = await userTimelineFeed.following();
        try {
          for (const expectedFeed of expectedFeeds) {
            const isFollowing = userTimelineFeedFollowing.results.some((feed) => feed.feed_id.split(":")[0] === expectedFeed.targetSlug && feed.feed_id.split(":")[1] === expectedFeed.targetUserId);
            if (!isFollowing) {
              functions.logger.info("Following feed", { feed: expectedFeed });
              await userTimelineFeed.follow(expectedFeed.targetSlug, expectedFeed.targetUserId);
            }
          }

          const nonExpectedFeeds = userTimelineFeedFollowing.results.filter((feed) => !expectedFeeds.some((expectedFeed) => feed.feed_id.split(":")[0] === expectedFeed.targetSlug && feed.feed_id.split(":")[1] === expectedFeed.targetUserId));
          for (const nonExpectedFeed of nonExpectedFeeds) {
            functions.logger.info("Unfollowing feed", { feed: nonExpectedFeed });
            await userTimelineFeed.unfollow(nonExpectedFeed.feed_id.split(":")[0], nonExpectedFeed.feed_id.split(":")[1]);
          }
        } catch (error) {
          // This may occur if the thing you're subscribing to doesn't exist anymore, or if the socket times out for a number of reasons.
          functions.logger.warn("Error following feed", { error });
        }
      } catch (timelineFollowing) {
        // This may be thrown if the timeline feed has recently been created.
        // For example a new user, as they will not have an existing timeline feed yet.
        functions.logger.warn("Error getting timeline feed following", { timelineFollowing });
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
    });

    const entries = [] as FeedEntry[];
    response.results.forEach((activity: any) => {
      entries.push({
        id: activity?.id ?? "",
        foreign_id: activity?.foreign_id ?? "",
        object: activity?.object ?? "",
        actor: activity?.actor ?? "",
        reaction_counts: activity.reaction_counts,
        verb: activity?.verb ?? "",
        actorType: activity?.actor_type ?? "",
        description: activity?.description ?? "",
        tags: activity?.tags ?? [],
        time: activity?.time ?? "",
        to: activity?.to ?? [],
      });
    });

    return {
      results: entries,
      next: response?.next ?? "",
      unread: response?.unread ?? 0,
      unseen: response?.unseen ?? 0,
      origin: StreamHelpers.getOriginFromFeed(feed),
    };
  }

  /**
   * Gets a feed window for a personalized feed.
   * @param {PersonalizationAPIResponse<DefaultGenerics>} response the response from the personalization API.
   * @param {number} windowSize the size of the window.
   * @param {string} next the next token.
   * @return {Promise<GetFeedWindowResult>} a promise that resolves to the feed window.
   */
  export async function getPersonalizedFeedWindow(uid: string, response: PersonalizationAPIResponse<DefaultGenerics>, windowSize: number): Promise<GetFeedWindowResult> {
    const entries = [] as FeedEntry[];
    response.results.forEach((activity: any) => {
      entries.push({
        id: activity?.id ?? "",
        foreign_id: activity?.foreign_id ?? "",
        object: activity?.object ?? "",
        actor: activity?.actor ?? "",
        reaction_counts: activity.reaction_counts,
        verb: activity?.verb ?? "",
        actorType: activity?.actor_type ?? "",
        description: activity?.description ?? "",
        tags: activity?.tags ?? [],
        time: activity?.time ?? "",
        to: activity?.to ?? [],
      });
    });

    return {
      results: entries,
      next: response?.next ?? "",
      origin: StreamHelpers.getOriginFromPersonalizedApiResponse(uid),
      unread: 0,
      unseen: 0,
    };
  }

  /**
   * Follows a feed.
   * @param {StreamClient<DefaultGenerics>} client the Stream client.
   * @param {FeedRequest} source the source feed.
   * @param {FeedRequest} target the target feed.
   * @return {Promise<void>} a promise that resolves when the feed is followed.
   */
  export async function followFeed(client: StreamClient<DefaultGenerics>, source: FeedRequestJSON, target: FeedRequestJSON): Promise<void> {
    functions.logger.info("Following feed", { source, target });

    if (!source.targetSlug || !target.targetSlug || !source.targetUserId || !target.targetUserId) {
      throw new Error("Missing feed or slug for follow request");
    }

    // Get the source and targets user feeds
    const sourceFeed = client.feed(source.targetSlug, source.targetUserId);
    const targetFeed = client.feed(target.targetSlug, target.targetUserId);

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
  export async function unfollowFeed(client: StreamClient<DefaultGenerics>, source: FeedRequestJSON, target: FeedRequestJSON): Promise<void> {
    functions.logger.info("Unfollowing feed", { source, target });

    if (!source.targetSlug || !target.targetSlug || !source.targetUserId || !target.targetUserId) {
      throw new Error("Missing source or target");
    }

    // Get the source and targets user feeds
    const sourceFeed = client.feed(source.targetSlug, source.targetUserId);
    const targetFeed = client.feed(target.targetSlug, target.targetUserId);

    // Follow the target feed
    await sourceFeed.unfollow(targetFeed.slug, targetFeed.userId);
    functions.logger.info("Feed unfollowed", { source, target });
  }
}
