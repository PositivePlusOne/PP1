import fetch from "cross-fetch";

import { adminApp } from "..";
import { ArrayHelpers } from "../helpers/array_helpers";
import { DateHelpers } from "../helpers/date_helpers";

import { EventResult, ListEventResponse } from "../types/event_types";
import { SystemService } from "./system_service";

export namespace EventService {
  //* Once we have the contract, we will move this to environment vars.
  //* This is a test one for now.
  export const ogToken =
    "95a28ded5713552329f6cf5bff030a08eab7865a93419e7f8405910d37e388f1";

  /**
   * Imports all events from the future into our database.
   */
  export async function runEventImport(): Promise<void> {
    const events = await EventService.listEvents();
    const filteredEvents = ArrayHelpers.getUniqueListBy(events, "uuid");

    const flamelinkApp = await SystemService.getFlamelinkApp();

    const firestore = adminApp.firestore();
    const contentCollection = firestore.collection("fl_content");

    for (const event of filteredEvents) {
      console.log(`Checking event ${event.uuid} - (${filteredEvents.indexOf(event)} of ${filteredEvents.length})`);
      const querySnapshot = await contentCollection
        .where("uuid", "==", event.uuid)
        .get();

      if (querySnapshot.docs.length > 0) {
        console.log(`Skipping event ${event.uuid} as already stored`)
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
  }

  /**
   * Obtains a list of events for the next year for Occasion Genius.
   * @return {EventResult[]} a list of events.
   */
  export async function listEvents(): Promise<EventResult[]> {
    const events = new Array<EventResult>();
    const startDate = new Date();
    const startDateFormatted = DateHelpers.formatDate(startDate);
    const endDate = new Date(new Date().setFullYear(new Date().getFullYear() + 1));
    const endDateFormatted = DateHelpers.formatDate(endDate);

    let requestUrl = `https://v2.api.occasiongenius.com/api/events?limit=25&start_date=${startDateFormatted}&end_date=${endDateFormatted}`;

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

    console.log(`Found ${events.length} events`);
    return events;
  }
}
