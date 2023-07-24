// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:app/extensions/string_extensions.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:event_bus/event_bus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/event/cache_key_updated_event.dart';
import 'package:app/providers/user/relationship_controller.dart';
import '../../../../gen/app_router.dart';
import '../../../../helpers/profile_helpers.dart';
import '../../../../hooks/lifecycle_hook.dart';
import '../../../../providers/profiles/profile_controller.dart';
import '../../../../services/third_party.dart';

part 'profile_view_model.freezed.dart';
part 'profile_view_model.g.dart';

@freezed
class ProfileViewModelState with _$ProfileViewModelState {
  const factory ProfileViewModelState({
    Profile? profile,
    Relationship? relationship,
    @Default(false) bool isBusy,
  }) = _ProfileViewModelState;

  factory ProfileViewModelState.initialState() => const ProfileViewModelState();
}

@Riverpod(keepAlive: true)
class ProfileViewModel extends _$ProfileViewModel with LifecycleMixin {
  StreamSubscription<CacheKeyUpdatedEvent>? relationshipsUpdatedSubscription;
  Color get appBarColor => getSafeProfileColorFromHex(state.profile?.accentColor);

  @override
  ProfileViewModelState build() {
    return ProfileViewModelState.initialState();
  }

  Future<void> preloadUserProfile(String uid) async {
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final EventBus eventBus = ref.read(eventBusProvider);
    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);

    relationshipsUpdatedSubscription ??= eventBus.on<CacheKeyUpdatedEvent>().listen(onCacheKeyUpdatedEvent);

    logger.d('[Profile View Model] - Preloading profile for user: $uid');
    final Profile profile = await profileController.getProfile(uid);
    final List<String> members = <String>[
      profileController.currentProfileId ?? '',
      profile.flMeta?.id ?? '',
    ];

    Relationship relationship = Relationship.empty(members);

    if (profileController.currentProfileId != null && profileController.currentProfileId != uid) {
      final Relationship? cachedRelationship = cacheController.getFromCache(members.asGUID);
      if (cachedRelationship != null) {
        logger.d('[Profile View Model] - Preloading relationship for user: $uid');
        relationship = cachedRelationship;
      }
    }

    logger.i('[Profile View Model] - Preloaded profile for user: $uid');
    state = state.copyWith(profile: profile, relationship: relationship);
  }

  Future<void> onCacheKeyUpdatedEvent(CacheKeyUpdatedEvent event) async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('[Profile View Model] - Relationships updated event received');

    if (state.relationship == null) {
      logger.e('[Profile View Model] - Relationship is null');
      return;
    }

    final bool isValidChange = event.value is Relationship && (event.value as Relationship).flMeta?.id == state.relationship!.flMeta?.id;
    if (!isValidChange) {
      return;
    }

    state = state.copyWith(relationship: event.value as Relationship);
    logger.i('[Profile View Model] - Relationships updated event processed');
  }

  Future<void> onAccountSelected() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter router = ref.read(appRouterProvider);

    logger.d('[Profile View Model] - Navigating to account page');
    router.removeWhere((_) => true);
    await router.push(const AccountRoute());
  }

  Future<void> onDisconnectSelected() async {
    final Logger logger = ref.read(loggerProvider);
    final RelationshipController relationshipController = ref.read(relationshipControllerProvider.notifier);
    final AppRouter router = ref.read(appRouterProvider);

    logger.d('[Profile View Model] - Disconnecting from profile');
    final String profileId = state.profile?.flMeta?.id ?? '';
    if (profileId.isEmpty) {
      logger.e('[Profile View Model] - Profile ID is empty');
      return;
    }

    state = state.copyWith(isBusy: true);

    try {
      await relationshipController.disconnectRelationship(profileId);
      state = state.copyWith(isBusy: false);

      // Pop the disconnect dialog
      router.pop();
    } catch (e) {
      logger.e('[Profile View Model] - Error disconnecting from profile: $e');
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }
}
