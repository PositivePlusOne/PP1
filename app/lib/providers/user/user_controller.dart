// Dart imports:
import 'dart:async';

// Package imports:
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_platform/universal_platform.dart';

// Project imports:
import 'package:app/constants/application_constants.dart';
import 'package:app/extensions/user_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/user/get_stream_controller.dart';
import 'package:app/providers/user/mixins/password_auth_handler.dart';
import 'package:app/providers/user/mixins/two_factor_handler.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/organisms/splash/splash_page.dart';
import '../analytics/analytic_events.dart';
import '../analytics/analytics_controller.dart';

part 'user_controller.freezed.dart';
part 'user_controller.g.dart';

@freezed
class UserControllerState with _$UserControllerState {
  const factory UserControllerState({
    required DateTime last2FACheck,
    @Default({}) Map<String, dynamic> currentClaims,
  }) = _UserControllerState;

  factory UserControllerState.initialState() => UserControllerState(
        last2FACheck: DateTime.fromMicrosecondsSinceEpoch(0),
      );
}

enum PositiveAuthProvider {
  email,
  facebook,
  apple,
  google,
}

@Riverpod(keepAlive: true)
class UserController extends _$UserController with TwoFactorHandler, PasswordAuthHandler {
  final StreamController<User?> userChangedController = StreamController<User?>.broadcast();

  StreamSubscription<User?>? userSubscription;

  User? get currentUser => ref.read(firebaseAuthProvider).currentUser;

  bool get isUserLoggedIn => currentUser != null;
  bool get isPasswordProviderLinked => currentUser?.providerData.any((userInfo) => userInfo.providerId == 'password') ?? false;
  // bool get isPhoneProviderLinked => currentUser?.providerData.any((userInfo) => userInfo.providerId == 'phone') ?? false;

  bool get isGoogleProviderLinked => currentUser?.providerData.any((userInfo) => userInfo.providerId == 'google.com') ?? false;
  bool get isFacebookProviderLinked => currentUser?.providerData.any((userInfo) => userInfo.providerId == 'facebook.com') ?? false;
  bool get isAppleProviderLinked => currentUser?.providerData.any((userInfo) => userInfo.providerId == 'apple.com') ?? false;
  bool get isSocialProviderLinked => isGoogleProviderLinked || isFacebookProviderLinked || isAppleProviderLinked;

  bool get hasAllSocialProvidersLinked => isGoogleProviderLinked && isFacebookProviderLinked && isAppleProviderLinked;
  bool get hasAnyProviderLinked => isPasswordProviderLinked || isSocialProviderLinked;
  bool get isSocialProviderLinkedExclusive => isSocialProviderLinked && !isPasswordProviderLinked;

  bool get isMissingEmailProvider => !isPasswordProviderLinked;
  bool get isMissingSocialProvider => !isGoogleProviderLinked || !isFacebookProviderLinked || !isAppleProviderLinked;

  int get providerCount => currentUser?.providerData.length ?? 0;

  UserInfo? get passwordProvider => currentUser?.providerData.firstWhereOrNull((userInfo) => userInfo.providerId == 'password');
  UserInfo? get phoneProvider => currentUser?.providerData.firstWhereOrNull((userInfo) => userInfo.providerId == 'phone');
  UserInfo? get googleProvider => currentUser?.providerData.firstWhereOrNull((userInfo) => userInfo.providerId == 'google.com');
  UserInfo? get facebookProvider => currentUser?.providerData.firstWhereOrNull((userInfo) => userInfo.providerId == 'facebook.com');
  UserInfo? get appleProvider => currentUser?.providerData.firstWhereOrNull((userInfo) => userInfo.providerId == 'apple.com');

  Iterable<UserInfo> get allProviders => currentUser?.providerData ?? [];

  String get nameFromAuthenticationScopes {
    if (googleProvider != null) {
      return googleProvider!.displayName ?? '';
    }

    if (facebookProvider != null) {
      return facebookProvider!.displayName ?? '';
    }

    if (appleProvider != null) {
      return appleProvider!.displayName ?? '';
    }

    return '';
  }

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

    if (user == null) {
      log.d('[UserController] onUserUpdated() user is null');
      state = state.copyWith(currentClaims: {});
      return;
    }

    log.d('Preloading user claims into state');
    try {
      final Map<String, dynamic> claims = await user.getIdTokenResult().then((token) => token.claims ?? {});
      state = state.copyWith(currentClaims: claims);
    } catch (e) {
      log.e('Failed to preload user claims into state');
    }

