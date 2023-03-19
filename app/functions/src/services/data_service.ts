import * as functions from "firebase-functions";
import { DocumentData, DocumentReference } from "firebase-admin/firestore";
import { adminApp } from "..";

import { SystemService } from "./system_service";

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
  }): Promise<void> {
    const flamelinkApp = SystemService.getFlamelinkApp();
    functions.logger.info(`Getting document for user: ${options.entryId}`);

    return await flamelinkApp.content.get(options);
  };

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

    //* Updates are a bit more complicated than adds, because we need to merge the existing data with the new data.
    const documentId = currentDocument._fl_meta_.docId;
    const documentRef = adminApp
      .firestore()
      .collection("fl_content")
      .doc(documentId);
      
    const documentData = currentDocument.data;

    functions.logger.info(
      `Current document data: ${documentData} with ref: ${documentRef}`
    );

    const newData = { ...documentData, ...options.data };
    await documentRef.update(newData);
  };
}
