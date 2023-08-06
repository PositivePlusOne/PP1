import * as functions from "firebase-functions";

import { DocumentData, DocumentReference, FieldPath } from "firebase-admin/firestore";
import { adminApp } from "..";

import { SystemService } from "./system_service";
import { FlamelinkHelpers } from "../helpers/flamelink_helpers";
import { CacheService } from "./cache_service";
import { QueryOptions, UpdateOptions } from "./types/query_options";

export namespace DataService {

  export const getDocumentReference = async function(options: { schemaKey: string; entryId: string }): Promise<DocumentReference<DocumentData>> {
    const cacheKey = CacheService.generateCacheKey(options);
    const cachedDocument = await CacheService.getFromCache(cacheKey);
    let documentId = cachedDocument?._fl_meta_?.docId || "";
    let documentRef: DocumentReference<DocumentData>;

    if (documentId) {
      functions.logger.info(`Found document reference in cache for ${options.schemaKey}: ${options.entryId}`);
      documentRef = adminApp.firestore().collection("fl_content").doc(documentId);
      return documentRef;
    }

    const flamelinkApp = SystemService.getFlamelinkApp();
    functions.logger.info(`Converting flamelink document to firestore document ${options.entryId} from ${options.schemaKey}`);

    const currentDocument = await flamelinkApp.content.get(options);
    if (!currentDocument) {
      throw new functions.https.HttpsError("not-found", "Flamelink document not found");
    }

    documentId = currentDocument._fl_meta_.docId;
    documentRef = adminApp.firestore().collection("fl_content").doc(documentId);

    return documentRef;
  };

  export const getDocument = async function(options: { schemaKey: string; entryId: string }, skipCacheLookup = false): Promise<any> {
    let data;
    const cacheKey = CacheService.generateCacheKey(options);

    if (!skipCacheLookup) {
      data = await CacheService.getFromCache(cacheKey);
      if (data) {
        functions.logger.info(`Found document in cache for ${options.schemaKey}: ${options.entryId}`);
        return data;
      }
    }

    const flamelinkApp = SystemService.getFlamelinkApp();
    functions.logger.info(`Getting document for ${options.schemaKey}: ${options.entryId} from flamelink`);

    data = await flamelinkApp.content.get(options);
    if (data) {
      CacheService.setInCache(cacheKey, data);
    }

    return data;
  };

  export const getDocumentWindowRaw = async function(options: QueryOptions): Promise<DocumentData[]> {
    functions.logger.info(`Getting document window query`, options);

    const firestore = adminApp.firestore();
    let query = firestore.collection("fl_content").where("_fl_meta_.schema", "==", options.schemaKey);

    if (options.where) {
      for (const where of options.where) {
        query = query.where(where.fieldPath, where.op, where.value);
      }
    }

    if (options.limit) {
      query = query.limit(options.limit);
    }

    if (options.startAfter) {
      query = query.orderBy(FieldPath.documentId());
      query = query.startAfter(options.startAfter);
    }

    const querySnapshot = await query.get();
    const documents = querySnapshot.docs.map((doc) => doc.data());

    return documents;
  };

  export const countDocumentsRaw = async function(options: QueryOptions): Promise<number> {
    functions.logger.info(`Getting document count query for ${options.schemaKey}`);

    const firestore = adminApp.firestore();

    let query = firestore.collection("fl_content").where("_fl_meta_.schema", "==", options.schemaKey);

    if (options.where) {
      for (const where of options.where) {
        query = query.where(where.fieldPath, where.op, where.value);
      }
    }

    const querySnapshot = await query.count().get();
    const count = querySnapshot.data().count || 0;

    return count;
  };

