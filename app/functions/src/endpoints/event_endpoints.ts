import * as functions from "firebase-functions";

import { EventService } from "../services/event_service";
import { Keys } from "../constants/keys";
import { ActivityMappers } from "../mappers/activity_mappers";
import { ActivitiesService } from "../services/activities_service";

export namespace EventEndpoints {
  export const scheduleEventImport = functions
    .runWith({ secrets: [Keys.OccasionGeniusApiKey] })
    .https.onCall(async (data, context) => {
    // .pubsub.schedule("every 24 hours")
    // .onRun(async () => {
      functions.logger.info("Scheduling event import");
      const apiKey = EventService.getApiKey();
      const events = await EventService.listEvents(apiKey);
      const activities = ActivityMappers.convertOccasionGeniusEventsToActivities(events);
      await ActivitiesService.createActivities(activities);
    });
}
