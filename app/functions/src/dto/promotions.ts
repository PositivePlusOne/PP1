import { FlMeta, FlMetaJSON } from "./meta";

export interface PromotionJSON {
    _fl_meta_?: FlMetaJSON;
    title?: string;
    descriptionMarkdown?: string;
    link?: string;
    linkText?: string;
    owner?: any;
    startTime?: string;
    endTime?: string;
}

export class Promotion {
    _fl_meta_?: FlMeta;
    title?: string;
    descriptionMarkdown?: string;
    link?: string;
    linkText?: string;
    owner?: string;
    startTime?: string;
    endTime?: string;

    constructor(json: PromotionJSON) {
        this._fl_meta_ = json._fl_meta_ && new FlMeta(json._fl_meta_);
        this.title = json.title;
        this.descriptionMarkdown = json.descriptionMarkdown;
        this.link = json.link;
        this.linkText = json.linkText;
        this.owner = json.owner;
        this.startTime = json.startTime;
        this.endTime = json.endTime;
    }
}