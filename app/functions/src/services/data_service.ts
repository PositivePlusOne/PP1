import * as functions from "firebase-functions";
import { adminApp } from "..";

import { SystemService } from "./system_service";

export namespace DataService {
  export const getDocument = async function(options: {
    schemaKey: string;
    entryId: string;
  }): Promise<void> {
    const flamelinkApp = SystemService.getFlamelinkApp();
    functions.logger.info(`Getting document for user: ${options.entryId}`);

    return await flamelinkApp.content.get(options);
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
