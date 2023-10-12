import * as functions from 'firebase-functions';
import { AdminQuickActionDataJSON, AdminQuickActionJSON } from "../../dto/admin";
import { AdminQuickActionService } from '../admin_quick_action_service';
import { FlamelinkHelpers } from '../../helpers/flamelink_helpers';
import { DocumentReference } from 'firebase-admin/firestore';

export namespace FindPromotionKeyAction {
    export async function findPromotionKey(action: AdminQuickActionJSON): Promise<void> {
        const actionId = FlamelinkHelpers.getFlamelinkIdFromObject(action);
        if (!action || !actionId) {
            functions.logger.error(`No action ID specified`);
            return Promise.resolve();
        }

        const targetPromotion = action.data?.find((d: AdminQuickActionDataJSON) => d.target === 'targetPromotion') || {};
        const targetPromotionReference = (targetPromotion?.promotions?.length ?? 0) > 0 ? targetPromotion.promotions![0] : null as DocumentReference | null;
        const targetPromotionActualId = targetPromotionReference?.id ?? '';

        if (!targetPromotionActualId) {
            AdminQuickActionService.appendOutput(action, `Invalid data.`);
            AdminQuickActionService.updateStatus(action, 'error');
            return Promise.resolve();
        }

        const [targetPromotionSnapshot] = await Promise.all([
            targetPromotion.promotions![0].get(),
        ]);

        const targetPromotionData = targetPromotionSnapshot.data();
        const targetPromotionId = FlamelinkHelpers.getFlamelinkIdFromObject(targetPromotionData);

        if (!targetPromotionId || !targetPromotionData) {
            AdminQuickActionService.appendOutput(action, `Invalid data.`);
            AdminQuickActionService.updateStatus(action, 'error');
            return Promise.resolve();
        }

        
        AdminQuickActionService.appendOutput(action, `Promotion key is ${targetPromotionId}`);
        AdminQuickActionService.updateStatus(action, 'success');
    }
}