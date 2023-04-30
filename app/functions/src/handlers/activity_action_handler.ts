import * as functions from "firebase-functions";

import { DataChangeType } from "./data_change_type";
import { DataHandlerRegistry } from "./data_change_handler";
import { FeedService } from "../services/feed_service";
import { adminApp } from "..";

export namespace ActivityActionHandler {
  /**
   * Registers the event post handler.
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

    const firestore = adminApp.firestore();
    const actor = firestore.doc(after.actor);
    const activity = firestore.doc(after.activity);
    const client = await FeedService.getFeedsClient();

    if (!actor || !activity || !client) {
      functions.logger.error("Invalid activity action", {
        actor,
        activity,
        client,
      });

      return;
    }

    const feedName = after.feed || "";
    const verb = after.verb || "";
    if (!feedName || !verb) {
      functions.logger.error("Invalid feed name or verb", {
        feedName,
        verb,
      });

      return;
    }

    const feed = client.feed(feedName, actor.id);
    const activityData = {
      actor: actor.id,
      verb: verb,
      object: activity.id,
      foreign_id: id,
    };

    switch (changeType) {
      case DataChangeType.Create:
        functions.logger.info("Adding activity to feed", {
          actor,
          activity,
        });

        await feed.addActivity(activityData);
        break;

      case DataChangeType.Delete:
        functions.logger.info("Removing activity from feed", {
          actor,
          activity,
        });

        await feed.removeActivity(activityData);
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
