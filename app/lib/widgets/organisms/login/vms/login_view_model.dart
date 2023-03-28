// Dart imports:
import 'dart:async';

// Package imports:
import 'package:fluent_validation/fluent_validation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/extensions/validator_extensions.dart';
import '../../../../extensions/future_extensions.dart';
import '../../../../gen/app_router.dart';
import '../../../../providers/user/profile_controller.dart';
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
    ruleFor((e) => e.email, key: 'email').isValidEmailAddress();
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
      final ProfileController profileController = ref.read(profileControllerProvider.notifier);
      final AppRouter appRouter = ref.read(appRouterProvider);

      await userController.registerGoogleProvider();
      await failSilently(ref, () => profileController.loadCurrentUserProfile());
      state = state.copyWith(isBusy: false);

      appRouter.push(const LoginWelcomeBackRoute());
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onLoginWithAppleSelected() async {
    state = state.copyWith(isBusy: true);

    try {
      final UserController userController = ref.read(userControllerProvider.notifier);
      final ProfileController profileController = ref.read(profileControllerProvider.notifier);
      final AppRouter appRouter = ref.read(appRouterProvider);

      await userController.registerAppleProvider();
      await failSilently(ref, () => profileController.loadCurrentUserProfile());
      state = state.copyWith(isBusy: false);

      await appRouter.push(const LoginWelcomeBackRoute());
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onEmailSubmitted(String email) async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    logger.d('onLoginWithEmailSelected: $email');
    updateEmail(email);
    updatePassword('');

    logger.d('Waiting for native animations to complete');
    await Future.delayed(kAnimationDurationRegular);

    if (!isEmailValid) {
      logger.d('Invalid email address');
      return;
    }

    await appRouter.push(const LoginPasswordRoute());
  }

  Future<void> onPasswordSubmitted(String password) async {
    final UserController userController = ref.read(userControllerProvider.notifier);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);

    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    logger.d('onPasswordSubmitted: $password');
    updatePassword(password);

    logger.d('Waiting for native animations to complete');
    await Future.delayed(kAnimationDurationRegular);

    if (!isPasswordValid) {
      logger.d('Invalid password');
      return;
    }

    try {
      state = state.copyWith(isBusy: true);

      await userController.loginWithEmailAndPassword(state.email, state.password);
      await failSilently(ref, () => profileController.loadCurrentUserProfile());
      state = state.copyWith(isBusy: false);

      await appRouter.push(const LoginWelcomeBackRoute());
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

  Future<void> onPasswordResetSelected() async {}

  Future<void> onWelcomeBackContinueSelected() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    logger.d('onWelcomeBackContinueSelected');
    appRouter.removeWhere((route) => true);
    await appRouter.push(const HomeRoute());
  }
}
