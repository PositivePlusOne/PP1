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
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/extensions/relationship_extensions.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/hooks/lifecycle_hook.dart';
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
class PostViewModel extends _$PostViewModel with LifecycleMixin {
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

  bool checkCanComment() {
    final Logger logger = ref.read(loggerProvider);
    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);

    final Activity? activity = cacheController.getFromCache<Activity>(state.activityId);
    final String currentProfileId = profileController.currentProfileId ?? '';
    final String publisherProfileId = activity?.publisherInformation?.publisherId ?? '';

    if (activity == null || currentProfileId.isEmpty || publisherProfileId.isEmpty) {
      logger.e('checkCanComment() - currentProfileId or publisherProfileId is empty');
      return false;
    }

    final ActivitySecurityConfigurationMode commentMode = activity.securityConfiguration?.commentMode ?? const ActivitySecurityConfigurationMode.disabled();
    if (commentMode == const ActivitySecurityConfigurationMode.disabled()) {
      logger.d('checkCanComment() - commentMode is disabled');
      return false;
    }

    if (commentMode == const ActivitySecurityConfigurationMode.private() && currentProfileId == publisherProfileId) {
      logger.d('checkCanComment() - commentMode is private and currentProfileId is not the publisherProfileId');
      return true;
    }

    if (commentMode == const ActivitySecurityConfigurationMode.private()) {
      logger.d('checkCanComment() - commentMode is private and currentProfileId is not the publisherProfileId');
      return false;
    }

    if (commentMode == const ActivitySecurityConfigurationMode.public() || (commentMode == const ActivitySecurityConfigurationMode.signedIn() && currentProfileId.isNotEmpty)) {
      logger.d('checkCanComment() - commentMode is public or signedIn and currentProfileId is not empty');
      return true;
    }

    final String relationshipId = [currentProfileId, publisherProfileId].asGUID;
    final Relationship? relationship = cacheController.getFromCache<Relationship>(relationshipId);

    if (relationship == null) {
      logger.e('checkCanComment() - relationship is null');
      return false;
    }

    final Set<RelationshipState> relationshipStates = relationship.relationshipStatesForEntity(currentProfileId);
    final bool isConnected = relationshipStates.contains(RelationshipState.sourceConnected) && relationshipStates.contains(RelationshipState.targetConnected);
    final bool isFollowing = relationshipStates.contains(RelationshipState.sourceFollowed);

    if (commentMode == const ActivitySecurityConfigurationMode.connections()) {
      return isConnected;
    }

    if (commentMode == const ActivitySecurityConfigurationMode.followersAndConnections()) {
      return isConnected || isFollowing;
    }

    return true;
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
