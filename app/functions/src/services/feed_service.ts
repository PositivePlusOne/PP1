import * as functions from "firebase-functions";

import { DefaultGenerics, EnrichedActivity, StreamClient, StreamFeed, connect } from "getstream";
import { Activity } from "../dto/activities";
import { FeedBatchedClientResponse, FeedEntry, GetFeedWindowResult } from "../dto/stream";
import { RelationshipService } from "./relationship_service";
import { ProfileService } from "./profile_service";
import { StreamActorType } from "./enumerations/actors";
import { FeedRequest } from "../dto/feed_dtos";
import { DEFAULT_USER_TIMELINE_FEED_SUBSCRIPTION_SLUGS } from "../constants/default_feeds";

export namespace FeedService {
  type ActorFetchResolver = {
    [StreamActorType.user]: typeof ProfileService.getProfile;
    [StreamActorType.organisation]: typeof ProfileService.getProfile;
  };

  const actorTypeToServiceMap: ActorFetchResolver = {
    [StreamActorType.user]: ProfileService.getProfile,
    [StreamActorType.organisation]: ProfileService.getProfile,
  };

  /**
   * Returns a StreamClient instance with the API key and secret.
   * @return {StreamClient<DefaultGenerics>} instance of StreamClient
   * @see https://getstream.io/chat/docs/node/tokens_and_authentication/?language=javascript
   */
  export async function getFeedsClient(): Promise<
    StreamClient<DefaultGenerics>
  > {
    functions.logger.info("Connecting to feeds", { structuredData: true });
    const apiKey = process.env.STREAM_FEEDS_API_KEY;
    const apiSecret = process.env.STREAM_FEEDS_API_SECRET;

    if (!apiKey || !apiSecret) {
      throw new Error("Missing Stream Feeds API key or secret");
    }

    return connect(apiKey, apiSecret);
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
   * Verifies the integrity of the user's default feed subscriptions.
   * @param {StreamClient<DefaultGenerics>} client the StreamClient instance.
   * @param {string} userId the user's ID.
   * @return {Promise<void>} a promise that resolves when the integrity check is complete.
   */
  export async function verifyDefaultFeedSubscriptionsForUser(
    client: StreamClient<DefaultGenerics>,
    userId: string
  ): Promise<void> {
    functions.logger.info("Verifying default feed subscriptions for user", { userId });
    const userFlatFeed = client.feed("user", userId);

    try {
      // Assumption check: The users flat feed should include predefined feeds.
      functions.logger.info("Verifying default timeline feed subscriptions for user", { userId });
      for (const expectedFeed of DEFAULT_USER_TIMELINE_FEED_SUBSCRIPTION_SLUGS) {
        const userFlatFeedFollowing = await userFlatFeed.following();
        const isFollowing = userFlatFeedFollowing.results.some(
          (feed) =>
            feed.feed_id === expectedFeed.feed &&
            feed.target_id === expectedFeed.id
        );

        if (!isFollowing) {
          functions.logger.info("Following flat feed", { feed: expectedFeed });
          await userFlatFeed.follow(expectedFeed.feed, expectedFeed.id);
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
  export async function getFeedWindow(
    feed: StreamFeed<DefaultGenerics>,
    windowSize: number,
    next: string
  ): Promise<GetFeedWindowResult> {
    functions.logger.info("Getting feed window", { feed, windowSize, next });

    const response = await feed.get({ withOwnChildren: true, withOwnReactions: true });
    const results = (response.results as EnrichedActivity<DefaultGenerics>[]).map((activity) => {
      return {
        id: activity?.id ?? "",
        object: activity?.object ?? "",
        actor: activity?.actor ?? "",
      };
    }) as FeedEntry[];

    functions.logger.info("Got feed window", { feed, windowSize, next, results });

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
  export async function followFeed(
    client: StreamClient<DefaultGenerics>,
    source: FeedRequest,
    target: FeedRequest,
  ): Promise<void> {
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
  export async function unfollowFeed(
    client: StreamClient<DefaultGenerics>,
    source: FeedRequest,
    target: FeedRequest
  ): Promise<void> {
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
   * Publishes an activity to a feed.
   * @param {Activity} activity the activity to publish.
   * @param {StreamClient<DefaultGenerics>} client the Stream client.
   * @param {any} options the options to use.
   * @return {Promise<void>} a promise that resolves when the activity is published.
   */
  export async function publishActivity(
    activity: Activity,
    client: StreamClient<DefaultGenerics>,
    options = {
      feed: "user",
      publisher: "",
      verb: "",
      actor: "",
      actorType: "user",
    }
  ): Promise<void> {
    functions.logger.info("Publishing activity with options", {
      activity,
      options,
    });

    if (
      !options.feed ||
      !options.publisher ||
      !options.verb ||
      !options.actor
    ) {
      throw new Error("Missing options");
    }

    const feed = client.feed(options.feed, options.publisher);

    const activityData = {
      actor: options.actor,
      verb: options.verb,
      object: activity.foreignKey,
      foreign_id: activity.foreignKey,
      actorType: options.actorType,
    } as FeedEntry;

    await feed.addActivity(activityData);
    functions.logger.info("Activity published", { activityData });
  }

  /**
   * Processes feed entries for a user.
   * @param {string} uid the user's ID.
   * @param {FeedEntry[]} entries the feed entries.
   * @return {Promise<FeedBatchedClientResponse>} a promise that resolves to the feed entries.
   */
  export async function processFeedEntriesForUser(
    uid: string,
    entries: FeedEntry[]
  ): Promise<FeedBatchedClientResponse> {
    functions.logger.info("Processing feed entries for user", { entries });

    const unique = (value: any, index: number, self: any[]) =>
      self.indexOf(value) === index;

    const foreignKeys = entries.map((entry) => entry.foreign_id).filter(unique);
    const actors = entries.map((entry) => entry.actor).filter(unique);
    const foreignKeysAndActors = foreignKeys
      .concat(actors)
      .filter((value) => value !== uid);

    const sanitizedForeignKeysAndActors =
      await RelationshipService.sanitizeRelationships(
        uid,
        foreignKeysAndActors
      );

    const profiles: any[] = [];
    const organisations: any[] = [];

    const fetchProfileOrOrganisation = async (foreignKey: string) => {
      const actorType = entries.find(
        (entry) => entry.foreign_id === foreignKey
      )?.actorType;

      if (!actorType) return;

      try {
        const result = await actorTypeToServiceMap[actorType](foreignKey);

        if (result) {
          functions.logger.info(`${actorType} found`, { [actorType]: result });

          if (actorType === StreamActorType.user) {
            profiles.push(result);
          } else {
            organisations.push(result);
          }
        }
      } catch (error) {
        functions.logger.error(
          "Error getting data from firestore for foreign key",
          {
            foreignKey,
            error,
          }
        );
      }
    };

    await Promise.all(
      sanitizedForeignKeysAndActors.map(fetchProfileOrOrganisation)
    );

    return { profiles, organisations, activities: [] };
  }
}
