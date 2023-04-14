// Dart imports:

// Flutter imports:

// Package imports:
import 'package:app/providers/shared/enumerations/form_mode.dart';
import 'package:app/providers/user/profile_form_controller.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import '../../../../../hooks/lifecycle_hook.dart';
import '../../../../../providers/enumerations/positive_togglable_state.dart';
import '../../../../services/third_party.dart';

part 'profile_edit_settings_model.freezed.dart';
part 'profile_edit_settings_model.g.dart';

@freezed
class ProfileEditSettingsViewModelState with _$ProfileEditSettingsViewModelState {
  const factory ProfileEditSettingsViewModelState({
    @Default(PositiveTogglableState.active) PositiveTogglableState toggleStateDateOfBirth,
    @Default(PositiveTogglableState.inactive) PositiveTogglableState toggleStateGender,
    @Default(PositiveTogglableState.loading) PositiveTogglableState toggleStateHIVStatus,
    @Default(PositiveTogglableState.loading) PositiveTogglableState toggleStateLocation,
    @Default(PositiveTogglableState.loading) PositiveTogglableState toggleStateYouInterests,
    //? The current error to be shown to the user
    Object? currentError,
  }) = _ProfileEditSettingsViewModelState;

  factory ProfileEditSettingsViewModelState.initialState() => const ProfileEditSettingsViewModelState();
}

@riverpod
class ProfileEditSettingsViewModel extends _$ProfileEditSettingsViewModel with LifecycleMixin {
  @override
  ProfileEditSettingsViewModelState build() {
    return ProfileEditSettingsViewModelState.initialState();
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
    return;
  }

  void onUpdateAboutYou() {
    return;
  }

  void onHIVStatusUpdate() {
    return;
  }

  void onGenderUpdate() {
    return;
  }

  void onYouInterestsUpdate() {
    final router = ref.read(appRouterProvider);
    ref.read(profileFormControllerProvider.notifier).resetState(FormMode.edit);
    router.push(const ProfileInterestsEntryRoute());
    return;
  }

  void onLocationUpdate() {
    return;
  }
}
