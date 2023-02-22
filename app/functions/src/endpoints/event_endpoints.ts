import * as functions from "firebase-functions";

import { EventService } from "../services/event_service";

export namespace EventEndpoints {
  export const runEventImport = functions.https.onRequest(async (_, res) => {
    await EventService.runEventImport();
    res.status(200).send("Imported successfully");
  });

  /**
   * Runs a nightly job to populate the next year of events.
   * This is called from the Occasion Genius endpoint.
   */
  export const scheduleEventImport = functions.pubsub
    .schedule("every 24 hours")
    .onRun(async () => {
      await EventService.runEventImport();
    });
}
