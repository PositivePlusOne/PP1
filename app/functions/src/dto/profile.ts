import { StringSetFromJson } from "./generic";
import { FlMeta, FlMetaJSON } from "./meta";
import { Place, PlaceJSON } from "./location";
import { Media } from "./media";

export const profileSchemaKey = 'users';

export const visibilityFlagName = 'name';
export const visibilityFlagBirthday = 'birthday';
export const visibilityFlagIdentity = 'identity';
export const visibilityFlagMedical = 'medical';
export const visibilityFlagInterests = 'interests';
export const visibilityFlagGenders = 'genders';
export const visibilityFlagLocation = 'location';
export const visibilityFlagHivStatus = 'hiv_status';

export const featureFlagMarketing = 'marketing';
export const featureFlagIncognito = 'incognito';
export const featureFlagOrganisationControls = 'organisationControls';

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

    removeFlaggedData(): void {
        const visibilityFlags = Array.from(this.visibilityFlags);

        if (!visibilityFlags.includes(visibilityFlagName)) {
            this.name = '';
            this.displayName = '';
        }

        if (!visibilityFlags.includes(visibilityFlagBirthday)) {
            this.birthday = '';
        }

        if (!visibilityFlags.includes(visibilityFlagIdentity)) {
            this.email = '';
            this.phoneNumber = '';
        }

        if (!visibilityFlags.includes(visibilityFlagMedical)) {
            this.hivStatus = '';
        }

        if (!visibilityFlags.includes(visibilityFlagInterests)) {
            this.interests = new Set();
        }

        if (!visibilityFlags.includes(visibilityFlagGenders)) {
            this.genders = new Set();
        }

        if (!visibilityFlags.includes(visibilityFlagLocation)) {
            this.place = undefined;
            this.placeSkipped = false;
        }

        if (!visibilityFlags.includes(visibilityFlagHivStatus)) {
            this.hivStatus = '';
        }
    }

    removePrivateData(): void {
        this.email = '';
        this.phoneNumber = '';
        this.fcmToken = '';
    }
}
