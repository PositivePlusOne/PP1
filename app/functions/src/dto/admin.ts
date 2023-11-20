import { DocumentReference, Timestamp } from "firebase-admin/firestore";
import { FlMeta, FlMetaJSON } from "./meta";

export const adminQuickActionsSchemaKey = 'adminQuickActions';
export const adminScheduledActionsSchemaKey = 'adminScheduledActions';

export interface AdminScheduledActionJSON {
    _fl_meta_?: FlMetaJSON;
    cron?: string;
    actionJson?: string;
    lastRunDate?: string;
    lastRunActionId?: string;
}

export class AdminScheduledAction {
    _fl_meta_?: FlMeta;
    cron: string;
    actionJson: string;
    lastRunDate?: string;
    lastRunActionId?: string;

    constructor(data: AdminScheduledActionJSON) {
        this._fl_meta_ = data._fl_meta_ ? new FlMeta(data._fl_meta_) : undefined;
        this.cron = data.cron || '';
        this.actionJson = data.actionJson || '';
        this.lastRunDate = data.lastRunDate || '';
        this.lastRunActionId = data.lastRunActionId || '';
    }

    toJSON(): AdminScheduledActionJSON {
        return {
            _fl_meta_: this._fl_meta_?.toJSON(),
            cron: this.cron || '',
            actionJson: this.actionJson || '',
            lastRunDate: this.lastRunDate || '',
            lastRunActionId: this.lastRunActionId || '',
        };
    }
}

export interface AdminQuickActionDataJSON {
    target?: string;
    profiles?: DocumentReference[];
    activities?: DocumentReference[];
    promotions?: DocumentReference[];
    directoryEntries?: DocumentReference[];
    accountFlag?: string;
    promotionTypes?: string[];
    url?: string;
    feed?: string;
}

export class AdminQuickActionData {
    target: string;
    profiles: DocumentReference[];
    activities: DocumentReference[];
    promotions: DocumentReference[];
    directoryEntries: DocumentReference[];
    accountFlag: string;
    promotionTypes: string[];
    url: string;
    feed: string;

    constructor(data: AdminQuickActionDataJSON) {
        this.target = data.target || '';
        this.profiles = data.profiles || [];
        this.activities = data.activities || [];
        this.promotions = data.promotions || [];
        this.directoryEntries = data.directoryEntries || [];
        this.accountFlag = data.accountFlag || '';
        this.promotionTypes = data.promotionTypes || [];
        this.url = data.url || '';
        this.feed = data.feed || '';
    }

    toJSON(): AdminQuickActionDataJSON {
        return {
            target: this.target,
            profiles: this.profiles,
            activities: this.activities,
            promotions: this.promotions,
            directoryEntries: this.directoryEntries,
            accountFlag: this.accountFlag,
            promotionTypes: this.promotionTypes,
            url: this.url,
            feed: this.feed,
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