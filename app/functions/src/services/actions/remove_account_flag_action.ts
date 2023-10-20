import * as functions from 'firebase-functions';

import { AdminQuickActionDataJSON, AdminQuickActionJSON } from "../../dto/admin";
import { AdminQuickActionService } from '../admin_quick_action_service';
import { FlamelinkHelpers } from '../../helpers/flamelink_helpers';
import { ProfileService } from '../profile_service';

export namespace RemoveAccountFlagAction {
    export async function removeAccountFlag(action: AdminQuickActionJSON): Promise<void> {
        const actionId = FlamelinkHelpers.getFlamelinkIdFromObject(action);
        if (!action || !actionId) {
            functions.logger.error(`No action ID specified`);
            return Promise.resolve();
        }

        const sourceProfileData = action.data?.find((d: AdminQuickActionDataJSON) => d.target === 'sourceProfile') || {};
        const accountFlagData = action.data?.find((d: AdminQuickActionDataJSON) => d.target === 'accountFlags');
        const accountFlagsToBeRemoved = accountFlagData?.accountFlags || [];

        if (!sourceProfileData || !accountFlagsToBeRemoved) {
            AdminQuickActionService.appendOutput(action, `No source profile or account flag specified.`);
            AdminQuickActionService.updateStatus(action, 'error');
            return Promise.resolve();
        }

        const [sourceProfileSnapshot] = await Promise.all([
            sourceProfileData.profiles![0].get(),
        ]);

        const sourceProfile = sourceProfileSnapshot.data();
        const sourceProfileId = FlamelinkHelpers.getFlamelinkIdFromObject(sourceProfile);

        if (!sourceProfileId || !sourceProfile) {
            AdminQuickActionService.appendOutput(action, `No source profile found.`);
            AdminQuickActionService.updateStatus(action, 'error');
            return Promise.resolve();
        }

        const currentFlags = sourceProfile.accountFlags || new Set();

        // Check if the flags to be removed are already removed.
        const flagsToBeRemovedNotPresent = accountFlagsToBeRemoved.filter((flag: string) => !currentFlags.includes(flag));
        if (flagsToBeRemovedNotPresent.length === accountFlagsToBeRemoved.length) {
            AdminQuickActionService.appendOutput(action, `The flags to be removed are already removed.`);
            AdminQuickActionService.updateStatus(action, 'success');
            return Promise.resolve();
        }

        const newFlags = currentFlags.filter((flag: string) => !accountFlagsToBeRemoved.includes(flag));
        await ProfileService.updateAccountFlags(sourceProfileId, newFlags);
        
        AdminQuickActionService.appendOutput(action, `Successfully updated the account flags for the profile ${sourceProfileId}.`);
        AdminQuickActionService.updateStatus(action, 'success');
    }
}