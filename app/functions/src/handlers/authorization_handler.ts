import * as functions from "firebase-functions";

import { DataChangeType } from "./data_change_type";
import { DataHandlerRegistry } from "./data_change_handler";
import { SystemService } from "../services/system_service";

export namespace AuthorizationHandler {
  /**
   * Registers the activity action handler.
   */
  export function register(): void {
    functions.logger.info("Registering authorization handler");

    DataHandlerRegistry.registerChangeHandler(
      DataChangeType.Create | DataChangeType.Update,
      ["users"],
      "*",
      execute
    );
  }

  /**
   * Takes an the roles on the users admin profile and syncs it to Firebase Auth.
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
    functions.logger.info("Executing authorization handler", {
      changeType,
      schema,
      id,
      before,
      after,
    });

    const roles = after.admin.roles || [];
    const userId = after._fl_meta_.id || "";

    if (!userId) {
      functions.logger.error("Invalid user id", {
        userId,
      });

      return;
    }

    functions.logger.info("Updating user claims", {
        userId,
        roles,
    });

    await SystemService.updateUserClaims(userId, roles);
  }
}
