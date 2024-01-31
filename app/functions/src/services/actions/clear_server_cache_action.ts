import { AdminQuickActionJSON } from "../../dto/admin";
import { AdminQuickActionService } from "../admin_quick_action_service";
import { CacheService } from "../cache_service";

export namespace ClearServerCacheAction {
    export async function clearServerCache(action: AdminQuickActionJSON): Promise<void> {
        AdminQuickActionService.appendOutput(action, "Clearing server cache for all schemas...");
        await CacheService.deleteAllFromCache();
        
        AdminQuickActionService.appendOutput(action, "Clearing server cache complete.");
        AdminQuickActionService.updateStatus(action, "success");
    }
}