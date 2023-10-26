import { FeedRequestJSON } from "../dto/feed_dtos";

// A pre-defined list of feeds that should be followed by the user's timeline feed.
export const DEFAULT_USER_TIMELINE_FEED_SUBSCRIPTION_SLUGS = [
    { targetSlug: "tags", targetUserId: "system" } as FeedRequestJSON,
    { targetSlug: "tags", targetUserId: "admin" } as FeedRequestJSON,
    { targetSlug: "tags", targetUserId: "recommended" } as FeedRequestJSON,
    { targetSlug: "tags", targetUserId: "sponsored" } as FeedRequestJSON,
    { targetSlug: "tags", targetUserId: "trending" } as FeedRequestJSON,
    { targetSlug: "tags", targetUserId: "popular" } as FeedRequestJSON,
    { targetSlug: "tags", targetUserId: "new" } as FeedRequestJSON,
    { targetSlug: "tags", targetUserId: "featured" } as FeedRequestJSON,
    { targetSlug: "tags", targetUserId: "events" } as FeedRequestJSON,
    { targetSlug: "tags", targetUserId: "promotion_feed" } as FeedRequestJSON,
];

export enum FeedGroupType {
    Flat = 'flat',
    Notification = 'notification',
    Aggregated = 'aggregated'
}

export enum FeedName {
    Timeline = 'timeline',
    User = 'user',
    Notification = 'notification',
    TimelineAggregated = 'timeline_aggregated',
    Tags = 'tags'
}

