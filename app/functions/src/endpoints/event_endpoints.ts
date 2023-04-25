// import * as functions from "firebase-functions";

// import { ActivityMappers } from "../mappers/activity_mappers";
// import { ActivitiesService } from "../services/activities_service";
// import { OrganisationService } from "../services/organisation_service";

// import { FIREBASE_FUNCTION_INSTANCE_DATA } from "../constants/domain";
// import { OccasionGeniusListResponse } from "../dto/events";
// import { VenueService } from "../services/venue_service";

// export namespace EventEndpoints {
//   export const importTestEvents = functions
//     .runWith(FIREBASE_FUNCTION_INSTANCE_DATA)
//     .https.onCall(async (data) => {
//       functions.logger.info("Scheduling event import");
//       const functionPrivateKey = process.env.POSITIVEPLUSONE_FUNCTION_KEY || "";
//       const suppliedUserKey = data.key || "";
//       const suppliedEvents = data.events as OccasionGeniusListResponse;

//       if (functionPrivateKey !== suppliedUserKey) {
//         throw new functions.https.HttpsError(
//           "permission-denied",
//           "You do not have permission to perform this action"
//         );
//       }

//       const activities =
//         ActivityMappers.convertOccasionGeniusEventsToActivities(
//           suppliedEvents.results ?? []
//         );

//       await OrganisationService.attemptCreatePositivePlusOneOrganisation();

//       for (const event of suppliedEvents.results ?? []) {
//         if (!event.venue) {
//           continue;
//         }

//         await VenueService.createOccasionGeniusVenue(event.venue);
//       }

//       await ActivitiesService.createActivities(activities);
//     });
// }
