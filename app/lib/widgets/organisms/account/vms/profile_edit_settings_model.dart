// Dart imports:

// Flutter imports:

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/providers/shared/enumerations/form_mode.dart';
import 'package:app/providers/user/profile_form_controller.dart';
import '../../../../../hooks/lifecycle_hook.dart';
import '../../../../../providers/enumerations/positive_togglable_state.dart';
import '../../../../services/third_party.dart';

part 'profile_edit_settings_model.freezed.dart';
part 'profile_edit_settings_model.g.dart';

@freezed
class AccountProfileEditSettingsViewModelState with _$AccountProfileEditSettingsViewModelState {
  const factory AccountProfileEditSettingsViewModelState({
    @Default(PositiveTogglableState.active) PositiveTogglableState toggleStateDateOfBirth,
    @Default(PositiveTogglableState.inactive) PositiveTogglableState toggleStateGender,
    @Default(PositiveTogglableState.loading) PositiveTogglableState toggleStateHIVStatus,
    @Default(PositiveTogglableState.loading) PositiveTogglableState toggleStateLocation,
    @Default(PositiveTogglableState.loading) PositiveTogglableState toggleStateYouInterests,
    //? The current error to be shown to the user
    Object? currentError,
  }) = _AccountProfileEditSettingsViewModelState;

  factory AccountProfileEditSettingsViewModelState.initialState() => const AccountProfileEditSettingsViewModelState();
}

@riverpod
class AccountProfileEditSettingsViewModel extends _$AccountProfileEditSettingsViewModel with LifecycleMixin {
  @override
  AccountProfileEditSettingsViewModelState build() {
    return AccountProfileEditSettingsViewModelState.initialState();
  }

  void onBackSelected() {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    logger.d('[Profile Edit Settings View Model] - Navigating back to profile view');
    appRouter.removeLast();
  }

  void onToggleNotifications() {
    return;
  }

  void onAccount() {
    return;
  }

  void onProfileImageUpdate() {
    return;
  }

  void onDisplayName() {
    final router = ref.read(appRouterProvider);
    ref.read(profileFormControllerProvider.notifier).resetState(FormMode.edit);
    router.push(const ProfileDisplayNameEntryRoute());
    return;
  }

  void onUpdateAboutYou() {
    return;
  }

  void onHIVStatusUpdate() async {
    ref.read(profileFormControllerProvider.notifier).resetState(FormMode.edit);
    ref.read(appRouterProvider).push(const ProfileHivStatusRoute());
    return;
  }

  void onGenderUpdate() {
    final router = ref.read(appRouterProvider);
    ref.read(profileFormControllerProvider.notifier).resetState(FormMode.edit);
    router.push(const ProfileGenderSelectRoute());
    return;
  }

  void onYouInterestsUpdate() {
    final router = ref.read(appRouterProvider);
    ref.read(profileFormControllerProvider.notifier).resetState(FormMode.edit);
    router.push(const ProfileInterestsEntryRoute());
    return;
  }

  void onLocationUpdate() {
    final router = ref.read(appRouterProvider);
    ref.read(profileFormControllerProvider.notifier).resetState(FormMode.edit);
    router.push(const ProfileLocationRoute());
    return;
  }
}
