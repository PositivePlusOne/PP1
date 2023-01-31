import fetch from "cross-fetch";
import { DateHelpers } from "../helpers/date_helpers";

import { EventResult, ListEventResponse } from "../types/event_types";

export namespace EventService {
  export const ogToken =
    "95a28ded5713552329f6cf5bff030a08eab7865a93419e7f8405910d37e388f1";

  /**
   * Obtains a list of events for the next year for Occasion Genius.
   * @return {EventResult[]} a list of events.
   */
  export async function listEvents(): Promise<EventResult[]> {
    const events = new Array<EventResult>();
    const startDate = new Date();
    const endDate = new Date(new Date().setFullYear(new Date().getFullYear() + 1));

    const startDateFormatted = DateHelpers.formatDate(startDate);
    const endDateFormatted = DateHelpers.formatDate(endDate);

    let requestUrl = `https://v2.api.occasiongenius.com/api/events?start_date=${startDateFormatted}&end_date=${endDateFormatted}`;

    while (requestUrl != null) {
      const response = await fetch(requestUrl, {
        method: "GET",
        headers: {
          "Authorization": `Token ${ogToken}`,
          "Content-Type": "application/json",
        },
      });

      const eventPage: ListEventResponse = await response.json();
      events.push(...eventPage.results);

      requestUrl = eventPage.next;
    }

    return events;
  }
}
