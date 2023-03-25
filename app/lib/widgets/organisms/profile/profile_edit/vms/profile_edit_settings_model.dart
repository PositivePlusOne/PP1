// Dart imports:

// Flutter imports:

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import '../../../../../hooks/lifecycle_hook.dart';
import '../../../../../providers/enumerations/positive_togglable_state.dart';

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
    return;
  }

  void onLocationUpdate() {
    return;
  }

  @override
  ProfileEditSettingsViewModelState build() {
    return ProfileEditSettingsViewModelState.initialState();
  }
}
