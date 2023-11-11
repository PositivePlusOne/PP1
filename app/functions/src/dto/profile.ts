import { FlMeta, FlMetaJSON } from "./meta";
import { Place, PlaceJSON } from "./location";
import { Media, MediaJSON } from "./media";

export const profileSchemaKey = 'users';
export const profileStatisticsSchemaKey = 'userStatistics';

export const visibilityFlagName = 'name';
export const visibilityFlagBirthday = 'birthday';
export const visibilityFlagIdentity = 'identity';
export const visibilityFlagInterests = 'interests';
export const visibilityFlagGenders = 'genders';
export const visibilityFlagLocation = 'location';
export const visibilityFlagHivStatus = 'hiv_status';
export const visibilityFlagCompanySectors = 'company_sectors';

export const allVisibilityFlags = [
    visibilityFlagName,
    visibilityFlagBirthday,
    visibilityFlagIdentity,
    visibilityFlagInterests,
    visibilityFlagGenders,
    visibilityFlagLocation,
    visibilityFlagHivStatus,
    visibilityFlagCompanySectors,
];

export const featureFlagMarketing = 'marketing';
export const featureFlagIncognito = 'incognito';
export const featureFlagOrganisationControls = 'organisation';
export const featureFlagPendingDeletion = 'pending_deletion';

export const maximumProfileTags = 10;

export interface ProfileStatisicsJSON {
    _fl_meta_?: FlMetaJSON;
    profileId?: string;
    counts?: Record<string, number>;
}

export class ProfileStatistics {
    _fl_meta_?: FlMeta;
    profileId?: string;
    counts?: Record<string, number>;

    constructor(json: ProfileStatisicsJSON) {
        this._fl_meta_ = json._fl_meta_ && new FlMeta(json._fl_meta_);
        this.profileId = json.profileId;
        this.counts = json.counts;
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
    genders?: string[];
    interests?: string[];
    tags?: string[];
    placeSkipped?: boolean;
    place?: PlaceJSON;
    referenceImage?: string;
    profileImage?: string;
    biography?: string;
    media?: MediaJSON[];
    accountFlags?: string[];
    visibilityFlags?: string[];
    featureFlags?: string[];
    companySectors?: string[];
    companySize?: string;
    availablePromotionsCount?: number;
    activePromotionsCount?: number;
    isBanned?: boolean;
    banReason?: string;
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
    genders: string[];
    interests: string[];
    tags: string[];
    placeSkipped: boolean;
    place?: Place;
    biography: string;
    media: Media[];
    accountFlags: string[];
    visibilityFlags: string[];
    featureFlags: string[];
    companySectors: string[];
    companySize?: string;
    availablePromotionsCount: number;
    activePromotionsCount: number;
    isBanned?: boolean;
    banReason?: string;

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
        this.genders = json.genders || [];
        this.interests = json.interests || [];
        this.tags = json.tags || [];
        this.placeSkipped = json.placeSkipped || false;
        this.place = json.place && new Place(json.place);
        this.biography = json.biography || '';
        this.media = json.media ? json.media.map((media) => new Media(media)) : [];
        this.accountFlags = json.accountFlags || [];
        this.visibilityFlags = json.visibilityFlags || [];
        this.featureFlags = json.featureFlags || [];
        this.companySectors = json.companySectors || [];
        this.companySize = json.companySize;
        this.availablePromotionsCount = json.availablePromotionsCount || 0;
        this.activePromotionsCount = json.activePromotionsCount || 0;
        this.isBanned = json.isBanned;
        this.banReason = json.banReason;
    }

    isIncognito(): boolean {
        const featureFlags = Array.from(this.featureFlags);
        return featureFlags?.includes(featureFlagIncognito);
    }

    isOrganisation(): boolean {
        const featureFlags = Array.from(this.featureFlags);
        return featureFlags?.includes(featureFlagOrganisationControls);
    }

    removeFlaggedData(): void {
        const isIncognito = this.isIncognito();
        const currentVisibilityFlagsSet = Array.from(this.visibilityFlags);

        if (isIncognito || !currentVisibilityFlagsSet.includes(visibilityFlagName)) {
            this.name = '';
        }

        if (isIncognito || !currentVisibilityFlagsSet.includes(visibilityFlagBirthday)) {
            this.birthday = '';
        }

        if (isIncognito || !currentVisibilityFlagsSet.includes(visibilityFlagInterests)) {
            this.interests = [];
        }

        if (isIncognito || !currentVisibilityFlagsSet.includes(visibilityFlagGenders)) {
            this.genders = [];
        }

        if (isIncognito || !currentVisibilityFlagsSet.includes(visibilityFlagLocation)) {
            this.place = undefined;
            this.placeSkipped = false;
        }

        if (isIncognito || !currentVisibilityFlagsSet.includes(visibilityFlagHivStatus)) {
            this.hivStatus = '';
        }

        if (isIncognito || !currentVisibilityFlagsSet.includes(visibilityFlagCompanySectors)) {
            this.companySectors = [];
        }

        if (isIncognito) {
            this.locale = '';
            this.displayName = ''; // ? Should this be replaced with a localised anonymous name?
            this.placeSkipped = false;
            this.biography = '';
            this.media = [];
        }
    }

    removePrivateData(): void {
        this.email = '';
        this.phoneNumber = '';
        this.fcmToken = '';
        this.media = this.media.filter((media) => !media.isPrivate);
    }

    notifyPartial(): void {
        if (!this._fl_meta_) {
            return;
        }

        this._fl_meta_.isPartial = true;
    }

    computeSearchTags(): void {
        this._tags = [
            this.displayName.length > 0 ? 'hasDisplayName' : '',
            this.media.filter((media) => !media.isPrivate).length > 0 ? 'hasPublicMedia' : '',
        ];
    }

    generateExternalSearchTags(): string[] {
        return [
            this.displayName,
            this.name,
        ];
    }
}
