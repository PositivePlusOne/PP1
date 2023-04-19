import * as functions from "firebase-functions";

import fetch from "cross-fetch";

import { adminApp } from "..";
import { ArrayHelpers } from "../helpers/array_helpers";
import { DateHelpers } from "../helpers/date_helpers";

import { EventResult, ListEventResponse } from "../types/event_types";
import { SystemService } from "./system_service";
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
   * @return {EventResult[]} a list of events.
   */
  export async function listEvents(apiKey: string): Promise<EventResult[]> {
    const events = new Array<EventResult>();
    const startDate = new Date();
    const startDateFormatted = DateHelpers.formatDate(startDate);
    const endDate = new Date(
      new Date().setFullYear(new Date().getFullYear() + 1) // One year from now
    );

    const endDateFormatted = DateHelpers.formatDate(endDate);

    let requestUrl = `https://v2.api.occasiongenius.com/api/events?limit=25&start_date=${startDateFormatted}&end_date=${endDateFormatted}`;

    do {
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
    } while (requestUrl != null);

    console.log(`Found ${events.length} events`);
    return events;
  }
}
