import { FlMeta, FlMetaJSON } from "./meta";

export const reactionSchemaKey = "reactions";

export interface ReactionJSON {
    _fl_meta_?: FlMetaJSON;
    activityId?: string;
    reactionId?: string;
    senderId?: string;
    reactionType?: string;
    originFeed?: string;
}

export class Reaction {
    _fl_meta_?: FlMeta;
    activityId?: string;
    reactionId?: string;
    senderId?: string;
    reactionType?: string;
    originFeed?: string;

    constructor(json: ReactionJSON) {
        this._fl_meta_ = json._fl_meta_ ? new FlMeta(json._fl_meta_) : undefined;
        this.activityId = json.activityId;
        this.reactionId = json.reactionId;
        this.senderId = json.senderId;
        this.reactionType = json.reactionType;
        this.originFeed = json.originFeed;
    }

    public toJSON(): ReactionJSON {
        return {
            _fl_meta_: this._fl_meta_ ? this._fl_meta_.toJSON() : undefined,
            activityId: this.activityId,
            reactionId: this.reactionId,
            senderId: this.senderId,
            reactionType: this.reactionType,
            originFeed: this.originFeed,
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