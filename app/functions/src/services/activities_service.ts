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
import { ReactionStatisticsJSON } from "../dto/reactions";
import { FlamelinkHelpers } from "../helpers/flamelink_helpers";

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
   * Gets a list of activities.
   * @param {string[]} ids the ids of the activities.
   * @return {Promise<ActivityJSON[]>} a promise that resolves to the activities.
   */
  export async function getActivities(ids: string[]): Promise<ActivityJSON[]> {
    return await DataService.getBatchDocuments({
      schemaKey: "activities",
      entryIds: ids,
    }) as ActivityJSON[];
  }

  /**
   * Gets a list of activities from a list of feed entrys.
   * @param {FeedEntry[]} entrys the feed entrys to get the activities for.
   * @return {Promise<ActivityJSON[]>} a promise that resolves to the activities.
   */
  export async function getActivityFeedWindow(entrys: FeedEntry[]): Promise<any[]> {
    const activities = await getActivities(entrys.map((entry) => entry.object));
    for (const activity of activities) {
      const entry = entrys.find((entry) => entry.object === activity?._fl_meta_?.fl_id);
      if (!entry) {
        continue;
      }

      switch (entry.verb) {
        case ActivityActionVerb.Post:
          break;
        default:
          const actorId = entry.actor;
          if (!activity.publisherInformation) {
            activity.publisherInformation = {};
          }

          if (!activity.generalConfiguration) {
            activity.generalConfiguration = {};
          }
          
          activity.publisherInformation.actorId = actorId;
          activity.generalConfiguration.reactionType = entry.verb as ActivityActionVerb;
          break;
      }
    }

    return activities.filter((activity) => activity);
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

    const feedClient = FeedService.getFeedsUserClient(userID);
    const feed = feedClient.feed(feedName, userID);

    const getStreamActivity: NewActivity<DefaultGenerics> = {
      actor: feedClient.currentUser!,
      verb: ActivityActionVerb.Post,
      object: activityObjectForeignId,
      foreign_id: activityObjectForeignId,
      time: activity?._fl_meta_?.createdDate ?? new Date().toISOString(),
      to: targets,
    };
    
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

    const feed = FeedService.getFeedsUserClient(actorId).feed(feedName, actorId);

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

    const feed = FeedService.getFeedsUserClient(actorId).feed(feedName, actorId);


    await feed.removeActivity({ foreign_id: activityId });
  }

  export function enrichActivitiesWithReactionStatistics(activities: ActivityJSON[], statistics: ReactionStatisticsJSON[]): ActivityJSON[] {
    if (!statistics || statistics.length === 0) {
      return activities;
    }

    return activities.map((activity) => {
      const id = FlamelinkHelpers.getFlamelinkIdFromObject(activity);
      if (!id) {
        return activity;
      }

      for (const stat of statistics ?? []) {
        if (!stat) {
          continue;
        }
        
        if (stat.activity_id === id) {
          activity.enrichmentConfiguration ??= {};
          activity.enrichmentConfiguration.originFeed = stat.feed ?? "";
          activity.enrichmentConfiguration.reactionCounts = stat.counts ?? {};
          activity.enrichmentConfiguration.uniqueUserReactions = stat.unique_user_reactions ?? {};
        }
      }

      return activity;
    });
  }
}
