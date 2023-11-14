export interface PlaceJSON {
  latitudeCoordinates?: number;
  longitudeCoordinates?: number;
  description?: string;
  placeId?: string;
  optOut?: boolean;
}

/**
 * Represents a place
 * @class
 * @property {number} latitude the latitude.
 * @property {number} longitude the longitude.
 * @property {string} description the description.
 * @property {string} placeId the place id. (Google Maps)
 * @property {boolean} optOut the opt out flag. (Used by profiles to opt out of sharing their location)
 */
export class Place {
  latitudeCoordinates: number | null;
  longitudeCoordinates: number | null;
  description: string | null;
  placeId: string | null;
  optOut: boolean;

  /**
   * Creates a new place.
   * @param {PlaceJSON} json the json.
   * @returns {Place} the place.
   */
  constructor(json: PlaceJSON) {
    this.latitudeCoordinates = json.latitudeCoordinates || null;
    this.longitudeCoordinates = json.longitudeCoordinates || null;
    this.description = json.description || null;
    this.placeId = json.placeId || null;
    this.optOut = json.optOut || false;
  }
}
