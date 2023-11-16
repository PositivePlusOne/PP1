import * as functions from 'firebase-functions';

import { AdminQuickActionJSON } from "../../dto/admin";
import { AdminQuickActionService } from '../admin_quick_action_service';
import { FlamelinkHelpers } from '../../helpers/flamelink_helpers';
import { PromotionsService } from '../promotions_service';

export namespace DeactivateInactivePromotionsAction {
    export async function deactivateInactivePromotions(action: AdminQuickActionJSON): Promise<void> {
        const actionId = FlamelinkHelpers.getFlamelinkIdFromObject(action);
        if (!action || !actionId) {
            functions.logger.error(`No action ID specified`);
            return Promise.resolve();
        }

        AdminQuickActionService.appendOutput(action, `Deactivating inactive promotions.`);
        await PromotionsService.deactiveInactivePromotions(action);

        AdminQuickActionService.appendOutput(action, `Successfully deactivated inactive promotions.`);
        AdminQuickActionService.updateStatus(action, 'success');
    }
}