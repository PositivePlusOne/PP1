// Dart imports:

// Flutter imports:

// Dart imports:
import 'dart:async';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/constants/profile_constants.dart';
import 'package:app/dtos/database/user/user_profile.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/shared/enumerations/form_mode.dart';
import 'package:app/providers/user/profile_form_controller.dart';
import '../../../../../hooks/lifecycle_hook.dart';
import '../../../../../providers/enumerations/positive_togglable_state.dart';
import '../../../../providers/user/profile_controller.dart';
import '../../../../services/third_party.dart';

part 'account_profile_edit_settings_view_model.freezed.dart';
part 'account_profile_edit_settings_view_model.g.dart';

@freezed
class AccountProfileEditSettingsViewModelState with _$AccountProfileEditSettingsViewModelState {
  const factory AccountProfileEditSettingsViewModelState({
    @Default(PositiveTogglableState.loading) PositiveTogglableState toggleStateDateOfBirth,
    @Default(PositiveTogglableState.loading) PositiveTogglableState toggleStateGender,
    @Default(PositiveTogglableState.loading) PositiveTogglableState toggleStateHIVStatus,
    @Default(PositiveTogglableState.loading) PositiveTogglableState toggleStateLocation,
    @Default(PositiveTogglableState.loading) PositiveTogglableState toggleStateYouInterests,
    @Default(false) bool isBusy,
    //? The current error to be shown to the user
    Object? currentError,
  }) = _AccountProfileEditSettingsViewModelState;

  factory AccountProfileEditSettingsViewModelState.initialState() => const AccountProfileEditSettingsViewModelState();
}

@riverpod
class AccountProfileEditSettingsViewModel extends _$AccountProfileEditSettingsViewModel with LifecycleMixin {
  StreamSubscription<UserProfile?>? userProfileSubscription;

  @override
  AccountProfileEditSettingsViewModelState build() {
    return AccountProfileEditSettingsViewModelState.initialState();
  }

  @override
  void onFirstRender() {
    updateVisibilityFlags();
    updateListeners();
    super.onFirstRender();
  }

  void onUserProfileCHange(UserProfile? event) {
    final Logger logger = ref.read(loggerProvider);
    logger.d('[Profile Edit Settings View Model] - Attempting to update user profile listeners');
    updateVisibilityFlags();
  }

  Future<void> updateListeners() async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('[Profile Edit Settings View Model] - Attempting to add user profile listeners');

    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    await userProfileSubscription?.cancel();
    userProfileSubscription = profileController.userProfileStreamController.stream.listen(onUserProfileCHange);
  }

  void updateVisibilityFlags() {
    final UserProfile profile = ref.read(profileControllerProvider.select((value) => value.userProfile!));

    PositiveTogglableState birthday = PositiveTogglableState.inactive;
    PositiveTogglableState interests = PositiveTogglableState.inactive;
    PositiveTogglableState location = PositiveTogglableState.inactive;
    PositiveTogglableState genders = PositiveTogglableState.inactive;
    PositiveTogglableState hivStatus = PositiveTogglableState.inactive;

    if (profile.visibilityFlags.any((element) => element == kVisibilityFlagBirthday)) {
      birthday = PositiveTogglableState.active;
    }
    if (profile.visibilityFlags.any((element) => element == kVisibilityFlagInterests)) {
      interests = PositiveTogglableState.active;
    }
    if (profile.visibilityFlags.any((element) => element == kVisibilityFlagLocation)) {
      location = PositiveTogglableState.active;
    }
    if (profile.visibilityFlags.any((element) => element == kVisibilityFlagGenders)) {
      genders = PositiveTogglableState.active;
    }
    if (profile.visibilityFlags.any((element) => element == kVisibilityFlagHivStatus)) {
      hivStatus = PositiveTogglableState.active;
    }

    state = state.copyWith(
      toggleStateDateOfBirth: birthday,
      toggleStateYouInterests: interests,
      toggleStateLocation: location,
      toggleStateGender: genders,
      toggleStateHIVStatus: hivStatus,
    );
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

  Future<void> onDisplayName() async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('[Profile Edit Settings View Model] - Navigating to Display name view');

    final router = ref.read(appRouterProvider);
    ref.read(profileFormControllerProvider.notifier).resetState(FormMode.edit);
    await router.push(const ProfileDisplayNameEntryRoute());
  }

  void onUpdateAboutYou() {
    final router = ref.read(appRouterProvider);
    ref.read(profileFormControllerProvider.notifier).resetState(FormMode.edit);
    router.push(const ProfileBiographyEntryRoute());
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

  Future<void> onVisibilityToggleRequested(String flag) async {
    final Logger logger = ref.read(loggerProvider);
    logger.i('Toggling $flag visibility');
    //TODO This flag should be checked to make sure it is one that should be within the user profile?

    //TODO Nice to have, allow different flags to queue for the user if buttons are pushed multiple times (this would wait for isBusy state to resolve and continue from there)

    if (state.isBusy == true) {
      logger.i('Cannot toggle visibility flag during busy state');
      return;
    }

    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final UserProfile profile = profileController.state.userProfile!;

    final flags = {...profile.visibilityFlags};

    setLoadingStateOnFlag(flag);

    if (flags.contains(flag)) {
      flags.remove(flag);
    } else {
      flags.add(flag);
    }

    state = state.copyWith(isBusy: true);

    await profileController.updateVisibilityFlags(flags);

    state = state.copyWith(isBusy: false);
  }

  void setLoadingStateOnFlag(String flag) {
    final Logger logger = ref.read(loggerProvider);
    logger.i('Setting $flag to laoding state');

    switch (flag) {
      case kVisibilityFlagBirthday:
        state = state.copyWith(
          toggleStateDateOfBirth: PositiveTogglableState.loading,
        );
        break;
      case kVisibilityFlagInterests:
        state = state.copyWith(
          toggleStateYouInterests: PositiveTogglableState.loading,
        );
        break;
      case kVisibilityFlagLocation:
        state = state.copyWith(
          toggleStateLocation: PositiveTogglableState.loading,
        );
        break;
      case kVisibilityFlagGenders:
        state = state.copyWith(
          toggleStateGender: PositiveTogglableState.loading,
        );
        break;
      case kVisibilityFlagHivStatus:
        state = state.copyWith(
          toggleStateHIVStatus: PositiveTogglableState.loading,
        );
        break;
      default:
        return;
    }
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