    log.d('Notifying user changed stream');
    userChangedController.sink.add(user);
  }

  Future<UserCredential?> registerAppleProvider() async {
    final Logger log = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);

    log.d('[UserController] registerAppleProvider()');
    if (isUserLoggedIn) {
      log.d('[UserController] registerAppleProvider() user is already logged in');
      await appRouter.replaceAll([const HomeRoute()]);
      return null;
    }

    // If you're logged in, then you're linking the account and require a 2FA check.
    if (isUserLoggedIn) {
      await perform2FACheck();

      log.i('[UserController] registerAppleProvider() linking provider');
      final User user = firebaseAuth.currentUser!;
      final AppleAuthProvider appleProvider = AppleAuthProvider()..addDefaultScopes();
      final UserCredential creds = await user.linkWithProvider(appleProvider);
      await analyticsController.trackEvent(AnalyticEvents.accountLinkedApple);

      return creds;
    }

    log.i('[UserController] registerAppleProvider() signInWithCredential');
    final AppleAuthProvider appleProvider = AppleAuthProvider()..addDefaultScopes();
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

    return userCredential;
  }

  Future<UserCredential?> registerGoogleProvider() async {
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
      return null;
    }

    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    final AuthCredential googleAuthCredential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    // If logged in, then you're linking the account and require a 2FA check.
    if (isUserLoggedIn) {
      await perform2FACheck();

      log.i('[UserController] registerGoogleProvider() linking provider');
      final User user = firebaseAuth.currentUser!;
      final UserCredential creds = await user.linkWithCredential(googleAuthCredential);
      await analyticsController.trackEvent(AnalyticEvents.accountLinkedGoogle);

      return creds;
    }

    log.i('[UserController] registerGoogleProvider() signInWithCredential');
    final UserCredential userCredential = await firebaseAuth.signInWithCredential(googleAuthCredential);
    if (userCredential.user == null) {
      log.d('[UserController] registerGoogleProvider() userCredential.user is null');
      return null;
    }

    final bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
    log.i('[UserController] registerGoogleProvider() isNewUser: $isNewUser');

    if (isNewUser) {
      await analyticsController.trackEvent(AnalyticEvents.signUpWithGoogle);
    } else {
      await analyticsController.trackEvent(AnalyticEvents.signInWithGoogle);
    }

    return userCredential;
  }

  Future<void> disconnectAuthProvider(UserInfo userInfo, PositiveAuthProvider socialProvider) async {
    final Logger log = ref.read(loggerProvider);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);

    log.d('[UserController] disconnectProvider() provider: ${userInfo.providerId}');
    if (!isUserLoggedIn) {
      log.d('[UserController] disconnectProvider() user is not logged in');
      return;
    }

    await perform2FACheck();

    // If the provider is the last provider, and we are not using password auth
    // Then we must request a email/password login before we can disconnect the provider.
    final bool isLastProvider = providerCount == 1;
    final bool hasPasswordProvider = isPasswordProviderLinked;

    if (isLastProvider && !hasPasswordProvider) {
      log.d('[UserController] disconnectProvider() isLastProvider && !hasPasswordProvider');
      await requestLastProviderPasswordSignIn();

      // If the user still does not have a password provider, then we cannot disconnect the provider.
      if (!isPasswordProviderLinked) {
        log.d('[UserController] disconnectProvider() !isPasswordProviderLinked');
        return;
      }
    }

    log.i('[UserController] disconnectProvider() unlinking provider');
    final User user = firebaseAuth.currentUser!;
    await user.unlink(userInfo.providerId);

    switch (socialProvider) {
      case PositiveAuthProvider.facebook:
        await analyticsController.trackEvent(AnalyticEvents.accountUnlinkedFacebook);
        break;
      case PositiveAuthProvider.apple:
        await analyticsController.trackEvent(AnalyticEvents.accountUnlinkedApple);
        break;
      case PositiveAuthProvider.google:
        await analyticsController.trackEvent(AnalyticEvents.accountUnlinkedGoogle);
        break;
      case PositiveAuthProvider.email:
        await analyticsController.trackEvent(AnalyticEvents.accountUnlinkedEmail);
        break;
    }
  }

  //! This covers an edge case where the user has no password provider, and only a social provider.
  //! If the user requests to remove the social provider, then we must request a password provider to be setup.
  Future<void> requestLastProviderPasswordSignIn() async {
    final Logger log = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    log.i('[UserController] requestLastProviderPasswordSignIn() requesting password sign in');
    await appRouter.push(const AccountSocialDisconnectionRoute());
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

    // await perform2FACheck();

    log.i('[UserController] updatePhoneNumber() updated users phone number');
    analyticsController.trackEvent(AnalyticEvents.accountPhoneNumberUpdated);
  }

  Future<void> signOut({bool shouldNavigate = true}) async {
    final Logger log = ref.read(loggerProvider);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
    final GoogleSignIn googleSignIn = ref.read(googleSignInProvider);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final CacheController cacheController = ref.read(cacheControllerProvider);

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

    cacheController.cacheData.clear();
    log.i('[UserController] signOut() Cleared cache');

    await analyticsController.trackEvent(AnalyticEvents.accountSignOut);

    //? Remove the notifications key, so a new user has the chance to accept them.
    final SharedPreferences sharedPreferences = await ref.read(sharedPreferencesProvider.future);
    await sharedPreferences.remove(kNotificationsAcceptedKey);

    //? Remove the stream token and user id, so we do not receive messages from the previous user.
    await sharedPreferences.remove(GetStreamController.kLastStreamTokenPreferencesKey);
    await sharedPreferences.remove(GetStreamController.kLastStreamUserId);

    if (shouldNavigate) {
      log.d('[UserController] signOut() Navigating to home route');
      await appRouter.replaceAll([SplashRoute(style: SplashStyle.tomorrowStartsNow)]);
    }
  }
}
