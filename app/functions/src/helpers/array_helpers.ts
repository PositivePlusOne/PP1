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
      const removed = arr.filter(
        (i: { [x: string]: any }) => i[key] !== item[key]
      );
      return [...removed, item];
    }, []);
  }
}

/**
 * Merge two objects which values are arrays by concatenating arrays of the same key.
 * @param {object} obj1 The first object
 * @param {object} obj2 The second object
 * @return {object} The merged object
 */
export function mergeMapOfArrays(obj1: { [key: string]: any[] }, obj2: { [key: string]: any[] }): { [key: string]: any[] } {
  // Clone obj1 to avoid mutating input
  const merged = { ...obj1 };

  for (const key in obj2) {
    if (Object.prototype.hasOwnProperty.call(obj2, key)) {
      if (merged[key]) {
        merged[key] = merged[key].concat(obj2[key]);
      } else {
        merged[key] = obj2[key];
      }
    }
  }

  return merged;
}