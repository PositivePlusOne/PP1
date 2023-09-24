import * as functions from "firebase-functions";

import { AdminQuickActionJSON } from "../dto/admin";
import { FlamelinkHelpers } from "../helpers/flamelink_helpers";
import { DataService } from "./data_service";

import { AssignOrganisationMemberAction } from "./actions/assign_organisation_member_action";
import { RemoveOrganisationMemberAction } from "./actions/remove_organisation_member_action";

export namespace AdminQuickActionService {
    export async function processQuickAction(action: AdminQuickActionJSON): Promise<void> {
        try {
            functions.logger.debug(`Processing quick action: ${JSON.stringify(action)}`);
            if (!action.action) {
                appendOutput(action, `No action specified.`);
                updateStatus(action, 'error');
                return;
            }

            appendOutput(action, `Processing action: ${action.action}`);
            updateStatus(action, 'processing');
            await saveQuickAction(action);

            switch (action.action) {
                case 'removeOrganisationMember':
                    await RemoveOrganisationMemberAction.removeOrganisationMember(action);
                    break;
                case 'assignOrganisationMember':
                    await AssignOrganisationMemberAction.assignOrganisationMember(action);
                    break;
                default:
                    appendOutput(action, `No action handler defined for action ${action.action}`);
                    updateStatus(action, 'error');
                    break;
            }
        } catch (error) {
            functions.logger.error(`Error processing quick action: ${error}`);
            appendOutput(action, `Error processing action: ${error}`);
            updateStatus(action, 'error');
        } finally {
            await saveQuickAction(action);
        }
    }

    export async function saveQuickAction(action: AdminQuickActionJSON): Promise<void> {
        const actionId = FlamelinkHelpers.getFlamelinkIdFromObject(action);
        if (!action || !actionId) {
            functions.logger.error(`No action ID specified`);
            return Promise.resolve();
        }

        return DataService.updateDocument({
            schemaKey: 'adminQuickActions',
            entryId: actionId,
            data: action,
        });
    }

    export function appendOutput(action: AdminQuickActionJSON, output: string): AdminQuickActionJSON {
        const actionId = FlamelinkHelpers.getFlamelinkIdFromObject(action);
        if (!action || !actionId) {
            functions.logger.error(`No action ID specified`);
            return action;
        }

        const oldOutput = action.output || '';
        const newOutput = output || '';

        if (oldOutput === newOutput) {
            functions.logger.debug(`No output change for action ${actionId}`);
            return action;
        }

        action.output = oldOutput + '\n' + newOutput;
        return action;
    }

    export function updateStatus(action: AdminQuickActionJSON, status: string): AdminQuickActionJSON {
        const actionId = FlamelinkHelpers.getFlamelinkIdFromObject(action);
        if (!action || !actionId) {
            functions.logger.error(`No action ID specified`);
            return action;
        }

        const oldStatus = action.status || '';
        const newStatus = status || '';

        if (oldStatus === newStatus) {
            functions.logger.debug(`No status change for action ${actionId}`);
            return action;
        }

        action.status = status;
        return action;
    }
}