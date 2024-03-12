import { AdminQuickActionJSON } from "../../dto/admin";
import { AdminQuickActionService } from "../admin_quick_action_service";
import { FlamelinkHelpers } from "../../helpers/flamelink_helpers";
import { ActivitiesService } from "../activities_service";
import { DataService } from "../data_service";
import { EmailHelpers } from "../../helpers/email_helpers";
import { ProfileService } from "../profile_service";
import { ProfileJSON } from "../../dto/profile";

export namespace DeleteMemberAction {
  export async function deletePendingMembers(action: AdminQuickActionJSON): Promise<void> {
    const pendingMembers = await ProfileService.getPendingDeletionProfiles();
    if (!pendingMembers) {
      AdminQuickActionService.appendOutput(action, "No pending members found.");
      AdminQuickActionService.updateStatus(action, "success");
      return;
    }

    AdminQuickActionService.appendOutput(action, `Deleting ${pendingMembers.length} pending members.`);
    for (const pendingMember of pendingMembers) {
      AdminQuickActionService.appendOutput(action, `Deleting pending member ${pendingMember?._fl_meta_?.fl_id}`);
      await deleteMember(action, pendingMember);
    }

    AdminQuickActionService.updateStatus(action, "success");
  }

  export async function deleteMember(action: AdminQuickActionJSON, member: ProfileJSON): Promise<void> {
    const profileId = FlamelinkHelpers.getFlamelinkIdFromObject(member);
    if (!profileId) {
      return;
    }

    // Get all posts from the source profile and delete them.
    const activities = await ActivitiesService.getActivitiesForProfile(profileId);
    AdminQuickActionService.appendOutput(action, `Deleting ${activities.length} activities from profile ${profileId}`);

    for (const activity of activities) {
      const activityId = FlamelinkHelpers.getFlamelinkIdFromObject(activity);
      if (!activityId) {
        continue;
      }

      AdminQuickActionService.appendOutput(action, `Deleting activity ${activityId}`);
      await ActivitiesService.deleteActivity(activityId);
    }

    // Delete the source profile.
    AdminQuickActionService.appendOutput(action, `Deleting profile ${profileId}`);
    await DataService.deleteDocument({
      schemaKey: "users",
      entryId: profileId,
    });

    // and send an email informing them they have requested a deleted profile
    const emailAddress = member.email;
    if (emailAddress) {
      // not suppressing email, send one informing the user they have deleted their profile
      await EmailHelpers.sendEmail(emailAddress, "Positive+1 Account Deleted", "Account Deleted", "We're sorry to see you go, but we've deleted your account as requested.", "", "Return to Positive+1", "https://www.positiveplusone.com");
    }
  }
}
