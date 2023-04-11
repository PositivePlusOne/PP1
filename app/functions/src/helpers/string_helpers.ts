import * as functions from "firebase-functions";

export namespace StringHelpers {
    /**
   * Generates a private channel name for the given profiles.
   * @param {any} guids the guids of the profiles.
   * @return {string} the private channel name.
   */
  export function generateDocumentNameFromGuids(
    guids: string[],
  ): string {
    functions.logger.info("Generating document name from guids", { guids });
    const sortedGuids = guids.sort();
    const documentName = sortedGuids.join("-");

    return documentName;
  }
}