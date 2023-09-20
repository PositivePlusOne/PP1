// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluent_validation/fluent_validation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/extensions/validator_extensions.dart';
import 'package:app/providers/system/system_controller.dart';
import 'package:app/widgets/atoms/indicators/positive_snackbar.dart';
import 'package:unicons/unicons.dart';
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

    appRouter.removeWhere((route) => true);
    unawaited(appRouter.push(const HomeRoute()));

    return false;
  }

  Future<void> onLoginWithGoogleSelected() async {
    state = state.copyWith(isBusy: true);

    try {
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
      appRouter.removeWhere((route) => true);
      appRouter.push(const HomeRoute());
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onLoginWithAppleSelected() async {
    state = state.copyWith(isBusy: true);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));

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
      appRouter.removeWhere((route) => true);
      appRouter.push(const HomeRoute());
    } catch (e) {
      final SnackBar snackBar = PositiveGenericSnackBar(
        title: "Login Failed",
        icon: UniconsLine.envelope_exclamation,
        backgroundColour: colours.black,
      );

      if (appRouter.navigatorKey.currentContext != null) {
        ScaffoldMessenger.of(appRouter.navigatorKey.currentContext!).showSnackBar(snackBar);
      }
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

  Future<void> onPasswordSubmitted() async {
    final UserController userController = ref.read(userControllerProvider.notifier);
    final SystemController systemController = ref.read(systemControllerProvider.notifier);

    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

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

  Future<void> onPasswordResetSelected(BuildContext context) async {
    final UserController userController = ref.read(userControllerProvider.notifier);
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final String snackbarBody = appLocalizations.page_login_password_forgotten_body;

    state = state.copyWith(isBusy: true);

    try {
      await userController.sendPasswordResetEmail(state.email);
      ScaffoldMessenger.of(context).showSnackBar(PositiveSnackBar(content: Text(snackbarBody)));
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
