import * as functions from "firebase-functions";

export namespace SearchService {
  /**
   * Returns the Algolia API key.
   * @return {string} the Algolia API key.
   */
  export function getApiKey(): string {
    functions.logger.info("Getting Algolia API key", { structuredData: true });
    const apiKey = process.env.ALGOLIA_API_KEY;

    if (!apiKey) {
      throw new Error("Missing Algolia API key");
    }

    return apiKey;
  }
}
