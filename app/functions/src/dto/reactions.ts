import { Mention, MentionJSON } from "./mentions";
import { FlMeta, FlMetaJSON } from "./meta";

export const reactionSchemaKey = "reactions";

export interface ReactionJSON {
    _fl_meta_?: FlMetaJSON;
    activity_id?: string;
    target_user_id?: string;
    reaction_id?: string;
    entry_id?: string;
    user_id?: string;
    kind?: string;
    text?: string;
    tags?: string[];
    mentions?: MentionJSON[];
}

export class Reaction {
    _fl_meta_?: FlMeta;
    activity_id?: string;
    target_user_id?: string;
    reaction_id?: string;
    entry_id?: string;
    user_id?: string;
    kind?: string;
    text?: string;
    tags?: string[];
    mentions: Mention[];

    constructor(json: ReactionJSON) {
        this._fl_meta_ = json._fl_meta_ ? new FlMeta(json._fl_meta_) : undefined;
        this.activity_id = json.activity_id;
        this.target_user_id = json.target_user_id;
        this.reaction_id = json.reaction_id;
        this.entry_id = json.entry_id;
        this.user_id = json.user_id;
        this.kind = json.kind;
        this.text = json.text;
        this.tags = json.tags;
        this.mentions = json.mentions ? json.mentions.map((m) => new Mention(m)) : [];
    }

    public toJSON(): ReactionJSON {
        return {
            _fl_meta_: this._fl_meta_ ? this._fl_meta_.toJSON() : undefined,
            activity_id: this.activity_id,
            target_user_id: this.target_user_id,
            reaction_id: this.reaction_id,
            entry_id: this.entry_id,
            user_id: this.user_id,
            kind: this.kind,
            text: this.text,
            tags: this.tags,
            mentions: this.mentions ? this.mentions.map((m) => m.toJSON()) : undefined,
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