// Dart imports:
import 'dart:async';

// Flutter imports:

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/providers/user/relationship_controller.dart';
import '../../../../gen/app_router.dart';
import '../../../../hooks/lifecycle_hook.dart';
import '../../../../providers/profiles/profile_controller.dart';
import '../../../../services/third_party.dart';

part 'profile_view_model.freezed.dart';
part 'profile_view_model.g.dart';

@freezed
class ProfileViewModelState with _$ProfileViewModelState {
  const factory ProfileViewModelState({
    String? targetProfileId,
    @Default(false) bool isBusy,
  }) = _ProfileViewModelState;

  factory ProfileViewModelState.initialState() => const ProfileViewModelState();
}

@Riverpod(keepAlive: true)
class ProfileViewModel extends _$ProfileViewModel with LifecycleMixin {
  @override
  ProfileViewModelState build() {
    return ProfileViewModelState.initialState();
  }

  Future<void> preloadUserProfile(String uid) async {
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);

    logger.d('[Profile View Model] - Preloading profile for user: $uid');
    final Profile profile = await profileController.getProfile(uid);

    logger.i('[Profile View Model] - Preloaded profile for user: $uid');
    state = state.copyWith(targetProfileId: profile.flMeta?.id);
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
    if (state.targetProfileId?.isEmpty ?? true) {
      logger.e('[Profile View Model] - Profile ID is empty');
      return;
    }

    state = state.copyWith(isBusy: true);

    try {
      await relationshipController.disconnectRelationship(state.targetProfileId ?? '');
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
