import * as functions from "firebase-functions";

import { SearchService } from "../services/search_service";
import { DataHandlerRegistry } from "./data_change_handler";
import { DataChangeType } from "./data_change_type";
import { FlamelinkHelpers } from "../helpers/flamelink_helpers";
import { Profile, ProfileJSON } from "../dto/profile";

export namespace SearchIndexHandler {
  /**
   * Registers the search index handler.
   */
  export function register(): void {
    functions.logger.info("Registering search index handler");

    DataHandlerRegistry.registerChangeHandler(DataChangeType.Create | DataChangeType.Update | DataChangeType.Delete, ["activities", "users", "relationships", "tags", "venues", "guidanceArticles", "guidanceCategories", "guidanceDirectoryEntries"], "*", execute);
  }

  /**
   * Takes an event and syncs it to GetStream.
   * @param {DataChangeType} changeType the change type.
   * @param {string} schema the schema.
   * @param {string} id the id.
   * @param {any} before the before data.
   * @param {any} after the after data.
   */
  export async function execute(changeType: DataChangeType, schema: string, id: string, before: any, after: any): Promise<void> {
    functions.logger.info("Executing stream event sync handler", {
      changeType,
      schema,
      id,
      before,
      after,
    });

    const searchClient = SearchService.getAlgoliaClient();
    if (!searchClient) {
      functions.logger.error("Search client is not initialized");
      return;
    }

    const index = SearchService.getIndex(searchClient, schema);
    if (!index) {
      functions.logger.error(`Index ${schema} does not exist`);
      return;
    }

    if (changeType === DataChangeType.Delete) {
      await SearchService.deleteDocumentInIndex(index, id);
    }

    // Sanitize the data.
    const flamelinkSchema = FlamelinkHelpers.getFlamelinkSchemaFromObject(after);
    const flamelinkId = FlamelinkHelpers.getFlamelinkIdFromObject(after);

    if (!flamelinkSchema || !flamelinkId) {
      functions.logger.error("Missing Flamelink schema or ID");
      return;
    }

    switch (flamelinkSchema) {
      case "users":
        const profile = new Profile(after as ProfileJSON);
        profile.removePrivateData();
        profile.computeSearchTags();
        after = profile;
        break;
    }

    if (changeType === DataChangeType.Create || changeType === DataChangeType.Update) {
      await SearchService.addOrUpdateDocumentInIndex(index, after);
    }
  }
}