  export const updateDocumentsRaw = async function(options: UpdateOptions<any>): Promise<void> {
    const firestore = adminApp.firestore();
    const batch = firestore.batch();

    let query = firestore.collection("fl_content").where("_fl_meta_.schema", "==", options.schemaKey);

    if (options.where) {
      for (const where of options.where) {
        query = query.where(where.fieldPath, where.op, where.value);
      }
    }

    await query.get().then((querySnapshot) => {
      querySnapshot.forEach((doc) => {
        const ref = doc.ref;
        for (const dataChange in options.dataChanges) {
          if (Object.prototype.hasOwnProperty.call(options.dataChanges, dataChange)) {
            const data = options.dataChanges[dataChange];
            batch.update(ref, { [dataChange]: data });
          }
        }
      });
    });

    await batch.commit();
  };

  export const getBatchDocuments = async function(options: { schemaKey: string; entryIds: string[] }): Promise<any> {
    const flamelinkApp = SystemService.getFlamelinkApp();
    functions.logger.info(`Getting batch documents for ${options.schemaKey}: ${options.entryIds}`);

    const futures = options.entryIds.map(async (entryId) => {
      let data;
      const cacheKey = CacheService.generateCacheKey({ schemaKey: options.schemaKey, entryId });
      data = await CacheService.getFromCache(cacheKey);

      if (data) {
        functions.logger.info(`Found document in cache for ${options.schemaKey}: ${entryId}`);
        return data;
      }

      functions.logger.info(`Getting document for ${options.schemaKey}: ${entryId}`);
      data = await flamelinkApp.content.get({
        schemaKey: options.schemaKey,
        entryId: entryId,
      });

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
    const cacheKey = CacheService.generateCacheKey(options);
    const cachedDocument = await CacheService.getFromCache(cacheKey);

    if (cachedDocument) {
      functions.logger.info(`Document exists in cache for ${options.schemaKey}: ${options.entryId}`);
      return true;
    }

    functions.logger.info(`Checking if document exists in flamelink for ${options.schemaKey}: ${options.entryId}`);
    const currentDocument = await flamelinkApp.content.get(options);
    if (currentDocument) {
      return true;
    }

    return false;
  };

  /**
   * Deletes a document.
   * @param {any} options the options to use.
   * @return {Promise<void>} a promise that resolves when the document is deleted.
   */
  export const deleteDocument = async function(options: { schemaKey: string; entryId: string }): Promise<void> {
    const cacheKey = CacheService.generateCacheKey(options);
    let currentDocument = await CacheService.getFromCache(cacheKey);

    await CacheService.deleteFromCache(cacheKey);

    const flamelinkApp = SystemService.getFlamelinkApp();
    functions.logger.info(`Deleting document for user: ${options.entryId}`);

    if (!currentDocument) {
      functions.logger.info(`Document not found, fetching from flamelink`);
      currentDocument = await flamelinkApp.content.get(options);
    }

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
   * @return {Promise<any>} a promise that resolves when the document is updated.
   */
  export const updateDocument = async function(options: { schemaKey: string; entryId: string; data: any }): Promise<any> {
    const flamelinkApp = SystemService.getFlamelinkApp();
    const cacheKey = CacheService.generateCacheKey(options);

    functions.logger.info(`Updating document for user: ${options.entryId}`);
    let data = {};

    await adminApp.firestore().runTransaction(async (transaction) => {
      let document = await CacheService.getFromCache(cacheKey);
      if (!document) {
        functions.logger.info(`Document not found, fetching from flamelink`);
        document = await flamelinkApp.content.get(options);
      }

      if (!document) {
        functions.logger.info(`Document not found, creating new`);
        data = await flamelinkApp.content.add(options);
        return;
      }

      const documentId = document._fl_meta_.docId;
      const documentRef = adminApp.firestore().collection("fl_content").doc(documentId);
      const isSame = FlamelinkHelpers.arePayloadsEqual(document, options.data);

      if (isSame) {
        functions.logger.info(`Current document data is the same as the new data, not updating`);
        return;
      }

      data = { ...document, ...options.data };
      transaction.update(documentRef, data);
    });

    return data;
  };
}
