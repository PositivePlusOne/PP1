// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/providers/analytics/analytic_events.dart';
import 'package:app/providers/analytics/analytics_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/services/third_party.dart';

mixin PasswordAuthHandler on Notifier<UserControllerState> {
  Future<void> linkEmailPasswordProvider(String email, String password) async {
    final bool isUserLoggedIn = ref.read(userControllerProvider.notifier).isUserLoggedIn;
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

  Future<UserCredential?> loginWithEmailAndPassword(String email, String password) async {
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final Logger log = ref.read(loggerProvider);

    log.d('[UserController] loginWithEmailAndPassword()');
    final UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    if (userCredential.user == null) {
      log.e('[UserController] loginWithEmailAndPassword() userCredential.user is null');
      return null;
    }

    log.i('[UserController] loginWithEmailAndPassword() userCredential.user: ${userCredential.user}');
    await analyticsController.trackEvent(AnalyticEvents.signInWithEmail);
    return userCredential;
  }

  Future<void> sendPasswordResetEmail(String email) async {
    final Logger log = ref.read(loggerProvider);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);

    log.d('[UserController] sendPasswordResetEmail()');
    await firebaseAuth.sendPasswordResetEmail(email: email);
    await analyticsController.trackEvent(AnalyticEvents.accountPasswordForgotten);
  }

  Future<bool> confirmPassword(String password) async {
    final bool isUserLoggedIn = ref.read(userControllerProvider.notifier).isUserLoggedIn;
    final Logger log = ref.read(loggerProvider);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);

    log.d('[UserController] confirmPassword()');
    if (!isUserLoggedIn) {
      log.d('[UserController] confirmPassword() user is not logged in');
      return false;
    }

    final User user = firebaseAuth.currentUser!;
    final AuthCredential emailAuthCredential = EmailAuthProvider.credential(
      email: user.email!,
      password: password,
    );

    log.i('[UserController] confirmPassword() reauthenticateWithCredential');
    await user.reauthenticateWithCredential(emailAuthCredential);
    await analyticsController.trackEvent(AnalyticEvents.account2FASuccess);
    // this throws an exception when it doesn't work - so this is good here
    return true;
  }

  Future<void> updateEmailAddress(String email) async {
    final UserController userController = ref.read(userControllerProvider.notifier);
    final Logger log = ref.read(loggerProvider);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);

    log.d('[UserController] updateEmailAddress()');
    if (!userController.isUserLoggedIn) {
      log.d('[UserController] updateEmailAddress() user is not logged in');
      return;
    }

    await userController.perform2FACheck();

    await firebaseAuth.currentUser!.updateEmail(email);
    await userController.forceUserRefresh();

    await analyticsController.trackEvent(AnalyticEvents.accountEmailAddressUpdated);
  }

  Future<void> updatePassword(String password) async {
    final UserController userController = ref.read(userControllerProvider.notifier);
    final Logger log = ref.read(loggerProvider);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);

    log.d('[UserController] updatePassword()');
    if (!userController.isUserLoggedIn) {
      log.d('[UserController] updatePassword() user is not logged in');
      return;
    }

    await userController.perform2FACheck();

    await firebaseAuth.currentUser!.updatePassword(password);
    await userController.forceUserRefresh();

    await analyticsController.trackEvent(AnalyticEvents.accountPasswordUpdated);
  }
}
