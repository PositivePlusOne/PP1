enum AnalyticEvents {
  signUpWithEmail, // A user has just signed up with their email address
  signUpWithGoogle, // A user has just signed up with Google
  signUpWithFacebook, // A user has just signed up with Facebook
  signUpWithApple, // A user has just signed up with Apple
  signUpWithPhone, // A user has just signed up with their phone number
  signInWithEmail, // A user has just signed in with their email address
  signInWithGoogle, // A user has just signed in with Google
  signInWithFacebook, // A user has just signed in with Facebook
  signInWithApple, // A user has just signed in with Apple
  signInWithPhone, // A user has just signed in with their phone number
  registrationComplete, // A user has completed the registration process
  sessionTimeout, // A user has been signed out for inactivity
  accountLinkedEmail, // An email address has been linked to the users account
  accountLinkedGoogle, // A Google account has been linked to the users account
  accountLinkedFacebook, // A Facebook account has been linked to the users account
  accountLinkedApple, // An Apple account has been linked to the users account
  accountLinkedPhone, // A mobile phone has been linked to the users account
  accountUnlinkedEmail, // An email address has been unlinked to the users account
  accountUnlinkedGoogle, // A Google account has been unlinked to the users account
  accountUnlinkedFacebook, // A Facebook account has been unlinked to the users account
  accountUnlinkedApple, // An Apple account has been unlinked to the users account
  accountUnlinkedPhone, // A mobile phone has been unlinked to the users account
  accountReauthenticated, // A user has reauthenticated to perform a sensitive action
  account2FASuccess, // A user has successfully authenticated with 2FA
  account2FAFailed, // A user has failed to authenticate with 2FA
  accountEmailAddressUpdated, // A users email address has been updated
  accountPasswordUpdated, // A users password has been updated
  accountPasswordForgotten, // A users password has been forgotten
  accountPhoneNumberUpdated, // A users phone number has been updated
  phoneLoginTokenSent, // The user has been sent a phone verification code
  phoneLoginTokenTimeout, // The users phone verification code has been timed out
  phoneLoginTokenVerified, // A users phone verification code has been verified
  phoneLoginTokenFailed, // A users phone verification code is incorrect or has failed
  notificationFcmTokenUpdated, // A users FCM token has been updated
  notificationPreferencesEnabled, // A user has enabled notification preferences inside of the app
  notificationPreferencesDisabled, // A user has disabled notificationPreferences inside of the app
  biometricsPreferencesEnabled, // A users biometric preferences have been set to allow
  biometricsPreferencesDisabled, // A users biometric preferences have been set to block
  screenDisplayed, // A user has been shown a screen on the app
  accountPledgesAccepted, // A user has agreed to the pledge
  accountSignOut, // A user has signed out from the application
  accountDelete, // A user has deleted their account
  accountSetup, // A users account has been setup
  accountReported, // A user has reported someones accouny
  profileSetup, // A users profile has been setup
  profileEdited, // A users profile has been edited
  profileFollowed, // A user has followed another user
  profileConnected, // A user has connected with another user
  postDisplayed, // A post has been displayed to the user
  postShared, // A post has been shared to another user
  postCreated, // A post has been created on the platform
  postEdited, // A post has been edited
  postViewed, // A post has been viewed by the user and is no longer on the screen
  postReported, // The user has reported a post
  postDeleted, // A user has deleted a post
  eventDisplayed, // An event has been displayed to the user
  eventShared, // An event has been shared to another user
  eventCreated, // An event has been created on the platform
  eventEdited, // An event has been edited
  eventViewed, // An event has been viewed by the user and is no longer on the screen
  eventReported, // The user has reported an event
  eventDeleted, // A user has deleted an event
  subscriptionCreated, // A user has created a subscription
  subscriptionEnded, // A user has ended a subscription
  subscriptionRenewed, // A user has renewed a subscription
  purchaseCreated, // A user has created a purchase
  search, // A user has performed a search on the platform
  openLinkTerms, // A user has been presented with the terms and conditions
  openLinkTickets, // A user has requested to view an events tickets
  securityDebuggerDetected,
  securityHookDetected,
  securityRootDetected,
  securityTamperDetected,
  securityUntrustedInstallationDetected,
  securityEmulatorDetected,
  securityDeviceBindingDetected,
  securityUnofficialStoreDetected,
  securitySimulatorDetected,
  securitySignatureDetected,
  securityRuntimeManipulationDetected,
  securityPasscodeDetected,
  securityMissingSecureEnclaveDetected,
  securityJailbreakDetected,
  securityDeviceIdDetected,
  securityDeviceChangeDetected,

  // Custom conversion events
  conversionRegisterFromInterestRegistration,
  conversionRegisterFromPostComments;

  // Takes the camel case name of the enum and converts it to a string with spaces and capital letters
  String get friendlyName {
    final String name = toString().split('.').last;
    final String splitName = name.replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(0)}').trim();
    return splitName[0].toUpperCase() + splitName.substring(1);
  }
}
