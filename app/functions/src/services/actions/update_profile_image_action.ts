import * as functions from "firebase-functions";

import { AdminQuickActionDataJSON, AdminQuickActionJSON } from "../../dto/admin";
import { AdminQuickActionService } from "../admin_quick_action_service";
import { FlamelinkHelpers } from "../../helpers/flamelink_helpers";
import { ProfileService } from "../profile_service";
import { SystemService } from "../system_service";
import { MediaJSON } from "../../dto/media";
import { StorageService } from "../storage_service";

export namespace UpdateProfileImageAction {
  export async function updateProfileImage(action: AdminQuickActionJSON): Promise<void> {
    const actionId = FlamelinkHelpers.getFlamelinkIdFromObject(action);
    if (!action || !actionId) {
      functions.logger.error(`No action ID specified`);
      return Promise.resolve();
    }

    const sourceProfileData = action.data?.find((d: AdminQuickActionDataJSON) => d.target === "sourceProfile") || {};
    const profileImageUrlData = action.data?.find((d: AdminQuickActionDataJSON) => d.target === "url");
    const profileImageUrl = profileImageUrlData?.url || "";

    if (!sourceProfileData || !profileImageUrl) {
      AdminQuickActionService.appendOutput(action, `No source profile or cover image URL specified.`);
      AdminQuickActionService.updateStatus(action, "error");
      return Promise.resolve();
    }

    const sourceReference = sourceProfileData.profiles![0];
    const [sourceProfileSnapshot, profileImageBytes] = await Promise.all([sourceReference.get(), SystemService.getBytesFromUrl(profileImageUrl)]);

    const sourceProfile = sourceProfileSnapshot.data();
    const sourceProfileId = FlamelinkHelpers.getFlamelinkIdFromObject(sourceProfile);

    if (!sourceProfileId || !sourceProfile) {
      AdminQuickActionService.appendOutput(action, `No source profile found.`);
      AdminQuickActionService.updateStatus(action, "error");
      return Promise.resolve();
    }

    if (!profileImageBytes) {
      AdminQuickActionService.appendOutput(action, `No profile image bytes found. URL: ${profileImageUrl}`);
      AdminQuickActionService.updateStatus(action, "error");
      return Promise.resolve();
    }

    const media = sourceProfile.media || [];
    const profileImage = media.find((m: MediaJSON) => m.bucketPath?.includes("/profile") || false) as MediaJSON;
    AdminQuickActionService.appendOutput(action, `Attempting to update profile image for profile ${sourceProfileId}. Current profile image: ${profileImage ? profileImage : "none"}.`);

    if (profileImage) {
      AdminQuickActionService.appendOutput(action, `Profile image already exists, deleting.`);
      await ProfileService.removeMedia(sourceProfile, [profileImage]);
    }

    AdminQuickActionService.appendOutput(action, `Creating profile image.`);
    const mime = StorageService.getMimeTypeFromBytes(profileImageBytes) || "application/octet-stream";
    AdminQuickActionService.appendOutput(action, `Profile image mime: ${mime}`);

    const ext = StorageService.getExtensionFromMime(mime) || "bin";
    AdminQuickActionService.appendOutput(action, `Profile image extension: ${ext}`);

    const fileName = `profile.${ext}`;
    const newProfileImage = await ProfileService.createMediaFromBytes(sourceProfile, profileImageBytes, "gallery", fileName, mime);

    AdminQuickActionService.appendOutput(action, `Updating source profile.`);
    await ProfileService.addMedia(sourceProfile, [newProfileImage]);

    AdminQuickActionService.updateStatus(action, "success");
  }
}
