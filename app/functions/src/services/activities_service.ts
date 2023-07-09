import * as functions from "firebase-functions";

import { DefaultGenerics, NewActivity, StreamClient } from "getstream";
import { Activity } from "../dto/activities";
import { FeedService } from "./feed_service";
import { SystemService } from "./system_service";

export namespace ActivitiesService {
  /**
   * Creates a list of activities.
   * @param {Activity[]} activities the activities to create.
   * @return {Promise<void>} a promise that resolves when the activities are created.
   */
  export async function createActivities(activities: Activity[]): Promise<void> {
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

    await flamelinkApp.content.add({
      schemaKey: "activities",
      data: activity,
    });

    functions.logger.info("Created activity", activity);
  }

  /**
   * Gets an activity.
   * @param {string} id the id of the activity.
   * @return {Promise<any>} a promise that resolves to the activity.
   */
  export async function getActivity(id: string): Promise<any> {
    functions.logger.info("Getting activity", { id });
    const flamelinkApp = SystemService.getFlamelinkApp();
    const activity = await flamelinkApp.content.get({
      schemaKey: "activities",
      entryId: id,
    });

    functions.logger.info("Got activity", activity);
    return activity;
  }

  /**
   * Posts an activity to GetStream.
   * @param {StreamClient<DefaultGenerics>} client the GetStream client.
   * @param {string} feedName the name of the feed to post to.
   * @param {string} actorId the id of the actor.
   * @param {any} activityData the activity data.
   * @return {Promise<void>} a promise that resolves when the activity is posted.
   */
  export async function addActivity(feedSlug: string, userID: string, activityData: NewActivity<DefaultGenerics>): Promise<NewActivity> {
    functions.logger.info("Adding activity", {
      feedSlug,
      userID,
      activityData,
    });
    const feed = (await FeedService.getFeedsClient()).feed(feedSlug, userID);
    return feed.addActivity(activityData);
  }

  /**
   * Unposts an activity from GetStream.
   * @param {StreamClient<DefaultGenerics>} client the GetStream client.
   * @param {string} feedName the name of the feed to post to.
   * @param {string} actorId the id of the actor.
   * @param {any} activityData the activity data.
   * @return {Promise<void>} a promise that resolves when the activity is unposted.
   */
  export async function unpostActivity(client: StreamClient<DefaultGenerics>, feedName: any, actorId: any, activityData: any): Promise<void> {
    functions.logger.info("Unposting activity", {
      feedName,
      actorId,
      activityData,
    });

    const feed = client.feed(feedName, actorId);
    await feed.removeActivity(activityData);
  }
}
