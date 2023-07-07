// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:universal_platform/universal_platform.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/organisms/splash/splash_page.dart';
import '../analytics/analytic_events.dart';
import '../analytics/analytics_controller.dart';

part 'user_controller.freezed.dart';
part 'user_controller.g.dart';

@freezed
class UserControllerState with _$UserControllerState {
  const factory UserControllerState() = _UserControllerState;
  factory UserControllerState.initialState() => const UserControllerState();
}

enum PositiveSocialProvider {
  facebook,
  apple,
  google,
}

@Riverpod(keepAlive: true)
class UserController extends _$UserController {
  final StreamController<User?> userChangedController = StreamController<User?>.broadcast();

  StreamSubscription<User?>? userSubscription;

  User? get currentUser => ref.read(firebaseAuthProvider).currentUser;

  bool get isUserLoggedIn => currentUser != null;
  bool get isPasswordProviderLinked => currentUser?.providerData.any((userInfo) => userInfo.providerId == 'password') ?? false;
  bool get isPhoneProviderLinked => currentUser?.providerData.any((userInfo) => userInfo.providerId == 'phone') ?? false;

  bool get isGoogleProviderLinked => currentUser?.providerData.any((userInfo) => userInfo.providerId == 'google.com') ?? false;
  bool get isFacebookProviderLinked => currentUser?.providerData.any((userInfo) => userInfo.providerId == 'facebook.com') ?? false;
  bool get isAppleProviderLinked => currentUser?.providerData.any((userInfo) => userInfo.providerId == 'apple.com') ?? false;
  bool get isSocialProviderLinked => isGoogleProviderLinked || isFacebookProviderLinked || isAppleProviderLinked;
  bool get hasAllSocialProvidersLinked => isGoogleProviderLinked && isFacebookProviderLinked && isAppleProviderLinked;

  UserInfo? get googleProvider => currentUser?.providerData.firstWhereOrNull((userInfo) => userInfo.providerId == 'google.com');
  UserInfo? get facebookProvider => currentUser?.providerData.firstWhereOrNull((userInfo) => userInfo.providerId == 'facebook.com');
  UserInfo? get appleProvider => currentUser?.providerData.firstWhereOrNull((userInfo) => userInfo.providerId == 'apple.com');

  @override
  UserControllerState build() {
    return UserControllerState.initialState();
  }

  Future<void> setupListeners() async {
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);

    await userSubscription?.cancel();
    userSubscription = firebaseAuth.authStateChanges().listen(onUserUpdated);

