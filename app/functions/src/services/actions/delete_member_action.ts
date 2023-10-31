import * as functions from 'firebase-functions';
import { AdminQuickActionDataJSON, AdminQuickActionJSON } from "../../dto/admin";
import { AdminQuickActionService } from '../admin_quick_action_service';
import { FlamelinkHelpers } from '../../helpers/flamelink_helpers';
import { DocumentReference } from 'firebase-admin/firestore';
import { ActivitiesService } from '../activities_service';

export namespace DeleteMemberAction {
    export async function deleteMember(action: AdminQuickActionJSON): Promise<void> {
        const actionId = FlamelinkHelpers.getFlamelinkIdFromObject(action);
        if (!action || !actionId) {
            functions.logger.error(`No action ID specified`);
            return Promise.resolve();
        }

        const sourceProfileData = action.data?.find((d: AdminQuickActionDataJSON) => d.target === 'sourceProfile') || {};
        const sourceProfileReference = (sourceProfileData?.profiles?.length ?? 0) > 0 ? sourceProfileData.profiles![0] : null as DocumentReference | null;
        const sourceProfileActualId = sourceProfileReference?.id ?? '';

        if (!sourceProfileActualId) {
            AdminQuickActionService.appendOutput(action, `No source or target profile ID specified.`);
            AdminQuickActionService.updateStatus(action, 'error');
            return Promise.resolve();
        }

        const [sourceProfileSnapshot] = await Promise.all([
            sourceProfileData.profiles![0].get(),
        ]);

        const sourceProfile = sourceProfileSnapshot.data();
        const sourceProfileId = FlamelinkHelpers.getFlamelinkIdFromObject(sourceProfile);

        if (!sourceProfileId || !sourceProfile) {
            AdminQuickActionService.appendOutput(action, `No source or target profile specified.`);
            AdminQuickActionService.updateStatus(action, 'error');
            return Promise.resolve();
        }

        const isPendingDeletion = sourceProfile?.visibilityFlags?.includes('pending_deletion');
        if (!isPendingDeletion) {
            AdminQuickActionService.appendOutput(action, `The source profile is not pending deletion.`);
            AdminQuickActionService.updateStatus(action, 'error');
            return Promise.resolve();
        }

        // Get all posts from the source profile and delete them.
        const activities = await ActivitiesService.getActivitiesForProfile(sourceProfileId);
        AdminQuickActionService.appendOutput(action, `Deleting ${activities.length} activities from profile ${sourceProfileId}`);
        for (const activity of activities) {
            const activityId = FlamelinkHelpers.getFlamelinkIdFromObject(activity);
            if (!activityId) {
                continue;
            }

            AdminQuickActionService.appendOutput(action, `Deleting activity ${activityId}`);
            await ActivitiesService.deleteActivity(activityId);
        }

        // Delete the source profile.
        AdminQuickActionService.appendOutput(action, `Deleting profile ${sourceProfileId}`);
        await sourceProfileReference?.delete();

        AdminQuickActionService.appendOutput(action, `Successfully deleted profile ${sourceProfileId}`);
        AdminQuickActionService.updateStatus(action, 'success');
    }
}