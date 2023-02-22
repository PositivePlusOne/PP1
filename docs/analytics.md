# Analytics

Here covers a breakdown of analytics on the system, use this document for a breakdown of what events are collected.

## Revisions:
| Author | Date |
| ----------- | ----------- |
| R.D | 19/02/2023 |

## Before we begin

Each event in the system is prefixed with a class name, in this case that is `AnalyticEvents.`.  
All events will be the camel cased and string interpolated with the above.

## Structure of an event

For those dealing with events for the first time, they're quite simple.  
All events are thrown on the client when a specific event happens. For example authentication (logging in), and posting an article.

Each event will contain a list of properties about the sender. This information is super useful for demographic trends.

## Default properties (Mixpanel)

As we don't write our own analytics solution, the one we have decided to use is Mixpanel.  
With all analytic solutions, they often capture a load of data themselves about our users.

This can be foundhere: https://help.mixpanel.com/hc/en-us/articles/115004613766-Default-Properties-Collected-by-Mixpanel

## Default properties (Positive Plus One)

Sometimes, we will have additional properties which are bound to each event.  
These provide context and can be used to filter based on a variety of properties, such as the user name, display name, gender, and more.

This list is subject to change, based on the state of development.

If the following information is available on the client, then it will be bound to all events unless opted out:

- userId - The current signed in users Firebase Authentication Identifier
- membership - The membership of the user

Most other information can be extrapolated from the user ID and the CMS. Some of the information which could be added include:

- emailAddress
- phoneNumber
- region
- displayName
- medicalDiagnosis
- interests
- sexualPreferences
- birthDate
- joinDate

## Events (Mixpanel)

Events thrown as part of the Mixpanel SDK include the following: https://help.mixpanel.com/hc/en-us/articles/115004596186-Default-Mobile-Events-Collection

## Events (Positive Plus One)

These events are subject our roadmap and are liable to change, but give some indication as to the data we capture on platform.

```dart
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
  sessionTimeout, // A user has been signed out for inactivity
  accountLinkedEmail, // An email address has been linked to the users account
  accountLinkedGoogle, // A Google account has been linked to the users account
  accountLinkedFacebook, // A Facebook account has been linked to the users account
  accountLinkedApple, // An Apple account has been linked to the users account
  accountLinkedPhone, // A mobile phone has been linked to the users account
  phoneLoginTokenSent, // The user has been sent a phone verification code
  phoneLoginTokenTimeout, // The users phone verification code has been timed out
  phoneLoginTokenVerified, // A users phone verification code has been verified
  phoneLoginTokenFailed, // A users phone verification code is incorrect or has failed
  notificationPreferencesEnabled, // A user has enabled notification preferences inside of the app
  notificationPreferencesDisabled, // A user has disabled notificationPreferences inside of the app
  biometricsPreferencesEnabled, // A users biometric preferences have been set to allow
  biometricsPreferencesDisabled, // A users biometric preferences have been set to block
  screenDisplayed, // A user has been shown a screen on the app (See )
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
}

```

# Event properties

These are properties additional to each event which require them for context.

## screenDisplayed

- screenName (The name of the screen being shown - to designs)

## search (all)

- content (The search being performed)

## post (all)

- content (*TBC the content of the message)
- reactionType (message, like, heart, etc)
- threadId (The ID if part of a thread)

## postShared

- sharedWith (The ID of the user it has been shared to)

## postViewed

- time (The time in milliseconds the user has viewed the post for)

## event (all)

- eventId (The ID of the event in question)
- eventType (Vlog, event, etc)

## eventShared

- sharedWith (The ID of the user it has been shared to)

## eventViewed

- time (The time in milliseconds the user has viewed the event for)

## messages (all)

- receiverId (The user ID of the recepient)
- content (*TBC the content of the message)
- messageType (message, image, video, like, heart)
- mediaCount (The amount of media attached to the message if present)
- mediaSize (The total size of the uploaded media if present)
- topics (All hash tags and mentions)

## openLink (all)

- link (The link being opened by the application)
