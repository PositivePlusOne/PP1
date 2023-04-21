import * as functions from "firebase-functions";

import { adminApp } from "../..";

import { DataChangeType } from "../data_change_type";
import { DataHandlerRegistry } from "../data_handler_registry";

export namespace StreamEventSyncHandler {
  /**
   * Registers the event sync handler.
   */
  export function register(): void {
    functions.logger.info("Registering stream event sync handler");

    DataHandlerRegistry.registerChangeHandler(
      DataChangeType.Create | DataChangeType.Update | DataChangeType.Delete,
      "events",
      "*",
      execute
    );
  }

  /**
   * Takes an event and syncs it to GetStream.
   * @param {DataChangeType} changeType the change type.
   * @param {string} schema the schema.
   * @param {string} id the id.
   * @param {any} before the before data.
   * @param {any} after the after data.
   */
  export async function execute(
    changeType: DataChangeType,
    schema: string,
    id: string,
    before: any,
    after: any
  ): Promise<void> {
    functions.logger.info("Executing event sync handler", {
      changeType,
      schema,
      id,
    });

    // TODO(ryan): Sync events to GetStream as they're updated.

    return;
  }
}
