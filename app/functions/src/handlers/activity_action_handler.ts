import * as functions from "firebase-functions";

import { DataChangeType } from "./data_change_type";
import { DataHandlerRegistry } from "./data_change_handler";
import { FeedService } from "../services/feed_service";
import { ActivitiesService } from "../services/activities_service";
import { adminApp } from "..";

export namespace ActivityActionHandler {
  /**
   * Registers the activity action handler.
   */
  export function register(): void {
    functions.logger.info("Registering activity action handler");

    DataHandlerRegistry.registerChangeHandler(
      DataChangeType.Create | DataChangeType.Delete,
      ["activityActions"],
      "*",
      execute
    );
  }

  /**
   * Takes activity actions and syncs them to GetStream.
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
    functions.logger.info("Executing activity action handler", {
      changeType,
      schema,
      id,
      before,
      after,
    });

    // Convert after.activity to a document reference
    const activityRef = after.activity;
    if (activityRef) {
      after.activity = adminApp.firestore().doc(activityRef.path);
    }

    // Convert after.actor to a document reference
    const actorRef = after.actor;
    if (actorRef) {
      after.actor = adminApp.firestore().doc(actorRef.path);
    }

    const client = await FeedService.getFeedsClient();
    const feedName = after.feed || "";
    const verb = after.verb || "";

    if (!feedName || !verb) {
      functions.logger.error("Invalid feed name, or verb", {
        feedName,
        verb,
      });
      
      return;
    }

    functions.logger.info("Prefetching data for content post", { after, client, feedName, verb });

    const activityData = (await after.activity.get()).data();
    const profileData = (await after.actor.get()).data();
    const activityFlId = activityData?._fl_meta_.fl_id || "";
    const profileFlId = profileData?._fl_meta_.fl_id || "";

    if (!activityFlId || !profileFlId) {
      functions.logger.error("Invalid activity or profile fl_id", {
        activityFlId,
        profileFlId,
      });

      return;
    }

    // Convert all tags from document references to strings from their key property
    const tags = (await Promise.all((activityData.enrichmentConfiguration?.tags || []).map(async (tagRef: any) => {
      const tagData = (await tagRef.get()).data();
      return typeof tagData?.key === "string" ? `tags:${tagData.key}` : null;
    }))).filter((tag: any) => tag !== null);

    functions.logger.info("Prefetched data for content post", { activityData, profileData, tags });
    const gsActivityData = {
      actor: profileFlId,
      verb: verb,
      object: activityFlId,
      foreign_id: id,
      to: [...tags],
    };

    switch (changeType) {
      case DataChangeType.Create:
        functions.logger.info("Adding activity to feed");
        await ActivitiesService.postActivity(client, feedName, profileFlId, gsActivityData);
        break;

      case DataChangeType.Delete:
        functions.logger.info("Removing activity from feed");
        await ActivitiesService.unpostActivity(client, feedName, profileFlId, gsActivityData);
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
