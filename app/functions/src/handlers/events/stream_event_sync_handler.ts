import * as functions from "firebase-functions";

import { DataChangeType } from "../data_change_type";
import { DataHandlerRegistry } from "../data_handler_registry";

DataHandlerRegistry.registerChangeHandler(
  DataChangeType.Create | DataChangeType.Update | DataChangeType.Delete,
  "event",
  "*",
  execute
);

/**
 * Takes an event and syncs it to GetStream.
 * @param {DataChangeType} changeType the change type.
 * @param {string} schema the schema.
 * @param {string} id the id.
 */
export async function execute(
  changeType: DataChangeType,
  schema: string,
  id: string,
  before: any,
  after: any,
): Promise<void> {
  functions.logger.info("Executing event sync handler", {
    changeType,
    schema,
    id,
  });

  if (changeType !== DataChangeType.Update) {
    functions.logger.info("Event sync handler ignored (not update)");
    return;
  }

  return;
}
