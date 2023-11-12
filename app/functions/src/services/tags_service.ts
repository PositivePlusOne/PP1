import * as functions from "firebase-functions";

import { Tag, TagJSON } from "../dto/tags";
import { DataService } from "./data_service";
import { CacheService } from "./cache_service";
import { FeedService } from "./feed_service";
import { ActivitiesService } from "./activities_service";
import { ActivityGeneralConfigurationType, ActivityJSON, ActivitySecurityConfigurationMode } from "../dto/activities";

export namespace TagsService {
  /**
   * A type for restricted tag keys.
   */
  export enum RestrictedTagKey {
    admin = "admin",
    recommended = "recommended",
    featured = "featured",
    popular = "popular",
    new = "new",
    verified = "verified",
    promotion = "promotion",
    chatPromotion = "promotion_chat",
    feedPromotion = "promotion_feed",
    everyone = "everyone",
    signed_in_users = "signed_in_users",
    trending = "trending",
    events = "events",
    sponsored = "sponsored",
    clip = "clip",
    post = "post",
    event = "event",
  }

  export enum PostTypeTag {
    clip = "clip",
    post = "post",
    event = "event",
  }

  export function postTypeFromActivityGeneralConfigurationJSON(type: ActivityGeneralConfigurationType): PostTypeTag {
    switch (type) {
      case "clip":
        return PostTypeTag.clip;
      case "post":
        return PostTypeTag.post;
      case "event":
        return PostTypeTag.event;
    }
  }

  /**
   * The number of tags to return in a window.
   * @type {number}
   */
  export const TAG_WINDOW_SIZE = 30;

  /**
   * Gets a tag.
   * @param {string} key the tag key.
   * @returns {Promise<Tag | null>} the tag.
   */
  export async function getTag(key: string): Promise<any> {
    const formattedKey = isRestricted(key) ? key : formatTag(key);
    functions.logger.info("Getting tag", { formattedKey });

    if (!formattedKey || formattedKey.length === 0) {
      functions.logger.error("Invalid tag key", { key });
      return null;
    }

    const tagData = await DataService.getDocument({
      schemaKey: "tags",
      entryId: formattedKey,
    });

    return tagData;
  }

  export async function getOrCreateTags(validatedTags: string[]) : Promise<TagJSON[]> {
    const promises = [] as Promise<TagJSON>[];
    for (const tag of validatedTags) {
      const formattedTag = isRestricted(tag) ? tag : formatTag(tag);
      promises.push(getOrCreateTag(formattedTag));
    }

    const tags = await Promise.all(promises);
    return tags;
  }

  export async function getOrCreateTag(key: string): Promise<TagJSON> {
    const formattedKey = isRestricted(key) ? key : formatTag(key);
    functions.logger.info("Getting or creating tag", { formattedKey });

    if (!formattedKey || formattedKey.length === 0) {
      functions.logger.error("Invalid tag key", { key });
      return {};
    }

    const tagData = await DataService.getDocument({
      schemaKey: "tags",
      entryId: formattedKey,
    });

    if (!tagData) {
      const tag = await createTag(key);
      return tag;
    }

    return tagData;
  }

  /**
   * Gets multiple tags.
   * @param {string[]} keys the tag keys.
   * @returns {Promise<TagJSON[]>} the tags.
   */
  export async function getMultipleTags(keys: string[]): Promise<any[]> {
    const formattedKeys = keys.map((key) => isRestricted(key) ? key : formatTag(key));
    functions.logger.info("Getting multiple tags", { formattedKeys });

    if (!formattedKeys || formattedKeys.length === 0) {
      return [];
    }

    const tagData = await DataService.getBatchDocuments({
      schemaKey: "tags",
      entryIds: formattedKeys,
    });

    return tagData;
  }

  /**
   * Gets popular tags to display to the user
   * @returns {Promise<Tag[]>} the tags.
   */
  export async function getPopularTags(locale: string): Promise<TagJSON[]> {
    functions.logger.info("Getting popular tags for locale", { locale });
    const latestCacheKey = `tags-${locale}-popularity`;
    const latestCachedData = await CacheService.get(latestCacheKey) as Tag[];
    if (latestCachedData) {
      return latestCachedData;
    }


    functions.logger.info("Refreshing popular tags for locale", { locale });
    const queryWindowResponse = await DataService.getDocumentWindowRaw({
      schemaKey: "tags",
      limit: TAG_WINDOW_SIZE,
      orderBy: [
        { fieldPath: "popularity", directionStr: "asc" },
      ],
      where: [
        { fieldPath: "popularity", op: ">", value: 0 },
      ],
    });

    const popularTags = [] as TagJSON[];
    for (const tagData of queryWindowResponse) {
      popularTags.push(tagData as TagJSON);
    }

    if (popularTags.length > 0) {
      await CacheService.setInCache(latestCacheKey, popularTags);
    }

    return popularTags;
  }

  /**
   * Gets topic tags to display to the user
   * @returns {Promise<Tag[]>} the tags.
   */
  export async function getTopicTags(locale: string): Promise<TagJSON[]> {
    functions.logger.info("Getting topics tags for locale", { locale });
    const latestCacheKey = `tags-${locale}-topics`;
    const latestCachedData = await CacheService.get(latestCacheKey) as Tag[];
    if (latestCachedData) {
      return latestCachedData;
    }


    functions.logger.info("Refreshing topic tags for locale", { locale });
    const queryWindowResponse = await DataService.getDocumentWindowRaw({
      schemaKey: "tags",
      limit: TAG_WINDOW_SIZE,
      where: [
        { fieldPath: "topic.isEnabled", op: "==", value: true },
      ],
    });

    const topicTags = [] as TagJSON[];
    for (const tagData of queryWindowResponse) {
      topicTags.push(tagData as TagJSON);
    }

    if (topicTags.length > 0) {
      await CacheService.setInCache(latestCacheKey, topicTags);
    }

    return topicTags;
  }

