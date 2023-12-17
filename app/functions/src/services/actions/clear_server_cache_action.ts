import * as functions from "firebase-functions";

import { AdminQuickActionJSON } from "../../dto/admin";
import { AdminQuickActionService } from "../admin_quick_action_service";
import { CacheService } from "../cache_service";
import { FlamelinkHelpers } from "../../helpers/flamelink_helpers";

export namespace ClearServerCacheAction {
    export async function clearServerCache(action: AdminQuickActionJSON): Promise<void> {
        const actionId = FlamelinkHelpers.getFlamelinkIdFromObject(action);
        if (!action || !actionId) {
            functions.logger.error(`No action ID specified`);
            return Promise.resolve();
        }

        const schema = action.data?.find((d) => d.target === "schema")?.schema;
        if (schema) {
            AdminQuickActionService.appendOutput(action, `Clearing server cache for schema ${schema}...`);
            await CacheService.deleteSchemaFromCache(schema);
        } else {
            AdminQuickActionService.appendOutput(action, "Clearing server cache for all schemas...");
            await CacheService.deleteAllFromCache();
        }
        
        AdminQuickActionService.appendOutput(action, "Clearing server cache complete.");
        AdminQuickActionService.updateStatus(action, "success");
    }
}