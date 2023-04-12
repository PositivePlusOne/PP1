export namespace FlamelinkHelpers {
  /**
   * Gets the flamelink id from a flamelink object.
   * @param {any} object the object to get the flamelink id from.
   * @return {string} the flamelink id.
   * @throws {Error} if the id is not a valid string with a length.
   */
  export function getFlamelinkIdFromObject(object: any): string {
    if (
      object == null ||
      object._fl_meta_ == null ||
      object._fl_meta_.fl_id == null ||
      typeof object._fl_meta_.fl_id !== "string" ||
      object._fl_meta_.fl_id.length === 0
    ) {
      throw new Error("Object is not a valid flamelink object");
    }

    return object._fl_meta_.fl_id;
  }
}
