export interface MediaJSON {
    type?: string;
    url?: string;
    priority?: number;
    isSensitive?: boolean;
    isPrivate?: boolean;
}

export class Media {
    type: MediaType;
    url: string;
    priority: number;
    isSensitive: boolean;
    isPrivate: boolean;

    constructor(json: MediaJSON) {
        this.type = MediaTypeMap[json.type || "unknown"] || MediaType.unknown;
        this.url = json.url || '';
        this.priority = json.priority || kMediaPriorityDefault;
        this.isSensitive = json.isSensitive || false;
        this.isPrivate = json.isPrivate || false;
    }

    static fromJsonArray(data: any[]): Media[] {
        return data.map((e) => new Media(e));
    }

    static fromJSON(json: MediaJSON): Media {
        return new Media(json);
    }
}

export const kMediaPriorityMax = 0;
export const kMediaPriorityDefault = 1000;

export enum MediaType {
    unknown,
    website_link,
    ticket_link,
    photo_link,
    video_link,
    bucket_path,
}

export const MediaTypeMap: { [key: string]: MediaType } = {
    "unknown": MediaType.unknown,
    "website_link": MediaType.website_link,
    "ticket_link": MediaType.ticket_link,
    "photo_link": MediaType.photo_link,
    "video_link": MediaType.video_link,
    "bucket_path": MediaType.bucket_path,
};
