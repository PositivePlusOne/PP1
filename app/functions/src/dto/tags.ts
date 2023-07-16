import { lowerCase, snakeCase } from "lodash";

export const tagSchemaKey = "tags";

export type TagJSON = {
  key?: string;
  fallback?: string;
  promoted?: boolean;
  localizations?: TagLocalizationJSON[];
};

export type TagLocalizationJSON = {
  locale?: string;
  value?: string;
};

/**
 * Represents a tag.
 * @class
 * @property {string} key the tag key.
 * @property {string} fallback the fallback value.
 * @property {boolean} promoted true if the tag is promoted.
 * @property {TagLocalization[]} localizations the localizations.
 * @returns {Tag} the tag.
 */
export class Tag {
  key: string;
  fallback: string;
  promoted: boolean;
  localizations: TagLocalization[];

  /**
   * Creates a new tag.
   * @param {TagJSON} json the json.
   * @returns {Tag} the tag.
   * @constructor
   */
  constructor(json: TagJSON) {
    this.key = json.key || "";
    this.fallback = json.fallback || "";
    this.promoted = json.promoted || false;
    this.localizations = json.localizations?.map((e) => new TagLocalization(e)) || [];
  }

  /**
   * Gets a list of tags from a json array.
   * @param {TagJSON[]} data the json array.
   * @returns {Tag[]} the tags.
   */
  static fromJsonArray(data: any[]): Tag[] {
    return data.map((e) => new Tag(e));
  }

  /**
   * Gets a tag from json.
   * @param {TagJSON} json the json.
   * @returns {Tag} the tag.
   */
  static fromJSON(json: TagJSON): Tag {
    return new Tag(json);
  }
}

/**
 * Represents a tag localization.
 * @class
 * @property {string} locale the locale.
 * @property {string} value the value.
 */
export class TagLocalization {
  locale: string;
  value: string;

  /**
   * Creates a new tag localization.
   * @param {TagLocalizationJSON} json the json.
   * @returns {TagLocalization} the tag localization.
   */
  constructor(json: TagLocalizationJSON) {
    this.locale = json.locale || "";
    this.value = json.value || "";
  }
}

/**
 * Formats a tag.
 * @param {string} tag the tag.
 * @returns {string} the formatted tag.
 */
export function formatTag(tag: string): string {
  return snakeCase(lowerCase(tag));
}