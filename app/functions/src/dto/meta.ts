export interface FlMetaJSON {
    createdBy?: string;
    createdDate?: string | FirebaseFirestore.Timestamp;
    ownedBy?: string;
    ownedAsOfDate?: string | FirebaseFirestore.Timestamp;
    directoryEntryId?: string;
    docId?: string;
    fl_id?: string;
    env?: string;
    locale?: string;
    schema?: string;
    schemaRefId?: string;
    lastModifiedBy?: string;
    lastModifiedDate?: string | FirebaseFirestore.Timestamp;
    lastFetchMillis?: number;
    isPartial?: boolean;
}

export class FlMeta {
    createdBy?: string;
    createdDate?: string | FirebaseFirestore.Timestamp;
    ownedBy?: string;
    ownedAsOfDate?: string | FirebaseFirestore.Timestamp;
    directoryEntryId?: string;
    docId?: string;
    fl_id?: string;
    env = '';
    locale = 'en';
    schema = '';
    schemaRefId?: string;
    lastModifiedBy?: string;
    lastModifiedDate?: string | FirebaseFirestore.Timestamp;
    lastFetchMillis?: number;
    isPartial?: boolean;

    constructor(json: FlMetaJSON) {
        this.createdBy = json.createdBy;
        this.createdDate = json.createdDate;
        this.ownedBy = json.ownedBy;
        this.ownedAsOfDate = json.ownedAsOfDate;
        this.directoryEntryId = json.directoryEntryId;
        this.docId = json.docId;
        this.fl_id = json.fl_id;
        this.env = json.env || '';
        this.locale = json.locale || 'en';
        this.schema = json.schema || '';
        this.schemaRefId = json.schemaRefId;
        this.lastModifiedBy = json.lastModifiedBy || '';
        this.lastModifiedDate = json.lastModifiedDate || '';
        this.lastFetchMillis = json.lastFetchMillis || -1;
        this.isPartial = json.isPartial || false;
    }

    static fromJSON(json: FlMetaJSON): FlMeta {
        return new FlMeta(json);
    }

    toJSON(): FlMetaJSON {
        return {
            createdBy: this.createdBy,
            createdDate: this.createdDate,
            ownedBy: this.ownedBy,
            ownedAsOfDate: this.ownedAsOfDate,
            directoryEntryId: this.directoryEntryId,
            docId: this.docId,
            fl_id: this.fl_id,
            env: this.env,
            locale: this.locale,
            schema: this.schema,
            schemaRefId: this.schemaRefId,
            lastModifiedBy: this.lastModifiedBy,
            lastModifiedDate: this.lastModifiedDate,
            lastFetchMillis: this.lastFetchMillis,
            isPartial: this.isPartial,
        };
    }
}
