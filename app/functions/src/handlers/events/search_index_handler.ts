import * as functions from "firebase-functions";

import { DataChangeType } from "../data_change_type";
import { DataHandlerRegistry } from "../data_handler_registry";
import { SearchService } from "../../services/search_service";

export namespace SearchIndexHandler {
  /**
   * Registers the event sync handler.
   */
  export function register(): void {
    functions.logger.info("Registering stream event sync handler");

    DataHandlerRegistry.registerChangeHandler(
      DataChangeType.Create | DataChangeType.Update | DataChangeType.Delete,
      ["activities", "users", "tags", "venues"],
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
    functions.logger.info("Executing stream event sync handler", {
      changeType,
      schema,
      id,
      before,
      after,
    });

    const searchClient = SearchService.getMeiliSearchClient();
    if (!searchClient) {
      functions.logger.error("Search client is not initialized");
      return;
    }

    const index = await SearchService.getIndex(searchClient, schema);
    if (!index) {
      functions.logger.error(`Index ${schema} does not exist`);
      return;
    }

    if (changeType === DataChangeType.Delete) {
      await SearchService.deleteDocumentInIndex(index, id);
    }

    if (
      changeType === DataChangeType.Create ||
      changeType === DataChangeType.Update
    ) {
      await SearchService.addOrUpdateDocumentInIndex(index, after);
    }
  }
}
