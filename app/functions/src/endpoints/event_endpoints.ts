import * as functions from "firebase-functions";

import { EventService } from "../services/event_service";
import { Keys } from "../constants/keys";

export namespace EventEndpoints {
  export const scheduleEventImport = functions
    .runWith({ secrets: [Keys.OccasionGeniusApiKey] })
    .pubsub.schedule("every 24 hours")
    .onRun(async () => {
      const apiKey = EventService.getApiKey();
      const events = await EventService.listEvents(apiKey);

      await EventService.runEventImport(events);
    });
}
