// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/extensions/future_extensions.dart';
import 'package:app/providers/user/messaging_controller.dart';
import 'package:app/providers/user/profile_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import '../../../../gen/app_router.dart';
import '../../../../hooks/lifecycle_hook.dart';
import '../../../../providers/user/new_account_form_controller.dart';
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

  Future<void> onBackSelected() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    appRouter.removeWhere((route) => true);
    await appRouter.push(const HomeRoute());
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

      appRouter.push(const HomeRoute());
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

      await appRouter.push(const HomeRoute());
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onSignUpWithEmailSelected() async {
    state = state.copyWith(isBusy: true);

    try {
      final AppRouter appRouter = ref.read(appRouterProvider);
      final NewAccountFormController newAccountFormController = ref.read(newAccountFormControllerProvider.notifier);

      newAccountFormController.resetState();
      state = state.copyWith(isBusy: false);

      await appRouter.push(const RegistrationEmailEntryRoute());
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onCreateProfileSelected() async {
    state = state.copyWith(isBusy: true);

    try {
      final AppRouter appRouter = ref.read(appRouterProvider);
      final ProfileController profileController = ref.read(profileControllerProvider.notifier);
      final MessagingController messagingController = ref.read(messagingControllerProvider.notifier);
      final Logger logger = ref.read(loggerProvider);

      await profileController.createInitialProfile();
      await failSilently(ref, profileController.updateFirebaseMessagingToken);
      await failSilently(ref, messagingController.connectStreamUser);

      logger.i('Profile created, navigating to home screen');
      appRouter.removeWhere((route) => true);
      await appRouter.push(const HomeRoute());
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }
}
