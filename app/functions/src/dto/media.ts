export interface MediaJSON {
    name?: string;
    type?: string;
    path?: string;
    url?: string;
    thumbnails?: MediaThumbnailJSON[];
    priority?: number;
    isSensitive?: boolean;
    isPrivate?: boolean;
}

export class Media {
    name: string;
    type: string;
    path: string;
    url: string;
    thumbnails: MediaThumbnail[];
    priority: number;
    isSensitive: boolean;
    isPrivate: boolean;

    constructor(json: MediaJSON) {
        this.name = json.name || '';
        this.type = json.type || '';
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
    type: string;
    url?: string;
}

export class MediaThumbnail {
    type: string;
    url: string;

    constructor(json: MediaThumbnailJSON) {
        this.type = json.type || '';
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
