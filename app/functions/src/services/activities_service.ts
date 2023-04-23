import * as functions from "firebase-functions";

import { v4 as uuidv4 } from "uuid";

import { Activity } from "../dto/activities";
import { SystemService } from "./system_service";
import { DataService } from "./data_service";

export namespace ActivitiesService {
  /**
   * Creates a list of activities.
   * @param {Activity[]} activities the activities to create.
   * @return {Promise<void>} a promise that resolves when the activities are created.
   */
  export async function createActivities(
    activities: Activity[]
  ): Promise<void> {
    functions.logger.info("Creating activities", activities);
    for (const activity of activities) {
      await createActivity(activity);
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

    // Create a guid foreign key for the activity if it doesn't exist
    if (!activity.foreignKey) {
      activity.foreignKey = uuidv4();
      functions.logger.info("Created foreign key for activity", activity);
    }

    await flamelinkApp.content.add({
      schemaKey: "activities",
      entryId: activity.foreignKey,
      data: activity,
    });

    functions.logger.info("Created activity", activity);
  }

  /**
   * Publishes an activity.
   * @param {Activity} activity the activity to publish.
   * @return {Promise<void>} a promise that resolves when the activity is published.
   */
  export async function publishActivity(activity: Activity): Promise<void> {
    functions.logger.info("Publishing activity", activity);
    activity.publisherInformation.published = true;

    // TODO(ryan): Actually publish the activity kekw

    await DataService.updateDocument({
      schemaKey: "activities",
      entryId: activity.foreignKey,
      data: activity,
    });

    functions.logger.info("Published activity", activity);
  }
}
