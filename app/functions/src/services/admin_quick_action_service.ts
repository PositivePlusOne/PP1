import * as functions from "firebase-functions";

import { AdminQuickActionJSON } from "../dto/admin";
import { FlamelinkHelpers } from "../helpers/flamelink_helpers";
import { DataService } from "./data_service";

import { AssignOrganisationMemberAction } from "./actions/assign_organisation_member_action";
import { RemoveOrganisationMemberAction } from "./actions/remove_organisation_member_action";
import { AssignOrganisationOwnerAction } from "./actions/assign_organisation_owner_action";
import { RemoveOrganisationOwnerAction } from "./actions/remove_organisation_owner_action";
import { FlagAccountAction } from "./actions/flag_account_action";
import { RemoveAccountFlagAction } from "./actions/remove_account_flag_action";
import { UpdateCoverImageAction } from "./actions/update_cover_image_action";
import { LinkDirectoryEntryAction } from "./actions/link_directory_entry_action";
import { UnlinkDirectoryEntryAction } from "./actions/unlink_directory_entry_action";
import { UpdatePromotionMixpanelAnalyticsAction } from "./actions/update_promotion_mixpanel_analytics_action";
import { ShufflePromotionSeedsAction } from "./actions/shuffle_promotion_seeds_action";
import { DeactivateInactivePromotionsAction } from "./actions/deactivate_inactive_promotions_action";
import { DeleteMemberAction } from "./actions/delete_member_action";
import { ClearFeedAction } from "./actions/clear_feed_action";
import { UpdateProfileImageAction } from "./actions/update_profile_image_action";
import { FixProfilesAction } from "./actions/fix_profiles_action";
import { ClearServerCacheAction } from "./actions/clear_server_cache_action";

export namespace AdminQuickActionService {
    type ActionFunction = (action: AdminQuickActionJSON) => Promise<void>;

    const actionMapping: { [key: string]: ActionFunction } = {
        'deletePendingMembers': DeleteMemberAction.deletePendingMembers,
        'removeOrganisationMember': RemoveOrganisationMemberAction.removeOrganisationMember,
        'assignOrganisationMember': AssignOrganisationMemberAction.assignOrganisationMember,
        'assignOrganisationOwner': AssignOrganisationOwnerAction.assignOrganisationOwner,
        'removeOrganisationOwner': RemoveOrganisationOwnerAction.removeOrganisationOwner,
        'clearFeed': ClearFeedAction.clearFeed,
        'flagAccount': FlagAccountAction.flagAccount,
        'removeAccountFlag': RemoveAccountFlagAction.removeAccountFlag,
        'updateProfileImage': UpdateProfileImageAction.updateProfileImage,
        'updateCoverImage': UpdateCoverImageAction.updateCoverImage,
        'linkDirectoryEntry': LinkDirectoryEntryAction.linkDirectoryEntry,
        'unlinkDirectoryEntry': UnlinkDirectoryEntryAction.unlinkDirectoryEntry,
        'updatePromotionMixpanelAnalytics': UpdatePromotionMixpanelAnalyticsAction.updatePromotionsMixpanelAnalytics,
        'shufflePromotionSeeds': ShufflePromotionSeedsAction.shufflePromotionSeeds,
        'deactivateInactivePromotions': DeactivateInactivePromotionsAction.deactivateInactivePromotions,
        'fixProfileData': FixProfilesAction.fixProfiles,
        'clearServerCache': ClearServerCacheAction.clearServerCache,
    };

    export async function processQuickAction(action: AdminQuickActionJSON): Promise<void> {
        try {
            functions.logger.debug(`Processing quick action`, action);
            if (!action.action) {
                appendOutput(action, 'No action specified.');
                updateStatus(action, 'error');
                return;
            }

            appendOutput(action, `Processing action: ${action.action}`);
            updateStatus(action, 'processing');
            await saveQuickAction(action);

            AdminQuickActionService.appendOutput(action, `Processing action ${action.action}`);

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