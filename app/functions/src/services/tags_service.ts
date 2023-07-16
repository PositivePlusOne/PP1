import * as functions from "firebase-functions";

import { Tag, TagJSON } from "../dto/tags";
import { DataService } from "./data_service";

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
  }

  /**
   * Gets a tag.
   * @param {string} key the tag key.
   * @returns {Promise<Tag | null>} the tag.
   */
  export async function getTag(key: string): Promise<Tag | null> {
    const formattedKey = formatTag(key);
    functions.logger.info("Getting tag", { formattedKey });

    if (!formattedKey || formattedKey.length === 0) {
      functions.logger.error("Invalid tag key", { key });
      return null;
    }

    const tagData = await DataService.getDocument({
      schemaKey: "users",
      entryId: formattedKey,
    });

    if (!tagData) {
      return {
        key: formattedKey,
        fallback: formattedKey,
        promoted: false,
        localizations: [],
      };
    }

    return new Tag(tagData as TagJSON);
  }

  /**
   * Formats a tag from a string.
   * @param {string} input the input string.
   * @returns {string} the formatted tag.
   */
  export function formatTag(input: string): string {
    const stringWithSpaces = input.toLowerCase().replace(/[^a-z0-9]+/gi, " ");

    const singleSpaces = stringWithSpaces.replace(/\s+/g, " ");
    const snakeCased = singleSpaces.replace(/ /g, "_");

    return snakeCased;
  }

  /**
   * Gets or creates a tag.
   * @param {string} key the tag key.
   * @returns {Promise<Tag>} the tag.
   */
  export async function getOrCreateTag(key: string): Promise<Tag> {
    const formattedKey = formatTag(key);
    functions.logger.info("Getting or creating tag", { formattedKey });

    if (!formattedKey) {
      throw new Error(`Invalid tag key: ${formattedKey}`);
    }

    const tagObject = await getTag(formattedKey);
    if (tagObject) {
      return tagObject;
    }

    return createTag(key);
  }

  /**
   * Removes restricted tags from a string array.
   * @param {string[]} tags the tags.
    * @returns {string[]} the tags without restricted tags.
   */
  export function removeRestrictedTagsFromStringArray(tags: string[]): string[] {
    return tags.filter((tag) => !isRestricted(tag)).map((tag) => {
      const formattedTag = formatTag(tag);
      return formattedTag;
    });
  }

  /**
   * Checks if a tag is restricted.
   * @param {string} tag the tag.
   * @returns {boolean} true if the tag is restricted.
   */
  export function isRestricted(tag: string): boolean {
    const wrappedTag = formatTag(tag);
    return Object.values(RestrictedTagKey).includes(wrappedTag as RestrictedTagKey);
  }

  /**
   * Creates a new tag.
   * @param {string} key the tag key.
   * @returns {Promise<Tag>} the created tag.
   */
  export async function createTag(key: string): Promise<Tag> {
    const formattedKey = formatTag(key);
    functions.logger.info("Creating tag", { formattedKey });

    if (!formattedKey || formattedKey.length === 0) {
      throw new Error(`Invalid tag key: ${key}`);
    }

    const tag: Tag = {
      key,
      fallback: "",
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
