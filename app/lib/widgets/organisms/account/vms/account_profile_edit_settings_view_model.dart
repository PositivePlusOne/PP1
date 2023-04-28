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
import 'package:app/dtos/database/profile/profile.dart';
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
  final List<String> pendingFlags = [];

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

  void onUserProfileChange(UserProfile? event) {
    final Logger logger = ref.read(loggerProvider);
    logger.d('[Profile Edit Settings View Model] - Attempting to update user profile listeners');
    updateVisibilityFlags();
  }

  Future<void> updateListeners() async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('[Profile Edit Settings View Model] - Attempting to add user profile listeners');

    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    await userProfileSubscription?.cancel();
    userProfileSubscription = profileController.userProfileStreamController.stream.listen(onUserProfileChange);
  }

  void updateVisibilityFlags() {
    final Profile profile = ref.read(profileControllerProvider.select((value) => value.userProfile!));

    if (!pendingFlags.contains(kVisibilityFlagBirthday)) {
      if (profile.visibilityFlags.any((element) => element == kVisibilityFlagBirthday)) {
        state = state.copyWith(toggleStateDateOfBirth: PositiveTogglableState.active);
      } else {
        state = state.copyWith(toggleStateDateOfBirth: PositiveTogglableState.inactive);
      }
    }
    if (!pendingFlags.contains(kVisibilityFlagInterests)) {
      if (profile.visibilityFlags.any((element) => element == kVisibilityFlagInterests)) {
        state = state.copyWith(toggleStateYouInterests: PositiveTogglableState.active);
      } else {
        state = state.copyWith(toggleStateYouInterests: PositiveTogglableState.inactive);
      }
    }
    if (!pendingFlags.contains(kVisibilityFlagLocation)) {
      if (profile.visibilityFlags.any((element) => element == kVisibilityFlagLocation)) {
        state = state.copyWith(toggleStateLocation: PositiveTogglableState.active);
      } else {
        state = state.copyWith(toggleStateLocation: PositiveTogglableState.inactive);
      }
    }
    if (!pendingFlags.contains(kVisibilityFlagGenders)) {
      if (profile.visibilityFlags.any((element) => element == kVisibilityFlagGenders)) {
        state = state.copyWith(toggleStateGender: PositiveTogglableState.active);
      } else {
        state = state.copyWith(toggleStateGender: PositiveTogglableState.inactive);
      }
    }
    if (!pendingFlags.contains(kVisibilityFlagHivStatus)) {
      if (profile.visibilityFlags.any((element) => element == kVisibilityFlagHivStatus)) {
        state = state.copyWith(toggleStateHIVStatus: PositiveTogglableState.active);
      } else {
        state = state.copyWith(toggleStateHIVStatus: PositiveTogglableState.inactive);
      }
    }
  }

  void onBackSelected() {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    logger.d('[Profile Edit Settings View Model] - Navigating back to profile view');
    appRouter.removeLast();
  }

  Future<void> onVisibilityToggleRequested(String flag) async {
    final Logger logger = ref.read(loggerProvider);
    logger.i('Toggling $flag visibility');
    //TODO This flag should be checked to make sure it is one that should be within the user profile?

    if (state.isBusy == true) {
      logger.i('Cannot toggle visibility flag during busy state, adding flag to pending list');
      if (!pendingFlags.contains(flag)) {
        setLoadingStateOnFlag(flag);
        pendingFlags.add(flag);
      }
      return;
    }

    setLoadingStateOnFlag(flag);
    await updateVisibilityToggleRequested([flag]);
  }

  Future<void> updateVisibilityToggleRequested(List<String> flags) async {
    final Logger logger = ref.read(loggerProvider);
    logger.i('Updating user profile with new visibility flags');

    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final Profile profile = profileController.state.userProfile!;

    final Set<String> userFlags = {...profile.visibilityFlags};
    final List<String> pendingRemovalFlags = List.from(flags);

    for (var flag in flags) {
      pendingRemovalFlags.add(flag);
      if (userFlags.contains(flag)) {
        userFlags.remove(flag);
      } else {
        userFlags.add(flag);
      }
    }

    state = state.copyWith(isBusy: true);

    await profileController.updateVisibilityFlags(userFlags);

    pendingFlags.removeWhere((element) => pendingRemovalFlags.contains(element));

    updateVisibilityFlags();
    state = state.copyWith(isBusy: false);

    if (pendingFlags.isNotEmpty) {
      await updateVisibilityToggleRequested(pendingFlags);
    }
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
