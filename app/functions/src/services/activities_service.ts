import * as functions from "firebase-functions";

import { v4 as uuidv4 } from "uuid";

import { Activity } from "../dto/activities";
import { SystemService } from "./system_service";
import { FeedService } from "./feed_service";
import { DefaultGenerics, StreamClient } from "getstream";
import { StreamActorType } from "./enumerations/actors";

export namespace ActivitiesService {
  /**
   * Creates a list of activities.
   * @param {Activity[]} activities the activities to create.
   * @return {Promise<void>} a promise that resolves when the activities are created.
   */
  export async function createActivities(
    activities: Activity[]
  ): Promise<void> {
    functions.logger.info("Creating activities", activities);
    for (const activity of activities) {
      await createActivity(activity);
    }
  }

  /**
   * Creates an activity.
   * @param {Activity} activity the activity to create.
   * @return {Promise<void>} a promise that resolves when the activity is created.
   */
  export async function createActivity(activity: Activity): Promise<void> {
    functions.logger.info("Creating activity", activity);
    const flamelinkApp = SystemService.getFlamelinkApp();

    // Create a guid foreign key for the activity if it doesn't exist
    if (!activity.foreignKey) {
      activity.foreignKey = uuidv4();
      functions.logger.info("Created foreign key for activity", activity);
    }

    await flamelinkApp.content.add({
      schemaKey: "activities",
      entryId: activity.foreignKey,
      data: activity,
    });

    functions.logger.info("Created activity", activity);
  }

  /**
   * Publishes a list of activities.
   * @param {Activity[]} activities the activities to publish.
   * @param {StreamClient<DefaultGenerics>} client the Stream client.
   * @param {StreamActorType} actorType the type of actor.
   * @return {Promise<void>} a promise that resolves when the activities are published.
   */
  export async function publishActivities(
    activities: Activity[],
    client: StreamClient<DefaultGenerics>,
    actorType: StreamActorType
  ): Promise<void> {
    functions.logger.info("Publishing activities", activities);
    for (const activity of activities) {
      await publishActivity(activity, client, actorType);
    }
  }

  /**
   * Publishes an activity.
   * @param {Activity} activity the activity to publish.
   * @param {StreamClient<DefaultGenerics>} client the Stream client.
   * @param {StreamActorType} actorType the type of actor.
   * @return {Promise<void>} a promise that resolves when the activity is published.
   */
  export async function publishActivity(
    activity: Activity,
    client: StreamClient<DefaultGenerics>,
    actorType: StreamActorType
  ): Promise<void> {
    functions.logger.info("Publishing activity", activity);

    if (activity.publisherInformation.published) {
      functions.logger.info("Activity already published", activity);
      return;
    }

    await FeedService.publishActivity(activity, client, {
      feed: "event",
      verb: "post",
      publisher: activity.publisherInformation.foreignKey,
      actor: activity.publisherInformation.foreignKey,
      actorType: actorType,
    });

    functions.logger.info("Published activity", activity);
  }

  /**
   * Gets the activities for an event.
   * @return {Promise<Activity[]>} a promise that resolves with the activities for an event.
   */
  export async function getEventActivities(): Promise<Activity[]> {
    const flamelinkApp = SystemService.getFlamelinkApp();

    // TODO(ryan): This needs to be paginated
    const activities = (await flamelinkApp.content.get({
      schemaKey: "activities",
    })) as Activity[];

    return activities;
  }
}
