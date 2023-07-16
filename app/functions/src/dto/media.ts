export interface MediaJSON {
    type?: string;
    path?: string;
    url?: string;
    thumbnails?: MediaThumbnailJSON[];
    priority?: number;
    isSensitive?: boolean;
    isPrivate?: boolean;
}

export class Media {
    type: MediaType;
    path: string;
    url: string;
    thumbnails: MediaThumbnail[];
    priority: number;
    isSensitive: boolean;
    isPrivate: boolean;

    constructor(json: MediaJSON) {
        this.type = MediaTypeMap[json.type || 'unknown'] || MediaType.unknown;
        this.path = json.path || '';
        this.url = json.url || '';
        this.thumbnails = MediaThumbnail.fromJsonArray(json.thumbnails || []);
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

export interface MediaThumbnailJSON {
    width?: number;
    height?: number;
    url?: string;
}

export class MediaThumbnail {
    width: number;
    height: number;
    url: string;

    constructor(json: MediaThumbnailJSON) {
        this.width = json.width || 0;
        this.height = json.height || 0;
        this.url = json.url || '';
    }

    static fromJsonArray(data: any[]): MediaThumbnail[] {
        return data.map((e) => new MediaThumbnail(e));
    }

    static fromJSON(json: MediaThumbnailJSON): MediaThumbnail {
        return new MediaThumbnail(json);
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
