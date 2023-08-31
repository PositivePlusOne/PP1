import { FlMeta, FlMetaJSON } from "./meta";

export const reactionSchemaKey = "reactions";
export const reactionStatisticsSchemaKey = "reactionStatistics";

export interface ReactionStatisticsJSON {
    feed: string;
    counts: Record<string, number>;
    unique_user_reactions?: Record<string, boolean>;
    activity_id?: string;
    reaction_id?: string;
    user_id?: string;
}

export class ReactionStatistics {
    feed: string;
    counts: Record<string, number>;
    unique_user_reactions: Record<string, boolean>;
    activity_id: string;
    reaction_id: string;
    user_id: string;

    constructor(json: ReactionStatisticsJSON) {
        this.feed = json.feed;
        this.counts = json.counts;
        this.unique_user_reactions = json.unique_user_reactions ?? {};
        this.activity_id = json.activity_id ?? "";
        this.reaction_id = json.reaction_id ?? "";
        this.user_id = json.user_id ?? "";
    }

    public toJSON(): ReactionStatisticsJSON {
        return {
            feed: this.feed,
            counts: this.counts,
            unique_user_reactions: this.unique_user_reactions ?? {},
            activity_id: this.activity_id,
            reaction_id: this.reaction_id,
            user_id: this.user_id,
        };
    }

    static FromJSONList(jsonList: ReactionStatisticsJSON[]): ReactionStatistics[] {
        const list: ReactionStatistics[] = [];
        if (jsonList) {
            jsonList.forEach((json) => {
                list.push(new ReactionStatistics(json));
            });
        }

        return list;
    }
}

export interface ReactionJSON {
    _fl_meta_?: FlMetaJSON;
    activity_id?: string;
    reaction_id?: string;
    user_id?: string;
    kind?: string;
    origin?: string;
}

export class Reaction {
    _fl_meta_?: FlMeta;
    activity_id?: string;
    reaction_id?: string;
    user_id?: string;
    kind?: string;
    origin?: string;

    constructor(json: ReactionJSON) {
        this._fl_meta_ = json._fl_meta_ ? new FlMeta(json._fl_meta_) : undefined;
        this.activity_id = json.activity_id;
        this.reaction_id = json.reaction_id;
        this.user_id = json.user_id;
        this.kind = json.kind;
        this.origin = json.origin;
    }

    public toJSON(): ReactionJSON {
        return {
            _fl_meta_: this._fl_meta_ ? this._fl_meta_.toJSON() : undefined,
            activity_id: this.activity_id,
            reaction_id: this.reaction_id,
            user_id: this.user_id,
            kind: this.kind,
            origin: this.origin,
        };
    }

    static FromJSONList(jsonList: ReactionJSON[]): Reaction[] {
        const list: Reaction[] = [];
        if (jsonList) {
            jsonList.forEach((json) => {
                list.push(new Reaction(json));
            });
        }

        return list;
    }
}