    //* Wait for the first user if one exists
    await firebaseAuth.authStateChanges().first;
  }

  Future<void> forceUserRefresh() async {
    final Logger log = ref.read(loggerProvider);
    final User newUser = ref.read(firebaseAuthProvider).currentUser!;

    log.w('[UserController] forceUserRefresh() - Has an account update been performed?');
    onUserUpdated(newUser);
  }

  Future<void> onUserUpdated(User? user) async {
    final Logger log = ref.read(loggerProvider);
    final Mixpanel mixpanel = await ref.read(mixpanelProvider.future);
    log.d('[UserController] onUserUpdated() user: $user');

    log.d('Resetting mixpanel for new user');
    mixpanel.reset();

    if (user == null) {
      log.d('[UserController] onUserUpdated() user is null');
      return;
    }

    log.d('Identifying mixpanel for new user');
    mixpanel.identify(user.uid);

    log.d('Notifying user changed stream');
    userChangedController.sink.add(user);
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final Logger log = ref.read(loggerProvider);

    log.d('[UserController] loginWithEmailAndPassword()');
    final UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    if (userCredential.user == null) {
      log.e('[UserController] loginWithEmailAndPassword() userCredential.user is null');
      return;
    }

    log.i('[UserController] loginWithEmailAndPassword() userCredential.user: ${userCredential.user}');
    await analyticsController.trackEvent(AnalyticEvents.signInWithEmail);
  }

  Future<void> linkEmailPasswordProvider(String email, String password) async {
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final Logger log = ref.read(loggerProvider);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);

    log.d('[UserController] linkEmailPasswordProvider()');
    if (!isUserLoggedIn) {
      log.d('[UserController] linkEmailPasswordProvider() user is not logged in');
      return;
    }

    final User user = firebaseAuth.currentUser!;
    final AuthCredential emailAuthCredential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );

    log.i('[UserController] linkEmailPasswordProvider() linkWithCredential');

    await user.linkWithCredential(emailAuthCredential);
    await analyticsController.trackEvent(AnalyticEvents.accountLinkedEmail);
  }

  Future<void> registerEmailPasswordProvider(String emailAddress, String password) async {
    final Logger log = ref.read(loggerProvider);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);

    log.d('[UserController] registerEmailPasswordProvider()');
    final UserCredential newUser = await firebaseAuth.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );

    log.i('[UserController] registerEmailPasswordProvider() newUser: $newUser');
    await analyticsController.trackEvent(AnalyticEvents.signUpWithEmail);
  }

  Future<void> updateEmailAddress(String email) async {
    final Logger log = ref.read(loggerProvider);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);

    log.d('[UserController] updateEmailAddress()');
    if (!isUserLoggedIn) {
      log.d('[UserController] updateEmailAddress() user is not logged in');
      return;
    }

    await perform2FACheck();

    await firebaseAuth.currentUser!.updateEmail(email);
    await forceUserRefresh();
    await analyticsController.trackEvent(AnalyticEvents.accountEmailAddressUpdated);
  }

  Future<void> updatePassword(String password) async {
    final Logger log = ref.read(loggerProvider);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);

    log.d('[UserController] updatePassword()');
    if (!isUserLoggedIn) {
      log.d('[UserController] updatePassword() user is not logged in');
      return;
    }

    await perform2FACheck();

    await firebaseAuth.currentUser!.updatePassword(password);
    await forceUserRefresh();
    await analyticsController.trackEvent(AnalyticEvents.accountPasswordUpdated);
  }

  Future<void> registerAppleProvider() async {
    final Logger log = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);

    log.d('[UserController] registerAppleProvider()');
    if (isUserLoggedIn) {
      log.d('[UserController] registerAppleProvider() user is already logged in');
      appRouter.removeWhere((route) => true);
      await appRouter.push(const HomeRoute());
      return;
    }

    // If you're logged in, then you're linking the account and require a 2FA check.
    if (isUserLoggedIn) {
      await perform2FACheck();
    }

    log.i('[UserController] registerAppleProvider() signInWithCredential');
    final AppleAuthProvider appleProvider = AppleAuthProvider();

    //* Apple doesn't include basic scopes so we need to define them.
    appleProvider.addScope('email'); //* Add the email scope to the Apple auth provider
    appleProvider.addScope('name'); //* Add the name scope to the Apple auth provider

    late final UserCredential userCredential;
    if (UniversalPlatform.isWeb) {
      userCredential = await firebaseAuth.signInWithPopup(appleProvider);
    } else {
      userCredential = await firebaseAuth.signInWithProvider(appleProvider);
    }

    final bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
    log.i('[UserController] registerAppleProvider() isNewUser: $isNewUser');

    if (isNewUser) {
      await analyticsController.trackEvent(AnalyticEvents.signUpWithApple);
    } else {
      await analyticsController.trackEvent(AnalyticEvents.signInWithApple);
    }
  }

  Future<void> registerGoogleProvider() async {
    final Logger log = ref.read(loggerProvider);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
    final GoogleSignIn googleSignIn = ref.read(googleSignInProvider);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);

    log.d('[UserController] registerGoogleProvider()');
    if (googleSignIn.currentUser != null) {
      log.d('[UserController] registerGoogleProvider() disconnecting googleSignIn');
      await googleSignIn.disconnect();
    }

    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount == null) {
      log.d('[UserController] registerGoogleProvider() googleSignInAccount is null');
      return;
    }

    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    final AuthCredential googleAuthCredential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    log.i('[UserController] registerGoogleProvider() signInWithCredential');
    final UserCredential userCredential = await firebaseAuth.signInWithCredential(googleAuthCredential);
    if (userCredential.user == null) {
      log.d('[UserController] registerGoogleProvider() userCredential.user is null');
      return;
    }

    final bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
    log.i('[UserController] registerGoogleProvider() isNewUser: $isNewUser');

    if (isNewUser) {
      await analyticsController.trackEvent(AnalyticEvents.signUpWithGoogle);
    } else {
      await analyticsController.trackEvent(AnalyticEvents.signInWithGoogle);
    }
  }

  Future<void> disconnectSocialProvider(UserInfo userInfo, PositiveSocialProvider socialProvider) async {
    final Logger log = ref.read(loggerProvider);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);

    log.d('[UserController] disconnectSocialProvider() provider: ${userInfo.providerId}');
    if (!isUserLoggedIn) {
      log.d('[UserController] disconnectSocialProvider() user is not logged in');
      return;
    }

    await perform2FACheck();

    log.i('[UserController] disconnectSocialProvider() unlinking provider');
    final User user = firebaseAuth.currentUser!;
    await user.unlink(userInfo.providerId);

    switch (socialProvider) {
      case PositiveSocialProvider.facebook:
        await analyticsController.trackEvent(AnalyticEvents.accountUnlinkedFacebook);
        break;
      case PositiveSocialProvider.apple:
        await analyticsController.trackEvent(AnalyticEvents.accountUnlinkedApple);
        break;
      case PositiveSocialProvider.google:
        await analyticsController.trackEvent(AnalyticEvents.accountUnlinkedGoogle);
        break;
    }
  }

  Future<void> updatePhoneNumber(String newPhoneNumber) async {
    final Logger log = ref.read(loggerProvider);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);

    log.d('[UserController] updatePhoneNumber()');
    if (!isUserLoggedIn) {
      log.d('[UserController] updatePhoneNumber() user is not logged in');
      return;
    }

    final User user = firebaseAuth.currentUser!;
    final String? phoneNumber = user.phoneNumber;
    log.d('[UserController] updatePhoneNumber() phoneNumber: $phoneNumber');

    // Check if the phone number is the same as the new phone number.
    if (phoneNumber == newPhoneNumber) {
      log.d('[UserController] updatePhoneNumber() phone number is the same as the new phone number');
      return;
    }

    await perform2FACheck(phoneNumber: newPhoneNumber);

    log.i('[UserController] updatePhoneNumber() updated users phone number');
    analyticsController.trackEvent(AnalyticEvents.accountPhoneNumberUpdated);
  }

  Future<void> perform2FACheck({String? phoneNumber}) async {
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final Logger log = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
    final User user = firebaseAuth.currentUser!;

    // Set the phone number to the user's phone number if it is not provided
    phoneNumber ??= user.phoneNumber;
    if (phoneNumber == null) {
      throw Exception('[UserController] perform2FACheck() phoneNumber is null');
    }

    log.i('[UserController] perform2FACheck()');
    bool isVerified = false;
    await appRouter.push(VerificationDialogRoute(
      phoneNumber: phoneNumber,
      onVerified: () async {
        log.i('[UserController] perform2FACheck() onVerified()');
        isVerified = true;
      },
    ));

    log.d('isVerified: $isVerified');
    if (!isVerified) {
      log.d('Failed to verify phone number');
      await analyticsController.trackEvent(AnalyticEvents.account2FAFailed);
      throw Exception('Failed to verify phone number');
    }

    await analyticsController.trackEvent(AnalyticEvents.account2FASuccess);
  }

  Future<void> signOut({bool shouldNavigate = true}) async {
    final Logger log = ref.read(loggerProvider);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
    final GoogleSignIn googleSignIn = ref.read(googleSignInProvider);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final AppRouter appRouter = ref.read(appRouterProvider);

    log.d('[UserController] signOut()');
    if (!isUserLoggedIn) {
      log.d('[UserController] signOut() user is not logged in');
      return;
    }

    if (googleSignIn.currentUser != null) {
      await googleSignIn.signOut();
      log.i('[UserController] signOut() Signed out of Google');
    }

    await firebaseAuth.signOut();
    log.i('[UserController] signOut() Signed out of Firebase');

    await analyticsController.trackEvent(AnalyticEvents.accountSignOut);

    if (shouldNavigate) {
      log.d('[UserController] signOut() Navigating to home route');
      appRouter.removeWhere((route) => true);
      await appRouter.push(SplashRoute(style: SplashStyle.tomorrowStartsNow));
    }
  }

  Future<void> deleteAccount() async {
    final Logger log = ref.read(loggerProvider);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final AppRouter appRouter = ref.read(appRouterProvider);

    log.d('[UserController] deleteAccount()');
    if (!isUserLoggedIn) {
      log.d('[UserController] deleteAccount() user is not logged in');
      return;
    }

    await firebaseAuth.currentUser?.delete();
    log.i('[UserController] deleteAccount() Deleted user from Firebase');

    await analyticsController.trackEvent(AnalyticEvents.accountDelete);

    appRouter.removeWhere((route) => true);
    await appRouter.push(const HomeRoute());
  }
}
