// Dart imports:
import 'dart:async';
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluent_validation/fluent_validation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/constants/profile_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/extensions/localization_extensions.dart';
import 'package:app/extensions/validator_extensions.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/system_controller.dart';
import 'package:app/services/api.dart';
import 'package:app/widgets/atoms/indicators/positive_snackbar.dart';
import '../../../../gen/app_router.dart';
import '../../../../providers/user/user_controller.dart';
import '../../../../services/third_party.dart';

part 'login_view_model.freezed.dart';
part 'login_view_model.g.dart';

@freezed
class LoginViewModelState with _$LoginViewModelState {
  const factory LoginViewModelState({
    @Default(false) bool isBusy,
    @Default('') String email,
    @Default('') String password,
    @Default("") String serverError,
  }) = _LoginViewModelState;

  factory LoginViewModelState.initialState() => const LoginViewModelState();
}

class LoginValidator extends AbstractValidator<LoginViewModelState> {
  LoginValidator() {
    ruleFor((e) => e.email, key: 'email').isFormattedEmailAddress();
    ruleFor((e) => e.password, key: 'password').meetsPasswordComplexity();
  }
}

@Riverpod(keepAlive: true)
class LoginViewModel extends _$LoginViewModel {
  final LoginValidator validator = LoginValidator();

  List<ValidationError> get emailValidationResults => validator.validate(state).getErrorList('email');
  bool get isEmailValid => emailValidationResults.isEmpty && !state.isBusy;

  List<ValidationError> get passwordValidationResults => validator.validate(state).getErrorList('password');
  bool get isPasswordValid => passwordValidationResults.isEmpty && !state.isBusy;

  @override
  LoginViewModelState build() {
    return LoginViewModelState.initialState();
  }

  void resetState() {
    final Logger logger = ref.read(loggerProvider);
    logger.i('[LoginViewModel] resetState]');

    state = LoginViewModelState.initialState();
  }

  void updateEmail(String email) {
    final Logger logger = ref.read(loggerProvider);
    logger.i('[LoginViewModel] updateEmail: $email');

    state = state.copyWith(email: email);
  }

  void updatePassword(String password) {
    final Logger logger = ref.read(loggerProvider);
    logger.i('[LoginViewModel] updatePassword: $password');

    state = state.copyWith(password: password);
  }

  Future<bool> onBackSelected() async {
    final AppRouter appRouter = ref.read(appRouterProvider);

    final bool isHomeRoute = appRouter.stack.any((element) => element.name == HomeRoute.name);
    if (isHomeRoute) {
      appRouter.removeLast();
      return true;
    }

    await appRouter.replaceAll([const HomeRoute()]);
    return false;
  }

