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
    Object? currentError,
  }) = _RegistrationAccountViewModelState;

  factory RegistrationAccountViewModelState.initialState() => const RegistrationAccountViewModelState(isBusy: false);
}

@riverpod
class RegistrationAccountViewModel extends _$RegistrationAccountViewModel with LifecycleMixin {
  @override
  RegistrationAccountViewModelState build() {
    return RegistrationAccountViewModelState.initialState();
  }

  Future<void> onLoginWithGoogleSelected() async {
    state = state.copyWith(isBusy: true);
    state = state.copyWith(currentError: null);

    try {
      final UserController userController = ref.read(userControllerProvider.notifier);
      final AppRouter appRouter = ref.read(appRouterProvider);

      await userController.registerGoogleProvider();
      state = state.copyWith(isBusy: false);

      await appRouter.push(const HomeRoute());
    } catch (ex) {
      state = state.copyWith(currentError: ex);
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onLoginWithAppleSelected() async {
    state = state.copyWith(isBusy: true);
    state = state.copyWith(currentError: null);

    try {
      final UserController userController = ref.read(userControllerProvider.notifier);
      final AppRouter appRouter = ref.read(appRouterProvider);

      await userController.registerAppleProvider();
      state = state.copyWith(isBusy: false);

      await appRouter.push(const HomeRoute());
    } catch (ex) {
      state = state.copyWith(currentError: ex);
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onLoginWithEmailSelected() async {
    state = state.copyWith(isBusy: true);
    state = state.copyWith(currentError: null);

    try {
      final AppRouter appRouter = ref.read(appRouterProvider);
      final NewAccountFormController newAccountFormController = ref.read(newAccountFormControllerProvider.notifier);

      newAccountFormController.resetState();
      state = state.copyWith(isBusy: false);

      await appRouter.push(const RegistrationEmailEntryRoute());
    } catch (ex) {
      state = state.copyWith(currentError: ex);
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
      await profileController.updateFirebaseMessagingToken().failSilently(ref);
      await messagingController.connectStreamUser().failSilently(ref);

      logger.i('Profile created, navigating to home screen');
      appRouter.removeWhere((route) => true);
      await appRouter.push(const HomeRoute());
    } catch (ex) {
      state = state.copyWith(currentError: ex);
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }
}
