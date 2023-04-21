import * as functions from "firebase-functions";

import { DataChangeType } from "./data_change_type";

export namespace DataChangeHandler {
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
