import * as functions from 'firebase-functions';
import { AdminQuickActionDataJSON, AdminQuickActionJSON } from "../../dto/admin";
import { AdminQuickActionService } from '../admin_quick_action_service';
import { FlamelinkHelpers } from '../../helpers/flamelink_helpers';
import { DocumentReference } from 'firebase-admin/firestore';
import { ActivitiesService } from '../activities_service';
import { ProfileService } from '../profile_service';
import { DataService } from '../data_service';

export namespace DemoteActivityAction {
    export async function demoteActivity(action: AdminQuickActionJSON): Promise<void> {
        const actionId = FlamelinkHelpers.getFlamelinkIdFromObject(action);
        if (!action || !actionId) {
            functions.logger.error(`No action ID specified`);
            return Promise.resolve();
        }

        const targetActivity = action.data?.find((d: AdminQuickActionDataJSON) => d.target === 'targetActivity') || {};
        const targetActivityReference = (targetActivity?.activities?.length ?? 0) > 0 ? targetActivity.activities![0] : null as DocumentReference | null;
        const targetActivityActualId = targetActivityReference?.id ?? '';

        if (!targetActivityActualId) {
            AdminQuickActionService.appendOutput(action, `Invalid data.`);
            AdminQuickActionService.updateStatus(action, 'error');
            return Promise.resolve();
        }

        const [targetActivitySnapshot] = await Promise.all([
            targetActivity.activities![0].get(),
        ]);

        const targetActivityData = targetActivitySnapshot.data();
        const targetActivityId = FlamelinkHelpers.getFlamelinkIdFromObject(targetActivityData);

        if (!targetActivityId || !targetActivityData) {
            AdminQuickActionService.appendOutput(action, `Invalid data.`);
            AdminQuickActionService.updateStatus(action, 'error');
            return Promise.resolve();
        }

        const publisherId = targetActivityData.generalConfiguration.publisherId ?? '';
        const publisherProfile = await ProfileService.getProfile(publisherId);

        if (!publisherProfile || !publisherId) {
            AdminQuickActionService.appendOutput(action, `Invalid publisher profile.`);
            AdminQuickActionService.updateStatus(action, 'error');
            return Promise.resolve();
        }

        const publisherAvailablePromotionCount = publisherProfile.availablePromotionsCount ?? 0;
        const publisherActivePromotionCount = publisherProfile.activePromotionsCount ?? 0;

        if (publisherActivePromotionCount == 0) {
            AdminQuickActionService.appendOutput(action, `Publisher ${publisherId} has no active promotions.`);
            AdminQuickActionService.updateStatus(action, 'error');
            return Promise.resolve();
        }

        const tags = targetActivityData.enrichmentConfiguration?.tags ?? [];
        const newTags = tags.filter((t: string) => {
            const isPromotionTag = t === 'promotion';
            const isPublisherPromotionTag = t === `promotion_${publisherId}`;
            const isFeedPromotionTag = t === `promotion_feed`;
            const isPublisherFeedPromotionTag = t === `promotion_feed_${publisherId}`;
            const isChatPromotionTag = t === `promotion_chat`;
            const isPublisherChatPromotionTag = t === `promotion_chat_${publisherId}`;
            
            return !(isPromotionTag || isPublisherPromotionTag || isFeedPromotionTag || isPublisherFeedPromotionTag || isChatPromotionTag || isPublisherChatPromotionTag);
        });
        
        targetActivityData.enrichmentConfiguration ??= {};
        targetActivityData.enrichmentConfiguration.tags = newTags;
        targetActivityData.enrichmentConfiguration.promotionKey = "";
        await targetActivityReference?.update(targetActivityData);
        AdminQuickActionService.appendOutput(action, `Activity ${targetActivityId} demoted.`);

        AdminQuickActionService.appendOutput(action, `Updating feeds for activity ${targetActivityId}`);
        await ActivitiesService.updateTagFeedsForActivity(targetActivityData);

        AdminQuickActionService.appendOutput(action, `Updating publisher ${publisherId} profile with ${publisherActivePromotionCount - 1} active promotions and ${publisherAvailablePromotionCount + 1} available promotions.`);
        await DataService.updateDocument({
            entryId: publisherId,
            schemaKey: 'users',
            data: {
                activePromotionsCount: publisherActivePromotionCount - 1,
                availablePromotionsCount: publisherAvailablePromotionCount + 1,
            },
        });

        AdminQuickActionService.updateStatus(action, 'success');
    }
}