  Future<void> onAccountRecoverySelected() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    logger.d('onAccountRecoverySelected');
    await appRouter.push(const LoginAccountRecoveryRoute());
  }

  Future<void> onAccountRecoveryShowEmailClientSelected(BuildContext context) async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    logger.d('onAccountRecoveryShowEmailClientSelected');
    if (Platform.isAndroid) {
      // use the android intent to open email
      AndroidIntent intent = const AndroidIntent(
        action: 'android.intent.action.MAIN',
        category: 'android.intent.category.APP_EMAIL',
        // opening as a new task (app) so we can go back to the email password login on their return
        flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
      );
      // show the android email client
      await intent.launch().then((value) {
        // back from showing the email client, go back to entering your password
        logger.d('and we are back from visiting the email client in android');
        // pop until the name of the page is as expected (checking if data is null because then that's an unknown page - stop!)
        appRouter.popUntil((route) => route.data == null || route.data?.name == LoginPasswordRoute.name);
      }).catchError((e) {
        logger.e('failed to launch the android email client', error: e);
      });
    } else if (Platform.isIOS) {
      // try to compose a message in iOS and it should show the default email client
      await launchUrl(Uri.parse("message://")).then((value) {
        // back from showing the email client, go back to entering your password
        logger.d('and we are back from visiting the email client in iOS');
        // pop until the name of the page is as expected (checking if data is null because then that's an unknown page - stop!)
        appRouter.popUntil((route) => route.data == null || route.data?.name == LoginPasswordRoute.name);
      }).catchError((e) {
        logger.e('failed to launch the iOS email client', error: e);
      });
    } else {
      logger.e('no email client on this platform supported');
      final PositiveErrorSnackBar snackbar = PositiveErrorSnackBar(text: appLocalizations.page_registration_forgotten_password_recovery_noemailclient);
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Future<void> onLoginWithGoogleSelected() async {
    state = state.copyWith(isBusy: true);

    try {
      final Logger logger = ref.read(loggerProvider);
      final UserController userController = ref.read(userControllerProvider.notifier);
      final SystemController systemController = ref.read(systemControllerProvider.notifier);
      final AppRouter appRouter = ref.read(appRouterProvider);

      final UserCredential? credential = await userController.registerGoogleProvider();
      if (credential == null) {
        state = state.copyWith(isBusy: false);
        return;
      }

      await systemController.updateSystemConfiguration();
      state = state.copyWith(isBusy: false);

      final bool isNewUser = credential.additionalUserInfo?.isNewUser ?? false;
      if (isNewUser) {
        logger.d('New user, redirecting to registration');
        await appRouter.replaceAll([const RegistrationAccountSetupRoute()]);
        return;
      } else {
        await appRouter.replaceAll([const HomeRoute()]);
      }
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onLoginWithAppleSelected() async {
    state = state.copyWith(isBusy: true);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    try {
      final UserController userController = ref.read(userControllerProvider.notifier);
      final SystemController systemController = ref.read(systemControllerProvider.notifier);

      final UserCredential? credential = await userController.registerAppleProvider();
      if (credential == null) {
        state = state.copyWith(isBusy: false);
        return;
      }

      await systemController.updateSystemConfiguration();
      state = state.copyWith(isBusy: false);

      final bool isNewUser = credential.additionalUserInfo?.isNewUser ?? false;
      if (isNewUser) {
        logger.d('New user, redirecting to registration');
        await appRouter.replaceAll([const RegistrationAccountSetupRoute()]);
        return;
      } else {
        await appRouter.replaceAll([const HomeRoute()]);
      }
    } catch (e) {
      // when the login doesn't work - we are happy it just closing
      logger.e('login canceled / failed', error: e);
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onEmailSubmitted(BuildContext context) async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    // Unfocus any existing focus
    final FocusNode? focusChild = FocusManager.instance.primaryFocus;
    if (focusChild != null) {
      focusChild.unfocus();
      await Future<void>.delayed(kAnimationDurationFast);
    }

    logger.d('onLoginWithEmailSelected: ${state.email}');
    updatePassword('');

    logger.d('Waiting for native animations to complete');
    await Future.delayed(kAnimationDurationRegular);

    if (!isEmailValid) {
      logger.d('Invalid email address');
      return;
    }

    await appRouter.push(const LoginPasswordRoute());
  }

  Future<void> onPasswordSubmitted(BuildContext context) async {
    final UserController userController = ref.read(userControllerProvider.notifier);
    final SystemController systemController = ref.read(systemControllerProvider.notifier);
    final AppLocalizations localisations = AppLocalizations.of(context)!;

    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    state = state.copyWith(serverError: "");

    if (!isPasswordValid) {
      logger.d('Invalid password');
      return;
    }

    try {
      state = state.copyWith(isBusy: true);

      final UserCredential? credential = await userController.loginWithEmailAndPassword(state.email, state.password);
      if (credential == null) {
        state = state.copyWith(isBusy: false);
        return;
      }

      await systemController.updateSystemConfiguration();
      state = state.copyWith(isBusy: false);
      appRouter.removeWhere((route) => true);
      appRouter.push(const HomeRoute());
    } catch (e) {
      if (e is FirebaseAuthException && (e.code == 'wrong-password' || e.code == 'user-not-found')) {
        state = state.copyWith(serverError: localisations.page_login_password_error);
      }
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onSignUpRequested(Type type) async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    if (type is RegistrationAccountRoute) {
      logger.d('onSignUpRequested: RegistrationAccountRoute');
      appRouter.removeLast();
      return;
    }

    await appRouter.push(const RegistrationAccountRoute());
  }

  Future<void> onAccountDeleteOptionSelected() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);
    final ProfileApiService profileApiService = await ref.read(profileApiServiceProvider.future);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);

    logger.d('onAccountDeleteSelected');

    state = state.copyWith(isBusy: true);

    try {
      logger.i('Deleting profile');

      final Profile? profile = profileController.currentProfile;
      final String profileId = profile?.flMeta?.id ?? '';
      if (profileId.isEmpty || profile == null) {
        logger.e('No profile found');
        return;
      }

      final Set<String> accountFlags = profile.accountFlags;
      if (accountFlags.contains(kFeatureFlagPendingDeletion)) {
        logger.i('Profile already pending deletion');
        return;
      }

      await profileApiService.toggleProfileDeletion(uid: profileId);
      appRouter.popUntil((route) => route.settings.name == AccountDetailsRoute.name);
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onPasswordResetOptionSelected() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    logger.d('onPasswordResetSelected');
    await appRouter.push(const ForgottenPasswordRoute());
  }

  Future<void> onPasswordResetSelected(BuildContext context) async {
    final AppRouter appRouter = ref.read(appRouterProvider);

    state = state.copyWith(isBusy: true);

    try {
      // send the email
      //await userController.sendPasswordResetEmail(state.email);
      // and show the page to inform the user this has worked
      await appRouter.push(const ForgottenPasswordRecoveryRoute());
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onWelcomeBackContinueSelected() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    logger.d('onWelcomeBackContinueSelected');
    appRouter.removeWhere((route) => true);
    await appRouter.push(const HomeRoute());
  }
}
