import * as functions from "firebase-functions";

import { AdminQuickActionDataJSON, AdminQuickActionJSON } from "../../dto/admin";
import { AdminQuickActionService } from "../admin_quick_action_service";
import { FlamelinkHelpers } from "../../helpers/flamelink_helpers";
import { ProfileService } from "../profile_service";
import { SystemService } from "../system_service";
import { MediaJSON } from "../../dto/media";
import { StorageService } from "../storage_service";

export namespace UpdateCoverImageAction {
  export async function updateCoverImage(action: AdminQuickActionJSON): Promise<void> {
    const actionId = FlamelinkHelpers.getFlamelinkIdFromObject(action);
    if (!action || !actionId) {
      functions.logger.error(`No action ID specified`);
      return Promise.resolve();
    }

    const sourceProfileData = action.data?.find((d: AdminQuickActionDataJSON) => d.target === "sourceProfile") || {};
    const coverImageUrlData = action.data?.find((d: AdminQuickActionDataJSON) => d.target === "url");
    const coverImageUrl = coverImageUrlData?.url || "";

    if (!sourceProfileData || !coverImageUrl) {
      AdminQuickActionService.appendOutput(action, `No source profile or cover image URL specified.`);
      AdminQuickActionService.updateStatus(action, "error");
      return Promise.resolve();
    }

    const sourceReference = sourceProfileData.profiles![0];
    const [sourceProfileSnapshot, coverImageBytes] = await Promise.all([sourceReference.get(), SystemService.getBytesFromUrl(coverImageUrl)]);

    const sourceProfile = sourceProfileSnapshot.data();
    const sourceProfileId = FlamelinkHelpers.getFlamelinkIdFromObject(sourceProfile);

    if (!sourceProfileId || !sourceProfile) {
      AdminQuickActionService.appendOutput(action, `No source profile found.`);
      AdminQuickActionService.updateStatus(action, "error");
      return Promise.resolve();
    }

    if (!coverImageBytes) {
      AdminQuickActionService.appendOutput(action, `No cover image bytes found. URL: ${coverImageUrl}`);
      AdminQuickActionService.updateStatus(action, "error");
      return Promise.resolve();
    }

    const media = sourceProfile.media || [];
    const coverImage = media.find((m: MediaJSON) => m.bucketPath?.includes("/cover") || false) as MediaJSON;
    AdminQuickActionService.appendOutput(action, `Attempting to update cover image for profile ${sourceProfileId}. Current cover image: ${coverImage ? coverImage : "none"}.`);

    if (coverImage) {
      AdminQuickActionService.appendOutput(action, `Cover image already exists, deleting.`);
      await ProfileService.removeMedia(sourceProfile, [coverImage]);
    }

    AdminQuickActionService.appendOutput(action, `Creating cover image.`);
    const mime = StorageService.getMimeTypeFromBytes(coverImageBytes) || "application/octet-stream";
    AdminQuickActionService.appendOutput(action, `Cover image mime: ${mime}`);

    const ext = StorageService.getExtensionFromMime(mime) || "bin";
    AdminQuickActionService.appendOutput(action, `Cover image extension: ${ext}`);

    const fileName = `cover.${ext}`;
    const newCoverImage = await ProfileService.createMediaFromBytes(sourceProfile, coverImageBytes, "public", fileName, mime);

    AdminQuickActionService.appendOutput(action, `Updating source profile.`);
    await ProfileService.addMedia(sourceProfile, [newCoverImage]);

    AdminQuickActionService.updateStatus(action, "success");
  }
}
