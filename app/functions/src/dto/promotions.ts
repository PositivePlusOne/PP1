import { Timestamp } from "firebase-admin/firestore";
import { FlMeta, FlMetaJSON } from "./meta";

export const promotionsSchemaKey = "promotions";
export const promotionsStatisticsSchemaKey = "promotionsStatistics";

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
    description?: string;
    link?: string;
    linkText?: string;
    ownerId?: string;
    activityId?: string;
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
    description?: string;
    link?: string;
    linkText?: string;
    ownerId?: string;
    activityId?: string;
    isActive?: boolean;
    seed?: number;
    totalViewsSinceLastUpdate?: number;
    totalViewsAllotment?: number;
    startDate?: Timestamp;
    endDate?: Timestamp;

    constructor(json: PromotionJSON) {
        this._fl_meta_ = json._fl_meta_ && new FlMeta(json._fl_meta_);
        this.title = json.title;
        this.description = json.description;
        this.link = json.link;
        this.linkText = json.linkText;
        this.ownerId = json.ownerId;
        this.activityId = json.activityId;
        this.isActive = json.isActive;
        this.seed = json.seed;
        this.totalViewsSinceLastUpdate = json.totalViewsSinceLastUpdate;
        this.totalViewsAllotment = json.totalViewsAllotment;
        this.startDate = json.startDate;
        this.endDate = json.endDate;
    }
}