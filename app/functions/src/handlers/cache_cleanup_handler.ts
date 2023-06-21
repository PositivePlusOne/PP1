import * as functions from "firebase-functions";

import { DataHandlerRegistry } from "./data_change_handler";
import { DataChangeType } from "./data_change_type";
import { FlamelinkHelpers } from "../helpers/flamelink_helpers";
import { CacheService } from "../services/cache_service";

export namespace CacheCleanupHandler {
  /**
   * Registers the cache cleanup handler.
   */
  export function register(): void {
    functions.logger.info("Registering cache cleanup handler");
    DataHandlerRegistry.registerChangeHandler(DataChangeType.Delete, ["*"], "*", execute);
  }

  /**
   * Takes documents as they are deleted, and removes them from the cache
   * @param {DataChangeType} changeType the change type.
   * @param {string} schema the schema.
   * @param {string} id the id.
   * @param {any} before the before data.
   * @param {any} after the after data.
   */
  export async function execute(changeType: DataChangeType, schema: string, id: string, before: any, after: any): Promise<void> {
    functions.logger.info("Removing deleted data from the cache", {
      changeType,
      schema,
      id,
      before,
      after,
    });

    const deletionFlamelinkId = FlamelinkHelpers.getFlamelinkIdFromObject(before);
    if (!deletionFlamelinkId) {
        functions.logger.debug("No flamelink id found on the deleted object", {
            changeType,
            schema,
            id,
            before,
            after,
        });

        return;
    }

    switch (changeType) {
        case DataChangeType.Delete:
            const cacheKey = CacheService.generateCacheKey({ schemaKey: schema, entryId: deletionFlamelinkId });
            await CacheService.deleteFromCache(cacheKey);
            break;
        default:
            return;
    }
  }
}
