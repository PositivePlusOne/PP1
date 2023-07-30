import { Place, PlaceJSON } from "./location";
import { FlMeta, FlMetaJSON } from "./meta";

export const directorySchemaKey = "guidanceDirectoryEntries";

export interface DirectoryEntryJSON {
    _fl_meta_?: FlMetaJSON;
    place?: PlaceJSON;
    title?: string;
    description?: string;
    markdown?: string;
    websiteUrl?: string;
    logoUrl?: string;
    profile?: string;
    services?: string[];
}

export class DirectoryEntry {
    _fl_meta_?: FlMeta;
    place?: Place;
    title?: string;
    description?: string;
    markdown?: string;
    websiteUrl?: string;
    logoUrl?: string;
    profile?: string;
    services?: string[];

    constructor(json: DirectoryEntryJSON) {
        this._fl_meta_ = json._fl_meta_ ? new FlMeta(json._fl_meta_) : undefined;
        this.place = json.place && new Place(json.place);
        this.title = json.title;
        this.description = json.description;
        this.markdown = json.markdown;
        this.websiteUrl = json.websiteUrl;
        this.logoUrl = json.logoUrl;
        this.profile = json.profile;
        this.services = json.services;
    }
}
  