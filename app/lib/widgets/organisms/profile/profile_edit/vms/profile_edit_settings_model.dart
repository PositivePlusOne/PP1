// Dart imports:

// Flutter imports:

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import '../../../../../hooks/lifecycle_hook.dart';

part 'profile_edit_settings_model.freezed.dart';
part 'profile_edit_settings_model.g.dart';

@freezed
class ProfileEditSettingsViewModelState with _$ProfileEditSettingsViewModelState {
  const factory ProfileEditSettingsViewModelState({
    @Default(false) bool isBusy,
    //? has a face been found
    @Default(false) bool faceFound,
    //? camera has been started and is available for interactions
    @Default(false) bool cameraControllerInitialised,
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

  @override
  ProfileEditSettingsViewModelState build() {
    return ProfileEditSettingsViewModelState.initialState();
  }
}
