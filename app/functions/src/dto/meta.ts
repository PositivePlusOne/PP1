export interface FlMetaJSON {
    createdBy?: string;
    createdDate?: string;
    docId?: string;
    fl_id?: string;
    env?: string;
    locale?: string;
    schema?: string;
    schemaRefId?: string;
    lastModifiedBy?: string;
    lastModifiedDate?: string;
    lastFetchDate?: string;
    isPartial?: boolean;
}

export class FlMeta {
    createdBy?: string;
    createdDate?: string;
    docId?: string;
    fl_id?: string;
    env = '';
    locale = 'en';
    schema = '';
    schemaRefId?: string;
    lastModifiedBy?: string;
    lastModifiedDate?: string;
    lastFetchDate?: string;
    isPartial?: boolean;

    constructor(json: FlMetaJSON) {
        this.createdBy = json.createdBy;
        this.createdDate = json.createdDate;
        this.docId = json.docId;
        this.fl_id = json.fl_id;
        this.env = json.env || '';
        this.locale = json.locale || 'en';
        this.schema = json.schema || '';
        this.schemaRefId = json.schemaRefId;
        this.lastModifiedBy = json.lastModifiedBy || '';
        this.lastModifiedDate = json.lastModifiedDate || '';
        this.lastFetchDate = json.lastFetchDate || '';
        this.isPartial = json.isPartial || false;
    }

    static fromJSON(json: FlMetaJSON): FlMeta {
        return new FlMeta(json);
    }

    toJSON(): FlMetaJSON {
        return {
            createdBy: this.createdBy,
            createdDate: this.createdDate,
            docId: this.docId,
            fl_id: this.fl_id,
            env: this.env,
            locale: this.locale,
            schema: this.schema,
            schemaRefId: this.schemaRefId,
            lastModifiedBy: this.lastModifiedBy,
            lastModifiedDate: this.lastModifiedDate,
        };
    }
}
