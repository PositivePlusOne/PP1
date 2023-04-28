import * as functions from "firebase-functions";

import { DefaultGenerics, StreamClient, connect } from "getstream";
import { Activity } from "../dto/activities";
import { FeedBatchedClientResponse, FeedEntry } from "../dto/stream";
import { RelationshipService } from "./relationship_service";
import { ProfileService } from "./profile_service";
import { StreamActorType } from "./enumerations/actors";

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
  export async function getUserToken(userId: string): Promise<string> {
    functions.logger.info("Creating user token", { userId });
    const feedsClient = await getFeedsClient();

    const token = feedsClient.createUserToken(userId);
    functions.logger.info("User token", { token });

    return token;
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
