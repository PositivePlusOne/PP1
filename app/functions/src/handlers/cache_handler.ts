import * as functions from "firebase-functions";

import { DataHandlerRegistry } from "./data_change_handler";
import { DataChangeType } from "./data_change_type";
import { FlamelinkHelpers } from "../helpers/flamelink_helpers";
import { CacheService } from "../services/cache_service";

export namespace CacheHandler {
  /**
   * Registers the cache cleanup handler.
   */
  export function register(): void {
    functions.logger.info("Registering cache handler");
    DataHandlerRegistry.registerChangeHandler(DataChangeType.Create, ["*"], "*", execute);
    DataHandlerRegistry.registerChangeHandler(DataChangeType.Delete, ["*"], "*", execute);
    DataHandlerRegistry.registerChangeHandler(DataChangeType.Update, ["*"], "*", execute);
  }

  /**
   * Takes documents as they are deleted or updated, and removes or updates them from the cache
   * @param {DataChangeType} changeType the change type.
   * @param {string} schema the schema.
   * @param {string} id the id.
   * @param {any} before the before data.
   * @param {any} after the after data.
   */
  export async function execute(changeType: DataChangeType, schema: string, id: string, before: any, after: any): Promise<void> {
    functions.logger.info("Executing cache handler", {
      changeType,
      schema,
      id,
      before,
      after,
    });

    const creationFlamelinkId = FlamelinkHelpers.getFlamelinkIdFromObject(after);
    const deletionFlamelinkId = FlamelinkHelpers.getFlamelinkIdFromObject(before);
    const flamelinkId = creationFlamelinkId || deletionFlamelinkId;

    if (!flamelinkId) {
      functions.logger.info("No flamelink id found, skipping cache cleanup");
      return;
    }

    switch (schema) {
      case "guidanceCategories":
      case "guidanceArticles":
      case "guidanceDirectoryEntries":
        functions.logger.info("Cleaning guidance CMS caches");
        await CacheService.deletePrefixedFromCache("guidance");
        break;
      default:
        break;
    }

    switch (changeType) {
      case DataChangeType.Create:
        const cacheKeyCreate = CacheService.generateCacheKey({ schemaKey: schema, entryId: flamelinkId });
        if (after && cacheKeyCreate) {
          functions.logger.info("Setting cache key", cacheKeyCreate);
          await CacheService.setInCache(cacheKeyCreate, after);
        }
        return;
      case DataChangeType.Delete:
        const cacheKeyDel = CacheService.generateCacheKey({ schemaKey: schema, entryId: flamelinkId });
        if (cacheKeyDel) {
          functions.logger.info("Deleting cache key", cacheKeyDel);
          await CacheService.deleteFromCache(cacheKeyDel);
        }
        break;
      case DataChangeType.Update:
        const cacheKeyUpdate = CacheService.generateCacheKey({ schemaKey: schema, entryId: flamelinkId });
        if (after && cacheKeyUpdate) {
          functions.logger.info("Updating cache key", cacheKeyUpdate);
          await CacheService.setInCache(cacheKeyUpdate, after);
        }
        break;
      default:
        return;
    }
  }
}