  export async function getRecentUserTags(uid: string): Promise<TagJSON[]> {
    functions.logger.info("Getting recent user tags", { uid });
    const feedClient = FeedService.getFeedsClient();
    const userFeed = feedClient.feed("user", uid);

    // Increase this number from 3 when we find a way to scale this better
    const feedWindow = await FeedService.getFeedWindow(uid, userFeed, 3, "");
    const activities = await ActivitiesService.getActivityFeedWindow(feedWindow.results) as ActivityJSON[];

    const tagStringValues = [] as string[];
    for (const activity of activities) {
      for (const tag of activity?.enrichmentConfiguration?.tags || []) {
        if (!tag || tagStringValues.includes(tag)) {
          continue;
        }
        
        tagStringValues.push(tag);
      }
    }

    let filteredTags = [] as TagJSON[];

    if (tagStringValues.length === 0) {
      return filteredTags;
    }

    const cachedTags = await TagsService.getMultipleTags(tagStringValues);
    filteredTags = cachedTags.filter((tag) => !!tag);
    return filteredTags;
  }

  /**
   * Formats a tag from a string.
   * @param {string} input the input string.
   * @returns {string} the formatted tag.
   */
  export function formatTag(input: string): string {
    //* Validation of tags server side, please make sure this matches client side validation
    //* client side validation can be found in string_extensions.dart under the function asTagKey
    const stringWithSpaces = input.toLowerCase().replace(/[^a-z0-9]+/gi, " ");
    const singleSpaces = stringWithSpaces.replace(/\s+/g, " ");
    const snakeCased = singleSpaces.replace(/ /g, "_");
    const lowerCased = snakeCased.toLowerCase();

    // 30 characters max
    return lowerCased.substring(0, 30);
  }

  /**
   * Gets or creates a tag.
   * @param {string} key the tag key.
   * @returns {Promise<boolean>} returns true if tag was created, false if tag already exists.
   */
  export async function createTagIfNonexistant(key: string): Promise<boolean> {
    const formattedKey = isRestricted(key) ? key : formatTag(key);
    functions.logger.info("Getting or creating tag", { formattedKey });

    if (!formattedKey) {
      throw new Error(`Invalid tag key: ${formattedKey}`);
    }


    const tagData = await DataService.getDocument({
      schemaKey: "tags",
      entryId: formattedKey,
    });

    if (!tagData) {
      await createTag(key);
      return true;
    }

    return false;
  }

  /**
   * Removes restricted tags from a string array.
   * @param {string[]} tags the tags.
    * @returns {string[]} the tags without restricted tags.
   */
  export function removeRestrictedTagsFromStringArray(tags: string[], isPromotion: boolean): string[] {
    const promotedTags = tags.filter((tag) => isPromotedTag(tag));
    let returnTags = tags.filter((tag) => !isRestricted(tag)).map((tag) => {
      return formatTag(tag);
    });
    
    returnTags = returnTags.slice(0, 5);
    if (isPromotion && promotedTags.length > 1) {
      returnTags = [...promotedTags, ...returnTags];
    }
    
    // and return the final list of tags that are all valid and formattted
    return returnTags;
  }

  /**
   * Appends activity tags to tags based on security mode.
   * @param {ActivitySecurityConfigurationMode} securityMode the security mode.
   * @param {string[]} tags the tags.
   */
  export function appendActivityTagsToTags(securityMode: ActivitySecurityConfigurationMode, tags: string[], type: PostTypeTag): string[] {
    switch (securityMode) {
      case "public":
        tags.push(RestrictedTagKey.everyone);
        break;
      case "signed_in":
        tags.push(RestrictedTagKey.signed_in_users);
        break;
    }

    // Add the type tag
    const typeStr = type as string;
    functions.logger.info("Appending type tag", { typeStr });
    tags.push(typeStr);

    return tags;
  }

  /**
   * Checks if a tag is a restricted 'promoted' tag, which can include the 'promoted_{userId}' tag
   * @param {string} tag the tag.
   * @returns {boolean} true if the tag represents a promoted item.
   */
  export function isPromotedTag(tag: string): boolean {
    return tag === RestrictedTagKey.promotion || tag.startsWith(`${RestrictedTagKey.promotion}_`);
  }

  /**
   * Checks if a tag is restricted.
   * @param {string} tag the tag.
   * @returns {boolean} true if the tag is restricted.
   */
  export function isRestricted(tag: string): boolean {
    // this is a restricted tag if a special promoted tag, or in the list of RestrictedTagKey
    const wrappedTag = formatTag(tag);
    return isPromotedTag(tag) || Object.values(RestrictedTagKey).includes(wrappedTag as RestrictedTagKey);
  }

  /**
   * Creates a new tag.
   * @param {string} key the tag key.
   * @returns {Promise<Tag>} the created tag.
   */
  export async function createTag(key: string): Promise<Tag> {
    const formattedKey = isRestricted(key) ? key : formatTag(key);
    functions.logger.info("Creating tag", { formattedKey });

    if (!formattedKey || formattedKey.length === 0) {
      throw new Error(`Invalid tag key: ${key}`);
    }

    const tag: Tag = {
      key,
      fallback: key,
      popularity: -1,
      promoted: false,
      localizations: [],
    };

    await DataService.updateDocument({
      schemaKey: "tags",
      entryId: key,
      data: tag,
    });

    return tag;
  }
}
