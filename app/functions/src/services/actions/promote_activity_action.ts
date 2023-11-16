import * as functions from 'firebase-functions';
import { AdminQuickActionDataJSON, AdminQuickActionJSON } from "../../dto/admin";
import { AdminQuickActionService } from '../admin_quick_action_service';
import { FlamelinkHelpers } from '../../helpers/flamelink_helpers';
import { DocumentReference } from 'firebase-admin/firestore';
import { ActivitiesService } from '../activities_service';
import { DataService } from '../data_service';
import { ProfileService } from '../profile_service';
import { ActivityJSON } from '../../dto/activities';
import { PromotionJSON } from '../../dto/promotions';
import { ProfileJSON } from '../../dto/profile';

export namespace PromoteActivityAction {
    export async function promoteActivity(action: AdminQuickActionJSON): Promise<void> {
        const actionId = FlamelinkHelpers.getFlamelinkIdFromObject(action);
        if (!action || !actionId) {
            functions.logger.error(`No action ID specified`);
            return Promise.resolve();
        }

        const sourceProfile = action.data?.find((d: AdminQuickActionDataJSON) => d.target === 'sourceProfile') || {};
        const targetActivity = action.data?.find((d: AdminQuickActionDataJSON) => d.target === 'targetActivity') || {};
        const targetPromotion = action.data?.find((d: AdminQuickActionDataJSON) => d.target === 'targetPromotion') || {};
        const promotionTypesData = action.data?.find((d: AdminQuickActionDataJSON) => d.target === 'promotionTypes') || {};

        const sourceProfileReference = (sourceProfile?.profiles?.length ?? 0) > 0 ? sourceProfile.profiles![0] : null as DocumentReference | null;
        const targetActivityReference = (targetActivity?.activities?.length ?? 0) > 0 ? targetActivity.activities![0] : null as DocumentReference | null;
        const targetPromotionReference = (targetPromotion?.promotions?.length ?? 0) > 0 ? targetPromotion.promotions![0] : null as DocumentReference | null;
        const sourceProfileActualId = sourceProfileReference?.id ?? '';
        const targetActivityActualId = targetActivityReference?.id ?? '';
        const targetPromotionActualId = targetPromotionReference?.id ?? '';
        const promotionTypes = promotionTypesData?.promotionTypes ?? [];

        let isFeedPromotion = promotionTypes.includes('promotion_feed');
        const isChatPromotion = promotionTypes.includes('promotion_chat');

        if (!isFeedPromotion && !isChatPromotion) {
            isFeedPromotion = true;
            AdminQuickActionService.appendOutput(action, `No promotion types specified, defaulting to feed promotion.`);
        }

        if (!sourceProfileActualId || !targetActivityActualId || !targetPromotionActualId) {
            AdminQuickActionService.appendOutput(action, `Invalid data.`);
            AdminQuickActionService.updateStatus(action, 'error');
            return Promise.resolve();
        }

        const [sourceProfileSnapshot, targetActivitySnapshot, targetPromotionSnapshot] = await Promise.all([
            sourceProfile.profiles![0].get(),
            targetActivity.activities![0].get(),
            targetPromotion.promotions![0].get(),
        ]);

        AdminQuickActionService.appendOutput(action, `Promoting activity ${targetActivityActualId} with promotion ${targetPromotionActualId}`);

        const sourceProfileData = sourceProfileSnapshot.data() as ProfileJSON;
        const targetActivityData = targetActivitySnapshot.data() as ActivityJSON;
        const targetPromotionData = targetPromotionSnapshot.data() as PromotionJSON;

        if (!sourceProfileData || !targetActivityData || !targetPromotionData) {
            AdminQuickActionService.appendOutput(action, `Unable to load profile, activity or promotion.`);
            AdminQuickActionService.updateStatus(action, 'error');
            return Promise.resolve();
        }

        const currentPromotionKey = targetActivityData.enrichmentConfiguration?.promotionKey ?? '';
        if (currentPromotionKey) {
            AdminQuickActionService.appendOutput(action, `Activity ${targetActivityActualId} already has a promotion key.`);
            AdminQuickActionService.updateStatus(action, 'error');
            return Promise.resolve();
        }

        targetActivityData.generalConfiguration ??= {};
        const publisherId = targetActivityData.publisherInformation?.publisherId ?? '';
        const publisherProfile = await ProfileService.getProfile(publisherId) as ProfileJSON;

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
        targetActivityData.enrichmentConfiguration.promotionKey = targetPromotionActualId;

        await targetActivityReference?.update({
            enrichmentConfiguration: targetActivityData.enrichmentConfiguration,
        });

        // Update the relevent information in the promotion and mark it as active
        targetPromotionData.activityId = targetActivityActualId;
        targetPromotionData.ownerId = publisherId;
        targetPromotionData.isActive = true;
        
        AdminQuickActionService.appendOutput(action, `Activity ${targetActivityActualId} promoted with promotion ${targetPromotionActualId}`);
        await ActivitiesService.updateTagFeedsForActivity(targetActivityData);
        AdminQuickActionService.appendOutput(action, `Updated feeds for activity ${targetActivityActualId}`);

        let newAvailablePromotionsCount = publisherAvailablePromotionCount - 1;
        let newActivePromotionsCount = publisherActivePromotionCount + 1;

        // Clamp values
        if (newAvailablePromotionsCount < 0) {
            newAvailablePromotionsCount = 0;
        }

        if (newActivePromotionsCount < 0) {
            newActivePromotionsCount = 0;
        }
        
        await DataService.updateDocument({
            entryId: publisherId,
            schemaKey: 'users',
            data: {
                availablePromotionsCount: newAvailablePromotionsCount,
                activePromotionsCount: newActivePromotionsCount,
            },
        });
        
        AdminQuickActionService.appendOutput(action, `Updated publisher ${publisherId} with new promotion counts.`);
        AdminQuickActionService.updateStatus(action, 'success');
    }
}