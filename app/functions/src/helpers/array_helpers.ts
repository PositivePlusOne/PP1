export namespace ArrayHelpers {
  /**
   * Takes a list of objects, returning only those which match a pattern
   *
   * @param {any[]} arr The array of objects.
   * @param {string | number} key The key of the object to search by.
   * @return {any[]} The new list of filtered objects.
   */
  export function getUniqueListBy(arr: any[], key: string | number): any[] {
    return arr.reduce((arr, item) => {
      const removed = arr.filter((i: { [x: string]: any }) => i[key] !== item[key]);
      return [...removed, item];
    }, []);
  }
}

/**
 * Merges two maps (JavaScript objects) into a new one.
 * If a key is present in both input maps and both values are arrays,
 * it combines those arrays into one. Otherwise, the value from
 * the destination map is used.
 *
 * @param source - The source map.
 * @param destination - The destination map. If a key is present in both,
 *   the value from this map is used, unless both values are arrays.
 * @returns - A new map that combines the source and destination maps.
 */
export function mergeMapIncludingArrays(source: Record<string, any>, destination: Record<string, any>): Record<string, any> {
  // Create a copy of the source map.
  const mergedMap = { ...source };

  // Loop over each key in the destination map.
  for (const key in destination) {
    // Continue to next iteration if the key is not a direct property of the destination map.
    if (!Object.prototype.hasOwnProperty.call(destination, key)) {
      continue;
    }

    // If the key is in both maps and both values are arrays, concatenate the arrays.
    // Otherwise, use the value from the destination map.
    if (mergedMap[key] && Array.isArray(mergedMap[key]) && Array.isArray(destination[key])) {
      mergedMap[key] = [...mergedMap[key], ...destination[key]];
    } else {
      mergedMap[key] = destination[key];
    }
  }

  // Return the merged map.
  return mergedMap;
}
