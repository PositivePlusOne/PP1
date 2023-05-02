import * as functions from "firebase-functions";

import { Activity } from "../dto/activities";
import { SystemService } from "./system_service";

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

    await flamelinkApp.content.add({
      schemaKey: "activities",
      data: activity,
    });

    functions.logger.info("Created activity", activity);
  }

  /**
   * Gets an activity.
   * @param {string} id the id of the activity.
   * @return {Promise<any>} a promise that resolves to the activity.
   */
  export async function getActivity(id: string): Promise<any> {
    functions.logger.info("Getting activity", { id });
    const flamelinkApp = SystemService.getFlamelinkApp();
    const activity = await flamelinkApp.content.get({
      schemaKey: "activities",
      entryId: id,
    });

    functions.logger.info("Got activity", activity);
    return activity;
  }
}
