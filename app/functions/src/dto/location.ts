export interface PlaceJSON {
  latitude?: number;
  longitude?: number;
  description?: string;
  placeId?: string;
}

export class Place {
  latitude: number | null;
  longitude: number | null;
  description: string | null;
  placeId: string | null;

  constructor(json: PlaceJSON) {
    this.latitude = json.latitude || null;
    this.longitude = json.longitude || null;
    this.description = json.description || null;
    this.placeId = json.placeId || null;
  }
};
