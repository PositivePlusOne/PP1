import * as functions from "firebase-functions";

import { DataHandlerRegistry } from "./data_change_handler";
import { DataChangeType } from "./data_change_type";
import { AdminQuickActionJSON } from "../dto/admin";
import { AdminQuickActionService } from "../services/admin_quick_action_service";

export namespace QuickActionHandler {
    /**
     * Registers the quick action handler.
     */
    export function register(): void {
        functions.logger.info("Registering quick action handler");
        DataHandlerRegistry.registerChangeHandler(DataChangeType.Create, ["adminQuickActions"], "*", execute);
    }

    /**
     * Takes documents as they are added, and processes them as quick actions
     * @param {DataChangeType} changeType the change type.
     * @param {string} schema the schema.
     * @param {string} id the id.
     * @param {any} before the before data.
     * @param {any} after the after data.
     */
    export async function execute(changeType: DataChangeType, schema: string, id: string, before: any, after: any): Promise<void> {
        functions.logger.info("Executing quick action handler", {
            changeType,
            schema,
            id,
            before,
            after,
        });

        const data = after as AdminQuickActionJSON || before as AdminQuickActionJSON;
        if (!data) {
            return;
        }

        if (data.status !== "pending") {
            functions.logger.error("Quick action is not pending", {
                status: data.status,
            });
            
            return;
        }

        switch (changeType) {
            case DataChangeType.Create:
                await AdminQuickActionService.processQuickAction(data);
                return;
            default:
                return;
        }
    }
}
