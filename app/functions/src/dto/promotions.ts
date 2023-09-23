import { FlMeta, FlMetaJSON } from "./meta";

export const promotionsSchemaKey = "promotions";

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

export interface PromotionJSON {
    _fl_meta_?: FlMetaJSON;
    title?: string;
    descriptionMarkdown?: string;
    link?: string;
    linkText?: string;
    owners?: PromotionOwnerJSON[];
    activities?: PromotedActivityJSON[];
    startTime?: string;
    endTime?: string;
}

export class Promotion {
    _fl_meta_?: FlMeta;
    title?: string;
    descriptionMarkdown?: string;
    link?: string;
    linkText?: string;
    owners?: PromotionOwner[];
    activities?: PromotedActivity[];
    startTime?: string;
    endTime?: string;

    constructor(json: PromotionJSON) {
        this._fl_meta_ = json._fl_meta_ && new FlMeta(json._fl_meta_);
        this.title = json.title;
        this.descriptionMarkdown = json.descriptionMarkdown;
        this.link = json.link;
        this.linkText = json.linkText;
        this.owners = json.owners && json.owners.map((owner) => new PromotionOwner(owner));
        this.activities = json.activities && json.activities.map((activity) => new PromotedActivity(activity));
        this.startTime = json.startTime;
        this.endTime = json.endTime;
    }
}