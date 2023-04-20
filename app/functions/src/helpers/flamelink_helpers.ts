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

  /**
   * Determines if two flamelink objects are equal.
   * @param {any} d1 The first object to compare.
   * @param {any} d2 The second object to compare.
   * @return {boolean} true if the objects are equal, false otherwise.
   */
  export function arePayloadsEqual(d1: any, d2: any): boolean {
    if (d1 == null && d2 == null) {
      return true;
    }

    if (d1 == null || d2 == null) {
      return false;
    }
    
    return JSON.stringify(d1) === JSON.stringify(d2);
  }

  /**
   * Converts a firestore document to a Firebase Storage file url.
   * @param {any} documentReference the document reference to convert.
   * @return {string?} the url of the file.
   */
  export async function convertDocumentReferenceToFlamelinkFile(
    documentReference: any,
  ): Promise<string | null> {
    const id = documentReference.id;
    if (id == null || typeof id !== "string" || id.length === 0) {
      return null;
    }

    return "";
  }
}
