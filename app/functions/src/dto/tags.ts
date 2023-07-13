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

export class Tag {
  key: string;
  fallback: string;
  promoted: boolean;
  localizations: TagLocalization[];

  constructor(json: TagJSON) {
    this.key = json.key || "";
    this.fallback = json.fallback || "";
    this.promoted = json.promoted || false;
    this.localizations = json.localizations?.map((e) => new TagLocalization(e)) || [];
  }

  static fromJsonArray(data: any[]): Tag[] {
    return data.map((e) => new Tag(e));
  }

  static fromJSON(json: TagJSON): Tag {
    return new Tag(json);
  }
}

export class TagLocalization {
  locale: string;
  value: string;

  constructor(json: TagLocalizationJSON) {
    this.locale = json.locale || "";
    this.value = json.value || "";
  }
}


export function formatTag(tag: string): string {
  return snakeCase(lowerCase(tag));
}