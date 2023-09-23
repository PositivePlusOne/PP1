import { DataService } from './data_service';

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
}