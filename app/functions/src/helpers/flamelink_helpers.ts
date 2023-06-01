import * as functions from "firebase-functions";

export namespace FlamelinkHelpers {
  /**
   * Determines if an object is a valid flamelink object.
   * @param {any} object the object to check.
   * @return {boolean} true if the object is a valid flamelink object.
   */
  export function isValidFlamelinkObject(object: any): boolean {
    functions.logger.log("Checking if object is a valid flamelink object.");

    return object != null && object._fl_meta_ != null && object._fl_meta_.fl_id != null && typeof object._fl_meta_.fl_id === "string" && object._fl_meta_.fl_id.length > 0 && object._fl_meta_.schema != null && typeof object._fl_meta_.schema === "string" && object._fl_meta_.schema.length > 0;
  }

  /**
   * Gets the flamelink id from a flamelink object.
   * @param {any} object the object to get the flamelink id from.
   * @return {string | null} the flamelink id.
   */
  export function getFlamelinkIdFromObject(object: any): string | null {
    functions.logger.log("Getting flamelink id from object.");

    if (object == null || object._fl_meta_ == null || object._fl_meta_.fl_id == null || typeof object._fl_meta_.fl_id !== "string" || object._fl_meta_.fl_id.length === 0) {
      return null;
    }

    return object._fl_meta_.fl_id;
  }

  /**
   * Gets the flamelink schema from a flamelink object.
   * @param {any} object the object to get the flamelink schema from.
   * @return {string | null} the flamelink schema.
   */
  export function getFlamelinkSchemaFromObject(object: any): string | null {
    functions.logger.log("Getting flamelink schema from object.");

    if (object == null || object._fl_meta_ == null || object._fl_meta_.schema == null || typeof object._fl_meta_.schema !== "string" || object._fl_meta_.schema.length === 0) {
      return null;
    }

    return object._fl_meta_.schema;
  }

  /**
   * Determines if two flamelink objects are equal.
   * @param {any} d1 The first object to compare.
   * @param {any} d2 The second object to compare.
   * @return {boolean} true if the objects are equal, false otherwise.
   */
  export function arePayloadsEqual(d1: any, d2: any): boolean {
    functions.logger.log("Checking if payloads are equal.");

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
  export async function convertDocumentReferenceToFlamelinkFile(documentReference: any): Promise<string | null> {
    functions.logger.log("Converting document reference to flamelink file.");
    const id = documentReference.id;
    if (id == null || typeof id !== "string" || id.length === 0) {
      return null;
    }

    return "";
  }
}
