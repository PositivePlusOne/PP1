// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:event_bus/event_bus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

// Project imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/main.dart';
import 'package:app/providers/profiles/events/profile_switched_event.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/pills/security_mode_pill.dart';
import 'package:app/widgets/molecules/dialogs/positive_dialog.dart';
import 'package:app/widgets/molecules/dialogs/positive_switch_profile_dialog.dart';

/// This mixin is used to handle profile switching.
/// e.g. sending a comment as a different profile such as an organization.
// ignore: invalid_use_of_internal_member
mixin ProfileSwitchMixin {
  StreamSubscription<ProfileSwitchedEvent>? _profileSwitchedEventSubscription;

  /// This method is used to prepare the profile switcher.
  /// Call this from within the build method of the view model that uses this mixin.
  Future<void> prepareProfileSwitcher() async {
    final Logger logger = providerContainer.read(loggerProvider);
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
    final EventBus eventBus = providerContainer.read(eventBusProvider);

    logger.d('ProfileSwitchMixin.prepareProfileSwitcher()');
    await switchProfile(profileController.currentProfileId ?? '');

    _profileSwitchedEventSubscription?.cancel();
    _profileSwitchedEventSubscription = eventBus.on<ProfileSwitchedEvent>().listen(onInternalProfileSwitched);
  }

  Future<void> onInternalProfileSwitched(ProfileSwitchedEvent event) async {
    final Logger logger = providerContainer.read(loggerProvider);
    final ProfileControllerState profileControllerState = providerContainer.read(profileControllerProvider);
    final String targetProfileId = event.profileId;
    final bool isCurrentProfileSupported = profileControllerState.availableProfileIds.contains(targetProfileId);

    logger.d('ProfileSwitchMixin.onInternalProfileSwitched($event)');
    if (targetProfileId.isEmpty || !isCurrentProfileSupported) {
      logger.w('ProfileSwitchMixin.onInternalProfileSwitched($event) - targetProfileId.isEmpty || !isCurrentProfileSupported');
      await onProfileSwitched(null, null);
      return;
    }
  }

  List<String> getSupportedProfileIds() {
    final ProfileControllerState profileControllerState = providerContainer.read(profileControllerProvider);
    final UserController userController = providerContainer.read(userControllerProvider.notifier);
    final String currentUserId = userController.currentUser?.uid ?? '';

    Set<String> supportedProfileIds = profileControllerState.availableProfileIds;

    // Add the currentUser to the top of the list.
    if (currentUserId.isNotEmpty) {
      supportedProfileIds = {currentUserId, ...supportedProfileIds};
    }

    return supportedProfileIds.toList();
  }

  List<Profile> getSupportedProfiles() {
    final CacheController cacheController = providerContainer.read(cacheControllerProvider);
    final List<String> supportedProfileIds = getSupportedProfileIds();
    return cacheController.list(supportedProfileIds);
  }

  bool get canSwitchProfile {
    final ProfileControllerState profileControllerState = providerContainer.read(profileControllerProvider);
    return profileControllerState.availableProfileIds.length > 1;
  }

  int get availableProfileCount {
    final ProfileControllerState profileControllerState = providerContainer.read(profileControllerProvider);
    return profileControllerState.availableProfileIds.length;
  }

  Future<String> requestSwitchProfileDialog(
    BuildContext context, {
    required String title,
    bool requestSwitchProfile = true,
    ActivitySecurityConfigurationMode? mode,
  }) async {
    final Logger logger = providerContainer.read(loggerProvider);
    logger.i('[ProfileSwitchMixin.requestSwitchProfileDialog] - start');

    final String? newProfileId = await PositiveDialog.show(
      context: context,
      title: title,
      style: PositiveDialogStyle.fullScreen,
      hints: <Widget>[
        if (mode != null) ...<Widget>[
          const SecurityModePill(
            reactionMode: ActivitySecurityConfigurationMode.public(),
            brightness: Brightness.dark,
          ),
        ],
      ],
      child: PositiveSwitchProfileDialog(controller: this),
    );

    logger.i('[ProfileSwitchMixin.requestSwitchProfileDialog] - end');

    if (newProfileId != null) {
      logger.d('[ProfileSwitchMixin.requestSwitchProfileDialog] - newProfileId: $newProfileId');
      if (requestSwitchProfile) {
        await switchProfile(newProfileId);
      }
      
      return newProfileId;
    }
    return "";
  }

  Future<void> switchProfile(String profileId) async {
    final Logger logger = providerContainer.read(loggerProvider);
    final ProfileControllerState profileControllerState = providerContainer.read(profileControllerProvider);
    final CacheController cacheController = providerContainer.read(cacheControllerProvider);
    final String currentProfileId = getCurrentProfileId();

    logger.d('ProfileSwitchMixin.switchProfile($profileId)');
    if (profileId.isEmpty) {
      await onProfileSwitched(null, null);
      return;
    }

    if (profileId == currentProfileId) {
      logger.d('ProfileSwitchMixin.switchProfile($profileId) - profileId == currentProfileId');
      return;
    }

    final bool canSupport = profileControllerState.availableProfileIds.contains(profileId);
    final Profile? profile = cacheController.get(profileId);
    if (!canSupport || profile == null) {
      logger.e('ProfileSwitchMixin.switchProfile($profileId) - !canSupport || profile == null');
      return;
    }

    await onProfileSwitched(profileId, profile);
  }

  Profile? getCurrentProfile() {
    final CacheController cacheController = providerContainer.read(cacheControllerProvider);
    final String currentProfileId = getCurrentProfileId();
    return cacheController.get(currentProfileId);
  }

  User? getCurrentUser() {
    final UserController userController = providerContainer.read(userControllerProvider.notifier);
    return userController.currentUser;
  }

  String getCurrentUserId() {
    final UserController userController = providerContainer.read(userControllerProvider.notifier);
    return userController.currentUser?.uid ?? '';
  }

  String getCurrentProfileId() {
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
    return profileController.currentProfileId ?? '';
  }

  @mustCallSuper
  Future<void> onProfileSwitched(String? id, Profile? profile) async {
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
    final Logger logger = providerContainer.read(loggerProvider);

    if (id == null || profile == null) {
      logger.e('ProfileSwitchMixin.onProfileSwitched($id, $profile) - id == null || profile == null');
      return;
    }

    await profileController.switchProfile(id);
  }
}
