import * as functions from "firebase-functions";

import fetch from "cross-fetch";

import { ArrayHelpers } from "../helpers/array_helpers";
import { DateHelpers } from "../helpers/date_helpers";

import { OccasionGeniusEvent, OccasionGeniusListResponse } from "../dto/events";

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
   * Obtains a list of events for the next year for Occasion Genius.
   * @param {string} apiKey the Occasion Genius API key.
   * @return {OccasionGeniusEvent[]} a list of events.
   */
  export async function listEvents(apiKey: string): Promise<OccasionGeniusEvent[]> {
    const events = new Array<OccasionGeniusEvent>();
    const startDate = new Date();
    const startDateFormatted = DateHelpers.formatDate(startDate);
    const endDate = new Date(
      new Date().setHours(new Date().getHours() + 24) // Add 24 hours
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
            "Authorization": `Token ${apiKey}`,
            "Content-Type": "application/json",
          },
        });

        const eventPage: OccasionGeniusListResponse = await response.json();
        events.push(...eventPage.results ?? []);

        requestUrl = eventPage.next;
        pageIndex++;
      } catch (error) {
        functions.logger.error(error);
        break;
      }
    } while (requestUrl != null);

    // Remove duplicates
    const uniqueEvents = ArrayHelpers.getUniqueListBy(events, "uuid");
    console.log(`Found ${uniqueEvents.length} events`);
    
    return uniqueEvents;
  }
}
