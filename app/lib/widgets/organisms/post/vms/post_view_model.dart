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
import 'package:app/providers/content/reactions_controller.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/user/mixins/profile_switch_mixin.dart';
import 'package:app/services/reaction_api_service.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/organisms/splash/splash_page.dart';
import 'package:app/widgets/state/positive_reactions_state.dart';

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
    final bool comeFromDeepLink = appRouter.stack.any((element) => element.child is SplashPage);

    if (comeFromDeepLink) {
      appRouter.replaceAll([const HomeRoute()]);
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
    required Activity? activity,
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
      final Reaction newReaction = await reactionApiService.postReaction(
        activityId: state.activityId,
        kind: 'comment',
        text: trimmedString,
      );

      // Add the reaction to the reactions feed
      final CacheController cacheController = ref.read(cacheControllerProvider);
      final Activity? activity = cacheController.get<Activity>(state.activityId);
      final Profile? currentProfile = cacheController.get<Profile>(profileController.currentProfileId ?? '');
      if (activity == null || currentProfile == null) {
        logger.e('Activity or current profile is null');
        return;
      }

      final ReactionsController reactionsController = ref.read(reactionsControllerProvider.notifier);
      final String reactionsCacheKey = PositiveReactionsState.buildReactionsCacheKey(
        activityId: activityId,
        profileId: profileController.currentProfileId ?? '',
      );

      final PositiveReactionsState reactionsState = cacheController.get<PositiveReactionsState>(reactionsCacheKey) ?? PositiveReactionsState.createNewFeedState(activityId, profileController.currentProfileId ?? '');
      reactionsState.pagingController.itemList?.add(newReaction);

      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      reactionsState.pagingController.notifyListeners();

      // Update the reaction counts
      final String reactionStatisticsCacheKey = reactionsController.buildExpectedStatisticsCacheKey(activityId: activityId);
      ReactionStatistics reactionStatistics = reactionsController.getStatisticsForActivity(activityId: activityId);

      final Map<String, int> counts = {...reactionStatistics.counts};
      counts['comment'] = counts['comment'] ?? 0 + 1;
      reactionStatistics = reactionStatistics.copyWith(counts: counts);

      // Save new state
      cacheController.add(key: reactionsCacheKey, value: reactionsState);
      cacheController.add(key: reactionStatisticsCacheKey, value: reactionStatistics);

      commentTextController.clear();
      state = state.copyWith(currentCommentText: '');
      logger.d('Comment posted successfully');
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }
}
