import * as functions from "firebase-functions";

import { v1 as uuidv1 } from "uuid";

import { DefaultGenerics, ForeignIDTimes, NewActivity, StreamClient } from "getstream";
import { Activity, ActivityActionVerb, ActivityJSON } from "../dto/activities";
import { FeedService } from "./feed_service";
import { SystemService } from "./system_service";
import { DataService } from "./data_service";
import { FeedName } from "../constants/default_feeds";
import { FeedEntry } from "../dto/stream";
import { StreamHelpers } from "../helpers/stream_helpers";
import { FeedStatisticsService } from "./feed_statistics_service";
import { ProfileJSON } from "../dto/profile";
import { PromotionJSON } from "../dto/promotions";
import { MentionJSON } from "../dto/mentions";
import { ProfileService } from "./profile_service";
import { RelationshipService } from "./relationship_service";
import { RelationshipHelpers } from "../helpers/relationship_helpers";

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

  export async function getActivitiesForProfile(profileId: string): Promise<ActivityJSON[]> {
    return await DataService.getDocumentWindowRaw({
      schemaKey: "activities",
      where: [
        { fieldPath: "publisherInformation.publisherId", op: "==", value: profileId },
      ],
    }) as ActivityJSON[];
  }

  /**
   * Gets a list of activities from a list of feed entrys.
   * @param {FeedEntry[]} entrys the feed entrys to get the activities for.
   * @return {Promise<ActivityJSON[]>} a promise that resolves to the activities.
   */
  export async function getActivityFeedWindow(entrys: FeedEntry[]): Promise<any[]> {
    const activities = await getActivities(entrys.map((entry) => entry.object));
    return activities.filter((activity) => activity?._fl_meta_?.fl_id);
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
    const feedClient = FeedService.getFeedsClient();
    const feed = feedClient.feed(feedName, userID);

    const createdTimestamp = activity?._fl_meta_?.createdDate;
    const creationTime = createdTimestamp ? StreamHelpers.convertTimestampToUnix(createdTimestamp) : StreamHelpers.getCurrentUnixTimestamp();

    const getStreamActivity: NewActivity<DefaultGenerics> = {
      actor: userID,
      verb: ActivityActionVerb.Post,
      object: activityObjectForeignId,
      foreign_id: activityObjectForeignId,
      time: creationTime,
    };
    
    await feed.addActivity(getStreamActivity);

    const activityResponse = await DataService.updateDocument({
      schemaKey: "activities",
      data: activity,
      entryId: activityObjectForeignId,
    }) as ActivityJSON;
    
    return activityResponse;
  }

  export async function deleteActivity(activityId: string): Promise<void> {
    functions.logger.info("Deleting activity", {
      activityId,
    });

    const activity = await getActivity(activityId);
    if (!activity) {
      throw new functions.https.HttpsError("invalid-argument", "Activity does not exist");
    }

    const publisherId = activity.publisherInformation?.publisherId ?? "";
    const publisherFeed = FeedService.getFeedsClient().feed(FeedName.User, publisherId);
    await publisherFeed.removeActivity({ foreign_id: activityId });

    await DataService.deleteDocument({
      schemaKey: "activities",
      entryId: activityId,
    });
  }

  /**
   * Gets a promotion.
   * @param {string} promotionKey the key of the promotion.
   * @return {Promise<boolean>} a promise that resolves to true if the promotion exists.
   */
  export async function getPromotion(promotionKey: string): Promise<PromotionJSON> {
    return await DataService.getDocument({
      schemaKey: "promotions",
      entryId: promotionKey,
    });
  }

  export async function sanitizeMentions(profile: ProfileJSON, content: string, visibilityFlag: string, mentions: MentionJSON[]): Promise<MentionJSON[]> {
    let newMentions: MentionJSON[] = [];

    // Get our ID and display name
    const profileId = profile?._fl_meta_?.fl_id ?? "";
    const profileDisplayName = profile?.displayName ?? "";

    // Exit if we don't have a profile ID or display name
    if (!profileId || !profileDisplayName) {
      return mentions;
    }

    // Remove any mentions that are us
    for (const mention of mentions) {
      if (mention.foreignKey !== profileId && mention.label !== profileDisplayName) {
        functions.logger.info("Adding mention", { mention });
        newMentions.push(mention);
      }
    }

    // Loop through each, and if they do not have a foreign key, add one based on the label
    for (const mention of newMentions) {
      const isDisplayNameMention = mention.label?.startsWith("@") ?? false;
      const isUsersSchema = mention.schema === "users";
      if (!mention.foreignKey && isDisplayNameMention && isUsersSchema) {
        const displayName = mention.label?.substring(1) ?? "";
        const foundProfile = await ProfileService.getProfileByDisplayName(displayName);
        if (foundProfile) {
          mention.foreignKey = foundProfile?._fl_meta_?.fl_id ?? "";
        }
      }

      // TODO - Handle tags and other things
    }

    // Loop through each, and add a start and end index from the content if they do not have one already
    // Check that the content is not empty and that the label is inside the content
    if (content && content.length > 0) {
      for (const mention of newMentions) {
        if (!mention.startIndex && !mention.endIndex && mention.label) {
          const startIndex = content.indexOf(mention.label);
          if (startIndex > -1) {
            mention.startIndex = startIndex;
            mention.endIndex = startIndex + mention.label.length;
          }
        }
      }
    }

    // Perform relationship checks and remove any mentions that are not valid
    const tempMentions = [...newMentions];
    const isEveryoneFlag = visibilityFlag === 'public';
    newMentions = [];

    functions.logger.info("Sanitizing mentions", {
      profileId,
      profileDisplayName,
      visibilityFlag,
      mentions,
      tempMentions,
      isEveryoneFlag,
    });

    for (const mention of tempMentions) {
      if (!mention.foreignKey) {
        continue;
      }

      // Check if the foreign key is us
      if (mention.foreignKey === profileId) {
        functions.logger.info("Mentioned user is us", {
          mention,
        });

        // Can we mention ourselves?
        newMentions.push(mention);
        continue;
      }

      const relationship = await RelationshipService.getRelationship([profileId, mention.foreignKey]);

      // Remove the mention as we have no relationship to the user
      if (!relationship) {
        if (isEveryoneFlag) {
          newMentions.push(mention);
        } else {
          functions.logger.error("Missing everyone flag and no relationship", {
            mention,
            relationship,
          });
        }
        
        continue;
      }

      // Check if they have blocked us
      const isBlockedByMentioned = RelationshipHelpers.hasBlockedRelationship(mention.foreignKey, relationship);
      if (isBlockedByMentioned) {
        functions.logger.info("Mentioned user has blocked us", {
          mention,
          relationship,
        });

        continue;
      }

      // Visibility check
      const isMentionedFollowing = RelationshipHelpers.isUserFollowing(mention.foreignKey, relationship);
      const isMentionedConnected = RelationshipHelpers.isUserConnected(mention.foreignKey, relationship);
      let canMention = true;

      if (visibilityFlag === 'followers_and_connections' && !isMentionedFollowing) {
        functions.logger.info("Mentioned user is not following", {
          mention,
          relationship,
        });

        canMention = false;
      } else if (visibilityFlag === 'connections' && !isMentionedConnected) {
        functions.logger.info("Mentioned user is not connected", {
          mention,
          relationship,
        });

        canMention = false;
      }

      if (canMention) {
        newMentions.push(mention);
      }
    }

    return newMentions;
  }

  export async function getForeignIdTimeForActivity(activity: ActivityJSON): Promise<ForeignIDTimes> {
    const activityId = activity?._fl_meta_?.fl_id ?? "";
    if (!activityId) {
      throw new functions.https.HttpsError("invalid-argument", "Activity does not exist");
    }

    const createdTimestamp = activity?._fl_meta_?.createdDate;
    const creationTime = createdTimestamp ? StreamHelpers.convertTimestampToUnix(createdTimestamp) : StreamHelpers.getCurrentUnixTimestamp();

    return {
      foreignID: activityId,
      time: creationTime,
    };
  }

  export async function updateTagFeedsForActivity(activity: ActivityJSON): Promise<void> {
    const activityId = activity?._fl_meta_?.fl_id ?? "";
    if (!activityId) {
      throw new functions.https.HttpsError("invalid-argument", "Activity does not exist");
    }

    const feedsClient = FeedService.getFeedsClient();

    const publisherFeedStr = activity.publisherInformation?.originFeed ?? "";
    const reposterFeedStr = activity.repostConfiguration?.targetActivityOriginFeed ?? "";
    
    // Split each feed into its components
    let originFeed = StreamHelpers.getFeedFromOrigin(publisherFeedStr);
    if (reposterFeedStr) {
      const reposterFeed = StreamHelpers.getFeedFromOrigin(reposterFeedStr);
      originFeed = reposterFeed;
    }

    // Get a list of all places the activity is currently posted
    const foreignTimes = await getForeignIdTimeForActivity(activity);
    const activitiesQuery = await feedsClient.getActivities({
      foreignIDTimes: [foreignTimes],
    });

    functions.logger.info("Got query result for tag updates", {
      activityId,
      activitiesQuery,
    });

    // Get a list of all the tags the activity should be posted to
    const isPublic = activity.securityConfiguration?.viewMode === "public";
    const isSignedIn = activity.securityConfiguration?.viewMode === "signed_in";
    const canExternallyTag = isPublic || isSignedIn;

    // Convert to set
    const expectedTags = new Set<string>(canExternallyTag ? activity.enrichmentConfiguration?.tags ?? [] : []);

    // Get a list of all the tags the activity is currently posted to
    const currentTags = [];
    for (const result of activitiesQuery.results) {
      functions.logger.info("Checking activity result", {
        activityId,
        result,
      });

      const origin = result.origin;
      if (!origin) {
        continue;
      }

      const slug = StreamHelpers.getSlugFromOrigin(origin);
      const feed = StreamHelpers.getFeedFromOrigin(origin);
      if (!slug || feed !== FeedName.Tags) {
        continue;
      }

      currentTags.push(slug);
    }

    functions.logger.info("Updating tag feeds for activity", {
      activityId,
      expectedTags,
      currentTags,
    });

    // Loop through all the old tags and remove the activity from the feed
    const tagUpdatePromises = [];
    for (const tag of currentTags) {
      if (!expectedTags.has(tag)) {
        functions.logger.info("Removing activity from tag feed", {
          activityId,
          tag,
        });

        tagUpdatePromises.push(removeActivityFromFeed(FeedName.Tags, tag, activityId, feedsClient));
      }
    }

    // Loop through all the new tags and add the activity to the feed
    for (const tag of expectedTags) {
      if (!currentTags.includes(tag)) {
        functions.logger.info("Adding activity to tag feed", {
          activityId,
          tag,
        });

        tagUpdatePromises.push(postActivityToFeed(FeedName.Tags, tag, activity, feedsClient, originFeed));
      }
    }

    await Promise.all(tagUpdatePromises);
    functions.logger.info("Updated tag feeds for activity", {
      activityId,
      expectedTags,
      currentTags,
    });
  }

  /**
   * Posts an activity to a specific feed.
   * @param {string} feedName the name of the feed to post to.
   * @param {string} actorId the id of the actor.
   * @param {any} activityData the activity data.
   * @return {Promise<void>} a promise that resolves when the activity is posted.
   */
  export async function postActivityToFeed(feedName: string, actorId: string, activity: ActivityJSON, client: StreamClient<DefaultGenerics>, originFeed?: string): Promise<void> {
    functions.logger.info("Posting activity", {
      feedName,
      actorId,
      activity,
      originFeed,
    });

    const activityId = activity?._fl_meta_?.fl_id ?? "";
    if (!activityId || !actorId || !feedName || !client) {
      throw new functions.https.HttpsError("invalid-argument", "Activity, actor or feed name is missing");
    }

    const createdTimestamp = activity?._fl_meta_?.createdDate;
    const creationTime = createdTimestamp ? StreamHelpers.convertTimestampToUnix(createdTimestamp) : StreamHelpers.getCurrentUnixTimestamp();

    const feed = client.feed(feedName, actorId);
    const getStreamActivity: NewActivity<DefaultGenerics> = {
      origin: originFeed,
      actor: actorId,
      verb: ActivityActionVerb.Post,
      object: activityId,
      foreign_id: activityId,
      time: creationTime,
    };

    await feed.addActivity(getStreamActivity);
    await FeedStatisticsService.updateCountForFeedStatistics(feedName, actorId, "total_posts", 1);
  }

  /**
   * Unposts an activity from a GetStream feed.
   * @param {string} feedName the name of the feed to post to.
   * @param {string} actorId the id of the actor.
   * @param {any} activityData the activity data.
   * @return {Promise<void>} a promise that resolves when the activity is unposted.
   */
  export async function removeActivityFromFeed(feedName: any, actorId: any, activityId: string, client: StreamClient<DefaultGenerics>): Promise<void> {
    functions.logger.info("Unposting activity", {
      feedName,
      actorId,
      activityId,
    });

    if (!activityId || !actorId || !feedName || !client) {
      throw new functions.https.HttpsError("invalid-argument", "Activity, actor or feed name is missing");
    }

    const feed = client.feed(feedName, actorId);
    await feed.removeActivity({ foreign_id: activityId });

    await FeedStatisticsService.updateCountForFeedStatistics(feedName, actorId, "total_posts", -1);
  }

  /**
   * Generates a description for an activity.
   * This is so that it can be searched for in Flamelink.
   * @param {ActivityJSON} activity the activity to generate the description for.
   * @return {string} the description.
   */
  export function generateFlamelinkDescription(activity: ActivityJSON, publisher: ProfileJSON): string {
    const mediaCount = activity.media?.length ?? 0;
    let trimmedDescription = activity.generalConfiguration?.content?.substring(0, 50) ?? "";
    const publisherDisplayName = publisher.displayName ?? "";

    if (trimmedDescription.length == 0 && mediaCount > 0) {
      trimmedDescription = `Uploaded ${mediaCount} media`;
    } else if (trimmedDescription.length == 0 && mediaCount == 0) {
      trimmedDescription = "Posted an activity";
    }

    return `${publisherDisplayName} - ${trimmedDescription}`;
  }
}
