// Dart imports:

// Flutter imports:

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import '../../../../../hooks/lifecycle_hook.dart';
import '../profile_edit_settings_content.dart';

part 'profile_edit_settings_model.freezed.dart';
part 'profile_edit_settings_model.g.dart';

@freezed
class ProfileEditSettingsViewModelState with _$ProfileEditSettingsViewModelState {
  const factory ProfileEditSettingsViewModelState({
    @Default(ToggleState.loading) ToggleState toggleStateDateOfBirth,
    @Default(ToggleState.loading) ToggleState toggleStateGender,
    @Default(ToggleState.loading) ToggleState toggleStateHIVStatus,
    @Default(ToggleState.loading) ToggleState toggleStateLocation,
    @Default(ToggleState.loading) ToggleState toggleStateYouInterests,
    //? The current error to be shown to the user
    Object? currentError,
  }) = _ProfileEditSettingsViewModelState;

  factory ProfileEditSettingsViewModelState.initialState() => const ProfileEditSettingsViewModelState();
}

@riverpod
class ProfileEditSettingsViewModel extends _$ProfileEditSettingsViewModel with LifecycleMixin {
  void onBack() {
    return;
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
