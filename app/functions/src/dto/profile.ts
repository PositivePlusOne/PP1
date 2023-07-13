import { StringSetFromJson } from "./generic";
import { FlMeta, FlMetaJSON } from "./meta";
import { Place, PlaceJSON } from "./location";
import { Media } from "./media";

export interface ProfileJSON {
    id?: string;
    email?: string;
    phoneNumber?: string;
    locale?: string;
    fcmToken?: string;
    name?: string;
    displayName?: string;
    birthday?: string;
    accentColor?: string;
    hivStatus?: string;
    genders?: StringSetFromJson;
    interests?: StringSetFromJson;
    visibilityFlags?: StringSetFromJson;
    featureFlags?: StringSetFromJson;
    placeSkipped?: boolean;
    place?: PlaceJSON;
    flMeta?: FlMetaJSON;
    referenceImage?: string;
    profileImage?: string;
    biography?: string;
    media?: Media[];
}

export class Profile {
    flMeta?: FlMeta;
    email: string;
    phoneNumber: string;
    locale: string;
    fcmToken: string;
    name: string;
    displayName: string;
    birthday: string;
    accentColor: string;
    hivStatus: string;
    genders: StringSetFromJson;
    interests: StringSetFromJson;
    visibilityFlags: StringSetFromJson;
    featureFlags: StringSetFromJson;
    placeSkipped: boolean;
    place?: Place;
    biography: string;
    media: Media[];

    constructor(json: ProfileJSON) {
        this.flMeta = json.flMeta && new FlMeta(json.flMeta);
        this.email = json.email || '';
        this.phoneNumber = json.phoneNumber || '';
        this.locale = json.locale || 'en-GB';
        this.fcmToken = json.fcmToken || '';
        this.name = json.name || '';
        this.displayName = json.displayName || '';
        this.birthday = json.birthday || '';
        this.accentColor = json.accentColor || '';
        this.hivStatus = json.hivStatus || '';
        this.genders = json.genders || new Set();
        this.interests = json.interests || new Set();
        this.visibilityFlags = json.visibilityFlags || new Set();
        this.featureFlags = json.featureFlags || new Set();
        this.placeSkipped = json.placeSkipped || false;
        this.place = json.place && new Place(json.place);
        this.biography = json.biography || '';
        this.media = json.media || [];
    }
}
