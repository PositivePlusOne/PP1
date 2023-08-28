import * as functions from "firebase-functions";

import { v1 as uuidv1 } from "uuid";

import { DefaultGenerics, NewActivity, StreamClient } from "getstream";
import { Activity, ActivityActionVerb, ActivityJSON } from "../dto/activities";
import { FeedService } from "./feed_service";
import { SystemService } from "./system_service";
import { DataService } from "./data_service";
import { TagsService } from "./tags_service";
import { FeedName } from "../constants/default_feeds";
import { FeedEntry } from "../dto/stream";
import { ReactionStatisticsService } from "./reaction_statistics_service";
import { ReactionStatisticsJSON } from "../dto/reactions";

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
   * Gets an activity with reaction statistics.
   * @param {string} id the id of the activity.
   * @param {string} origin the origin of the activity.
   * @return {Promise<ActivityJSON>} a promise that resolves to the activity.
   */
  export async function getActivityWithReactionStatistics(client: StreamClient<DefaultGenerics>, id: string, feed: string, skipCacheLookup = false): Promise<ActivityJSON> {
    const reactionStatsPromise = feed && client ? ReactionStatisticsService.getReactionStatisticsForSenderAndActivity(client, feed, id) : Promise.resolve({});
    const activity = await DataService.getDocument({
      schemaKey: "activities",
      entryId: id,
    }, skipCacheLookup) as ActivityJSON;

    if (!activity) {
      functions.logger.warn("Could not find activity", { id });
      return {};
    } else if (!feed) {
      functions.logger.warn("Could not find origin", { feed });
      return activity;
    }

    const reactionStatistics = await reactionStatsPromise as ReactionStatisticsJSON;
    if (!activity.enrichmentConfiguration) {
      activity.enrichmentConfiguration = {};
    }

    if (reactionStatistics) {
      functions.logger.info("Found reaction statistics for activity", {
        activityId: id,
        reactionStatistics,
      });

      activity.enrichmentConfiguration.reactionCounts = reactionStatistics.counts;
      activity.enrichmentConfiguration.originFeed = reactionStatistics.feed;
    } else {
      functions.logger.info("No reaction statistics found for activity", {
        activityId: id,
      });
    }

    return activity;
  }

  /**
   * Gets a list of activities from a list of feed entrys.
   * @param {FeedEntry[]} entrys the feed entrys to get the activities for.
   * @return {Promise<ActivityJSON[]>} a promise that resolves to the activities.
   */
  export async function getActivityFeedWindow(client: StreamClient<DefaultGenerics>, entrys: FeedEntry[], feed: string): Promise<any[]> {
    const activityPromise = entrys.map(async (entry) => {
      if (!entry.object || !feed) {
        return;
      }
      
      const activity = await getActivityWithReactionStatistics(client, entry.object, feed);
      if (!activity) {
        return;
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
          functions.logger.info("Enriched activity for verb", {
            activityId: entry.object,
            verb: entry.verb,
          });
          break;
      }

      return activity;
    });

    const activities = await Promise.all(activityPromise);
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
}
