import { MediaJSON } from "./media";
import { MentionJSON } from "./mentions";
import { FlMeta, FlMetaJSON } from "./meta";

export const commentSchemaKey = "comments";

export interface CommentJSON {
    _fl_meta_?: FlMetaJSON;
    data?: string;
    reaction_id?: string;
    activity_id?: string;
    user_id?: string;
    origin?: string;
    mentions?: MentionJSON[];
    media?: MediaJSON[];
}

export class Comment {
    _fl_meta_?: FlMeta;
    data?: string;
    reaction_id?: string;
    activity_id?: string;
    user_id?: string;
    origin?: string;
    mentions?: MentionJSON[];
    media?: MediaJSON[];

    constructor(json: CommentJSON) {
        this._fl_meta_ = json._fl_meta_ ? new FlMeta(json._fl_meta_) : undefined;
        this.data = json.data;
        this.reaction_id = json.reaction_id;
        this.activity_id = json.activity_id;
        this.user_id = json.user_id;
        this.origin = json.origin;
        this.mentions = json.mentions;
        this.media = json.media;
    }

    public toJSON(): CommentJSON {
        return {
            _fl_meta_: this._fl_meta_ ? this._fl_meta_.toJSON() : undefined,
            data: this.data,
            reaction_id: this.reaction_id,
            activity_id: this.activity_id,
            user_id: this.user_id,
            origin: this.origin,
            mentions: this.mentions,
            media: this.media,
        };
    }

    static FromJSONList(jsonList: CommentJSON[]): Comment[] {
        const list: Comment[] = [];
        if (jsonList) {
            jsonList.forEach((json) => {
                list.push(new Comment(json));
            });
        }

        return list;
    }
}