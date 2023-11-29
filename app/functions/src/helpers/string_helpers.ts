import * as crypto from "crypto";

import removeMd from 'remove-markdown';

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

  // Appends a @ to the beginning of a string if it doesn't already have one.
  export function asHandle(handle: string): string {
    if (handle.startsWith("@")) {
      return handle;
    }

    return `@${handle}`;
  }

  export function generateHmac(key: string): crypto.Hmac {
    return crypto.createHmac("sha256", key);
  }

  export function isAlphanumericWithSpecialChars(input: string): boolean {
    const pattern = /^[a-zA-Z0-9-_']+$/;
    return pattern.test(input);
  }
  
  export function isValidRealName(input: string): boolean {
    const pattern = /^[a-zA-Z-`‘’’' .À-ÖØ-öø-ÿĀ-ſ-ƀ]+$/;
    return pattern.test(input);
  }

  export function isFirebaseUID(uid: string): boolean {
    const expectedLength = 28;
    return uid.length === expectedLength && /^[A-Za-z0-9]+$/.test(uid);
  }

  export function markdownToPlainText(markdown: string): string {
    return removeMd(markdown);
  }
}
