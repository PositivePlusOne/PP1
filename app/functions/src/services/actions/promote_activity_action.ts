import * as functions from 'firebase-functions';
import { AdminQuickActionDataJSON, AdminQuickActionJSON } from "../../dto/admin";
import { AdminQuickActionService } from '../admin_quick_action_service';
import { FlamelinkHelpers } from '../../helpers/flamelink_helpers';
import { DocumentReference } from 'firebase-admin/firestore';
import { ActivitiesService } from '../activities_service';

export namespace PromoteActivityAction {
    export async function promoteActivity(action: AdminQuickActionJSON): Promise<void> {
        const actionId = FlamelinkHelpers.getFlamelinkIdFromObject(action);
        if (!action || !actionId) {
            functions.logger.error(`No action ID specified`);
            return Promise.resolve();
        }

        const targetActivity = action.data?.find((d: AdminQuickActionDataJSON) => d.target === 'targetActivity') || {};
        const targetPromotion = action.data?.find((d: AdminQuickActionDataJSON) => d.target === 'targetPromotion') || {};
        const targetActivityReference = (targetActivity?.activities?.length ?? 0) > 0 ? targetActivity.activities![0] : null as DocumentReference | null;
        const targetPromotionReference = (targetPromotion?.promotions?.length ?? 0) > 0 ? targetPromotion.promotions![0] : null as DocumentReference | null;
        const targetActivityActualId = targetActivityReference?.id ?? '';
        const targetPromotionActualId = targetPromotionReference?.id ?? '';

        if (!targetActivityActualId || !targetPromotionActualId) {
            AdminQuickActionService.appendOutput(action, `Invalid data.`);
            AdminQuickActionService.updateStatus(action, 'error');
            return Promise.resolve();
        }

        const [targetActivitySnapshot, targetPromotionSnapshot] = await Promise.all([
            targetActivity.activities![0].get(),
            targetPromotion.promotions![0].get(),
        ]);

        const targetActivityData = targetActivitySnapshot.data();
        const targetPromotionData = targetPromotionSnapshot.data();
        const targetActivityId = FlamelinkHelpers.getFlamelinkIdFromObject(targetActivityData);
        const targetPromotionId = FlamelinkHelpers.getFlamelinkIdFromObject(targetPromotionData);

        if (!targetActivityId || !targetPromotionId || !targetActivityData || !targetPromotionData) {
            AdminQuickActionService.appendOutput(action, `Invalid data.`);
            AdminQuickActionService.updateStatus(action, 'error');
            return Promise.resolve();
        }

        targetActivityData.enrichmentConfiguration ??= {};
        targetActivityData.enrichmentConfiguration.promotionKey = targetPromotionId;
        await targetActivityReference?.update(targetActivityData);
        
        AdminQuickActionService.appendOutput(action, `Activity ${targetActivityId} promoted with promotion ${targetPromotionId}`);

        AdminQuickActionService.appendOutput(action, `Updating feeds for activity ${targetActivityId}`);
        await ActivitiesService.updateTagFeedsForActivity(targetActivityData);

        AdminQuickActionService.updateStatus(action, 'success');
    }
}