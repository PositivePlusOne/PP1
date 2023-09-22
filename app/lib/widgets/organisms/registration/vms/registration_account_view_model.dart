// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:app/extensions/router_extensions.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/system/system_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/widgets/atoms/indicators/positive_snackbar.dart';
import 'package:app/widgets/organisms/login/vms/login_view_model.dart';
import '../../../../gen/app_router.dart';
import '../../../../hooks/lifecycle_hook.dart';
import '../../../../providers/user/account_form_controller.dart';
import '../../../../services/third_party.dart';

part 'registration_account_view_model.freezed.dart';
part 'registration_account_view_model.g.dart';

@freezed
class RegistrationAccountViewModelState with _$RegistrationAccountViewModelState {
  const factory RegistrationAccountViewModelState({
    @Default(false) bool isBusy,
  }) = _RegistrationAccountViewModelState;

  factory RegistrationAccountViewModelState.initialState() => const RegistrationAccountViewModelState(isBusy: false);
}

@riverpod
class RegistrationAccountViewModel extends _$RegistrationAccountViewModel with LifecycleMixin {
  @override
  RegistrationAccountViewModelState build() {
    return RegistrationAccountViewModelState.initialState();
  }

  Future<bool> onBackSelected() async {
    final AppRouter appRouter = ref.read(appRouterProvider);

    appRouter.removeLastOrHome();

    return false;
  }

  Future<void> onLoginWithGoogleSelected() async {
    state = state.copyWith(isBusy: true);

    try {
      final SystemController systemController = ref.read(systemControllerProvider.notifier);
      final UserController userController = ref.read(userControllerProvider.notifier);
      final AppRouter appRouter = ref.read(appRouterProvider);

      final UserCredential? credentials = await userController.registerGoogleProvider();
      await systemController.updateSystemConfiguration();

      state = state.copyWith(isBusy: false);

      if (credentials == null) {
        return;
      }

      appRouter.removeWhere((route) => true);
      await appRouter.push(const HomeRoute());
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onLoginWithAppleSelected() async {
    state = state.copyWith(isBusy: true);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));

    try {
      final SystemController systemController = ref.read(systemControllerProvider.notifier);
      final UserController userController = ref.read(userControllerProvider.notifier);

      final credentials = await userController.registerAppleProvider();
      await systemController.updateSystemConfiguration();
      state = state.copyWith(isBusy: false);

      if (credentials == null) {
        return;
      }

      appRouter.removeWhere((route) => true);
      await appRouter.push(const HomeRoute());
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

  Future<void> onSignUpWithEmailSelected(BuildContext context, AccountFormController controller) async {
    state = state.copyWith(isBusy: true);

    try {
      final AppRouter appRouter = ref.read(appRouterProvider);
      final Locale locale = Localizations.localeOf(context);

      controller.resetState(locale);
      state = state.copyWith(isBusy: false);

      await appRouter.push(const RegistrationEmailEntryRoute());
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onSignInRequested() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final LoginViewModel loginViewModel = ref.read(loginViewModelProvider.notifier);

    logger.i('Navigating to login screen');
    loginViewModel.resetState();
    await appRouter.push(LoginRoute(senderRoute: RegistrationAccountRoute));
  }

  Future<void> onCreateProfileSelected() async {
    state = state.copyWith(isBusy: true);

    try {
      final AppRouter appRouter = ref.read(appRouterProvider);
      final ProfileController profileController = ref.read(profileControllerProvider.notifier);
      final SystemController systemController = ref.read(systemControllerProvider.notifier);
      final Logger logger = ref.read(loggerProvider);

      await systemController.updateSystemConfiguration();
      profileController.updateFirebaseMessagingToken().onError((error, stackTrace) {
        logger.e('Failed to set initial firebase messaging token. Error: $error');
      });

      logger.i('Profile created, navigating to home screen');
      appRouter.removeWhere((route) => true);
      await appRouter.push(const ProfileNameEntryRoute());
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }
}
