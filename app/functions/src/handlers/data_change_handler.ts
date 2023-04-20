import * as functions from "firebase-functions";

import { FlamelinkHelpers } from "../helpers/flamelink_helpers";
import { DataChangeType } from "./data_change_type";
import { DataHandlerRegistry } from "./data_handler_registry";

export namespace DataChangeHandler {
  exports.handler = functions.firestore
    .document("fl_content/{documentId}")
    .onWrite(async (change, context) => {
      functions.logger.info("Data change detected", { change, context });

      const changeType = getChangeType(change);
      const beforeData = change.before.exists ? change.before.data() : null;
      const afterData = change.after.exists ? change.after.data() : null;
      const schema = getChangeDocumentSchema(changeType, beforeData, afterData);
      const id = getChangeDocumentId(changeType, beforeData, afterData);
      if (schema.length === 0 || id.length === 0) {
        functions.logger.info("Data change ignored", {
          changeType,
          schema,
          id,
        });

        return;
      }

      const isRecursive = FlamelinkHelpers.arePayloadsEqual(
        beforeData,
        afterData
      );

      if (isRecursive) {
        functions.logger.info("Data change ignored (recursive)", {
          changeType,
          schema,
          id,
        });

        return;
      }
      
      await DataHandlerRegistry.executeChangeHandlers(
        changeType,
        schema,
        id,
        beforeData,
        afterData
      );
    });

  /**
   * Gets the document id from a change object.
   * @param {DataChangeType} changeType the change type.
   * @param {any} beforeData the before data
   * @param {any} afterData the after data
   * @return {string} the document id.
   */
  export function getChangeDocumentId(
    changeType: DataChangeType,
    beforeData: any,
    afterData: any
  ): string {
    let id = "";
    switch (changeType) {
      case DataChangeType.Delete:
        id = beforeData?._fl_meta_?.fl_id || "";
        break;
      default:
        id = afterData?._fl_meta_?.fl_id || "";
        break;
    }

    return id;
  }

  /**
   * Gets the schema from a change object.
   * @param {DataChangeType} changeType the change type.
   * @param {any} beforeData the before data
   * @param {any} afterData the after data
   * @return {string} the schema.
   */
  export function getChangeDocumentSchema(
    changeType: DataChangeType,
    beforeData: any,
    afterData: any
  ): string {
    let schema = "";
    switch (changeType) {
      case DataChangeType.Delete:
        schema = beforeData?._fl_meta_?.schema || "";
        break;
      default:
        schema = afterData?._fl_meta_?.schema || "";
        schema = afterData?._fl_meta_?.schema || "";
        break;
    }

    return schema;
  }

  /**
   * Gets the change type from a change object.
   * @param {functions.Change<functions.firestore.DocumentSnapshot>} change the change object.
   * @return {DataChangeType} the change type.
   */
  export function getChangeType(
    change: functions.Change<functions.firestore.DocumentSnapshot>
  ): DataChangeType {
    if (!change.before.exists && change.after.exists) {
      return DataChangeType.Create;
    } else if (change.before.exists && change.after.exists) {
      return DataChangeType.Update;
    } else if (change.before.exists && !change.after.exists) {
      return DataChangeType.Delete;
    } else {
      return DataChangeType.None;
    }
  }
}
