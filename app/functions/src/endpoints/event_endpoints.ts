import * as functions from "firebase-functions";

import { StreamActorType } from "../services/enumerations/actors";
import { EventService } from "../services/event_service";
import { Keys } from "../constants/keys";

import { ActivityMappers } from "../mappers/activity_mappers";
import { ActivitiesService } from "../services/activities_service";
import { FeedService } from "../services/feed_service";
import { OrganisationService } from "../services/organisation_service";

export namespace EventEndpoints {
  export const scheduleEventImport = functions
    .runWith({
      secrets: [
        Keys.OccasionGeniusApiKey,
        Keys.StreamFeedsApiKey,
        Keys.StreamFeedsApiSecret,
      ],
    })
    .pubsub.schedule("every 24 hours")
    .onRun(async () => {
      functions.logger.info("Scheduling event import");
      const apiKey = EventService.getApiKey();
      const feedsClient = await FeedService.getFeedsClient();

      const events = await EventService.listEvents(apiKey);
      const activities = ActivityMappers.convertOccasionGeniusEventsToActivities(events);

      // Create the positive plus one organisation if it doesn't exist
      await OrganisationService.attemptCreatePositivePlusOneOrganisation();

      await ActivitiesService.createActivities(activities);
      await ActivitiesService.publishActivities(
        activities,
        feedsClient,
        StreamActorType.organisation
      );
    });
}
