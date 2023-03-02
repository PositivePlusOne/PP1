import * as functions from "firebase-functions";
import algoliasearch, { SearchClient, SearchIndex } from "algoliasearch";
import { Keys } from "../constants/keys";

export namespace SearchService {
  /**
   * Returns an Algolia search client.
   * @return {SearchClient} an Algolia search client.
   * @see https://www.algolia.com/doc/api-client/getting-started/install/javascript/?language=javascript
   */
  export function getAlgoliaSearchClient(): SearchClient {
    functions.logger.info("Getting Algolia search client", {
      structuredData: true,
    });

    return algoliasearch(getApplicationId(), getApiKey());
  }

  /**
   * Returns an Algolia search index.
   * @param {SearchClient} client the Algolia search client.
   * @return {SearchIndex} an Algolia search index.
   * @see https://www.algolia.com/doc/api-client/getting-started/install/javascript/?language=javascript
   */
  export function getAlgoliaSearchIndex(client: SearchClient): SearchIndex {
    functions.logger.info("Getting Algolia search index", {
      structuredData: true,
    });

    return client.initIndex(Keys.AlgoliaIndex);
  }

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

  /**
   * Returns the Algolia Application ID.
   * @return {string} the Algolia Application ID.
   */
  export function getApplicationId(): string {
    functions.logger.info("Getting Algolia Application ID", {
      structuredData: true,
    });
    const applicationId = process.env.ALGOLIA_APP_ID;

    if (!applicationId) {
      throw new Error("Missing Algolia Application ID");
    }

    return applicationId;
  }
}
