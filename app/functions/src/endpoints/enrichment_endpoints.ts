import * as functions from "firebase-functions";

import { UserService } from "../services/user_service";
import { ProfileService } from "../services/profile_service";

import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";
import { FeedService } from "../services/feed_service";
import { EndpointRequest, buildEndpointResponse } from "./dto/payloads";
import { TagsService } from "../services/tags_service";
import { DataService } from "../services/data_service";
import { DEFAULT_USER_TIMELINE_FEED_SUBSCRIPTION_SLUGS } from "../constants/default_feeds";
import { PromotionsService } from "../services/promotions_service";
import { Promotion } from "../dto/promotions";

export namespace EnrichmentEndpoints {
  export const followTags = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    const uid = await UserService.verifyAuthenticated(context, request.sender);
    functions.logger.info(`Getting notifications for current user: ${uid}`);

    if (uid.length === 0) {
      throw new functions.https.HttpsError("permission-denied", "User is not authenticated");
    }

    const feedsClient = FeedService.getFeedsClient();
    const requestedTags = request.data.tags as string[];

    if (!requestedTags || requestedTags.length === 0) {
      throw new functions.https.HttpsError("invalid-argument", "Invalid arguments");
    }

    const [tags, profile] = await Promise.all([TagsService.getOrCreateTags(requestedTags), ProfileService.getProfile(uid)]);
    const newTags = tags.map((tag) => tag.key);

    const defaultTags = DEFAULT_USER_TIMELINE_FEED_SUBSCRIPTION_SLUGS.map((feed) => feed.targetSlug);
    profile.tags = newTags.filter((tag) => !defaultTags.includes(tag ?? ""));

    if (!profile) {
      throw new functions.https.HttpsError("not-found", "Profile not found");
    }

    // Assume FILO and take from profile.tags and add to tags to make 10 total
    const currentTags = profile.tags || [];
    while (newTags.length < 10 && currentTags.length > 0) {
        const tag = currentTags.pop();
        if (tag) {
            newTags.push(tag);
        }
    }

    // Remove duplicates from the new tags
    profile.tags = [...new Set(newTags)];

    const newProfileData = await DataService.updateDocument({
        schemaKey: "users",
        entryId: uid,
        data: profile,
    });

    await FeedService.verifyDefaultFeedSubscriptionsForUser(feedsClient, profile);

    return buildEndpointResponse(context, {
      sender: uid,
      data: [newProfileData],
    });
  });

  export const getPromotionWindow = functions.region('europe-west3').runWith(FIREBASE_FUNCTION_INSTANCE_DATA).https.onCall(async (request: EndpointRequest, context) => {
    functions.logger.info(`Getting a promotion window`);

    const cursor = request.data.cursor || "";
    const limit = request.data.limit || 10;
    const uid = context.auth?.uid || "";

    if (!cursor || !limit) {
      throw new functions.https.HttpsError("invalid-argument", "Invalid arguments");
    }

    const promotions = await PromotionsService.getActivePromotionWindow(cursor, limit) as Promotion[];

    return buildEndpointResponse(context, {
      sender: uid,
      data: [...promotions],
    });
  });
}
