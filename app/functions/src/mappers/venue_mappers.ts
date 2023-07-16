import { OccasionGeniusVenue } from "../dto/events";
import { Venue } from "../dto/venues";
import { NumberHelpers } from "../helpers/number_helpers";

export namespace VenueMappers {
  /**
   * Maps an OccasionGeniusVenue to a Venue.
   * @param {OccasionGeniusVenue} occasionGeniusVenue The OccasionGeniusVenue to map.
   * @return {Venue} The mapped Venue.
   */
  export function mapOccasionGeniusVenueToVenue(occasionGeniusVenue: OccasionGeniusVenue): Venue {
    const latitude = NumberHelpers.safelyParseFloat(occasionGeniusVenue.latitude);
    const longitude = NumberHelpers.safelyParseFloat(occasionGeniusVenue.longitude);

    return {
      foreignKey: occasionGeniusVenue.uuid,
      name: occasionGeniusVenue.name,
      description: "", // Assuming there's no suitable property from OccasionGeniusVenue for description
      addressFirstLine: occasionGeniusVenue.address_1,
      addressSecondLine: occasionGeniusVenue.address_2,
      city: occasionGeniusVenue.city,
      region: occasionGeniusVenue.region,
      country: occasionGeniusVenue.country,
      postalCode: occasionGeniusVenue.postal_code,
      space: occasionGeniusVenue.space,
      place: {
        latitude: latitude,
        longitude: longitude,
        description: "", // Assuming there's no suitable property from OccasionGeniusVenue for description
        placeId: "", // Assuming there's no suitable property from OccasionGeniusVenue for placeId
        optOut: false, // Assuming there's no suitable property from OccasionGeniusVenue for optOut
      },
    };
  }

  /**
   * Maps a Venue to an OccasionGeniusVenue.
   * @param {Venue} venue The Venue to map.
   * @return {OccasionGeniusVenue} The mapped OccasionGeniusVenue.
   */
  export function mapVenueToOccasionGeniusVenue(venue: Venue): OccasionGeniusVenue {
    return {
      uuid: venue.foreignKey,
      name: venue.name,
      address_1: venue.addressFirstLine,
      address_2: venue.addressSecondLine,
      city: venue.city,
      region: venue.region,
      country: venue.country,
      postal_code: venue.postalCode,
      space: venue.space,
      latitude: venue.place?.latitude?.toString() ?? "",
      longitude: venue.place?.longitude?.toString() ?? "",
    };
  }
}
