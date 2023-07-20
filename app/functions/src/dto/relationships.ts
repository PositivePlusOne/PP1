import { FlMeta, FlMetaJSON } from "./meta";

export const relationshipSchemaKey = 'relationships';

export interface RelationshipMemberJSON {
    hasBlocked?: boolean;
    hasConnected?: boolean;
    hasFollowed?: boolean;
    hasHidden?: boolean;
    hasMuted?: boolean;
    memberId?: string;
}

export class RelationshipMember {
    hasBlocked: boolean;
    hasConnected: boolean;
    hasFollowed: boolean;
    hasHidden: boolean;
    hasMuted: boolean;
    memberId: string;

    constructor(json: RelationshipMemberJSON) {
        this.hasBlocked = json.hasBlocked || false;
        this.hasConnected = json.hasConnected || false;
        this.hasFollowed = json.hasFollowed || false;
        this.hasHidden = json.hasHidden || false;
        this.hasMuted = json.hasMuted || false;
        this.memberId = json.memberId || '';
    }
}

export interface RelationshipJSON {
    _fl_meta_?: FlMetaJSON;
    blocked?: boolean;
    channelId?: string;
    connected?: boolean;
    following?: boolean;
    hidden?: boolean;
    id?: string;
    muted?: boolean;
    members?: RelationshipMemberJSON[];
}

export class Relationship {
    _fl_meta_?: FlMeta;
    blocked: boolean;
    channelId: string;
    connected: boolean;
    following: boolean;
    hidden: boolean;
    id: string;
    muted: boolean;
    members: RelationshipMember[];

    constructor(json: RelationshipJSON) {
        this._fl_meta_ = json._fl_meta_ ? new FlMeta(json._fl_meta_) : undefined;
        this.blocked = json.blocked || false;
        this.channelId = json.channelId || '';
        this.connected = json.connected || false;
        this.following = json.following || false;
        this.hidden = json.hidden || false;
        this.id = json.id || '';
        this.muted = json.muted || false;
        this.members = json.members?.map((member) => new RelationshipMember(member)) || [];
    }
}
