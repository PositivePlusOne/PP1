// Flutter imports:
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
  }) = _ProfileViewModelState;

  factory ProfileViewModelState.initialState() => const ProfileViewModelState();
}

@Riverpod(keepAlive: true)
class ProfileViewModel extends _$ProfileViewModel with LifecycleMixin {
  Color get appBarColor => getSafeProfileColorFromHex(state.profile?.accentColor);

  @override
  ProfileViewModelState build() {
    return ProfileViewModelState.initialState();
  }

  Future<void> preloadUserProfile(String uid) async {
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final RelationshipController relationshipController = ref.read(relationshipControllerProvider.notifier);
    final UserController userController = ref.read(userControllerProvider.notifier);

    logger.d('[Profile View Model] - Preloading profile for user: $uid');
    final Profile profile = await profileController.getProfile(uid);
    Relationship? relationship = await relationshipController.getRelationship([userController.state.user!.uid, uid]);

    // Default the relationship to none if it doesn't exist
    relationship ??= Relationship.empty();

    logger.i('[Profile View Model] - Preloaded profile for user: $uid');
    state = state.copyWith(profile: profile, relationship: relationship);
  }

  Future<void> onAccountSelected() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter router = ref.read(appRouterProvider);

    logger.d('[Profile View Model] - Navigating to account page');
    router.removeWhere((_) => true);
    await router.push(const AccountRoute());
  }
}
