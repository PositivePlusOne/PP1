export interface FeedRequestJSON {
  targetSlug: string;
  targetUserId: string;
}

export class FeedRequest {
  targetSlug: string;
  targetUserId: string;

  constructor(json: FeedRequestJSON) {
    this.targetSlug = json.targetSlug || "";
    this.targetUserId = json.targetUserId || "";
  }
}
