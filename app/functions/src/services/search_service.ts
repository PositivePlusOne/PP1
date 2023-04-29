import * as functions from "firebase-functions";
import { MeiliSearch, Index } from "meilisearch";

export namespace SearchService {
  /**
   * Returns a MeiliSearch client.
   * @return {MeiliSearch} a MeiliSearch client.
   * @see https://github.com/meilisearch/meilisearch-js
   */
  export function getMeiliSearchClient(): MeiliSearch {
    functions.logger.info("Getting MeiliSearch client", {
      structuredData: true,
    });

    return new MeiliSearch({
      host: getHostUrl(),
      apiKey: getApiKey(),
    });
  }

  /**
   * Returns the MeiliSearch API key.
   * @return {string} the MeiliSearch API key.
   */
  export function getApiKey(): string {
    functions.logger.info("Getting MeiliSearch API key", {
      structuredData: true,
    });
    const apiKey = process.env.MEILISEARCH_API_KEY;

    if (!apiKey) {
      throw new Error("Missing MeiliSearch API key");
    }

    return apiKey;
  }

  /**
   * Returns the MeiliSearch host URL.
   * @return {string} the MeiliSearch host URL.
   */
  export function getHostUrl(): string {
    functions.logger.info("Getting MeiliSearch host URL", {
      structuredData: true,
    });
    const hostUrl = process.env.MEILISEARCH_HOST_URL;

    if (!hostUrl) {
      throw new Error("Missing MeiliSearch host URL");
    }

    return hostUrl;
  }

  /**
   * Returns the MeiliSearch index with the schema if it exists, otherwise null.
   * @param {MeiliSearchClient} client the MeiliSearch client.
   * @param {string} schema the schema.
   * @return {Promise<Index<Record<string, any>> | null>} a promise that resolves with the index if it exists, otherwise null.
   */
  export async function getIndex(
    client: MeiliSearch,
    schema: string,
  ): Promise<Index<Record<string, any>>> {
    functions.logger.info("Getting MeiliSearch index", {
      structuredData: true,
    });

    const index = client.index(schema);
    return index;
  }

  /**
   * Adds or updates the document in the index.
   * @param {Index<Record<string, any>>} index the MeiliSearch index.
   * @param {any} data the data containing the Flamelink ID and schema.
   * @return {Promise<void>} a promise that resolves when the document has been added or updated.
   */
  export async function addOrUpdateDocumentInIndex(
    index: Index<Record<string, any>>,
    data: any
  ): Promise<void> {
    functions.logger.info("Adding or updating document in MeiliSearch index", {
      structuredData: true,
    });

    const flamelinkId = data?._fl_meta_?.fl_id;
    if (!flamelinkId) {
      throw new Error("Missing Flamelink ID");
    }

    await index.updateDocuments([data]);
    functions.logger.info("Document added or updated in MeiliSearch index", {
      structuredData: true,
    });
  }

  /**
   * Deletes the document in the index.
   * @param {Index<Record<string, any>>} index the MeiliSearch index.
   * @param {any} data the data containing the Flamelink ID and schema.
   * @return {Promise<void>} a promise that resolves when the document has been deleted.
   */
  export async function deleteDocumentInIndex(
    index: Index<Record<string, any>>,
    data: any
  ): Promise<void> {
    functions.logger.info("Deleting document in MeiliSearch index", {
      structuredData: true,
    });

    const flamelinkId = data?._fl_meta_?.fl_id;
    if (!flamelinkId) {
      throw new Error("Missing Flamelink ID");
    }

    await index.deleteDocument(flamelinkId);
    functions.logger.info("Document deleted in MeiliSearch index", {
      structuredData: true,
    });
  }

  /**
   * Deletes the index with the given UID.
   * @param {MeiliSearchClient} client the MeiliSearch client.
   * @param {string} uid the unique identifier for the index.
   * @return {Promise<void>} a promise that resolves when the index has been deleted.
   */
  export async function deleteIndex(
    client: MeiliSearch,
    uid: string
  ): Promise<void> {
    functions.logger.info("Deleting MeiliSearch index", {
      structuredData: true,
    });

    await client.deleteIndex(uid);
  }

  /**
   * Searches the index with the given query, page, limit, filters, and locale.
   * @param {Index<Record<string, any>>} index the MeiliSearch index.
   * @param {string} query the search query.
   * @param {number} page the page number.
   * @param {number} limit the number of results per page.
   * @param {any} filters the filters to apply to the search.
   * @return {Promise<any>} a promise that resolves with the search results.
   */
  export function search(
    index: Index<Record<string, any>>,
    query: string,
    page: number,
    limit: number,
    filters: any
  ): Promise<any> {
    functions.logger.info("Searching MeiliSearch index", {
      structuredData: true,
    });

    return index.search(query, {
      limit: limit,
      offset: (page - 1) * limit,
      filters: filters,
      attributesToHighlight: ["_fl_meta_.fl_id"],
      cropLength: 200,
      matches: true,
    });
  }
}
