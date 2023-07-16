export interface FlMetaJSON {
    created_by?: string;
    created_date?: string;
    doc_id?: string;
    fl_id?: string;
    env?: string;
    locale?: string;
    schema?: string;
    schema_ref_id?: string;
    updated_by?: string;
    updated_date?: string;
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
        this.createdBy = json.created_by;
        this.createdDate = json.created_date;
        this.docId = json.doc_id;
        this.fl_id = json.fl_id;
        this.env = json.env || '';
        this.locale = json.locale || 'en';
        this.schema = json.schema || '';
        this.schemaRefId = json.schema_ref_id;
        this.updatedBy = json.updated_by;
        this.updatedDate = json.updated_date;
    }

    static fromJSON(json: FlMetaJSON): FlMeta {
        return new FlMeta(json);
    }
}
