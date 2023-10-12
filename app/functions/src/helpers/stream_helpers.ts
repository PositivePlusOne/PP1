import { DefaultGenerics, StreamClient, StreamFeed } from "getstream";

export namespace StreamHelpers {
  export const paginationTokenRegex = /&id_lt=(.+?)&/;

  export function getCurrentTimestamp() {
    return getTimestampForDate(new Date());
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

  export function getTimestampForDate(date: Date) {
    return `${date.getFullYear()}-` +
      `${String(date.getMonth() + 1).padStart(2, '0')}-` +
      `${String(date.getDate()).padStart(2, '0')}T` +
      `${String(date.getHours()).padStart(2, '0')}:` +
      `${String(date.getMinutes()).padStart(2, '0')}:` +
      `${String(date.getSeconds()).padStart(2, '0')}.` +
      `${String(date.getMilliseconds()).padStart(3, '0')}`;
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