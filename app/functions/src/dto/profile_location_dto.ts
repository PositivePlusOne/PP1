export type ProfileLocationDto = {
  location?: GeoLocation;
  visibilityFlags: string[];
};
export type GeoLocation = {
  latitude: number;
  longitude: number;
};
