import * as functions from "firebase-functions";

import fetch from "cross-fetch";

import { ArrayHelpers } from "../helpers/array_helpers";
import { DateHelpers } from "../helpers/date_helpers";

import { EventResult, ListEventResponse } from "../types/event_types";
import { DataService } from "./data_service";

export namespace EventService {
  /**
   * Gets the Occasion Genius API key.
   * @return {string} the Occasion Genius API key.
   */
  export function getApiKey(): string {
    functions.logger.info("Getting Occasion Genius API key", {
      structuredData: true,
    });

    const apiKey = process.env.OCCASION_GENIUS_API_KEY;
    if (!apiKey) {
      throw new Error("Missing Algolia API key");
    }

    return apiKey;
  }

  /**
   * Imports all events from the future into our database.
   * @param {EventResult[]} events the events to import.
   */
  export async function runEventImport(events: EventResult[]): Promise<void> {
    const filteredEvents = ArrayHelpers.getUniqueListBy(events, "uuid");

    for (const event of filteredEvents) {
      functions.logger.info(`Processing event: ${event.uuid}`);
      const documentExists = await DataService.exists({
        schemaKey: "events",
        entryId: event.uuid,
      });

      if (documentExists) {
        functions.logger.info(`Event already exists: ${event.uuid}`);
        continue;
      }

      // Pull off the venue to store in another collection.
      const venue = event.venue;
      const venueId = venue.uuid;
      delete event.venue;

      if (venueId) {
        functions.logger.info(`Processing venue: ${venueId}`);
        const venueExists = await DataService.exists({
          schemaKey: "venues",
          entryId: venueId,
        });

        if (!venueExists) {
          functions.logger.info(`Creating venue: ${venueId}`);
          await DataService.updateDocument({
            schemaKey: "venues",
            entryId: venueId,
            data: venue,
          });
        }
      }

      functions.logger.info(`Creating event: ${event.uuid}`);
      await DataService.updateDocument({
        schemaKey: "events",
        entryId: event.uuid,
        data: event,
      });

      functions.logger.info(`Created event: ${event.uuid}`);
    }
  }

  /**
   * Obtains a list of events for the next year for Occasion Genius.
   * @param {string} apiKey the Occasion Genius API key.
   * @return {EventResult[]} a list of events.
   */
  export async function listEvents(apiKey: string): Promise<EventResult[]> {
    const events = new Array<EventResult>();
    const startDate = new Date();
    const startDateFormatted = DateHelpers.formatDate(startDate);
    const endDate = new Date(
      new Date().setFullYear(new Date().getFullYear() + 1) // One month from now
    );

    const endDateFormatted = DateHelpers.formatDate(endDate);

    let requestUrl = `https://v2.api.occasiongenius.com/api/events?limit=25&start_date=${startDateFormatted}&end_date=${endDateFormatted}`;
    let pageIndex = 0;

    do {
      try {
        functions.logger.info(
          `Requesting page ${pageIndex} from ${requestUrl}`
        );

        const response = await fetch(requestUrl, {
          method: "GET",
          headers: {
            Authorization: `Token ${apiKey}`,
            "Content-Type": "application/json",
          },
        });

        const eventPage: ListEventResponse = await response.json();
        events.push(...eventPage.results);

        requestUrl = eventPage.next;
        pageIndex++;
      } catch (error) {
        functions.logger.error(error);
        break;
      }
    } while (requestUrl != null);

    console.log(`Found ${events.length} events`);
    return events;
  }
}
