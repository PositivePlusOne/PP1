export type Tag = {
  key: string;
  fallback: string;
  promoted: boolean;
  localizations: TagLocalization[];
};

export type TagLocalization = {
  locale: string;
  value: string;
};

/**
 * Checks if the given object is a valid TagLocalization.
 * @param obj the object to check.
 * @returns true if the object is a valid TagLocalization, false otherwise.
 */
export function isTagLocalization(obj: any): obj is TagLocalization {
  return (
    obj !== null &&
    typeof obj === "object" &&
    typeof obj.locale === "string" &&
    typeof obj.value === "string"
  );
}

/**
 * Checks if the given object is a valid Tag.
 * @param obj the object to check.
 * @returns true if the object is a valid Tag, false otherwise.
 */
export function isTag(obj: any): obj is Tag {
  return (
    obj !== null &&
    typeof obj === "object" &&
    typeof obj.key === "string" &&
    typeof obj.fallback === "string" &&
    typeof obj.promoted === "boolean" &&
    Array.isArray(obj.localizations) &&
    obj.localizations.every(isTagLocalization)
  );
}

/**
 * Resolves the given input to a Tag.
 * @param input the input to resolve.
 * @returns the resolved Tag, or null if the input is invalid.
 */
export function resolveTag(input: any): Tag | null {
  if (isTag(input)) {
    return input;
  }

  return null;
}
