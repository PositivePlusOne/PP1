import { GeoLocation } from "./shared";

export type Venue = {
    foreignKey: string;
    name: string;
    description: string;
    addressFirstLine: string;
    addressSecondLine: string;
    city: string;
    region: string;
    country: string;
    postalCode: string;
    space: string;
    location: GeoLocation,
}