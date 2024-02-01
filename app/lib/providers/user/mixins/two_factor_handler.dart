// Package imports:
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:universal_platform/universal_platform.dart';

// Project imports:
import 'package:app/extensions/user_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/services/third_party.dart';

mixin TwoFactorHandler on Notifier<UserControllerState> {
  Future<void> perform2FACheck() async {
    final Logger log = ref.read(loggerProvider);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
    final User? user = firebaseAuth.currentUser;

    final String providerId = user?.providerData.firstWhereOrNull((userInfo) => userInfo.providerId.isNotEmpty)?.providerId ?? '';
    log.d('providerId: $providerId');

    switch (providerId) {
      case 'password':
        await performEmail2FACheck(user);
        break;
      case 'google.com':
        await performGoogle2FACheck(user);
        break;
      case 'apple.com':
        await performApple2FACheck(user);
        break;
      default:
        log.d('No 2FA check for providerId: $providerId');
    }

    state = state.copyWith(last2FACheck: DateTime.now());
  }

  Future<void> performEmail2FACheck(User? user) async {
    final Logger log = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    final UserInfo? emailProvider = user?.providerData.firstWhereOrNull((userInfo) => userInfo.providerId == 'password');
    if (emailProvider?.email == null) {
      log.e('[UserController] perform2FACheck() emailProvider is null');
      return;
    }

    log.i('[UserController] perform2FACheck()');
    bool isVerified = false;
    await appRouter.push(VerificationDialogRoute(
      emailAddress: emailProvider!.email!,
      onVerified: () async {
        log.i('[UserController] perform2FACheck() onVerified()');
        isVerified = true;
      },
    ));

    log.d('isVerified: $isVerified');
    if (!isVerified) {
      log.d('Failed to verify phone number');
      throw Exception('Failed to verify phone number');
    }
  }

  Future<void> performGoogle2FACheck(User? user) async {
    final Logger log = ref.read(loggerProvider);
    final GoogleSignIn googleSignIn = ref.read(googleSignInProvider);

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

    await user?.reauthenticateWithCredential(googleAuthCredential);
    state = state.copyWith(last2FACheck: DateTime.now());
  }

  Future<void> performApple2FACheck(User? user) async {
    final Logger log = ref.read(loggerProvider);
    final FirebaseAuth firebaseAuth = ref.read(firebaseAuthProvider);
    log.i('[UserController] registerAppleProvider() signInWithCredential');

    final AppleAuthProvider appleProvider = AppleAuthProvider()..addDefaultScopes();
    late final UserCredential userCredential;
    if (UniversalPlatform.isWeb) {
      userCredential = await firebaseAuth.signInWithPopup(appleProvider);
    } else {
      userCredential = await firebaseAuth.signInWithProvider(appleProvider);
    }

    if (userCredential.user == null) {
      log.d('[UserController] registerAppleProvider() userCredential.user is null');
      return;
    }

    await user?.reauthenticateWithCredential(userCredential.credential!);

    state = state.copyWith(last2FACheck: DateTime.now());
  }
}
