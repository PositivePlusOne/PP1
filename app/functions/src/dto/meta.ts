export interface FlMetaJSON {
    createdBy?: string;
    createdDate?: string;
    docId?: string;
    fl_id?: string;
    env?: string;
    locale?: string;
    schema?: string;
    schemaRefId?: string;
    updatedBy?: string;
    updatedDate?: string;
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
    updatedBy?: string;
    updatedDate?: string;

    constructor(json: FlMetaJSON) {
        this.createdBy = json.createdBy;
        this.createdDate = json.createdDate;
        this.docId = json.docId;
        this.fl_id = json.fl_id;
        this.env = json.env || '';
        this.locale = json.locale || 'en';
        this.schema = json.schema || '';
        this.schemaRefId = json.schemaRefId;
        this.updatedBy = json.updatedBy;
        this.updatedDate = json.updatedDate;
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
            updatedBy: this.updatedBy,
            updatedDate: this.updatedDate,
        };
    }
}
