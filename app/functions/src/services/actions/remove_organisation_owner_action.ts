import * as functions from "firebase-functions";
import { AdminQuickActionDataJSON, AdminQuickActionJSON } from "../../dto/admin";
import { AdminQuickActionService } from "../admin_quick_action_service";
import { FlamelinkHelpers } from "../../helpers/flamelink_helpers";
import { DocumentReference } from "firebase-admin/firestore";
import { RelationshipService } from "../relationship_service";

export namespace RemoveOrganisationOwnerAction {
  export async function removeOrganisationOwner(action: AdminQuickActionJSON): Promise<void> {
    const actionId = FlamelinkHelpers.getFlamelinkIdFromObject(action);
    if (!action || !actionId) {
      functions.logger.error(`No action ID specified`);
      return Promise.resolve();
    }

    const targetProfileData = action.data?.find((d: AdminQuickActionDataJSON) => d.target === "targetProfile") || {};
    const targetProfileReference = (targetProfileData?.profiles?.length ?? 0) > 0 ? targetProfileData.profiles![0] : (null as DocumentReference | null);
    const targetProfileActualId = targetProfileReference?.id ?? "";

    if (!targetProfileActualId) {
      AdminQuickActionService.appendOutput(action, `No source or target profile ID specified.`);
      AdminQuickActionService.updateStatus(action, "error");
      return Promise.resolve();
    }

    const [targetProfileSnapshot] = await Promise.all([targetProfileData.profiles![0].get()]);

    const targetProfile = targetProfileSnapshot.data();
    const targetProfileId = FlamelinkHelpers.getFlamelinkIdFromObject(targetProfile);

    if (!targetProfileId || !targetProfile) {
      AdminQuickActionService.appendOutput(action, `target profile specified.`);
      AdminQuickActionService.updateStatus(action, "error");
      return Promise.resolve();
    }

    await RelationshipService.removeOwnership(targetProfile);
    AdminQuickActionService.appendOutput(action, `Successfully updated ownership.`);
    AdminQuickActionService.updateStatus(action, "success");
  }
}
