import * as functions from "firebase-functions";

import { v1 as uuidv1 } from "uuid";

import { DefaultGenerics, NewActivity } from "getstream";
import { Activity, ActivityActionVerb, ActivityJSON } from "../dto/activities";
import { FeedService } from "./feed_service";
import { SystemService } from "./system_service";
import { DataService } from "./data_service";
import { TagsService } from "./tags_service";
import { FeedName } from "../constants/default_feeds";
import { FeedEntry } from "../dto/stream";

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
   * Verifies that an activity exists.
   * @param {string} activityId the id of the activity.
   * @return {Promise<void>} a promise that resolves when the activity exists.
   * @throws {functions.https.HttpsError} if the activity does not exist.
   */
  export async function verifyActivityExists(activityId: string): Promise<void> {
    const activity = await getActivity(activityId);
    if (!activity) {
      throw new functions.https.HttpsError("invalid-argument", "Activity does not exist");
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
   * @return {Promise<ActivityJSON>} a promise that resolves to the activity.
   */
  export async function getActivity(id: string, skipCacheLookup = false): Promise<ActivityJSON> {
    return await DataService.getDocument({
      schemaKey: "activities",
      entryId: id,
    }, skipCacheLookup) as ActivityJSON;
  }

  /**
   * Gets a list of activities from a list of feed entrys.
   * @param {FeedEntry[]} entrys the feed entrys to get the activities for.
   * @return {Promise<ActivityJSON[]>} a promise that resolves to the activities.
   */
  export async function getActivityFeedWindow(entrys: FeedEntry[]): Promise<ActivityJSON[]> {
    return Promise.all(entrys.map(async (entry) => {
      const activity = await getActivity(entry.object) as ActivityJSON;

      switch (entry.verb) {
        case ActivityActionVerb.Post:
          break;
        default:
          const actorId = entry.actor;
          activity.publisherInformation ??= {};
          activity.publisherInformation.actorId = actorId;

          activity.generalConfiguration ??= {};
          activity.generalConfiguration.type = entry.verb as ActivityActionVerb || "post";
          break;
      }

      return activity;
    }));
  }

  /**
   * Posts an activity to the users feed and all the tags feeds.
   * @param {StreamClient<DefaultGenerics>} client the GetStream client.
   * @param {string} feedName the name of the feed to post to.
   * @param {string} actorId the id of the actor.
   * @param {any} activityData the activity data.
   * @return {Promise<ActivityJSON>} a promise that resolves when the activity is posted.
   */
  export async function postActivity(userID: string, feedName: string, activity: ActivityJSON): Promise<ActivityJSON> {
    functions.logger.info("Adding activity", {
      userID,
      activity,
    });

    const activityObjectForeignId = uuidv1();
    const targets = [] as string[];

    if (activity.securityConfiguration?.viewMode === "private") {
      throw new functions.https.HttpsError("permission-denied", "You do not have permission to post this activity.");
    }

    if (activity.securityConfiguration?.viewMode === "public") {
      functions.logger.info("Adding tags to public activity", {
        tags: activity.enrichmentConfiguration?.tags,
      });

      activity.enrichmentConfiguration?.tags?.forEach(async (tag) => {
        await TagsService.createTagIfNonexistant(tag);
        targets.push(`${FeedName.Tags}:${tag}`);
      });
    }

    const getStreamActivity: NewActivity<DefaultGenerics> = {
      actor: userID,
      verb: ActivityActionVerb.Post,
      object: activityObjectForeignId,
      foreign_id: activityObjectForeignId,
      to: targets,
    };

    const feed = (await FeedService.getFeedsClient()).feed(feedName, userID);
    await feed.addActivity(getStreamActivity);

    const activityResponse = await DataService.updateDocument({
      schemaKey: "activities",
      data: activity,
      entryId: activityObjectForeignId,
    }) as ActivityJSON;
    
    return activityResponse;
  }

  /**
   * Posts an activity to a specific feed.
   * @param {string} feedName the name of the feed to post to.
   * @param {string} actorId the id of the actor.
   * @param {any} activityData the activity data.
   * @return {Promise<void>} a promise that resolves when the activity is posted.
   */
  export async function postActivityToFeed(feedName: string, actorId: string, activityId: string): Promise<void> {
    functions.logger.info("Unposting activity", {
      feedName,
      actorId,
    });

    const feed = (await FeedService.getFeedsClient()).feed(feedName, actorId);

    if (!activityId) {
      throw new functions.https.HttpsError("invalid-argument", "Activity does not exist");
    }

    const getStreamActivity: NewActivity<DefaultGenerics> = {
      actor: actorId,
      verb: ActivityActionVerb.Post,
      object: activityId,
      foreign_id: activityId,
    };


    await feed.addActivity(getStreamActivity);
  }

  /**
   * Unposts an activity from a GetStream feed.
   * @param {string} feedName the name of the feed to post to.
   * @param {string} actorId the id of the actor.
   * @param {any} activityData the activity data.
   * @return {Promise<void>} a promise that resolves when the activity is unposted.
   */
  export async function removeActivityFromFeed(feedName: any, actorId: any, activityId: string): Promise<void> {
    functions.logger.info("Unposting activity", {
      feedName,
      actorId,
      activityId,
    });

    const feed = (await FeedService.getFeedsClient()).feed(feedName, actorId);


    await feed.removeActivity({ foreign_id: activityId });
  }
}
