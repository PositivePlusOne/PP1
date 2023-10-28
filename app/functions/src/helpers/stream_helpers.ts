import { Timestamp } from "firebase-admin/firestore";
import { DefaultGenerics, StreamClient, StreamFeed } from "getstream";

export namespace StreamHelpers {
  export const paginationTokenRegex = /&id_lt=(.+?)&/;

  export function getCurrentTimestamp(): Timestamp {
    return getTimestampForDate(new Date());
  }

  export function getCurrentUnixTimestamp(): string {
    return convertTimestampToUnix(getCurrentTimestamp());
  }

  export function getOriginFromFeed(feed: StreamFeed): string {
    // Check if the slug is read-only such as "timeline".
    // Then we default back to the user feed.
    if (feed.slug === "timeline") {
      return `user:${feed.userId}`;
    }
    
    return `${feed.slug}:${feed.userId}`;
  }

  export function getStreamFeedFromOrigin(origin: string, client: StreamClient<DefaultGenerics>): StreamFeed {
    const parts = origin.split(":");
    if (parts.length !== 2) {
      throw new Error("Invalid origin");
    }

    return client.feed(parts[0], parts[1]);
  }

  export function getFeedFromOrigin(origin: string): string {
    const parts = origin.split(":");
    if (parts.length !== 2) {
      return ""; 
    }

    return parts[0];
  }

  export function getSlugFromOrigin(origin: string): string {
    const parts = origin.split(":");
    if (parts.length !== 2) {
      return "";
    }

    return parts[1];
  }

  export function getTimestampForDate(date: Date): Timestamp {
    // return the nice ISO string to represent dates in our data
    return Timestamp.fromDate(date);
  }

  export function convertTimestampToUnix(timestamp: any): string {
    if (timestamp instanceof Timestamp) {
      return new Date(timestamp.toMillis()).toISOString();
    }

    if (typeof timestamp === "string") {
      return timestamp;
    }

    if (typeof timestamp === "number") {
      return new Date(timestamp).toISOString();
    }

    throw new Error("Invalid timestamp");
  }

  export function extractPaginationToken(url: string): string {
    const match = paginationTokenRegex.exec(url);
    if (match) {
      return match[1];
    } else {
      return "";
    }
  }
}