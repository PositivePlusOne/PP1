import { FeedRequest } from "../dto/feed_dtos";

// A pre-defined list of feeds that should be followed by the user's timeline feed.
export const DEFAULT_USER_TIMELINE_FEED_SUBSCRIPTION_SLUGS = [{ feed: "tags", id: "system" } as FeedRequest, { feed: "tags", id: "admin" } as FeedRequest, { feed: "tags", id: "recommended" } as FeedRequest, { feed: "tags", id: "sponsored" } as FeedRequest, { feed: "tags", id: "trending" } as FeedRequest, { feed: "tags", id: "popular" } as FeedRequest, { feed: "tags", id: "new" } as FeedRequest, { feed: "tags", id: "featured" } as FeedRequest, { feed: "tags", id: "events" } as FeedRequest];

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

