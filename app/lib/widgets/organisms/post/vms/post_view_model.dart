// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:event_bus/event_bus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/content/reactions_controller.dart';
import 'package:app/providers/events/content/activities.dart';
import 'package:app/providers/events/content/reactions.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/services/reaction_api_service.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/behaviours/positive_reaction_pagination_behaviour.dart';
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
class PostViewModel extends _$PostViewModel {
  final TextEditingController commentTextController = TextEditingController();

  @override
  PostViewModelState build(String activityId, TargetFeed feed) {
    return PostViewModelState.fromActivity(activityId: activityId, targetFeed: feed);
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

  Future<void> onPostCommentRequested() async {
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final ReactionsController reactionsController = ref.read(reactionsControllerProvider.notifier);
    final ReactionApiService reactionApiService = await ref.read(reactionApiServiceProvider.future);
    final EventBus eventBus = ref.read(eventBusProvider);
    final String trimmedString = state.currentCommentText.trim();

    if (trimmedString.isEmpty) {
      logger.e('Reaction text is empty');
      return;
    }

    if (profileController.currentProfileId == null) {
      logger.e('Profile is not loaded');
      return;
    }

    state = state.copyWith(isBusy: true);

    try {
      logger.i('Posting comment');
      final Reaction reaction = await reactionApiService.postReaction(
        activityId: state.activityId,
        origin: TargetFeed.toOrigin(state.targetFeed),
        kind: 'comment',
        text: trimmedString,
      );

      reactionsController.offsetReactionCountForActivity(
        activityId: activityId,
        userId: profileController.currentProfileId!,
        origin: TargetFeed.toOrigin(state.targetFeed),
        reactionType: 'comment',
        offset: 1,
      );

      eventBus.fire(ReactionCreatedEvent(activityId: activityId, reaction: reaction));
      commentTextController.clear();
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onRefresh() async {
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);

    if (profileController.currentProfileId == null) {
      logger.d('onRefresh() - profileController.currentProfileId is null');
      return;
    }

    logger.d('onRefresh()');
    state = state.copyWith(isRefreshing: true);

    try {
      final String cacheId = PositiveReactionPaginationBehaviourState.buildCacheKey("comment", state.activityId);
      final PositiveReactionsState? commentsState = cacheController.getFromCache<PositiveReactionsState>(cacheId);

      // Check if the feed is already loaded
      if (commentsState != null) {
        commentsState.pagingController.refresh();
      }
    } finally {
      state = state.copyWith(isRefreshing: false);
    }
  }
}
