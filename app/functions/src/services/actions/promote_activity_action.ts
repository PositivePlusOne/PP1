import * as functions from 'firebase-functions';
import { AdminQuickActionDataJSON, AdminQuickActionJSON } from "../../dto/admin";
import { AdminQuickActionService } from '../admin_quick_action_service';
import { FlamelinkHelpers } from '../../helpers/flamelink_helpers';
import { DocumentReference } from 'firebase-admin/firestore';
import { ActivitiesService } from '../activities_service';
import { DataService } from '../data_service';
import { ProfileService } from '../profile_service';

export namespace PromoteActivityAction {
    export async function promoteActivity(action: AdminQuickActionJSON): Promise<void> {
        const actionId = FlamelinkHelpers.getFlamelinkIdFromObject(action);
        if (!action || !actionId) {
            functions.logger.error(`No action ID specified`);
            return Promise.resolve();
        }

        const targetActivity = action.data?.find((d: AdminQuickActionDataJSON) => d.target === 'targetActivity') || {};
        const targetPromotion = action.data?.find((d: AdminQuickActionDataJSON) => d.target === 'targetPromotion') || {};
        const promotionTypesData = action.data?.find((d: AdminQuickActionDataJSON) => d.target === 'promotionTypes') || {};

        const targetActivityReference = (targetActivity?.activities?.length ?? 0) > 0 ? targetActivity.activities![0] : null as DocumentReference | null;
        const targetPromotionReference = (targetPromotion?.promotions?.length ?? 0) > 0 ? targetPromotion.promotions![0] : null as DocumentReference | null;
        const targetActivityActualId = targetActivityReference?.id ?? '';
        const targetPromotionActualId = targetPromotionReference?.id ?? '';
        const promotionTypes = promotionTypesData?.promotionTypes ?? [];

        let isFeedPromotion = promotionTypes.includes('promotion_feed');
        const isChatPromotion = promotionTypes.includes('promotion_chat');

        if (!isFeedPromotion && !isChatPromotion) {
            isFeedPromotion = true;
            AdminQuickActionService.appendOutput(action, `No promotion types specified, defaulting to feed promotion.`);
        }

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

        targetActivityData.generalConfiguration ??= {};
        const publisherId = targetActivityData.generalConfiguration.publisherId ?? '';
        const publisherProfile = await ProfileService.getProfile(publisherId);

        if (!publisherProfile || !publisherId) {
            AdminQuickActionService.appendOutput(action, `Invalid publisher profile.`);
            AdminQuickActionService.updateStatus(action, 'error');
            return Promise.resolve();
        }

        const publisherAvailablePromotionCount = publisherProfile.availablePromotionsCount ?? 0;
        const publisherActivePromotionCount = publisherProfile.activePromotionsCount ?? 0;

        if (publisherAvailablePromotionCount <= 0) {
            AdminQuickActionService.appendOutput(action, `Publisher ${publisherId} has no available promotions.`);
            AdminQuickActionService.updateStatus(action, 'error');
            return Promise.resolve();
        }

        // TODO -> Decide what this number is
        if (publisherActivePromotionCount >= 3) {
            AdminQuickActionService.appendOutput(action, `Publisher ${publisherId} has reached the maximum number of active promotions.`);
            AdminQuickActionService.updateStatus(action, 'error');
            return Promise.resolve();
        }

        AdminQuickActionService.appendOutput(action, `Updating tags for promotion types`);
        let currentTags = [...(targetActivityData.enrichmentConfiguration?.tags ?? [])];

        if (isFeedPromotion) {
            AdminQuickActionService.appendOutput(action, `Adding promotion_feed tag`);
            currentTags.push('promotion_feed');
            currentTags.push(`promotion_feed_${publisherId}`);
        }

        if (isChatPromotion) {
            AdminQuickActionService.appendOutput(action, `Adding promotion_chat tag`);
            currentTags.push('promotion_chat');
            currentTags.push(`promotion_chat_${publisherId}`);
        }

        if (!currentTags.includes('promotion')) {
            AdminQuickActionService.appendOutput(action, `Adding promotion tag`);
            currentTags.push('promotion');
            currentTags.push(`promotion_${publisherId}`);
        }

        // Ensure tags are unique
        currentTags = [...new Set(currentTags)];

        targetActivityData.enrichmentConfiguration ??= {};
        targetActivityData.enrichmentConfiguration.tags = currentTags;
        targetActivityData.enrichmentConfiguration.promotionKey = targetPromotionId;
        await targetActivityReference?.update(targetActivityData);
        AdminQuickActionService.appendOutput(action, `Activity ${targetActivityId} promoted with promotion ${targetPromotionId}`);

        AdminQuickActionService.appendOutput(action, `Updating feeds for activity ${targetActivityId}`);
        await ActivitiesService.updateTagFeedsForActivity(targetActivityData);
        
        AdminQuickActionService.appendOutput(action, `Updating publisher ${publisherId} with new promotion counts.`);
        await DataService.updateDocument({
            entryId: publisherId,
            schemaKey: 'users',
            data: {
                availablePromotionsCount: publisherProfile.availablePromotionsCount - 1,
                activePromotionsCount: publisherProfile.activePromotionsCount + 1,
            },
        });

        AdminQuickActionService.updateStatus(action, 'success');
    }
}