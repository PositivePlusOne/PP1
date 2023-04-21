import * as functions from "firebase-functions";

import { DocumentData, DocumentReference } from "firebase-admin/firestore";
import { adminApp } from "..";

import { SystemService } from "./system_service";
import { FlamelinkHelpers } from "../helpers/flamelink_helpers";

export namespace DataService {
  export const getDocumentReference = async function(options: {
    schemaKey: string;
    entryId: string;
  }): Promise<DocumentReference<DocumentData>> {
    const flamelinkApp = SystemService.getFlamelinkApp();
    functions.logger.info(
      `Converting flamelink document to firestore document ${options.entryId} from ${options.schemaKey}`
    );

    const currentDocument = await flamelinkApp.content.get(options);
    if (!currentDocument) {
      throw new functions.https.HttpsError(
        "not-found",
        "Flamelink document not found"
      );
    }

    const documentId = currentDocument._fl_meta_.docId;
    return adminApp.firestore().collection("fl_content").doc(documentId);
  };

  export const getDocument = async function(options: {
    schemaKey: string;
    entryId: string;
  }): Promise<any> {
    const flamelinkApp = SystemService.getFlamelinkApp();
    functions.logger.info(
      `Getting document for ${options.schemaKey}: ${options.entryId}`
    );

    return await flamelinkApp.content.get(options);
  };

  /**
   * Checks if a document exists.
   * @param {any} options the options to use.
   * @return {Promise<boolean>} true if the document exists, false otherwise.
   */
  export const exists = async function(options: {
    schemaKey: string;
    entryId: string;
  }): Promise<boolean> {
    const flamelinkApp = SystemService.getFlamelinkApp();
    functions.logger.info(
      `Checking if document exists for ${options.schemaKey}: ${options.entryId}`
    );

    const currentDocument = await flamelinkApp.content.get(options);
    return !!currentDocument;
  };

  /**
   * Deletes a document.
   * @param {any} options the options to use.
   * @return {Promise<void>} a promise that resolves when the document is deleted.
   */
  export const deleteDocument = async function(options: {
    schemaKey: string;
    entryId: string;
  }): Promise<void> {
    const flamelinkApp = SystemService.getFlamelinkApp();
    functions.logger.info(`Deleting document for user: ${options.entryId}`);

    const currentDocument = await flamelinkApp.content.get(options);
    if (!currentDocument) {
      throw new functions.https.HttpsError(
        "not-found",
        "Flamelink document not found"
      );
    }

    const documentId = currentDocument._fl_meta_.docId;
    const documentRef = adminApp
      .firestore()
      .collection("fl_content")
      .doc(documentId);

    await documentRef.delete();
  };

  /**
   * Updates a document.
   * @param {any} options the options to use.
   */
  export const updateDocument = async function(options: {
    schemaKey: string;
    entryId: string;
    data: any;
  }): Promise<void> {
    const flamelinkApp = SystemService.getFlamelinkApp();
    functions.logger.info(
      `Updating document for user: ${options.entryId} to ${options.data}`
    );

    const currentDocument = await flamelinkApp.content.get(options);
    if (!currentDocument) {
      await flamelinkApp.content.add(options);
      return;
    }

    const documentId = currentDocument._fl_meta_.docId;
    const documentRef = adminApp
      .firestore()
      .collection("fl_content")
      .doc(documentId);

    const isSame = FlamelinkHelpers.arePayloadsEqual(
      currentDocument,
      options.data
    );

    if (isSame) {
      functions.logger.info(
        `Current document data is the same as the new data, not updating`
      );

      return;
    }

    functions.logger.info(
      `Current document data: ${currentDocument} with ref: ${documentRef}`
    );

    const newData = { ...currentDocument, ...options.data };
    await documentRef.update(newData);
  };
}
