// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/extensions/activity_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/user/mixins/profile_switch_mixin.dart';
import 'package:app/services/reaction_api_service.dart';
import 'package:app/services/third_party.dart';

part 'post_view_model.freezed.dart';
part 'post_view_model.g.dart';

@freezed
class PostViewModelState with _$PostViewModelState {
  const factory PostViewModelState({
    required String activityId,
    required TargetFeed targetFeed,
    @Default('') currentCommentText,
    @Default(false) bool isBusy,
    @Default(false) bool isRefreshing,
  }) = _PostViewModelState;

  factory PostViewModelState.fromActivity({
    required String activityId,
    required TargetFeed targetFeed,
  }) =>
      PostViewModelState(
        activityId: activityId,
        targetFeed: targetFeed,
      );
}

@riverpod
class PostViewModel extends _$PostViewModel with LifecycleMixin, ProfileSwitchMixin {
  final TextEditingController commentTextController = TextEditingController();

  @override
  PostViewModelState build(String activityId, TargetFeed feed) {
    return PostViewModelState.fromActivity(activityId: activityId, targetFeed: feed);
  }

  @override
  void onFirstRender() {
    super.onFirstRender();
    prepareProfileSwitcher();
  }

  Future<bool> onWillPopScope() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final bool comeFromDeepLink = appRouter.stack.any((element) => element is SplashRoute);

    if (comeFromDeepLink) {
      appRouter.removeWhere((route) => true);
      appRouter.navigate(const HomeRoute());
    } else {
      appRouter.removeLast();
    }

    return false;
  }

  void onCommentTextChanged(String str) {
    state = state.copyWith(currentCommentText: str.trim());
  }

  bool checkCanView({
    required Activity? activity,
    required Profile? currentProfile,
    required Relationship? publisherRelationship,
  }) {
    final ActivitySecurityConfigurationMode viewMode = activity?.securityConfiguration?.viewMode ?? const ActivitySecurityConfigurationMode.disabled();
    return viewMode.canActOnActivity(
      activity: activity,
      currentProfile: currentProfile,
      publisherRelationship: publisherRelationship,
    );
  }

  bool checkCanComment({
    required Activity activity,
    required Profile? currentProfile,
    required Relationship? publisherRelationship,
  }) {
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    if (profileController.currentProfileId == null) {
      return false;
    }

    final CacheController cacheController = ref.read(cacheControllerProvider);
    final Activity? activity = cacheController.get<Activity>(state.activityId);
    final ActivitySecurityConfigurationMode commentMode = activity?.securityConfiguration?.commentMode ?? const ActivitySecurityConfigurationMode.disabled();
    return checkCanView(
          activity: activity,
          currentProfile: currentProfile,
          publisherRelationship: publisherRelationship,
        ) &&
        commentMode.canActOnActivity(
          activity: activity,
          currentProfile: currentProfile,
          publisherRelationship: publisherRelationship,
        );
  }

  Future<void> onPostCommentRequested() async {
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    if (profileController.currentProfileId == null) {
      logger.e('Profile is not loaded');
      return;
    }

    final String trimmedString = state.currentCommentText.trim();
    if (trimmedString.isEmpty) {
      logger.e('Reaction text is empty');
      return;
    }

    try {
      logger.i('Posting comment');
      state = state.copyWith(isBusy: true);
      final ReactionApiService reactionApiService = await ref.read(reactionApiServiceProvider.future);
      await reactionApiService.postReaction(
        activityId: state.activityId,
        origin: TargetFeed.toOrigin(state.targetFeed),
        kind: 'comment',
        text: trimmedString,
      );

      commentTextController.clear();
      state = state.copyWith(currentCommentText: '');
      logger.d('Comment posted successfully');
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }
}
