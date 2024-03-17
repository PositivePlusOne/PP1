import * as functions from "firebase-functions";
import { AdminQuickActionDataJSON, AdminQuickActionJSON } from "../../dto/admin";
import { AdminQuickActionService } from "../admin_quick_action_service";
import { FlamelinkHelpers } from "../../helpers/flamelink_helpers";
import { DocumentReference } from "firebase-admin/firestore";
import { RelationshipService } from "../relationship_service";

export namespace RemoveOrganisationMemberAction {
  export async function removeOrganisationMember(action: AdminQuickActionJSON): Promise<void> {
    const actionId = FlamelinkHelpers.getFlamelinkIdFromObject(action);
    if (!action || !actionId) {
      functions.logger.error(`No action ID specified`);
      return Promise.resolve();
    }

    const sourceProfileData = action.data?.find((d: AdminQuickActionDataJSON) => d.target === "sourceProfile") || {};
    const targetProfileData = action.data?.find((d: AdminQuickActionDataJSON) => d.target === "targetProfile") || {};
    const sourceProfileReference = (sourceProfileData?.profiles?.length ?? 0) > 0 ? sourceProfileData.profiles![0] : (null as DocumentReference | null);
    const targetProfileReference = (targetProfileData?.profiles?.length ?? 0) > 0 ? targetProfileData.profiles![0] : (null as DocumentReference | null);
    const sourceProfileActualId = sourceProfileReference?.id ?? "";
    const targetProfileActualId = targetProfileReference?.id ?? "";

    if (!sourceProfileActualId || !targetProfileActualId) {
      AdminQuickActionService.appendOutput(action, `No source or target profile ID specified.`);
      AdminQuickActionService.updateStatus(action, "error");
      return Promise.resolve();
    }

    const [sourceProfileSnapshot, targetProfileSnapshot] = await Promise.all([sourceProfileData.profiles![0].get(), targetProfileData.profiles![0].get()]);

    const sourceProfile = sourceProfileSnapshot.data();
    const targetProfile = targetProfileSnapshot.data();
    const sourceProfileId = FlamelinkHelpers.getFlamelinkIdFromObject(sourceProfile);
    const targetProfileId = FlamelinkHelpers.getFlamelinkIdFromObject(targetProfile);

    if (!sourceProfileId || !targetProfileId) {
      AdminQuickActionService.appendOutput(action, `No source or target profile ID specified.`);
      AdminQuickActionService.updateStatus(action, "error");
      return Promise.resolve();
    }

    const relationship = await RelationshipService.getOrCreateRelationship([sourceProfileId, targetProfileId]);
    if (!relationship) {
      AdminQuickActionService.appendOutput(action, `A relationship could not be created.`);
      AdminQuickActionService.updateStatus(action, "error");
      return Promise.resolve();
    }

    // Todo, add a check to make sure the profile can be managed as an organisation}

    await RelationshipService.manageRelationship(sourceProfileId, relationship, false);

    AdminQuickActionService.updateStatus(action, "success");
    AdminQuickActionService.appendOutput(action, `Successfully removed ${targetProfileId} from ${sourceProfileId}`);
  }
}
