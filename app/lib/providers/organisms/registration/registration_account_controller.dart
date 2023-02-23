// Package imports:
import 'package:app/providers/user/profile_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import '../../../gen/app_router.dart';
import '../../../hooks/lifecycle_hook.dart';
import '../../../services/third_party.dart';
import '../../user/new_account_form_controller.dart';

part 'registration_account_controller.freezed.dart';
part 'registration_account_controller.g.dart';

@freezed
class RegistrationAccountControllerState with _$RegistrationAccountControllerState {
  const factory RegistrationAccountControllerState({
    @Default(false) bool isBusy,
    Object? currentError,
  }) = _RegistrationAccountControllerState;

  factory RegistrationAccountControllerState.initialState() => const RegistrationAccountControllerState(isBusy: false);
}

@riverpod
class RegistrationAccountController extends _$RegistrationAccountController with LifecycleMixin {
  @override
  RegistrationAccountControllerState build() {
    return RegistrationAccountControllerState.initialState();
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
      final Logger logger = ref.read(loggerProvider);

      await profileController.createInitialProfile();
      await profileController.updateFirebaseMessagingToken();

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
