// Dart imports:
import 'dart:async';

// Package imports:
import 'package:event_bus/event_bus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/services/third_party.dart';
import '../../events/authentication/phone_verification_code_sent_event.dart';
import '../../events/authentication/phone_verification_failed_event.dart';
import '../../events/authentication/phone_verification_timeout_event.dart';
import '../analytics/analytic_events.dart';
import '../analytics/analytics_controller.dart';

part 'user_controller.freezed.dart';
part 'user_controller.g.dart';

@freezed
class UserControllerState with _$UserControllerState {
  const factory UserControllerState({
    User? user,
    int? phoneVerificationResendToken,
    String? phoneVerificationId,
  }) = _UserControllerState;

  factory UserControllerState.initialState() => const UserControllerState();
}

@Riverpod(keepAlive: true)
class UserController extends _$UserController {
  final StreamController<User?> userChangedController = StreamController<User?>.broadcast();

  StreamSubscription<User?>? userSubscription;

  bool get isUserLoggedIn => state.user != null;
  bool get isUserAnonymous => state.user?.isAnonymous ?? false;
  bool get isPasswordProviderLinked => state.user?.providerData.any((userInfo) => userInfo.providerId == 'password') ?? false;
  bool get isPhoneProviderLinked => state.user?.providerData.any((userInfo) => userInfo.providerId == 'phone') ?? false;
  bool get isGoogleProviderLinked => state.user?.providerData.any((userInfo) => userInfo.providerId == 'google.com') ?? false;
  bool get isFacebookProviderLinked => state.user?.providerData.any((userInfo) => userInfo.providerId == 'facebook.com') ?? false;
  bool get isAppleProviderLinked => state.user?.providerData.any((userInfo) => userInfo.providerId == 'apple.com') ?? false;

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

  Future<void> onUserUpdated(User? user) async {
    final Logger log = ref.read(loggerProvider);
    final Mixpanel mixpanel = await ref.read(mixpanelProvider.future);
    log.d('[UserController] onUserUpdated() user: $user');

    log.d('Resetting mixpanel for new user');
    mixpanel.reset();

    if (user == null) {
      state = state.copyWith(user: null);
      return;
    }

    log.d('Identifying mixpanel for new user');
    mixpanel.identify(user.uid);

    state = state.copyWith(user: user);
    userChangedController.sink.add(user);
  }

  Future<void> linkEmailPasswordProvider(String email, String password) async {
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final Logger log = ref.read(loggerProvider);

    log.d('[UserController] linkEmailPasswordProvider()');
    if (!isUserLoggedIn) {
      log.d('[UserController] linkEmailPasswordProvider() user is not logged in');
      return;
    }

    final User user = state.user!;
    final AuthCredential emailAuthCredential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );

    log.i('[UserController] linkEmailPasswordProvider() linkWithCredential');
    final UserCredential newUser = await user.linkWithCredential(emailAuthCredential);
    state = state.copyWith(user: newUser.user);

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
    state = state.copyWith(user: newUser.user);
    await analyticsController.trackEvent(AnalyticEvents.signUpWithEmail);
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
    state = state.copyWith(user: userCredential.user);

    final bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
    log.i('[UserController] registerGoogleProvider() isNewUser: $isNewUser');

