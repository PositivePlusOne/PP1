import { MediaJSON } from "./media";
import { MentionJSON } from "./mentions";
import { FlMeta, FlMetaJSON } from "./meta";

export const commentSchemaKey = "comments";

export interface CommentJSON {
    _fl_meta_?: FlMetaJSON;
    content?: string;
    reactionId?: string;
    activityId?: string;
    senderId?: string;
    mentions?: MentionJSON[];
    media?: MediaJSON[];
}

export class Comment {
    _fl_meta_?: FlMeta;
    content?: string;
    reactionId?: string;
    activityId?: string;
    senderId?: string;
    mentions?: MentionJSON[];
    media?: MediaJSON[];

    constructor(json: CommentJSON) {
        this._fl_meta_ = json._fl_meta_ ? new FlMeta(json._fl_meta_) : undefined;
        this.content = json.content;
        this.reactionId = json.reactionId;
        this.activityId = json.activityId;
        this.senderId = json.senderId;
        this.mentions = json.mentions;
        this.media = json.media;
    }

    public toJSON(): CommentJSON {
        return {
            _fl_meta_: this._fl_meta_ ? this._fl_meta_.toJSON() : undefined,
            content: this.content,
            reactionId: this.reactionId,
            activityId: this.activityId,
            senderId: this.senderId,
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