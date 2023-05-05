import * as functions from "firebase-functions";

import { DataChangeType } from "./data_change_type";
import { DataHandlerRegistry } from "./data_change_handler";
import { FeedService } from "../services/feed_service";
import { ActivitiesService } from "../services/activities_service";
import { DefaultGenerics, StreamFeed } from "getstream";

export namespace ActivityActionHandler {
  /**
   * Registers the activity action handler.
   */
  export function register(): void {
    functions.logger.info("Registering event post handler");

    DataHandlerRegistry.registerChangeHandler(
      DataChangeType.Create,
      ["activityActions"],
      "*",
      execute
    );
  }

  /**
   * Takes an event and syncs it to GetStream.
   * @param {DataChangeType} changeType the change type.
   * @param {string} schema the schema.
   * @param {string} id the id.
   * @param {any} before the before data.
   * @param {any} after the after data.
   */
  export async function execute(
    changeType: DataChangeType,
    schema: string,
    id: string,
    before: any,
    after: any
  ): Promise<void> {
    functions.logger.info("Executing event post handler", {
      changeType,
      schema,
      id,
      before,
      after,
    });

    const actorId = after.actor || "";
    const activityId = after.activity.id || "";
    if (!actorId || !activityId) {
      functions.logger.error("Invalid actor or activity", {
        actorId,
        activityId,
      });
    }

    const activity = await ActivitiesService.getActivity(activityId);
    const client = await FeedService.getFeedsClient();
    const feedName = after.feed || "";
    const verb = after.verb || "";

    if (!activity || !feedName || !verb) {
      functions.logger.error("Invalid feed name or verb", {
        feedName,
        verb,
      });

      return;
    }

    const tags = activity?.enrichmentConfiguration?.tags || [];
    const activityData = {
      actor: actorId,
      verb: verb,
      object: activityId,
      foreign_id: id,
      tags: tags,
    };

    switch (changeType) {
      case DataChangeType.Create:
        functions.logger.info("Adding activity to feed");
        await ActivitiesService.postActivity(client, feedName, actorId, activityData, tags);
        break;

      case DataChangeType.Delete:
        functions.logger.info("Removing activity from feed");
        await ActivitiesService.unpostActivity(client, feedName, actorId, activityData, tags);
        break;
    }

    functions.logger.info("Finished executing event post handler", {
      changeType,
      schema,
      id,
      before,
      after,
    });
  }
}
