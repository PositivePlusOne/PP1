import 'dart:async';

import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/main.dart';
import 'package:app/providers/profiles/events/profile_switched_event.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:event_bus/event_bus.dart';
import 'package:logger/logger.dart';

/// This mixin is used to handle profile switching.
/// e.g. sending a comment as a different profile such as an organization.
// ignore: invalid_use_of_internal_member
abstract class ProfileSwitchMixin {
  StreamSubscription<ProfileSwitchedEvent>? _profileSwitchedEventSubscription;

  /// This method is used to prepare the profile switcher.
  /// Call this from within the build method of the view model that uses this mixin.
  void prepareProfileSwitcher() {
    final Logger logger = providerContainer.read(loggerProvider);
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
    final EventBus eventBus = providerContainer.read(eventBusProvider);

    logger.d('ProfileSwitchMixin.prepareProfileSwitcher()');
    switchProfile(profileController.currentProfileId ?? '');

    _profileSwitchedEventSubscription?.cancel();
    _profileSwitchedEventSubscription = eventBus.on<ProfileSwitchedEvent>().listen(onInternalProfileSwitched);
  }

  void onInternalProfileSwitched(ProfileSwitchedEvent event) {
    final Logger logger = providerContainer.read(loggerProvider);
    final ProfileControllerState profileControllerState = providerContainer.read(profileControllerProvider);
    final String targetProfileId = event.profileId;
    final bool isCurrentProfileSupported = profileControllerState.availableProfileIds.contains(targetProfileId);

    logger.d('ProfileSwitchMixin.onInternalProfileSwitched($event)');
    if (targetProfileId.isEmpty || !isCurrentProfileSupported) {
      logger.w('ProfileSwitchMixin.onInternalProfileSwitched($event) - targetProfileId.isEmpty || !isCurrentProfileSupported');
      onProfileSwitched(null, null);
      return;
    }
  }

  void switchProfile(String profileId) {
    final Logger logger = providerContainer.read(loggerProvider);
    final ProfileControllerState profileControllerState = providerContainer.read(profileControllerProvider);
    final CacheController cacheController = providerContainer.read(cacheControllerProvider.notifier);
    final String currentProfileId = getCurrentProfileId();

    logger.d('ProfileSwitchMixin.switchProfile($profileId)');
    if (profileId.isEmpty) {
      onProfileSwitched(null, null);
      return;
    }

    if (profileId == currentProfileId) {
      logger.d('ProfileSwitchMixin.switchProfile($profileId) - profileId == currentProfileId');
      return;
    }

    final bool canSupport = profileControllerState.availableProfileIds.contains(profileId);
    final Profile? profile = cacheController.getFromCache(profileId);
    if (!canSupport || profile == null) {
      logger.e('ProfileSwitchMixin.switchProfile($profileId) - !canSupport || profile == null');
      return;
    }

    onProfileSwitched(profileId, profile);
  }

  String getCurrentProfileId();

  void onProfileSwitched(String? id, Profile? profile);
}
