import { StringSetFromJson } from "./generic";
import { FlMeta, FlMetaJSON } from "./meta";
import { Place, PlaceJSON } from "./location";
import { Media, MediaJSON } from "./media";

export const profileSchemaKey = 'users';

export const visibilityFlagName = 'name';
export const visibilityFlagBirthday = 'birthday';
export const visibilityFlagIdentity = 'identity';
export const visibilityFlagInterests = 'interests';
export const visibilityFlagGenders = 'genders';
export const visibilityFlagLocation = 'location';
export const visibilityFlagHivStatus = 'hiv_status';

export const featureFlagMarketing = 'marketing';
export const featureFlagIncognito = 'incognito';
export const featureFlagOrganisationControls = 'organisationControls';

export interface ProfileOrganisationConfigurationJSON {
    members?: any[];
}

export class ProfileOrganisationConfiguration {
    members: any[];

    constructor(json: ProfileOrganisationConfigurationJSON) {
        this.members = json.members || [];
    }
}

export interface ProfileJSON {
    _fl_meta_?: FlMetaJSON;
    _tags?: string[];
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
    referenceImage?: string;
    profileImage?: string;
    biography?: string;
    organisationConfiguration?: ProfileOrganisationConfigurationJSON;
    media?: MediaJSON[];
}

export class Profile {
    _fl_meta_?: FlMeta;
    _tags?: string[];
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
    organisationConfiguration?: ProfileOrganisationConfiguration;
    media: Media[];

    constructor(json: ProfileJSON) {
        this._fl_meta_ = json._fl_meta_ && new FlMeta(json._fl_meta_);
        this._tags = json._tags;
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
        this.organisationConfiguration = json.organisationConfiguration && new ProfileOrganisationConfiguration(json.organisationConfiguration);
        this.media = json.media ? json.media.map((media) => new Media(media)) : [];
    }

    isIncognito(): boolean {
        const featureFlags = Array.from(this.featureFlags);
        return featureFlags?.includes(featureFlagIncognito);
    }

    removeFlaggedData(isConnected: boolean): void {
        const visibilityFlags = Array.from(this.visibilityFlags);
        const incognito = this.isIncognito() && !isConnected;

        if (incognito || !visibilityFlags.includes(visibilityFlagName)) {
            this.name = '';
        }

        if (incognito || !visibilityFlags.includes(visibilityFlagBirthday)) {
            this.birthday = '';
        }

        if (incognito || !visibilityFlags.includes(visibilityFlagInterests)) {
            this.interests = new Set();
        }

        if (incognito || !visibilityFlags.includes(visibilityFlagGenders)) {
            this.genders = new Set();
        }

        if (incognito || !visibilityFlags.includes(visibilityFlagLocation)) {
            this.place = undefined;
            this.placeSkipped = false;
        }

        if (incognito || !visibilityFlags.includes(visibilityFlagHivStatus)) {
            this.hivStatus = '';
        }

        this.visibilityFlags = new Set();

        if (incognito) {
            this.locale = '';
            this.displayName = ''; // ? Should this be replaced with a localised anonymous name?
            this.placeSkipped = false;
            this.biography = '';
            this.media = [];
            this.featureFlags.delete(featureFlagIncognito);

            // ? Not sure if this should be removed or not
            // this.organisationConfiguration = json.organisationConfiguration && new ProfileOrganisationConfiguration(json.organisationConfiguration);
            // this.featureFlags.delete(featureFlagOrganisationControls);
            // this.featureFlags.delete(featureFlagMarketing);
        }
    }

    removePrivateData(): void {
        this.email = '';
        this.phoneNumber = '';
        this.fcmToken = '';
        this.media = this.media.filter((media) => !media.isPrivate);
    }

    computeSearchTags(): void {
        this._tags = [
            this.displayName.length > 0 ? 'hasDisplayName' : '',
            this.media.filter((media) => !media.isPrivate).length > 0 ? 'hasPublicMedia' : '',
        ];
    }
}
