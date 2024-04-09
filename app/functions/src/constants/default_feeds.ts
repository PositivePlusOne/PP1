import { FeedRequestJSON } from "../dto/feed_dtos";

// A pre-defined list of feeds that should be followed by the user's timeline feed.
export const DEFAULT_USER_TIMELINE_FEED_SUBSCRIPTION_SLUGS = [
  { targetSlug: "tags", targetUserId: "system" } as FeedRequestJSON,
  { targetSlug: "tags", targetUserId: "admin" } as FeedRequestJSON,
  { targetSlug: "tags", targetUserId: "sponsored" } as FeedRequestJSON,
  // { targetSlug: "tags", targetUserId: "recommended" } as FeedRequestJSON,
  // { targetSlug: "tags", targetUserId: "trending" } as FeedRequestJSON,
  // { targetSlug: "tags", targetUserId: "popular" } as FeedRequestJSON,
  // { targetSlug: "tags", targetUserId: "new" } as FeedRequestJSON,
  // { targetSlug: "tags", targetUserId: "featured" } as FeedRequestJSON,
  // { targetSlug: "tags", targetUserId: "events" } as FeedRequestJSON,
  // This means EVERYONE will see these posts, eventually we will want to swap this to Mixpanel stats for trending
  // { targetSlug: "tags", targetUserId: "everyone" } as FeedRequestJSON,
  // { targetSlug: "tags", targetUserId: "signed_in_users" } as FeedRequestJSON,
];

export enum FeedGroupType {
  Flat = "flat",
  Notification = "notification",
  Aggregated = "aggregated",
}

export enum FeedName {
  Timeline = "timeline",
  User = "user",
  Notification = "notification",
  TimelineAggregated = "timeline_aggregated",
  Tags = "tags",
}
