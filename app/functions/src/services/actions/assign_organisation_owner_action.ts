import * as functions from 'firebase-functions';
import { AdminQuickActionDataJSON, AdminQuickActionJSON } from "../../dto/admin";
import { AdminQuickActionService } from '../admin_quick_action_service';
import { FlamelinkHelpers } from '../../helpers/flamelink_helpers';
import { DocumentReference } from 'firebase-admin/firestore';
import { RelationshipService } from '../relationship_service';

export namespace AssignOrganisationOwnerAction {
    export async function assignOrganisationOwner(action: AdminQuickActionJSON): Promise<void> {
        const actionId = FlamelinkHelpers.getFlamelinkIdFromObject(action);
        if (!action || !actionId) {
            functions.logger.error(`No action ID specified`);
            return Promise.resolve();
        }

        const sourceProfileData = action.data?.find((d: AdminQuickActionDataJSON) => d.target === 'sourceProfile') || {};
        const targetProfileData = action.data?.find((d: AdminQuickActionDataJSON) => d.target === 'targetProfile') || {};
        const sourceProfileReference = (sourceProfileData?.profiles?.length ?? 0) > 0 ? sourceProfileData.profiles![0] : null as DocumentReference | null;
        const targetProfileReference = (targetProfileData?.profiles?.length ?? 0) > 0 ? targetProfileData.profiles![0] : null as DocumentReference | null;
        const sourceProfileActualId = sourceProfileReference?.id ?? '';
        const targetProfileActualId = targetProfileReference?.id ?? '';

        if (!sourceProfileActualId || !targetProfileActualId) {
            AdminQuickActionService.appendOutput(action, `No source or target profile ID specified.`);
            AdminQuickActionService.updateStatus(action, 'error');
            return Promise.resolve();
        }

        const [sourceProfileSnapshot, targetProfileSnapshot] = await Promise.all([
            sourceProfileData.profiles![0].get(),
            targetProfileData.profiles![0].get(),
        ]);

        const sourceProfile = sourceProfileSnapshot.data();
        const targetProfile = targetProfileSnapshot.data();
        const sourceProfileId = FlamelinkHelpers.getFlamelinkIdFromObject(sourceProfile);
        const targetProfileId = FlamelinkHelpers.getFlamelinkIdFromObject(targetProfile);

        if (!sourceProfileId || !targetProfileId || !sourceProfile || !targetProfile) {
            AdminQuickActionService.appendOutput(action, `No source or target profile specified.`);
            AdminQuickActionService.updateStatus(action, 'error');
            return Promise.resolve();
        }

        const relationship = await RelationshipService.getOrCreateRelationship([sourceProfileId, targetProfileId]);
        if (!relationship) {
            AdminQuickActionService.appendOutput(action, `A relationship could not be created.`);
            AdminQuickActionService.updateStatus(action, 'error');
            return Promise.resolve();
        }

        await RelationshipService.setOwnership(sourceProfile, targetProfile);
        AdminQuickActionService.appendOutput(action, `Successfully updated ownership.`);

        AdminQuickActionService.appendOutput(action, `Adding the organisation flag to the profile ${targetProfileId} if it doesn't already exist.`);

        if (!targetProfile?.featureFlags?.includes('organisation')) {
            targetProfile.featureFlags = targetProfile?.featureFlags ?? [];
            targetProfile.featureFlags.push('organisation');
            await targetProfileReference?.update(targetProfile);
            AdminQuickActionService.appendOutput(action, `Successfully added the organisation flag to the profile ${targetProfileId}.`);
        } else {
            AdminQuickActionService.appendOutput(action, `The organisation flag already exists on the profile ${targetProfileId}.`);
        }

        AdminQuickActionService.updateStatus(action, 'success');
    }
}