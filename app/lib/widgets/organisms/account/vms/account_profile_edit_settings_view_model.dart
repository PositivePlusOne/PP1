// Dart imports:

// Flutter imports:

// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:event_bus/event_bus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/constants/profile_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/shared/enumerations/form_mode.dart';
import 'package:app/providers/system/event/cache_key_updated_event.dart';
import '../../../../../hooks/lifecycle_hook.dart';
import '../../../../../providers/enumerations/positive_togglable_state.dart';
import '../../../../providers/profiles/profile_controller.dart';
import '../../../../providers/profiles/profile_form_controller.dart';
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
    @Default(PositiveTogglableState.loading) PositiveTogglableState toggleStateCompanySectors,
    @Default(false) bool isBusy,

    //? The current error to be shown to the user
    Object? currentError,
  }) = _AccountProfileEditSettingsViewModelState;

  factory AccountProfileEditSettingsViewModelState.initialState() => const AccountProfileEditSettingsViewModelState();
}

@riverpod
class AccountProfileEditSettingsViewModel extends _$AccountProfileEditSettingsViewModel with LifecycleMixin {
  StreamSubscription<CacheKeyUpdatedEvent>? cacheKeySubscription;
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

  Future<void> updateListeners() async {
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final EventBus eventBus = ref.read(eventBusProvider);

    logger.d('[Profile Edit Settings View Model] - Attempting to add user profile listeners');
    final String currentProfileId = profileController.state.currentProfile?.flMeta?.id ?? '';
    await cacheKeySubscription?.cancel();

    if (currentProfileId.isEmpty) {
      logger.d('[Profile Edit Settings View Model] - No profile id found, not adding listeners');
      return;
    }

    cacheKeySubscription = eventBus.on<CacheKeyUpdatedEvent>().listen(onCacheKeyUpdated);
  }

  void onCacheKeyUpdated(CacheKeyUpdatedEvent event) {
    final Logger logger = ref.read(loggerProvider);
    if (!event.isCurrentProfileChangeEvent) {
      return;
    }

    logger.d('[Profile Edit Settings View Model] - Attempting to update user profile listeners');
    updateVisibilityFlags();
  }

  void updateVisibilityFlags() {
    final Profile? profile = ref.read(profileControllerProvider.select((value) => value.currentProfile));
    if (profile == null) {
      return;
    }

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
    if (!pendingFlags.contains(kVisibilityFlagCompanySectors)) {
      if (profile.visibilityFlags.any((element) => element == kVisibilityFlagCompanySectors)) {
        state = state.copyWith(toggleStateCompanySectors: PositiveTogglableState.active);
      } else {
        state = state.copyWith(toggleStateCompanySectors: PositiveTogglableState.inactive);
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
    final Profile? profile = profileController.state.currentProfile;

    if (profile == null) {
      logger.e('No profile found, cannot update visibility flags');
      return;
    }

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
          toggleStateDateOfBirth: PositiveTogglableState.updating,
        );
        break;
      case kVisibilityFlagInterests:
        state = state.copyWith(
          toggleStateYouInterests: PositiveTogglableState.updating,
        );
        break;
      case kVisibilityFlagLocation:
        state = state.copyWith(
          toggleStateLocation: PositiveTogglableState.updating,
        );
        break;
      case kVisibilityFlagGenders:
        state = state.copyWith(
          toggleStateGender: PositiveTogglableState.updating,
        );
        break;
      case kVisibilityFlagHivStatus:
        state = state.copyWith(
          toggleStateHIVStatus: PositiveTogglableState.updating,
        );
        break;
      case kVisibilityFlagCompanySectors:
        state = state.copyWith(
          toggleStateCompanySectors: PositiveTogglableState.updating,
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

  Future<void> onDisplayName(BuildContext context) async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('[Profile Edit Settings View Model] - Navigating to Display name view');

    final router = ref.read(appRouterProvider);
    ref.read(profileFormControllerProvider.notifier).resetState(FormMode.edit);
    await router.push(const ProfileDisplayNameEntryRoute());
  }

  void onUpdateAboutYou() {
    final router = ref.read(appRouterProvider);
    ref.read(profileFormControllerProvider.notifier).resetState(FormMode.edit);
    router.push(const ProfileAboutRoute());
  }

  void onHIVStatusUpdate(BuildContext context) async {
    ref.read(profileFormControllerProvider.notifier).resetState(FormMode.edit);
    ref.read(appRouterProvider).push(const ProfileHivStatusRoute());
  }

  void onGenderUpdate(BuildContext context) {
    final router = ref.read(appRouterProvider);
    ref.read(profileFormControllerProvider.notifier).resetState(FormMode.edit);
    router.push(const ProfileGenderSelectRoute());
  }

  void onYouInterestsUpdate(BuildContext context) {
    final router = ref.read(appRouterProvider);
    ref.read(profileFormControllerProvider.notifier).resetState(FormMode.edit);
    router.push(const ProfileInterestsEntryRoute());
  }

  void onLocationUpdate(BuildContext context) {
    final router = ref.read(appRouterProvider);
    ref.read(profileFormControllerProvider.notifier).resetState(FormMode.edit);
    router.push(const ProfileLocationRoute());
  }

  void onCompanySectorsUpdate(BuildContext context) {
    final router = ref.read(appRouterProvider);
    ref.read(profileFormControllerProvider.notifier).resetState(FormMode.edit);
    router.push(const ProfileCompanySectorSelectRoute());
  }

  Future<void> onProfileImageChangeSelected() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final ProfileFormController controller = ref.read(profileFormControllerProvider.notifier);
    logger.d('[Profile Edit Settings View Model] - Navigating to Profile Image Change view');

    controller.resetState(FormMode.edit);
    await appRouter.push(const ProfileAccentPhotoRoute());
  }
}
