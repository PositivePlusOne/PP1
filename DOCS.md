# Positive Plus One

Welcome to the Positive Plus One repository.  
This comprehensive guide will help you get started with the project, and provide you with all the information you need to contribute.


## Glossary

- [Running the project locally](#running-the-project-locally)
- [Architecture overview](#architecture-overview)
- [Caching](#caching)
- [Analytics](#analytics)
- [Security](#security)
- [i18n](#i18n)
- [Services overview](#services-overview)
- [Controllers overview](#controllers-overview)
- [Useful commands](#useful-commands)
- [Useful links](#useful-links)
- [FAQ](#faq)


## Running the project locally

This project consists of a Flutter application, and a Firebase backend.  
We utilise Firebase for our database, authentication, and cloud functions.  

When running on a development build, you will be pointed to the development environment.  
When running on a release build, you will be pointed to the production environment.
Optionally there is a staging environment for user acceptance testing.

Before you start running the project, you will need to set up the following:

1. Flutter
2. Firebase CLI
3. NPM
4. FVM

There are a couple of recommendations when it comes to packages you can use.  
Most development in house was done via VSCode, and the following extensions are recommended:

- Dart
- Flutter
- Firebase
- GitLens

When you install Flutter, it is recommended to install it via FVM.  
This will allow you to have multiple versions of Flutter installed, and switch between them easily.
Upgrading Flutter can be done via `fvm flutter upgrade`. This allows us to easily upgrde test and roll back if needed.
All FVM configuration can be found, including what version of Flutter to use, in the `.fvm` file.

Flavors are used to differentiate between the different environments.
These are set up in the `android/app/build.gradle` file and iOS project settings respectively.  
When you run the application, refer to the included .vscode launch.json file for the correct configuration.

A typical command to run the application yourself via the terminal would be:

```bash
fvm flutter run --flavor develop -t lib/main_dev.dart
```


## Architecture overview

The application is a hub and spoke model, with the Flutter application being the hub.
Because Firebase is used, we do not need to worry about the backend, and can focus on the frontend.

The Cloud Firestore database is used to store all data, and Firebase Authentication is used for user management.
We access this database not directly, but via Firebase Cloud Functions.
This allows us to have a serverless backend, and not worry about scaling. And also for security reasons as we can control access to the database.

The application and backend have various third party dependencies which are managed via pubspec.yaml and package.json respectively.
Some important ones which we have enterprise licenses for are:

- GetStream
- OccasionGenius
- GCP (Google Cloud Platform)
- Algolia

We also have a Flamelink CMS.
This CMS allows us to model the data in the database, and have a user friendly interface for non technical users to manage the data.
You still may need to have some technical knowledge to set up the CMS, but it is a lot easier than managing the data directly in the database.

For any API keys or links for third parties. Please refer to the slack channel.

The application is built with a few key principles in mind:

- Separation of concerns
- Testability
- Scalability
- Maintainability

We leverage Riverpod for state management, and Freezed for data classes.
This means you will have to run a `build_runner` command to generate the necessary files.

This command is:

```bash
fvm flutter pub run build_runner watch --delete-conflicting-outputs
```

When building pages, try to remove all logic from the UI, and put it in the viewmodel.
Some pages may share the same viewmodel, and some may have their own.
We can use `flutter_hooks` to manage the lifecycle of the viewmodel.

See an example of use attaching a view model to a page:

```dart
1. Create
@Riverpod(keepAlive: true)
class HomeViewModel extends _$HomeViewModel with LifecycleMixin {
  @override
  HomeViewModelState build() {
    return HomeViewModelState.initialState();
  }
}

2. Use
final HomeViewModel viewModel = ref.read(homeViewModelProvider.notifier);
final HomeViewModelState state = ref.watch(homeViewModelProvider);
```

Testing can then be done by mocking the viewmodel, and testing the UI in isolation.
We use `mockito` for mocking, and `flutter_test` for testing.
However due to the domain of the application, we do not have a lot of unit tests and require more manual testing.

Lastly, naming is important to keep indexing and developer experience high.  
Services are called `controllers` in the application, and in the backend we just call them `services`.  
This allows you to quickly seperate out a service, for example (user_service, user_controller, user_viewmodel)


## Caching

A bit part of how we deal with being a social network is caching.
Both the backend and frontend have caching mechanisms in place to ensure the application is fast and responsive.
The application uses a simple HashMap for caching, and the backend uses Redis.

Consider the following process:

1. User one loads a feed
2. That feed consists of two promotions, 20 posts, 19 users, and 4 relationships
3. The backend will cache all of this data when it is written to the database
4. The backend will also cache the feed itself if it can
5. The frontend will cache the feed, and all the data in the feed
6. But the user only sees 19 posts, due to a relationship block
7. And still be given 20 posts, due to an included promotion

This means there is a process where we `mux` the data from the backend due to the state of the application.
The most complex part of this is the relationships, as we need to ensure we respect the wishes of users who have blocked each other.

This logic is therefore handled both in frontend and backend, and is a complex process to try and ensure we are not showing users content they do not want to see, whilst also being performant.

@see: `payloads.ts` and `cache_controller.dart`
Warning: This is most likely the most complex part of the application, and is the main focus point for any performance improvements and testing.


## Analytics

We use a couple of analytics tools to track the application.

1. Firebase Analytics
2. Mixpanel
3. AppsFlyer

The data for all of these are the same and exist only because product and marketing have different preferences.
The data is sent to all three services, and is used to track user behaviour and app performance.
@see: `analytics_controller.dart`

Users can opt out of this data collection, and we respect their wishes.
All analytics can be seen below:

Note: it is always better to refer to the codebase for the most up to date list of events.

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
```


## Security

Security is a big part of the application, and we take it very seriously.
We have a number of security measures in place to ensure the application is secure.

1. Firebase Authentication
2. Firebase Security Rules
3. Firebase Cloud Functions
4. Firebase Crashlytics
5. A variety of analytics tools
6. FreeRASP (Runtime Application Self Protection)
7. Google Secrets Manager

You may require different IAM roles to access different parts of the application; including configuring yourself as a GCP user.
If elevated access is required, please contact the project team.


User data is protected by a variety of measures, including encryption at rest and in transit.
The main way we protection in place though is through Firebase Cloud Functions.

As we do not allow direct access to the database, all data is accessed via the cloud functions.
This means we can control access to the data, and ensure that only the right people can access the data.
It also means that bad code could cause a data leak.

Please ensure all endpoints in the cloud functions are secure, and only allow access to the right people.
When these are changed, a regression test should be performed to ensure the security of the application.


All API secrets are stored in Google Secrets Manager, and are accessed via the cloud functions.
This means that the secrets are never exposed to the frontend, and are only accessed when needed.
Some API keys are on the frontend, but these are not sensitive and are used for analytics and tracking.

Since some of this config is in secrets manager, and some is in the Firebase environment. Please refer to the slack channel for the most up to date information and access.


## i18n

The application is internationalised, however we only support English at the moment.
Both the backend and frontend have i18n support, and we use the `flutter_localizations` package for the frontend.
The backend gets the users locale from the frontend, and serves the correct data based on this.

You can refer to the following files for the i18n data:

1. `app_en.json`: This is the main file for the application, and contains all the strings used in the application.
2. `en.ts`: This is the main file for the backend, and contains all the strings used in the backend.


## Services overview

The backend consists of a number of services, which are used to manage the data in the database.
Here is a summary of the services:

1. Activities: Manages post data
2. Admin Quick Actions: Performs quick actions for admins
3. Cache: Manages the cache
4. Conversations: Manages chat data
5. Data: Manages the data in the database
6. Events: Manages event data
7. Feed: Manages the feed data
8. Feed Statistics: Manages feed statistics such as views and reactions
9. Localizations: Manages the localisation data (en)
10. Mixpanel: Manages the mixpanel connection
11. Notifications: Manages the notification payloads and FCM tokens
12. Permissions: Manages the permissions for the application
13. Profile: Manages the profile data
14. Promotion Statistics: Manages the promotion statistics
15. Promotions: Manages the promotion data
16. Reactions: Manages the reactions data (likes, comments, shares)
17. Reaction Statistics: Manages the reaction statistics
18. Relationships: Manages the relationship data (follows, blocks, mutes)
19. Search: Manages the search configuration (Algolia)
20. Slack: Manages the slack connection
21. Storage: Manages the storage data (Firebase Storage)
22. System: Manages the system environment
23. Tags: Manages tagged data
24. Users: Manages the user data authentication
25. Venues: Manages the venue data (Deprecated)


## Controllers overview

The frontend consists of a number of controllers, which are used to manage the data in the application.
There are too many to list here, so they're split into categories.

1. Analtyics: Manages the analytics data and connections
2. Content: Manages the content data and connections (posts, promotions)
3. Enrichment: Manages the enrichment data and connections (tags, mentions)
4. Events: Manages the event data and connections
5. Guidance: Manages the guidance data and connections
6. Location: Manages the location data and connections
7. Profiles: Manages the profile data and connections
8. Shared/Common: Various shared entities (deprecated for models)
9. System: Manages the system data and connections
10. Users: Manages the user data and connections

Most of these controllers will use entities injected via GetIt.
You can view these from within the services folder, most are just bootstrapped with the service locator.

For example:

```dart
@Riverpod(keepAlive: true)
FutureOr<FlutterSecureStorage> flutterSecureStorage(FlutterSecureStorageRef ref) async {
  return const FlutterSecureStorage();
}
```

The above code is an example of registration of a Singleton service.
We can then read these using the context in the viewmodel and controllers.

```dart
final FlutterSecureStorage flutterSecureStorage = ref.read(flutterSecureStorageProvider);
```

Async services and Providers are also available, and can be used in the same way.

```dart
final FutureOr<FlutterSecureStorage> flutterSecureStorage = ref.read(flutterSecureStorageProvider.future);
final HomeViewModel viewModel = ref.read(homeViewModelProvider.notifier);
```

## Useful commands

Here are some useful commands to help you get started with the project:

1. Run the following commands to clean up any outstanding lint problems:
   ```bash
   fvm dart run build_runner build --delete-conflicting-outputs
   fvm dart fix --dry-run / --apply
   ```

2. Run the following command to generate the necessary files for Riverpod and Freezed:
   ```bash
    fvm flutter pub run build_runner watch --delete-conflicting-outputs
    ```

3. Run the following command to sort your imports:
   ```bash
   fvm flutter pub run import_sorter:main
   ```

4. Run the following command to generate classes for your assets:
   ```bash
   fvm flutter pub run flutter_launcher_icons:main
   spider build
   ```

## Useful links

Here are some useful links to help you get started with the project:

1. [Flutter](https://flutter.dev/)
2. [Firebase](https://firebase.google.com/)
3. [FVM](https://fvm.app/)
4. [Riverpod](https://riverpod.dev/)
5. [Freezed](https://pub.dev/packages/freezed)
6. [Firebase CLI](https://firebase.google.com/docs/cli)
7. [NPM](https://www.npmjs.com/)
8. [Dart](https://dart.dev/)
9. [Google Secrets Manager](https://cloud.google.com/secret-manager)
10. [Google Cloud Platform](https://cloud.google.com/)
11. [Algolia](https://www.algolia.com/)
12. [GetStream](https://getstream.io/)
13. [OccasionGenius](https://occasiongenius.com/)
14. [Flamelink](https://flamelink.io/)
15. [Mixpanel](https://mixpanel.com/)
16. [AppsFlyer](https://www.appsflyer.com/)

## FAQ

Here are some frequently asked questions to help you get started with the project:

1. What are the image sizes we're using for the application?
   - 128x128
   - 256x256
   - 512x512
   - Original
   
   All images are stored in Firebase Storage, and are served via Firebase Cloud Functions.
   We use an extension to resize the images on the fly, and serve them to the user.

2. How does the user face detection work?
   - We use the Google Vision API to detect faces in images.
   
   The check is used to varify a face is present in the image, and that the face is not obscured.
   We can then use this for user verification, and to ensure the user is who they say they are.

3. How do we manage assets in the Flutter application?
   - We use the `assets` folder in the Flutter project to store all assets.
   
   This includes images, fonts, and other resources.
   We then access these assets via the `AssetImage` class in Flutter.
   You can refer to the spider command in the (#useful-commands) section to generate the necessary files.

4. Do we enforce any coding standards in the project?
   - Yes, we use the `lint` package to enforce coding standards.
   
   This includes formatting, naming conventions, and other best practices.
   You can check the `analysis_options.yaml` file for the rules we enforce.

5. What are promotions and how do they work?
   - Promotions are a way for users to promote their content.
   
   This can be a post, or a simple link to a website.
   If the user requires a post to be promoted, they first need to create a post.
   Else we need a title, description, and a link to the website.
   Post promotions are shown in the feed, and website promotions are shown in the chat.
   We then `mux` the data into the feeds as we always have all promotions in the system on launch.