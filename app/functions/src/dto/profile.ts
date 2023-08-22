import { StringSetFromJson } from "./generic";
import { FlMeta, FlMetaJSON } from "./meta";
import { Place, PlaceJSON } from "./location";
import { Media, MediaJSON } from "./media";
import { FeedService } from "../services/feed_service";
import { CacheService } from "../services/cache_service";

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

export interface ProfileStatisicsJSON {
    followers: number;
    following: number;
}

export class ProfileStatisics {
    followers: number;
    following: number;

    constructor(json: ProfileStatisicsJSON) {
        this.followers = json.followers;
        this.following = json.following;
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
    statistics?: ProfileStatisicsJSON;
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
    statistics?: ProfileStatisics;

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
        this.statistics = json.statistics && new ProfileStatisics(json.statistics);
    }

    isIncognito(): boolean {
        const featureFlags = Array.from(this.featureFlags);
        return featureFlags?.includes(featureFlagIncognito);
    }

    removeFlaggedData(isConnected: boolean): void {
        const visibilityFlags = Array.from(this.visibilityFlags);
        const featureFlags = Array.from(this.featureFlags);
        const hideInfo = this.isIncognito() && !isConnected;

        if (hideInfo || !visibilityFlags.includes(visibilityFlagName)) {
            this.name = '';
        }

        if (hideInfo || !visibilityFlags.includes(visibilityFlagBirthday)) {
            this.birthday = '';
        }

        if (hideInfo || !visibilityFlags.includes(visibilityFlagInterests)) {
            this.interests = new Set();
        }

        if (hideInfo || !visibilityFlags.includes(visibilityFlagGenders)) {
            this.genders = new Set();
        }

        if (hideInfo || !visibilityFlags.includes(visibilityFlagLocation)) {
            this.place = undefined;
            this.placeSkipped = false;
        }

        if (hideInfo || !visibilityFlags.includes(visibilityFlagHivStatus)) {
            this.hivStatus = '';
        }

        this.visibilityFlags = new Set();

        if (hideInfo) {
            this.locale = '';
            this.displayName = ''; // ? Should this be replaced with a localised anonymous name?
            this.placeSkipped = false;
            this.biography = '';
            this.media = [];
            this.featureFlags = new Set(featureFlags.filter((flag) => flag !== featureFlagIncognito));

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

    async appendFollowersAndFollowingData(): Promise<void> {
        if (!this._fl_meta_?.fl_id || this.statistics) {
            return;
        }

        const cacheKey = `profile-stats-${this._fl_meta_.fl_id}`;
        const cachedStats = await CacheService.getFromCache(cacheKey) as ProfileStatisicsJSON | undefined;
        if (cachedStats) {
            this.statistics = new ProfileStatisics(cachedStats);
            return;
        }

        const client = FeedService.getFeedsClient();
        const feed = client.feed("user", this._fl_meta_!.fl_id!);
        const followStats = await feed.followStats();

        const stats = {
            followers: followStats.results.followers.count,
            following: followStats.results.following.count,
        } as ProfileStatisicsJSON;

        this.statistics = new ProfileStatisics(stats);
        await CacheService.setInCache(cacheKey, stats, 300); // Expires every 5 minutes
    }
}
