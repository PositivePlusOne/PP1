import { FlMeta, FlMetaJSON } from "./meta";

export const feedStatisticsSchemaKey = "feedStatistics";

export interface FeedStatisticsJSON {
    _fl_meta_?: FlMetaJSON;
    counts?: Record<string, number>;
    target_slug: string;
    target_user_id: string;
}

export class FeedStatistics {
    _fl_meta_?: FlMeta;
    counts: Record<string, number>;
    target_slug: string;
    target_user_id: string;

    constructor(json: FeedStatisticsJSON) {
        this._fl_meta_ = json._fl_meta_ ? new FlMeta(json._fl_meta_) : undefined;
        this.counts = json.counts ?? {};
        this.target_slug = json.target_slug ?? "";
        this.target_user_id = json.target_user_id ?? "";
    }

    public toJSON(): FeedStatisticsJSON {
        return {
            counts: this.counts,
            target_slug: this.target_slug,
            target_user_id: this.target_user_id,
        };
    }

    static FromJSONList(jsonList: FeedStatistics[]): FeedStatistics[] {
        const list: FeedStatistics[] = [];
        if (jsonList) {
            jsonList.forEach((json) => {
                list.push(new FeedStatistics(json));
            });
        }

        return list;
    }
}