import * as functions from 'firebase-functions';

import { Timestamp } from 'firebase-admin/firestore';
import { DataService } from './data_service';
import { AdminQuickActionJSON } from '../dto/admin';
import { AdminQuickActionService } from './admin_quick_action_service';
import { PromotionJSON } from '../dto/promotions';
import { StreamHelpers } from '../helpers/stream_helpers';

export namespace PromotionsService {
    export async function getPromotion(entryId: string) {
        return DataService.getDocument({
            schemaKey: 'promotions',
            entryId,
        });
    }

    export async function getPromotions(entryIds: string[]) {
        return DataService.getBatchDocuments({
            schemaKey: 'promotions',
            entryIds,
        });
    }

    export async function getActivePromotionWindow(cursor: string | null): Promise<any[]> {
        return DataService.getDocumentWindowRaw({
            schemaKey: 'promotions',
            startAfter: cursor || undefined,    
            orderBy: [
                { fieldPath: 'seed', directionStr: 'desc' },
            ],
            where: [
                { fieldPath: 'isActive', op: '==', value: true },
            ],
        });
    }

    export async function getOwnedPromotionsForManagedAccounts(members: string[]): Promise<any[]> {
        // If only one member, no need to query as they will not be managing any accounts
        if (!members || members.length < 2) {
            return [];
        }

        return DataService.getDocumentWindowRaw({
            schemaKey: 'promotions',
            where: [
                { fieldPath: 'ownerId', op: 'in', value: members },
            ],
        });
    }

    export async function shufflePromotionSeeds(action: AdminQuickActionJSON): Promise<void> {
        const promotions = await DataService.getDocumentWindowRaw({
            schemaKey: 'promotions',
            where: [
                { fieldPath: 'isActive', op: '==', value: true },
            ],
        });

        AdminQuickActionService.appendOutput(action, `Shuffling ${promotions.length} promotion seeds`);

        functions.logger.log(`Shuffling ${promotions.length} promotion seeds`);
        for (const promotion of promotions) {
            const seed = Math.random();
            await DataService.updateDocument({
                schemaKey: 'promotions',
                entryId: promotion.id,
                data: {
                    seed,
                },
            });
        }

        functions.logger.log(`Shuffled ${promotions.length} promotion seeds`);
    }

    export async function deactiveInactivePromotions(action: AdminQuickActionJSON): Promise<void> {
        const promotions = await DataService.getDocumentWindowRaw({
            schemaKey: 'promotions',
            where: [
                { fieldPath: 'isActive', op: '==', value: true },
            ],
        });

        AdminQuickActionService.appendOutput(action, `Checking ${promotions.length} promotions for inactivity`);
        const currentDateTimeMillis = new Date().getTime();

        for (const promotionRaw of promotions) {
            const promotionObj = promotionRaw as PromotionJSON;
            const promotionId = promotionObj._fl_meta_?.fl_id;
            if (!promotionId) {
                AdminQuickActionService.appendOutput(action, `Promotion ${promotionObj._fl_meta_?.fl_id} has no fl_id`);
                continue;
            }

            const endTimeTimestamp = promotionObj.endDate as Timestamp;
            const endTime = endTimeTimestamp ? StreamHelpers.convertTimestampToUnixNumber(endTimeTimestamp) : 0;
            const active = endTime < currentDateTimeMillis;

            AdminQuickActionService.appendOutput(action, `Promotion ${promotionObj._fl_meta_?.fl_id} is active: ${active} (${endTime} < ${currentDateTimeMillis})`);

            if (!active) {
                AdminQuickActionService.appendOutput(action, `Deactivating promotion ${promotionObj._fl_meta_?.fl_id}`);
                await DataService.updateDocument({
                    schemaKey: 'promotions',
                    entryId: promotionId,
                    data: {
                        active: false,
                    },
                });
            }
        }
    }
}