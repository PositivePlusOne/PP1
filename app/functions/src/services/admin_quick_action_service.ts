import * as functions from "firebase-functions";

import { AdminQuickActionJSON } from "../dto/admin";
import { FlamelinkHelpers } from "../helpers/flamelink_helpers";
import { DataService } from "./data_service";

import { AssignOrganisationMemberAction } from "./actions/assign_organisation_member_action";
import { RemoveOrganisationMemberAction } from "./actions/remove_organisation_member_action";
import { AssignOrganisationOwnerAction } from "./actions/assign_organisation_owner_action";
import { RemoveOrganisationOwnerAction } from "./actions/remove_organisation_owner_action";
import { PromoteActivityAction } from "./actions/promote_activity_action";
import { DemoteActivityAction } from "./actions/demote_activity_action";
import { FindPromotionKeyAction } from "./actions/find_promotion_key_action";

export namespace AdminQuickActionService {
    type ActionFunction = (action: AdminQuickActionJSON) => Promise<void>;

    const actionMapping: { [key: string]: ActionFunction } = {
        'removeOrganisationMember': RemoveOrganisationMemberAction.removeOrganisationMember,
        'assignOrganisationMember': AssignOrganisationMemberAction.assignOrganisationMember,
        'assignOrganisationOwner': AssignOrganisationOwnerAction.assignOrganisationOwner,
        'removeOrganisationOwner': RemoveOrganisationOwnerAction.removeOrganisationOwner,
        'promoteActivity': PromoteActivityAction.promoteActivity,
        'demoteActivity': DemoteActivityAction.demoteActivity,
        'findPromotionKey': FindPromotionKeyAction.findPromotionKey,
    };

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

            // Using dynamic function calls instead of the switch.
            const actionFunction = getActionFunction(action.action);
            if (actionFunction) {
                await actionFunction(action);
            } else {
                appendOutput(action, `No action handler defined for action ${action.action}`);
                updateStatus(action, 'error');
            }
        } catch (error) {
            functions.logger.error(`Error processing quick action: ${error}`);
            appendOutput(action, `Error processing action: ${error}`);
            updateStatus(action, 'error');
        } finally {
            await saveQuickAction(action);
        }
    }

    export function getActionFunction(actionName: string): ActionFunction | null {
        return actionMapping[actionName] || null;
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