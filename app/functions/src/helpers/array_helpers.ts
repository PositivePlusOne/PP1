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