    if (isNewUser) {
      await analyticsController.trackEvent(AnalyticEvents.signUpWithGoogle);
    } else {
      await analyticsController.trackEvent(AnalyticEvents.signInWithGoogle);
    }
  }

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    final Logger log = ref.read(loggerProvider);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);

    log.d('[UserController] verifyPhoneNumber() phoneNumber: $phoneNumber');
    if (state.phoneVerificationResendToken == null) {
      log.d('[UserController] verifyPhoneNumber() no resend token, sending new verification code');
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        codeSent: onPhoneVerificationCodeSent,
        codeAutoRetrievalTimeout: onPhoneVerificationCodeTimeout,
        verificationCompleted: onPhoneVerificationComplete,
        verificationFailed: onPhoneVerificationFailed,
      );

      return;
    }

    log.d('[UserController] verifyPhoneNumber() resend token exists, resending verification code');
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      forceResendingToken: state.phoneVerificationResendToken,
      codeSent: onPhoneVerificationCodeSent,
      codeAutoRetrievalTimeout: onPhoneVerificationCodeTimeout,
      verificationCompleted: onPhoneVerificationComplete,
      verificationFailed: onPhoneVerificationFailed,
    );
  }

  Future<void> registerPhoneProvider(String verificationCode) async {
    final Logger log = ref.read(loggerProvider);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);

    log.d('[UserController] registerPhoneProvider()');
    final AuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: state.phoneVerificationId!,
      smsCode: verificationCode,
    );

    log.i('[UserController] registerPhoneProvider() signInWithCredential');
    final UserCredential userCredential = await firebaseAuth.signInWithCredential(phoneAuthCredential);
    state = state.copyWith(user: userCredential.user, phoneVerificationId: null, phoneVerificationResendToken: null);

    final bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
    log.i('[UserController] registerPhoneProvider() isNewUser: $isNewUser');

    if (isNewUser) {
      await analyticsController.trackEvent(AnalyticEvents.signUpWithPhone);
    } else {
      await analyticsController.trackEvent(AnalyticEvents.signInWithPhone);
    }
  }

  Future<void> linkPhoneProvider(String verificationCode) async {
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final Logger log = ref.read(loggerProvider);

    log.d('[UserController] linkPhoneProvider()');
    if (!isUserLoggedIn) {
      log.d('[UserController] linkPhoneProvider() user is not logged in');
      return;
    }

    final AuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
      verificationId: state.phoneVerificationId!,
      smsCode: verificationCode,
    );

    final User user = state.user!;
    final UserCredential newUser = await user.linkWithCredential(phoneAuthCredential);
    log.i('[UserController] linkPhoneProvider() newUser: $newUser');

    state = state.copyWith(user: newUser.user, phoneVerificationId: null, phoneVerificationResendToken: null);
    await analyticsController.trackEvent(AnalyticEvents.accountLinkedPhone);
  }

  Future<void> onPhoneVerificationComplete(PhoneAuthCredential phoneAuthCredential) async {
    final Logger log = ref.read(loggerProvider);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final AppRouter appRouter = ref.read(appRouterProvider);

    log.d('[UserController] onPhoneVerificationComplete()');
    state = state.copyWith(phoneVerificationResendToken: null, phoneVerificationId: null);

    final UserCredential userCredential = await firebaseAuth.signInWithCredential(phoneAuthCredential);
    log.i('[UserController] onPhoneVerificationComplete() userCredential: $userCredential');
    state = state.copyWith(user: userCredential.user);

    final bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
    log.i('[UserController] onPhoneVerificationComplete() isNewUser: $isNewUser');

    if (isNewUser) {
      await analyticsController.trackEvent(AnalyticEvents.signUpWithPhone);
    } else {
      await analyticsController.trackEvent(AnalyticEvents.signInWithPhone);
    }

    // TODO(ryan): Change to use event bus so domain doesn't cross into service layer
    //* Since verification relies on external systems, we need to handle the navigation manually
    appRouter.removeWhere((route) => true);
    appRouter.push(const HomeRoute());
  }

  Future<void> onPhoneVerificationCodeSent(String verificationId, int? forceResendingToken) async {
    final Logger log = ref.read(loggerProvider);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final EventBus eventBus = ref.read(eventBusProvider);

    log.d('[UserController] onPhoneVerificationCodeSent() verificationId: $verificationId, forceResendingToken: $forceResendingToken');
    state = state.copyWith(phoneVerificationResendToken: forceResendingToken, phoneVerificationId: verificationId);
    analyticsController.trackEvent(AnalyticEvents.phoneLoginTokenSent);

    eventBus.fire(PhoneVerificationCodeSentEvent(verificationId, forceResendingToken));
  }

  void onPhoneVerificationCodeTimeout(String verificationId) {
    final Logger log = ref.read(loggerProvider);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final EventBus eventBus = ref.read(eventBusProvider);

    log.d('[UserController] onPhoneVerificationCodeTimeout() verificationId: $verificationId');
    state = state.copyWith(phoneVerificationId: verificationId);
    analyticsController.trackEvent(AnalyticEvents.phoneLoginTokenTimeout);
    eventBus.fire(PhoneVerificationTimeoutEvent(verificationId));
  }

  void onPhoneVerificationFailed(FirebaseAuthException error) {
    final Logger log = ref.read(loggerProvider);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final EventBus eventBus = ref.read(eventBusProvider);

    log.d('[UserController] onPhoneVerificationFailed() error: $error');
    state = state.copyWith(phoneVerificationId: null, phoneVerificationResendToken: null);
    analyticsController.trackEvent(AnalyticEvents.phoneLoginTokenFailed);
    eventBus.fire(PhoneVerificationFailedEvent(error));
  }

  Future<void> signOut({bool shouldNavigate = true}) async {
    final Logger log = ref.read(loggerProvider);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final AppRouter appRouter = ref.read(appRouterProvider);

    log.d('[UserController] signOut()');
    if (!isUserLoggedIn) {
      log.d('[UserController] signOut() user is not logged in');
      return;
    }

    await firebaseAuth.signOut();
    log.i('[UserController] signOut() Signed out of Firebase');

    await analyticsController.trackEvent(AnalyticEvents.accountSignOut);
    state = state.copyWith(user: null);

    if (shouldNavigate) {
      log.d('[UserController] signOut() Navigating to home route');
      appRouter.removeWhere((route) => true);
      await appRouter.push(const HomeRoute());
    }
  }

  Future<void> timeoutSession() async {
    final Logger log = ref.read(loggerProvider);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final AppRouter appRouter = ref.read(appRouterProvider);

    log.d('[UserController] timeoutSession()');
    if (!isUserLoggedIn) {
      return;
    }

    await firebaseAuth.signOut();
    await analyticsController.trackEvent(AnalyticEvents.sessionTimeout);
    state = state.copyWith(user: null);

    appRouter.removeWhere((route) => true);
    await appRouter.push(const HomeRoute());
  }
}
