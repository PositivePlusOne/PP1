import * as functions from "firebase-functions";

import { DataService } from "./data_service";
import { AdminQuickActionJSON } from "../dto/admin";
import { AdminQuickActionService } from "./admin_quick_action_service";

export namespace PromotionsService {
  export async function getPromotion(entryId: string) {
    return DataService.getDocument({
      schemaKey: "promotions",
      entryId,
    });
  }

  export async function getPromotions(entryIds: string[]) {
    return DataService.getBatchDocuments({
      schemaKey: "promotions",
      entryIds,
    });
  }

  export async function getActivePromotionWindow(cursor: string | null): Promise<any[]> {
    return DataService.getDocumentWindowRaw({
      schemaKey: "promotions",
      startAfter: cursor || undefined,
      orderBy: [{ fieldPath: "seed", directionStr: "desc" }],
    });
  }

  export async function getOwnedPromotionsForManagedAccounts(members: string[]): Promise<any[]> {
    // If only one member, no need to query as they will not be managing any accounts
    if (!members || members.length < 2) {
      return [];
    }

    return DataService.getDocumentWindowRaw({
      schemaKey: "promotions",
      where: [{ fieldPath: "ownerId", op: "in", value: members }],
    });
  }

  export async function shufflePromotionSeeds(action: AdminQuickActionJSON): Promise<void> {
    const promotions = await DataService.getDocumentWindowRaw({
      schemaKey: "promotions",
      where: [{ fieldPath: "isActive", op: "==", value: true }],
    });

    AdminQuickActionService.appendOutput(action, `Shuffling ${promotions.length} promotion seeds`);

    functions.logger.log(`Shuffling ${promotions.length} promotion seeds`);
    for (const promotion of promotions) {
      const seed = Math.random();
      await DataService.updateDocument({
        schemaKey: "promotions",
        entryId: promotion.id,
        data: {
          seed,
        },
      });
    }

    functions.logger.log(`Shuffled ${promotions.length} promotion seeds`);
  }
}
