import { DocumentReference } from "firebase-admin/firestore";
import { FlMeta, FlMetaJSON } from "./meta";

export const adminQuickActionsSchemaKey = 'adminQuickActions';

export interface AdminQuickActionDataJSON {
    target?: string;
    profiles?: DocumentReference[];
}

export class AdminQuickActionData {
    target: string;
    profiles: DocumentReference[];

    constructor(data: AdminQuickActionDataJSON) {
        this.target = data.target || '';
        this.profiles = data.profiles || [];
    }

    toJSON(): AdminQuickActionDataJSON {
        return {
            target: this.target,
            profiles: this.profiles,
        };
    }
}

export interface AdminQuickActionJSON {
    _fl_meta_?: FlMetaJSON;
    action?: string;
    status?: string;
    output?: string;
    data?: AdminQuickActionDataJSON[];
}

export class AdminQuickAction {
    _fl_meta_?: FlMeta;
    action: string;
    status: string;
    output: string;
    data: AdminQuickActionData[];

    constructor(data: AdminQuickActionJSON) {
        this._fl_meta_ = data._fl_meta_ ? new FlMeta(data._fl_meta_) : undefined;
        this.action = data.action || '';
        this.status = data.status || '';
        this.output = data.output || '';
        this.data = data.data ? data.data.map((d) => new AdminQuickActionData(d)) : [];
    }

    toJSON(): AdminQuickActionJSON {
        return {
            action: this.action || '',
            status: this.status || '',
            output: this.output || '',
            data: this.data?.map((d) => d.toJSON()) || [],
        };
    }
}