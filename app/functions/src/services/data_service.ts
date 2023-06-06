import * as functions from "firebase-functions";

import { DocumentData, DocumentReference } from "firebase-admin/firestore";
import { adminApp } from "..";

import { SystemService } from "./system_service";
import { FlamelinkHelpers } from "../helpers/flamelink_helpers";

export namespace DataService {
  /**
   * In-memory cache for storing previously fetched documents.
   * Future: Swap this out for a proper cache like Redis.
   */
  export const memoryCache: Map<string, any> = new Map();
  export const generateCacheKey = (options: { schemaKey: string; entryId: string }): string => `${options.schemaKey}_${options.entryId}`;

  export const getDocumentReference = async function(options: { schemaKey: string; entryId: string }): Promise<DocumentReference<DocumentData>> {
    const cacheKey = generateCacheKey(options);
    if (memoryCache.has(cacheKey)) {
      return memoryCache.get(cacheKey);
    }
    
    const flamelinkApp = SystemService.getFlamelinkApp();
    functions.logger.info(`Converting flamelink document to firestore document ${options.entryId} from ${options.schemaKey}`);

    const currentDocument = await flamelinkApp.content.get(options);
    if (!currentDocument) {
      throw new functions.https.HttpsError("not-found", "Flamelink document not found");
    }

    const documentId = currentDocument._fl_meta_.docId;
    const documentRef = adminApp.firestore().collection("fl_content").doc(documentId);
    
    memoryCache.set(cacheKey, documentRef);
    return documentRef;
  };

  export const getDocument = async function(options: { schemaKey: string; entryId: string }): Promise<any> {
    const cacheKey = generateCacheKey(options);
    if (memoryCache.has(cacheKey)) {
      return memoryCache.get(cacheKey);
    }

    const flamelinkApp = SystemService.getFlamelinkApp();
    functions.logger.info(`Getting document for ${options.schemaKey}: ${options.entryId}`);

    const doc = await flamelinkApp.content.get(options);
    memoryCache.set(cacheKey, doc);
    return doc;
  };

  export const getBatchDocuments = async function(options: { schemaKey: string; entryIds: string[] }): Promise<any> {
    const flamelinkApp = SystemService.getFlamelinkApp();
    functions.logger.info(`Getting batch documents for ${options.schemaKey}: ${options.entryIds}`);

    const futures = options.entryIds.map(async (entryId) => {
      const cacheKey = generateCacheKey({ schemaKey: options.schemaKey, entryId });
      if (memoryCache.has(cacheKey)) {
        return memoryCache.get(cacheKey);
      }

      const entry = await flamelinkApp.content.get({
        schemaKey: options.schemaKey,
        entryId: entryId,
      });
      
      memoryCache.set(cacheKey, entry); // Cache each entry

      return entry;
    });

    const entries = await Promise.all(futures);

    return entries;
  };

  export const getDocumentByField = async function(options: { schemaKey: string; field: string; value: string }): Promise<any> {
    const flamelinkApp = SystemService.getFlamelinkApp();
    functions.logger.info(`Getting document for ${options.schemaKey}: ${options.field} = ${options.value}`);

    return await flamelinkApp.content.getByField(options);
  };

  /**
   * Checks if a document exists.
   * @param {any} options the options to use.
   * @return {Promise<boolean>} true if the document exists, false otherwise.
   */
  export const exists = async function(options: { schemaKey: string; entryId: string }): Promise<boolean> {
    const cacheKey = generateCacheKey(options);
    if (memoryCache.has(cacheKey)) {
      return !!memoryCache.get(cacheKey);
    }

    const flamelinkApp = SystemService.getFlamelinkApp();
    functions.logger.info(`Checking if document exists for ${options.schemaKey}: ${options.entryId}`);

    const currentDocument = await flamelinkApp.content.get(options);
    const exists = !!currentDocument;
    
    if (exists) {
      memoryCache.set(cacheKey, currentDocument);
    }

    return exists;
  };

  /**
   * Deletes a document.
   * @param {any} options the options to use.
   * @return {Promise<void>} a promise that resolves when the document is deleted.
   */
  export const deleteDocument = async function(options: { schemaKey: string; entryId: string }): Promise<void> {
    const cacheKey = generateCacheKey(options);
    memoryCache.delete(cacheKey);

    const flamelinkApp = SystemService.getFlamelinkApp();
    functions.logger.info(`Deleting document for user: ${options.entryId}`);

    const currentDocument = await flamelinkApp.content.get(options);
    if (!currentDocument) {
      throw new functions.https.HttpsError("not-found", "Flamelink document not found");
    }

    const documentId = currentDocument._fl_meta_.docId;
    const documentRef = adminApp.firestore().collection("fl_content").doc(documentId);

    await documentRef.delete();
  };

  /**
   * Updates a document.
   * @param {any} options the options to use.
   */
  export const updateDocument = async function(options: { schemaKey: string; entryId: string; data: any }): Promise<void> {
    const cacheKey = generateCacheKey(options);
    memoryCache.delete(cacheKey);

    const flamelinkApp = SystemService.getFlamelinkApp();
    functions.logger.info(`Updating document for user: ${options.entryId} to ${options.data}`);

    const currentDocument = await flamelinkApp.content.get(options);
    if (!currentDocument) {
      await flamelinkApp.content.add(options);
      return;
    }

    const documentId = currentDocument._fl_meta_.docId;
    const documentRef = adminApp.firestore().collection("fl_content").doc(documentId);

    const isSame = FlamelinkHelpers.arePayloadsEqual(currentDocument, options.data);

    if (isSame) {
      functions.logger.info(`Current document data is the same as the new data, not updating`);
      return;
    }

    functions.logger.info(`Current document data: ${currentDocument} with ref: ${documentRef}`);

    const newData = { ...currentDocument, ...options.data };
    memoryCache.set(cacheKey, newData);
    await documentRef.update(newData);
  };
}
