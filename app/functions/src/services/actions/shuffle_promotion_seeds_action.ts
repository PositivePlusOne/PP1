import * as functions from "firebase-functions";

import { AdminQuickActionJSON } from "../../dto/admin";
import { AdminQuickActionService } from "../admin_quick_action_service";
import { FlamelinkHelpers } from "../../helpers/flamelink_helpers";
import { PromotionsService } from "../promotions_service";

export namespace ShufflePromotionSeedsAction {
  export async function shufflePromotionSeeds(action: AdminQuickActionJSON): Promise<void> {
    const actionId = FlamelinkHelpers.getFlamelinkIdFromObject(action);
    if (!action || !actionId) {
      functions.logger.error(`No action ID specified`);
      return Promise.resolve();
    }

    AdminQuickActionService.appendOutput(action, `Shuffling promotion seeds.`);
    await PromotionsService.shufflePromotionSeeds(action);

    AdminQuickActionService.appendOutput(action, `Successfully shuffled promotion seeds.`);
    AdminQuickActionService.updateStatus(action, "success");
  }
}
