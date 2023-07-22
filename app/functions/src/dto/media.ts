export interface MediaJSON {
    name?: string;
    type?: string;
    bucketPath?: string;
    url?: string;
    thumbnails?: MediaThumbnailJSON[];
    priority?: number;
    isSensitive?: boolean;
    isPrivate?: boolean;
}

export class Media {
    name: string;
    type: string;
    bucketPath: string;
    url: string;
    thumbnails: MediaThumbnail[];
    priority: number;
    isSensitive: boolean;
    isPrivate: boolean;

    constructor(json: MediaJSON) {
        this.name = json.name || '';
        this.type = json.type || '';
        this.bucketPath = json.bucketPath || '';
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
    bucketPath?: string;
    url?: string;
    height?: number;
    width?: number;
}

export class MediaThumbnail {
    bucketPath: string;
    url: string;
    height: number;
    width: number;

    constructor(json: MediaThumbnailJSON) {
        this.bucketPath = json.bucketPath || '';
        this.url = json.url || '';
        this.height = json.height || 0;
        this.width = json.width || 0;
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
