// Flutter imports:
import 'dart:async';

import 'package:app/providers/events/relationships_updated_event.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/providers/user/relationship_controller.dart';
import 'package:app/providers/user/user_controller.dart';
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
  Color get appBarColor => getSafeProfileColorFromHex(state.profile?.accentColor);
  StreamSubscription<RelationshipsUpdatedEvent>? relationshipsUpdatedSubscription;

  @override
  ProfileViewModelState build() {
    return ProfileViewModelState.initialState();
  }

  Future<void> preloadUserProfile(String uid) async {
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final RelationshipController relationshipController = ref.read(relationshipControllerProvider.notifier);
    final UserController userController = ref.read(userControllerProvider.notifier);

    relationshipsUpdatedSubscription ??= relationshipController.positiveRelationshipsUpdatedController.stream.listen(onRelationshipsUpdated);

    logger.d('[Profile View Model] - Preloading profile for user: $uid');
    final Profile profile = await profileController.getProfile(uid);
    final Relationship relationship = await relationshipController.getRelationship([userController.state.user!.uid, uid]);

    logger.i('[Profile View Model] - Preloaded profile for user: $uid');
    state = state.copyWith(profile: profile, relationship: relationship);
  }

  Future<void> onRelationshipsUpdated(RelationshipsUpdatedEvent event) async {
    final Logger logger = ref.read(loggerProvider);
    final RelationshipController relationshipController = ref.read(relationshipControllerProvider.notifier);

    logger.d('[Profile View Model] - Relationships updated event received');
    if (state.relationship == null) {
      logger.e('[Profile View Model] - Relationship is null');
      return;
    }

    final List<String> members = state.relationship!.members.map((e) => e.memberId).toList();
    final Relationship relationship = await relationshipController.getRelationship(members);
    state = state.copyWith(relationship: relationship);

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
