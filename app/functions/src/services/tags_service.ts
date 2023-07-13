import * as functions from "firebase-functions";

import { Tag, resolveTag } from "../dto/tags";
import { DataService } from "./data_service";

export namespace TagsService {
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

    const tagSnapshot = await DataService.getDocument({
      schemaKey: "users",
      entryId: formattedKey,
    });

    if (!tagSnapshot) {
      functions.logger.error("Tag not found", { key });
      return {
        key,
        fallback: key,
        promoted: false,
        localizations: [],
      };
    }

    return resolveTag(tagSnapshot);
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
