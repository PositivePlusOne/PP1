import { Timestamp } from "firebase-admin/firestore";
import { FlMeta, FlMetaJSON } from "./meta";

export const promotionsSchemaKey = "promotions";
export const promotionsStatisticsSchemaKey = "promotionsStatistics";

export interface PromotionOwnerJSON {
    profileId?: string;
    role?: string;
}

export class PromotionOwner {
    profileId?: string;
    role?: string;

    constructor(json: PromotionOwnerJSON) {
        this.profileId = json.profileId;
        this.role = json.role;
    }
}

export interface PromotedActivityJSON {
    activityId?: string;
}

export class PromotedActivity {
    activityId?: string;

    constructor(json: PromotedActivityJSON) {
        this.activityId = json.activityId;
    }
}

export interface PromotionStatisticsJSON {
    _fl_meta_?: FlMetaJSON;
    promotionId?: string;
    counts?: Record<string, number>;
    lastFetchedFromMixpanel?: Timestamp;
}

export class PromotionStatistics {
    _fl_meta_?: FlMeta;
    promotionId?: string;
    counts?: Record<string, number>;
    lastFetchedFromMixpanel?: Timestamp;

    constructor(json: PromotionStatisticsJSON) {
        this._fl_meta_ = json._fl_meta_ && new FlMeta(json._fl_meta_);
        this.promotionId = json.promotionId;
        this.counts = json.counts;
        this.lastFetchedFromMixpanel = json.lastFetchedFromMixpanel;
    }
}

export interface PromotionJSON {
    _fl_meta_?: FlMetaJSON;
    title?: string;
    link?: string;
    linkText?: string;
    owners?: PromotionOwnerJSON[];
    activities?: PromotedActivityJSON[];
    isActive?: boolean;
    seed?: number;
    totalViewsSinceLastUpdate?: number;
    totalViewsAllotment?: number;
    startDate?: Timestamp;
    endDate?: Timestamp;
}

export class Promotion {
    _fl_meta_?: FlMeta;
    title?: string;
    link?: string;
    linkText?: string;
    owners?: PromotionOwner[];
    activities?: PromotedActivity[];
    isActive?: boolean;
    seed?: number;
    totalViewsSinceLastUpdate?: number;
    totalViewsAllotment?: number;
    startDate?: Timestamp;
    endDate?: Timestamp;

    constructor(json: PromotionJSON) {
        this._fl_meta_ = json._fl_meta_ && new FlMeta(json._fl_meta_);
        this.title = json.title;
        this.link = json.link;
        this.linkText = json.linkText;
        this.owners = json.owners && json.owners.map((owner) => new PromotionOwner(owner));
        this.activities = json.activities && json.activities.map((activity) => new PromotedActivity(activity));
        this.isActive = json.isActive;
        this.seed = json.seed;
        this.totalViewsSinceLastUpdate = json.totalViewsSinceLastUpdate;
        this.totalViewsAllotment = json.totalViewsAllotment;
        this.startDate = json.startDate;
        this.endDate = json.endDate;
    }
}