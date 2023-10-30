import * as functions from 'firebase-functions';

import { AdminQuickActionService } from '../admin_quick_action_service';
import { FlamelinkHelpers } from '../../helpers/flamelink_helpers';
import { DataService } from '../data_service';
import { PromotionJSON } from '../../dto/promotions';
import { AdminQuickActionJSON } from '../../dto/admin';
import { PromotionStatisticsService } from '../promotion_statistics_service';
import { StreamHelpers } from '../../helpers/stream_helpers';

export namespace UpdatePromotionMixpanelAnalyticsAction {
    export async function updatePromotionsMixpanelAnalytics(action: AdminQuickActionJSON): Promise<void> {
        const actionId = FlamelinkHelpers.getFlamelinkIdFromObject(action);
        if (!action || !actionId) {
            functions.logger.error(`No action ID specified`);
            return Promise.resolve();
        }

        // Get all promotions from the database.
        AdminQuickActionService.appendOutput(action, `Getting all promotions`);
        const promotions = await DataService.getDocumentWindowRaw({
            schemaKey: 'promotions',
            where: [
                { fieldPath: 'isActive', op: '==', value: true },
            ]
        }) as PromotionJSON[];

        AdminQuickActionService.appendOutput(action, `Updating ${promotions.length} promotions`);
        for (const promotion of promotions) {
            await updatePromotionMixpanelAnalytics(action, promotion);
        }

        AdminQuickActionService.updateStatus(action, 'success');
    }

    export async function updatePromotionMixpanelAnalytics(action: AdminQuickActionJSON, promotion: PromotionJSON): Promise<void> {
        if (!promotion || !promotion._fl_meta_ || !promotion._fl_meta_.fl_id) {
            AdminQuickActionService.appendOutput(action, `Invalid promotion`);
            return Promise.resolve();
        }

        AdminQuickActionService.appendOutput(action, `Updating promotion ${promotion._fl_meta_.fl_id}`);

        const promotionStatistics = await PromotionStatisticsService.getStatisticsForPromotion(promotion._fl_meta_.fl_id);
        if (!promotionStatistics || !promotionStatistics._fl_meta_ || !promotionStatistics._fl_meta_.fl_id) {
            AdminQuickActionService.appendOutput(action, `No promotion statistics found for promotion ${promotion._fl_meta_.fl_id}`);
            return Promise.resolve();
        }

        const counts = promotionStatistics.counts ?? {};

        // Determine the date range to query.
        // const startDateTimestamp = promotionStatistics.lastFetchedFromMixpanel;
        // const startDate = startDateTimestamp ? StreamHelpers.timestampToYYYYMMDD(startDateTimestamp) : StreamHelpers.getCurrentYYYYMMDD();
        // const endDate = StreamHelpers.getCurrentYYYYMMDD();

        let totalViews = promotionStatistics.counts?.total_views ?? 0;

        AdminQuickActionService.appendOutput(action, `Fetching data from Mixpanel for promotion ${promotion._fl_meta_.fl_id}`);

        for (const promotedActivity of promotion.activities ?? []) {
            const activityId = promotedActivity.activityId;
            if (!activityId) {
                continue;
            }

            // TODO: Fetch from Mixpanel.
            // const segmentation = await MixpanelService.fetchMixpanelData('Post Viewed', startDate, endDate, {
            //     'activityId': activityId,
            // });
        }

        // Update the counts for the promotion and update the "lastFetchedFromMixpanel" timestamp.
        counts.total_views = totalViews;
        promotionStatistics.counts = counts;
        promotionStatistics.lastFetchedFromMixpanel = StreamHelpers.getCurrentTimestamp();

        // Update the promotion statistics.
        await DataService.updateDocument({
            schemaKey: 'promotionStatistics',
            entryId: promotionStatistics._fl_meta_.fl_id,
            data: promotionStatistics,
        });

        // Update the total views for the promotion.
        promotion.totalViewsSinceLastUpdate = totalViews;

        // Check totalViewsAllotment and if it is not null and above 0, then set isActive to false if totalViewsSinceLastUpdate is above totalViewsAllotment.
        if (promotion.totalViewsAllotment && promotion.totalViewsAllotment > 0 && promotion.totalViewsSinceLastUpdate && promotion.totalViewsSinceLastUpdate > promotion.totalViewsAllotment) {
            AdminQuickActionService.appendOutput(action, `Promotion ${promotion._fl_meta_.fl_id} has exceeded its total views allotment of ${promotion.totalViewsAllotment}`);
            promotion.isActive = false;
        }

        // Update the promotion with the statistics.
        await DataService.updateDocument({
            schemaKey: 'promotions',
            entryId: promotion._fl_meta_.fl_id,
            data: promotion,
        });

        AdminQuickActionService.appendOutput(action, `Updated promotion ${promotion._fl_meta_.fl_id} with ${totalViews} total views`);
    }
}