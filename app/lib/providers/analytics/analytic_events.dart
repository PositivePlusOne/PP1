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
  accountDeletionRequested, // A user has requested their account to be deleted
  accountDeletionCancelled, // A user has cancelled their account deletion
  accountSetup, // A users account has been setup
  accountReported, // A user has reported someones accouny
  profileSetup, // A users profile has been setup
  profileEdited, // A users profile has been edited
  profileBlocked, // A user has blocked another user
  profileUnblocked, // A user has unblocked another user
  profileFollowed, // A user has followed another user
  profileUnfollowed, // A user has unfollowed another user
  profileMuted, // A user has muted another user
  profileUnmuted, // A user has unmuted another user
  profileHidden, // A user has hidden another user
  profileUnhidden, // A user has unhidden another user
  profileConnectionRequestSent, // A user has sent a connection request to another user
  profileConnectionRequestDeclined, // A user has declined a connection request from another user
  profileConnectionRequestAccepted, // A user has accepted a connection request from another user
  profileConnectionRequestCancelled, // A user has cancelled a connection request to another user
  profileDisconnected, // A user has disconnected from another user
  profileViewed, // A user has viewed another users profile
  profileSwitched, // A user has switched to another profile
  postDisplayed, // A post has been displayed to the user
  postCreationStarted, // A user has started creating a post
  postEditStarted, // A user has started editing a post
  postCreated, // A post has been created on the platform
  postEdited, // A post has been edited
  postViewed, // A post has been viewed by the user and is no longer on the screen
  profileViewedFromPost, // A user has viewed another users profile from a post
  profileViewedFromSearch, // A user has viewed another users profile from a search
  postDiscarded, // A user has discarded a post
  postEditDiscarded, // A user has discarded an edit to a post
  postReported, // The user has reported a post
  postDeleted, // A user has deleted a post
  postLiked, // A user has liked a post
  postUnliked, // A user has unliked a post
  postBookmarked, // A user has bookmarked a post
  postUnbookmarked, // A user has unbookmarked a post
  postCommented, // A user has commented on a post
  postCommentDeleted, // A user has deleted a comment on a post
  postSharedExternally, // A user has shared a post externally
  postSharedOnFeed, // A user has shared a post on their feed
  postSharedThroughChat, // A user has shared a post through chat
  postPromotionClicked, // A user has viewed a post promotion
  mentionSelected, // A user has selected a mention
  photoViewed, // A user has viewed a photo
  videoMuted, // A user has muted a video
  videoUnmuted, // A user has unmuted a video
  videoViewed, // A user has viewed a video
  videoViewedWithEngagement, // A user has viewed a video with engagement past the nose (2% or maximum duration if less than 5 seconds) of the video
  videoViewedFully, // A user has viewed a video fully
  chatStarted, // A user has started a chat with another user
  chatViewed, // A user has viewed a chat
  chatMessageSent, // A user has sent a message in a chat
  chatPromotionClicked, // A user has viewed a chat promotion
  tagViewed, // TODO
  tagViewedFromSearch, // TODO
  searchPost, // A user has searched for a post
  searchUser, // A user has searched for a user
  searchTag, // A user has searched for a tag
  openLinkTerms, // A user has been presented with the terms and conditions
  openLinkTickets, // A user has requested to view an events tickets
  securityAlert, // A security related event
  // Custom conversion events
  conversionRegisterFromInterestRegistration, // A user has registered from the interest registration page
  conversionRegisterFromPostComments; // A user has registered from the post comments page

  // Takes the camel case name of the enum and converts it to a string with spaces and capital letters
  String get friendlyName {
    final String name = toString().split('.').last;
    final String splitName = name.replaceAllMapped(RegExp(r'([A-Z])'), (match) => ' ${match.group(0)}').trim();
    return splitName[0].toUpperCase() + splitName.substring(1);
  }
}
