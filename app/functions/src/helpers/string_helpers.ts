export namespace StringHelpers {
  /**
   * Generates a private channel name for the given profiles.
   * @param {any} guids the guids of the profiles.
   * @return {string} the private channel name.
   */
  export function generateDocumentNameFromGuids(guids: string[]): string {
    // Remove duplicates.
    guids = guids.filter((guid, index, self) => {
      return self.indexOf(guid) === index;
    });

    // Sort guids
    guids = guids.sort();

    // Join guids with a dash.
    const documentName = guids.join("-");
    return documentName;
  }
}
