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
    created_by?: string;
    created_date?: string;
    doc_id?: string;
    fl_id?: string;
    env = '';
    locale = 'en';
    schema = '';
    schema_ref_id?: string;
    updated_by?: string;
    updated_date?: string;

    constructor(json: FlMetaJSON) {
        this.created_by = json.created_by;
        this.created_date = json.created_date;
        this.doc_id = json.doc_id;
        this.fl_id = json.fl_id;
        this.env = json.env || '';
        this.locale = json.locale || 'en';
        this.schema = json.schema || '';
        this.schema_ref_id = json.schema_ref_id;
        this.updated_by = json.updated_by;
        this.updated_date = json.updated_date;
    }

    static fromJSON(json: FlMetaJSON): FlMeta {
        return new FlMeta(json);
    }
}
