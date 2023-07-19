import * as functions from "firebase-functions";
import algoliasearch, { SearchClient, SearchIndex } from "algoliasearch";

export namespace SearchService {
  /**
   * Returns an Algolia client.
   * @return {SearchClient} an Algolia client.
   * @see https://www.algolia.com/doc/api-client/getting-started/install/javascript/
   */
  export function getAlgoliaClient(): SearchClient {
    functions.logger.info("Getting Algolia client", {
      structuredData: true,
    });

    return algoliasearch(getAppId(), getApiKey());
  }

  /**
   * Returns the Algolia API key.
   * @return {string} the Algolia API key.
   */
  export function getApiKey(): string {
    functions.logger.info("Getting Algolia API key", {
      structuredData: true,
    });

    const apiKey = process.env.ALGOLIA_API_KEY;
    if (!apiKey) {
      throw new Error("Missing Algolia API key");
    }

    return apiKey;
  }

  /**
   * Returns the Algolia application ID.
   * @return {string} the Algolia application ID.
   */
  export function getAppId(): string {
    functions.logger.info("Getting Algolia application ID", {
      structuredData: true,
    });
    const appId = process.env.ALGOLIA_APP_ID;

    if (!appId) {
      throw new Error("Missing Algolia application ID");
    }

    return appId;
  }

  /**
   * Returns the Algolia index with the schema if it exists, otherwise null.
   * @param {SearchClient} client the Algolia client.
   * @param {string} schema the schema.
   * @return {SearchIndex} the Algolia index.
   */
  export function getIndex(client: SearchClient, schema: string): SearchIndex {
    functions.logger.info("Getting Algolia index", {
      structuredData: true,
    });

    return client.initIndex(schema);
  }

  /**
   * Adds or updates the document in the index.
   * @param {SearchIndex} index the Algolia index.
   * @param {any} data the data containing the Flamelink ID and schema.
   * @return {Promise<void>} a promise that resolves when the document has been added or updated.
   */
  export async function addOrUpdateDocumentInIndex(index: SearchIndex, data: any): Promise<void> {
    functions.logger.info("Adding or updating document in Algolia index", {
      structuredData: true,
    });

    const flamelinkId = data?._fl_meta_?.fl_id;
    if (!flamelinkId) {
      throw new Error("Missing Flamelink ID");
    }

    // Algolia requires the objectID to be a string.
    data.objectID = flamelinkId;

    await index.saveObject(data);
    functions.logger.info("Document added or updated in Algolia index", {
      structuredData: true,
    });
  }

  /**
   * Deletes the document in the index.
   * @param {SearchIndex} index the Algolia index.
   * @param {any} data the data containing the Flamelink ID and schema.
   * @return {Promise<void>} a promise that resolves when the document has been deleted.
   */
  export async function deleteDocumentInIndex(index: SearchIndex, data: any): Promise<void> {
    functions.logger.info("Deleting document in Algolia index", {
      structuredData: true,
    });

    const flamelinkId = data?.fl_meta?.fl_id;
    if (!flamelinkId) {
      throw new Error("Missing Flamelink ID");
    }

    await index.deleteObject(flamelinkId);
    functions.logger.info("Document deleted in Algolia index", {
      structuredData: true,
    });
  }

  /**

    Searches the index with the given query, page, limit, filters, and locale.
    @param {SearchIndex} index the Algolia index.
    @param {string} query the search query.
    @param {number} page the page number.
    @param {number} limit the number of results per page.
    @param {any} filters the filters to apply to the search.
    @return {Promise<any>} a promise that resolves with the search results.
    */
  export async function search(index: SearchIndex, query: string, page: number, limit: number, filters: any): Promise<any> {
    functions.logger.info("Searching Algolia index");

    const searchResponse = await index.search(query, {
      hitsPerPage: limit,
      page: page,
      filters: filters,
      attributesToHighlight: ["_fl_meta_.fl_id"],
      snippetEllipsisText: "…",
      minWordSizefor1Typo: 4,
    });

    functions.logger.info("Got search response", searchResponse);

    return searchResponse.hits;
  }
}
