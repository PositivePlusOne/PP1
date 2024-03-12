import { ProfileService } from "../services/profile_service";
import { EmailHelpers } from "./email_helpers";

export namespace ProfileHelpers {
  /**
   * helper function to determine if a profile is completed now
   * @param profileUid is the UID of the profile we are checking
   * @param profile is the profile to check
   * @return a boolean to signal if the profile is complete enough to be sending emails
   */
  export async function isProfileComplete(profileUid: string, profile: any): Promise<boolean> {
    // to be safe if the profile is incomplete, let's get it again to have the total picture here
    if (!profile || !profile.email) {
      // just to make this robust - if we don't have enough of a picture of the profile, we will get a better one
      profile = await ProfileService.getProfile(profileUid);
    }

    //!TODO what constitues a completed profile - so we don't send hundreds of emails as they type in each bit for the first time
    //! probably something to do with the color being set - or whatever is the last required thing...
    return profile && profile && profile.accentColor;
  }

  /**
   * helper to send an update email when they change something about the profile
   * @param profileUid is the UID of the profile we are checking
   * @param profile is the profile they just changed
   * @returns promise of true if sent, else false
   */
  export async function sendRequiredAccountUpdateEmail(profileUid: string, profile: any): Promise<boolean> {
    if (!profile || !profile.email) {
      // just to make this robust - if we don't have enough of a picture of the profile, we will get a better one
      profile = ProfileService.getProfile(profileUid);
    }
    if ((await isProfileComplete(profileUid, profile)) && !profile.suppressEmailNotifications) {
      // the new profile is complete - but they just updated it, send an email please
      return EmailHelpers.sendEmail(profile.email, "Positive+1 Account Updated", "Account Updated", "Some details have been updated in your Positive+1 account settings", "", "Return to Positive+1", "https://www.positiveplusone.com");
    } else {
      // return that this failed
      return Promise.resolve(false);
    }
  }
}
