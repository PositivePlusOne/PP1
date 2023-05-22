import * as functions from "firebase-functions";

import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";

import { ConversationService } from "../services/conversation_service";
import { UserService } from "../services/user_service";
import { FeedService } from "../services/feed_service";
import { ActivitiesService } from "../services/activities_service";
import { ProfileService } from "../services/profile_service";
import { RelationshipService } from "../services/relationship_service";
import { PermissionsService } from "../services/permissions_service";
import { AuthorizationTarget } from "../services/enumerations/authorization_target";
import { ProfileMapper } from "../maps/profile_mappers";

export namespace StreamEndpoints {
  export const getChatToken = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (_, context) => {
      await UserService.verifyAuthenticated(context);

      const uid = context.auth?.uid || "";
      functions.logger.info("Getting user chat token", { uid });

      const chatClient = ConversationService.getStreamChatInstance();
      const userChatToken = ConversationService.getUserToken(chatClient, uid);
      functions.logger.info("User chat token", { userChatToken });

      // We should check here the integrity of the user's feeds.
      // Note: Subscribed follower feeds integrity will be checked on the relationship endpoints.
      const feedsClient = await FeedService.getFeedsClient();
      await FeedService.verifyDefaultFeedSubscriptionsForUser(feedsClient, uid);

      return userChatToken;
    });

    export const getFeedWindow = functions
    .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
    .https.onCall(async (data, context) => {
      await UserService.verifyAuthenticated(context);

      const uid = context.auth?.uid || "";
      const feedId = data.feed || "";
      const slugId = data.options?.slug || "";
      const windowSize = data.options?.windowSize || 10;
      const windowLastActivityId = data.options?.windowLastActivityId || "";

      functions.logger.info("Getting feed window", { uid, feedId, slugId });
      if (!feedId || feedId.length === 0 || !slugId || slugId.length === 0) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "Feed and slug must be provided"
        );
      }

      // TODO: Perform a permission check here to make sure the user can access this feed.

      const feedsClient = await FeedService.getFeedsClient();
      const feed = feedsClient.feed(feedId, slugId);

      const window = await FeedService.getFeedWindow(feed, windowSize, windowLastActivityId);
      functions.logger.info("Feed window", { window });

      const activities = [];
      const profiles = [];
      const relationships = [];

      functions.logger.info("Getting required activity and profile data", { window });
      for (const activity of window.results) {
        // The activity is a string GUID for the real activity.
        const dActivity = await ActivitiesService.getActivity(activity.object);
        const dProfile = await ProfileService.getProfile(activity.actor);

        if (!dActivity || !dProfile) {
          functions.logger.warn("Activity or profile not found", { activity });
          continue;
        }

        const permissionContext = PermissionsService.getPermissionContext(
          context,
          AuthorizationTarget.Profile,
          activity.actor,
        );

        const dRelationship = await RelationshipService.getRelationship([uid, activity.actor]);
        const safeMappedProfile = ProfileMapper.convertProfileToResponse(
          dProfile,
          permissionContext
        );

        profiles.push(safeMappedProfile);
        activities.push(dActivity);

        if (dRelationship) {
          relationships.push(dRelationship);
        }
      }

      functions.logger.info("Returning batched feed data", { activities, profiles, relationships });

      return JSON.stringify({
        activities,
        profiles,
        relationships,
        next: window.next,
      });
    });
}

