import * as functions from "firebase-functions";

import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";

import { UserService } from "../services/user_service";
import { FeedService } from "../services/feed_service";

import { ActivitiesService } from "../services/activities_service";
import { ProfileService } from "../services/profile_service";
import { buildEndpointResponse } from "./dto/payloads";

export namespace StreamEndpoints {
  export const getFeedWindow = functions.runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (data, context) => {
    await UserService.verifyAuthenticated(context);

    const uid = context.auth?.uid || "";
    const feedId = data.feed || "";
    const slugId = data.options?.slug || "";
    const windowSize = data.options?.windowSize || 10;
    const windowLastActivityId = data.options?.windowLastActivityId || "";

    if (!feedId || feedId.length === 0 || !slugId || slugId.length === 0) {
      throw new functions.https.HttpsError("invalid-argument", "Feed and slug must be provided");
    }

    const feedsClient = await FeedService.getFeedsClient();
    const feed = feedsClient.feed(feedId, slugId);

    const window = await FeedService.getFeedWindow(feed, windowSize, windowLastActivityId);

    // Convert window results to a list of IDs
    const activityIds = window.results.map((item) => item.object);
    const actorIds = window.results.map((item) => item.actor);

    // Loop over window IDs in parallel and get the activity data
    const payloadData = await Promise.all([...activityIds.map((id) => ActivitiesService.getActivity(id)), ...actorIds.map((id) => ProfileService.getProfile(id))]);

    return buildEndpointResponse(context, {
      sender: uid,
      data: payloadData,
      limit: windowSize,
      cursor: window.next,
      seedData: {
        next: window.next,
        unread: window.unread,
        unseen: window.unseen,
      },
    });
  });
}

// {
//   next: window.next,
//   unread: window.unread,
//   unseen: window.unseen,
// }