import * as functions from "firebase-functions";

import { AdminQuickActionDataJSON, AdminQuickActionJSON } from "../../dto/admin";
import { AdminQuickActionService } from "../admin_quick_action_service";

import { FlamelinkHelpers } from "../../helpers/flamelink_helpers";
import { FeedService } from "../feed_service";

export namespace ClearFeedAction {
  export async function clearFeed(action: AdminQuickActionJSON): Promise<void> {
    const actionId = FlamelinkHelpers.getFlamelinkIdFromObject(action);
    if (!action || !actionId) {
      functions.logger.error(`No action ID specified`);
      return Promise.resolve();
    }

    const feedData = action.data?.find((d: AdminQuickActionDataJSON) => d.target === "feed") || {};
    const feed = feedData.feed ?? "";

    if (!feed) {
      AdminQuickActionService.appendOutput(action, `No feed specified.`);
      AdminQuickActionService.updateStatus(action, "error");
      return Promise.resolve();
    }

    // Check the feed is in the format (slug:id)
    const feedParts = feed.split(":");
    if (feedParts.length !== 2) {
      AdminQuickActionService.appendOutput(action, `Feed is not in the correct format: ${feed}`);
      AdminQuickActionService.updateStatus(action, "error");
      return Promise.resolve();
    }

    const feedClient = FeedService.getFeedsClient();
    const gsFeed = feedClient.feed(feedParts[0], feedParts[1]);

    // Get all activities from the feed paginated
    AdminQuickActionService.appendOutput(action, `Getting activities from feed ${feed}`);

    const activities = [];
    let page = 1;
    let hasNextPage = true;

    while (hasNextPage) {
      const response = await gsFeed.get({ limit: 100, offset: (page - 1) * 100 });
      const responseActivities = response.results;
      activities.push(...responseActivities);
      hasNextPage = responseActivities.length > 0;
      page++;
    }

    AdminQuickActionService.appendOutput(action, `Deleting ${activities.length} activities from feed ${feed}`);

    for (const activity of activities) {
      const activityId = activity.id;
      if (!activityId) {
        continue;
      }

      try {
        AdminQuickActionService.appendOutput(action, `Deleting activity ${activityId}`);
        await gsFeed.removeActivity(activityId);
      } catch (e) {
        AdminQuickActionService.appendOutput(action, `Error deleting activity ${activityId}: ${e}`);
      }
    }

    AdminQuickActionService.appendOutput(action, `Cleared feed ${feed}`);
    AdminQuickActionService.updateStatus(action, "success");
  }
}
