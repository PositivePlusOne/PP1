import { FlMeta, FlMetaJSON } from "./meta";

export interface BookmarkJson {
    _fl_meta_?: FlMetaJSON;
    profile: any;
    activity: any;
    type: string;
}

export class Bookmark {
    _fl_meta_?: FlMeta;
    profile: any;
    activity: any;
    type: string;

    constructor(json: BookmarkJson) {
        this._fl_meta_ = json._fl_meta_ && new FlMeta(json._fl_meta_);
        this.profile = json.profile;
        this.activity = json.activity;
        this.type = json.type;
    }
}