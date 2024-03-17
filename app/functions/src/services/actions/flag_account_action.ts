import * as functions from "firebase-functions";

import { AdminQuickActionDataJSON, AdminQuickActionJSON } from "../../dto/admin";
import { AdminQuickActionService } from "../admin_quick_action_service";
import { FlamelinkHelpers } from "../../helpers/flamelink_helpers";
import { ProfileService } from "../profile_service";
import { CacheService } from "../cache_service";

export namespace FlagAccountAction {
  export async function flagAccount(action: AdminQuickActionJSON): Promise<void> {
    const actionId = FlamelinkHelpers.getFlamelinkIdFromObject(action);
    if (!action || !actionId) {
      functions.logger.error(`No action ID specified`);
      return Promise.resolve();
    }

    const sourceProfileData = action.data?.find((d: AdminQuickActionDataJSON) => d.target === "sourceProfile") || {};
    const accountFlagData = action.data?.find((d: AdminQuickActionDataJSON) => d.target === "accountFlag");
    const accountFlag = accountFlagData?.accountFlag || "";

    if (!sourceProfileData || !accountFlag) {
      AdminQuickActionService.appendOutput(action, `No source profile or account flag specified.`);
      AdminQuickActionService.updateStatus(action, "error");
      return Promise.resolve();
    }

    const sourceReference = sourceProfileData.profiles![0];
    const [sourceProfileSnapshot] = await Promise.all([sourceReference.get()]);

    const sourceProfile = sourceProfileSnapshot.data();
    const sourceProfileId = FlamelinkHelpers.getFlamelinkIdFromObject(sourceProfile);

    if (!sourceProfileId || !sourceProfile) {
      AdminQuickActionService.appendOutput(action, `No source profile found.`);
      AdminQuickActionService.updateStatus(action, "error");
      return Promise.resolve();
    }

    const currentFlags = sourceProfile.accountFlags || new Set();

    // Check if the flags are already present.
    const flagsPresent = [...currentFlags].filter((flag) => flag === accountFlag);
    if (flagsPresent.length > 0) {
      AdminQuickActionService.appendOutput(action, `The flags are already present.`);
      AdminQuickActionService.updateStatus(action, "success");
      return Promise.resolve();
    }

    const newFlags = [...currentFlags, accountFlag];
    const newUniqueFlags = [...new Set(newFlags)];
    await ProfileService.updateAccountFlags(sourceProfileId, newUniqueFlags);
    AdminQuickActionService.appendOutput(action, `Successfully updated the account flag ${accountFlag} for the profile ${sourceProfileId}.`);

    // Check if we need to do anything else based on the flags that are present.
    switch (accountFlag) {
      case "name_offensive":
        await sourceReference.update({ name: "" });
        await CacheService.deleteFromCache(`profile_${sourceProfileId}`);
        AdminQuickActionService.appendOutput(action, `Removed the name for the profile ${sourceProfileId}.`);
        break;
      case "display_name_offensive":
        await sourceReference.update({ displayName: "" });
        await CacheService.deleteFromCache(`profile_${sourceProfileId}`);
        AdminQuickActionService.appendOutput(action, `Removed the display name for the profile ${sourceProfileId}.`);
        break;
    }

    AdminQuickActionService.updateStatus(action, "success");
  }
}
