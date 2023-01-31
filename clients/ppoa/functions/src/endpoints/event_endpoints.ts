import * as functions from "firebase-functions";
import { adminApp } from "..";
import { EnvironmentConstants } from "../constants/environment_constants";

import { EventService } from "../services/event_service";
import { SystemService } from "../services/system_service";

export namespace EventEndpoints {
  /**
   * Runs a nightly job to populate the next year of events.
   * This is called from the Occasion Genius endpoint.
   */
  export const scheduleEventImport = functions.pubsub
    .schedule("every 24 hours")
    .onRun(async (_) => {
      const events = await EventService.listEvents();
      const flamelinkApp = await SystemService.getFlamelinkApp(
        EnvironmentConstants.flamelineEnvironmentDevelopment
      );

      const firestore = adminApp.firestore();
      const eventCollection = firestore.collection("events");

      for (const event of events) {
        const querySnapshot = await eventCollection
          .where("uuid", "==", event.uuid)
          .get();

        if (querySnapshot.docs.length > 0) {
          continue;
        }

        console.log(`Attempting to create event: ${event.uuid}`);
        await flamelinkApp.content.add({
          schemaKey: "events",
          entryId: event.uuid,
          data: event,
          status: "review",
        });

        console.log(`Event created successfully: ${event.uuid}`);
      }

      return events;
    });
}
