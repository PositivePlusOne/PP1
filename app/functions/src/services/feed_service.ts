import * as functions from "firebase-functions";

import { DefaultGenerics, StreamClient, connect } from "getstream";
import { Activity } from "../dto/activities";
import { FeedBatchedClientResponse, FeedEntry } from "../dto/stream";
import { RelationshipService } from "./relationship_service";
import { ProfileService } from "./profile_service";
import { OrganisationService } from "./organisation_service";
import { StreamActorType } from "./enumerations/actors";

export namespace FeedService {
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
   * Processes a list of feed entries for a user.
   * @param {string} uid the user's ID.
   * @param {FeedEntry[]} entries the feed entries to process.
   * @return {Promise<void>} a promise that resolves when the feed entries are processed.
   */
  export async function processFeedEntriesForUser(
    uid: string,
    entries: FeedEntry[]
  ): Promise<FeedBatchedClientResponse> {
    functions.logger.info("Processing feed entries for user", { entries });
    const profiles = [];
    const organisations = [];

    // Get a list of unique foreign keys from the feed entries
    const foreignKeys = entries
      .map((entry) => entry.foreign_id)
      .filter((value, index, self) => self.indexOf(value) === index);

    // Get a list of unique actors from the feed entries
    const actors = entries
      .map((entry) => entry.actor)
      .filter((value, index, self) => self.indexOf(value) === index);

    // Create a list from the foreign keys and actors, removing the user's ID
    const foreignKeysAndActors = foreignKeys
      .concat(actors)
      .filter((value) => value !== uid);

    // Removes all relationships that are not able to be seen by the user
    const sanitizedForeignKeysAndActors =
      await RelationshipService.sanitizeRelationships(
        uid,
        foreignKeysAndActors
      );

    // Grabs all the data from firestore
    for (const foreignKey of sanitizedForeignKeysAndActors) {
      const actorType = entries.find(
        (entry) => entry.foreign_id === foreignKey
      )?.actorType;

      if (!actorType) {
        continue;
      }

      try {
        switch (actorType) {
          case StreamActorType.user:
            const profile = await ProfileService.getUserProfile(foreignKey);
            if (profile) {
              functions.logger.info("Profile found", { profile });
              profiles.push(profile);
            }
            case StreamActorType.organisation:
            const organisation = await OrganisationService.getOrganisation(
              foreignKey
            );
            if (organisation) {
              functions.logger.info("Organisation found", { organisation });
              organisations.push(organisation);
            }
          default:
            break;
        }
      } catch (error) {
        functions.logger.error(
          "Error getting data from firestore for foreign key",
          { foreignKey, error }
        );
      }
    }

    return {
      profiles,
      organisations,
      activities: [],
    };
  }
}
