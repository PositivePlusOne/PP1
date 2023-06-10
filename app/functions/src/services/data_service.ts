import * as functions from "firebase-functions";

import { DocumentData, DocumentReference } from "firebase-admin/firestore";
import { adminApp } from "..";

import { SystemService } from "./system_service";
import { FlamelinkHelpers } from "../helpers/flamelink_helpers";
import { CacheService } from "./cache_service";

export namespace DataService {

  export const getDocumentReference = async function(options: { schemaKey: string; entryId: string }): Promise<DocumentReference<DocumentData>> {
    const cacheKey = CacheService.generateCacheKey(options);
    const flamelinkApp = SystemService.getFlamelinkApp();
    functions.logger.info(`Converting flamelink document to firestore document ${options.entryId} from ${options.schemaKey}`);

    const currentDocument = await flamelinkApp.content.get(options);
    if (!currentDocument) {
      throw new functions.https.HttpsError("not-found", "Flamelink document not found");
    }

    const documentId = currentDocument._fl_meta_.docId;
    const documentRef = adminApp.firestore().collection("fl_content").doc(documentId);
    
    CacheService.setInCache(cacheKey, documentRef);
    return documentRef;
  };

  export const getDocument = async function(options: { schemaKey: string; entryId: string }): Promise<any> {
    let data;
    const cacheKey = CacheService.generateCacheKey(options);
    data = await CacheService.getFromCache(cacheKey);
    if (data) {
      return data;
    }

    const flamelinkApp = SystemService.getFlamelinkApp();
    functions.logger.info(`Getting document for ${options.schemaKey}: ${options.entryId}`);

    data = await flamelinkApp.content.get(options);
    CacheService.setInCache(cacheKey, data);
    return data;
  };

  export const getBatchDocuments = async function(options: { schemaKey: string; entryIds: string[] }): Promise<any> {
    const flamelinkApp = SystemService.getFlamelinkApp();
    functions.logger.info(`Getting batch documents for ${options.schemaKey}: ${options.entryIds}`);

    const futures = options.entryIds.map(async (entryId) => {
      let data;
      const cacheKey = CacheService.generateCacheKey({ schemaKey: options.schemaKey, entryId });
      data = await CacheService.getFromCache(cacheKey);
      if (data) {
        return data;
      }

      data = await flamelinkApp.content.get({
        schemaKey: options.schemaKey,
        entryId: entryId,
      });
      
      CacheService.setInCache(cacheKey, data);
      return data;
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
    const flamelinkApp = SystemService.getFlamelinkApp();
    functions.logger.info(`Checking if document exists for ${options.schemaKey}: ${options.entryId}`);

    const currentDocument = await flamelinkApp.content.get(options);
    const exists = !!currentDocument;
    
    if (exists) {
      const cacheKey = CacheService.generateCacheKey(options);
      await CacheService.setInCache(cacheKey, currentDocument);
    }

    return exists;
  };

  /**
   * Deletes a document.
   * @param {any} options the options to use.
   * @return {Promise<void>} a promise that resolves when the document is deleted.
   */
  export const deleteDocument = async function(options: { schemaKey: string; entryId: string }): Promise<void> {
    const cacheKey = CacheService.generateCacheKey(options);
    await CacheService.deleteFromCache(cacheKey);

    const flamelinkApp = SystemService.getFlamelinkApp();
    functions.logger.info(`Deleting document for user: ${options.entryId}`);

    const currentDocument = await flamelinkApp.content.get(options);
    if (!currentDocument) {
      functions.logger.info(`Document not found, not deleting`);
      return;
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
    const cacheKey = CacheService.generateCacheKey(options);
    await CacheService.deleteFromCache(cacheKey);

    const flamelinkApp = SystemService.getFlamelinkApp();
    functions.logger.info(`Updating document for user: ${options.entryId} to ${options.data}`);

    const transactionResult = await adminApp.firestore().runTransaction(async (transaction) => {
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
      CacheService.setInCache(cacheKey, newData);
      transaction.update(documentRef, newData);
    });

    functions.logger.info(`Transaction finished: ${transactionResult}`);
  };
}
