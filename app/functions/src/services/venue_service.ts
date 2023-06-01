import * as functions from "firebase-functions";

import { OccasionGeniusVenue } from "../dto/events";
import { DataService } from "./data_service";
import { VenueMappers } from "../mappers/venue_mappers";

export namespace VenueService {
  /**
   * Creates a venue from an OccasionGeniusVenue.
   * @param {OccasionGeniusVenue} venue The OccasionGeniusVenue to create a venue from.
   * @return {Promise<void>} A promise that resolves when the venue has been created.
   */
  export async function createOccasionGeniusVenue(venue: OccasionGeniusVenue): Promise<void> {
    functions.logger.info(`Creating venue ${venue.name}`);
    const mappedVenue = VenueMappers.mapOccasionGeniusVenueToVenue(venue);
    await DataService.updateDocument({
      schemaKey: "venues",
      entryId: venue.uuid,
      data: mappedVenue,
    });

    functions.logger.info(`Created venue ${venue.name}`);
  }
}
