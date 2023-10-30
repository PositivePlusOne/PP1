import * as functions from "firebase-functions";

import { PromotionStatisticsJSON, promotionsStatisticsSchemaKey } from "../dto/promotions";

import { DataService } from "./data_service";

export namespace PromotionStatisticsService {

    export function getExpectedKeyFromOptions(promotionId: string): string {
        if (!promotionId) {
            throw new Error(`Invalid user id: ${promotionId} cannot generate expected key.`);
        }

        return `statistics:promotions:${promotionId}`;
    }

    export async function getStatisticsForPromotion(promotionId: string): Promise<PromotionStatisticsJSON> {
        functions.logger.info("Getting Promotion statistics", { promotionId });
        const expectedKey = getExpectedKeyFromOptions(promotionId);

        const baseStats = {
            counts: {},
            promotionId: promotionId,
        } as PromotionStatisticsJSON;
        
        return await DataService.getOrCreateDocument(baseStats, {
            schemaKey: promotionsStatisticsSchemaKey,
            entryId: expectedKey,
        }) as PromotionStatisticsJSON;
    }

    export async function updateCountForPromotion(promotionId: string, kind: string, offset: number): Promise<PromotionStatisticsJSON> {
        functions.logger.info(`Updating count for Promotion`, { promotionId, kind, offset });
        if (!promotionId) {
            functions.logger.error(`Invalid promotion id: ${promotionId}`);
            return {};
        }

        const stats = await getStatisticsForPromotion(promotionId);
        stats.counts ??= {};
        stats.counts[kind] = (stats.counts[kind] ?? 0) + offset;
        functions.logger.info(`Kind: ${kind}, offset: ${offset}, new count: ${stats.counts[kind]}`);

        // This should never happen, but to be safe; lets clamp the value to 0.
        if (stats.counts[kind] < 0) {
            stats.counts[kind] = 0;
        }

        const expectedKey = getExpectedKeyFromOptions(promotionId);
        functions.logger.info(`Updating promotion statistics`, { stats, expectedKey });

        return await DataService.updateDocument({
            schemaKey: promotionsStatisticsSchemaKey,
            entryId: expectedKey,
            data: stats,
        });
    }
}