import * as functions from "firebase-functions";

import { Tag, resolveTag } from "../dto/tag";
import { DataService } from "./data_service";

export namespace TagsService {
  /**
   * Gets a tag.
   * @param {string} key the tag key.
   * @returns {Promise<Tag | null>} the tag.
   */
  export async function getTag(key: string): Promise<Tag | null> {
    functions.logger.info("Getting tag", { key });

    const tagSnapshot = await DataService.getDocument({
      schemaKey: "users",
      entryId: key,
    });

    if (!tagSnapshot) {
      functions.logger.error("Tag not found", { key });
      return null;
    }

    return resolveTag(tagSnapshot);
  }

  /**
   * Gets or creates a tag.
   * @param {string} key the tag key.
   * @returns {Promise<Tag>} the tag.
   */
  export async function getOrCreateTag(key: string): Promise<Tag> {
    functions.logger.info("Getting or creating tag", { key });

    if (!key) {
      throw new Error(`Invalid tag key: ${key}`);
    }

    const tag = await getTag(key);
    if (tag) {
      return tag;
    }

    return createTag(key);
  }

  /**
   * Creates a new tag.
   * @param {string} key the tag key.
   * @returns {Promise<Tag>} the created tag.
   */
  export async function createTag(key: string): Promise<Tag> {
    functions.logger.info("Creating tag", { key });
    
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
