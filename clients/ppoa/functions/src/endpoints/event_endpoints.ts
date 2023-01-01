import * as functions from "firebase-functions";
import { adminApp } from "..";

import { EventService } from "../services/event_service";
import { SystemService } from "../services/system_service";

export namespace EventEndpoints {
    export const getEvents = functions.region("europe-west1").https.onCall(
        async (data, __) => {
            const events = await EventService.listEvents();
            const flamelinkApp = await SystemService.getFlamelinkApp(data.environment);
            const firestore = adminApp.firestore();
            const eventCollection = firestore.collection("events");

            for (const event of events) {
                const querySnapshot = await eventCollection.where("uuid", "==", event.uuid).get();
                if (querySnapshot.docs.length > 0) {
                    continue;
                }

                console.log(`Attempting to create event: ${event.uuid}`);
                await flamelinkApp.content.add({
                    "schemaKey": "events",
                    "entryId": event.uuid,
                    "data": event,
                    "status": "review",
                });

                console.log(`Event created successfully: ${event.uuid}`);
            }
            
            return events;
        }
      );
}
