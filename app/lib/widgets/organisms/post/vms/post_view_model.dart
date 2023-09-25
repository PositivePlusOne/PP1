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
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/extensions/activity_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/content/reactions_controller.dart';
import 'package:app/providers/events/content/activity_events.dart';
import 'package:app/providers/events/content/reaction_events.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/user/mixins/profile_switch_mixin.dart';
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
    Activity? activity,
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

  StreamSubscription<ActivityCreatedEvent>? _activityCreatedEventSubscription;
  StreamSubscription<ActivityUpdatedEvent>? _activityUpdatedEventSubscription;
  StreamSubscription<ActivityDeletedEvent>? _activityDeletedEventSubscription;

  @override
  PostViewModelState build(String activityId, TargetFeed feed) {
    return PostViewModelState.fromActivity(activityId: activityId, targetFeed: feed);
  }

  @override
  void onFirstRender() {
    super.onFirstRender();
    prepareProfileSwitcher();
    setupListeners();
  }

  Future<void> setupListeners() async {
    final Logger logger = ref.read(loggerProvider);
    final EventBus eventBus = ref.read(eventBusProvider);

    await _activityCreatedEventSubscription?.cancel();
    await _activityUpdatedEventSubscription?.cancel();
    await _activityDeletedEventSubscription?.cancel();

    logger.i('[PostViewModel] setupListeners() - Setting up listeners');
    _activityCreatedEventSubscription = eventBus.on<ActivityCreatedEvent>().listen((_) => updateActivity());
    _activityUpdatedEventSubscription = eventBus.on<ActivityUpdatedEvent>().listen((_) => updateActivity());
    _activityDeletedEventSubscription = eventBus.on<ActivityDeletedEvent>().listen((_) => updateActivity());
  }

  void updateActivity() {
    final Logger logger = ref.read(loggerProvider);
    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);
    final Activity? activity = cacheController.getFromCache<Activity>(state.activityId);

    state = state.copyWith(activity: activity);
    logger.i('[PostViewModel] updateActivity() - activity: $activity');
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

  bool checkCanView() {
    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);
    final Activity? activity = cacheController.getFromCache<Activity>(state.activityId);
    final ActivitySecurityConfigurationMode viewMode = activity?.securityConfiguration?.viewMode ?? const ActivitySecurityConfigurationMode.disabled();
    return viewMode.canActOnActivity(state.activityId);
  }

  bool checkCanComment() {
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    if (profileController.currentProfileId == null) {
      return false;
    }

    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);
    final Activity? activity = cacheController.getFromCache<Activity>(state.activityId);
    final ActivitySecurityConfigurationMode commentMode = activity?.securityConfiguration?.commentMode ?? const ActivitySecurityConfigurationMode.disabled();
    return checkCanView() && commentMode.canActOnActivity(state.activityId, currentProfileId: profileController.currentProfileId!);
  }

  Future<void> onPostCommentRequested() async {
    final Logger logger = ref.read(loggerProvider);
    final ReactionsController reactionsController = ref.read(reactionsControllerProvider.notifier);
    final ReactionApiService reactionApiService = await ref.read(reactionApiServiceProvider.future);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
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
