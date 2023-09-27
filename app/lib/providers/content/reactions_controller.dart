// Dart imports:
import 'dart:async';
import 'dart:collection';

// Package imports:
import 'package:event_bus/event_bus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/main.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/event/cache_key_updated_event.dart';
import 'package:app/providers/user/user_controller.dart';
import 'package:app/services/reaction_api_service.dart';
import 'package:app/services/third_party.dart';

part 'reactions_controller.freezed.dart';
part 'reactions_controller.g.dart';

@freezed
class ReactionsControllerState with _$ReactionsControllerState {
  const factory ReactionsControllerState({
    required HashMap<String, HashMap<String, Reaction>> activityReactions,
  }) = _ReactionsControllerState;

  factory ReactionsControllerState.initialState() => ReactionsControllerState(
        activityReactions: HashMap<String, HashMap<String, Reaction>>(),
      );
}

@Riverpod(keepAlive: true)
class ReactionsController extends _$ReactionsController {
  StreamSubscription<CacheKeyUpdatedEvent>? _onCacheKeyUpdatedSubscription;

  static const List<String> kUniqueReactionTypes = <String>["like", "bookmark"];
  static const List<String> kAllReactionTypes = <String>[
    "like",
    "bookmark",
    "comment",
    "share",
  ];

  @override
  ReactionsControllerState build() {
    return ReactionsControllerState.initialState();
  }

  Future<void> setupListeners() async {
    final Logger logger = providerContainer.read(loggerProvider);
    final EventBus eventBus = providerContainer.read(eventBusProvider);
    logger.d('ReactionsController - setupListeners - Setting up listeners');

    await _onCacheKeyUpdatedSubscription?.cancel();
    _onCacheKeyUpdatedSubscription = eventBus.on<CacheKeyUpdatedEvent>().listen(onCacheKeyUpdated);
  }

  void onCacheKeyUpdated(CacheKeyUpdatedEvent event) {
    if (event.value is Reaction) {
      final Reaction reaction = event.value as Reaction;
      final CacheKeyUpdatedEventType eventType = event.eventType;

      switch (eventType) {
        case CacheKeyUpdatedEventType.created:
          addReactionToStatistics(activityId: reaction.activityId, origin: reaction.origin, reaction: reaction);
          break;
        case CacheKeyUpdatedEventType.updated:
          updateReactionInStatistics(activityId: reaction.activityId, origin: reaction.origin, reaction: reaction);
          break;
        case CacheKeyUpdatedEventType.deleted:
          removeReactionFromStatistics(activityId: reaction.activityId, origin: reaction.origin, reaction: reaction);
          break;
      }
    }

    // Add to activity reactions map
    final String activityId = event.value.activityId;
    final Reaction reaction = event.value as Reaction;
    final String reactionId = reaction.flMeta?.id ?? '';
    final HashMap<String, Reaction> activityReactions = state.activityReactions[activityId] ?? HashMap<String, Reaction>();

    if (reactionId.isEmpty) {
      return;
    }

    switch (event.eventType) {
      case CacheKeyUpdatedEventType.created:
        activityReactions[reactionId] = reaction;
        break;
      case CacheKeyUpdatedEventType.updated:
        activityReactions[reactionId] = reaction;
        break;
      case CacheKeyUpdatedEventType.deleted:
        activityReactions.remove(reactionId);
        break;
    }
  }

  List<Reaction> getOwnReactionsForFeedActivity({
    required String activityId,
    required String origin,
    required String uid,
    String? kind,
  }) {
    final CacheController cacheController = ref.read(cacheControllerProvider);
    final List<Reaction> cachedReactions = cacheController.list<Reaction>().toList();
    final Iterable<Reaction> targetReactions = cachedReactions.where((element) {
      final String expectedKind = ReactionType.toJson(element.kind);
      return element.activityId == activityId && element.origin == origin && element.userId == uid && (kind == null || expectedKind == kind);
    });

    return targetReactions.toList();
  }

  ReactionStatistics getStatisticsForActivity(String activityId, String origin) {
    final Logger logger = providerContainer.read(loggerProvider);
    ReactionStatistics statistics = ReactionStatistics(
      activityId: activityId,
      counts: {},
      feed: origin,
    );

    logger.i('getStatisticsForActivity: $activityId, $origin');
    final String expectedCacheKey = ReactionStatistics.buildCacheKey(statistics);
    final CacheController cacheController = ref.read(cacheControllerProvider);
    final ReactionStatistics? cachedStatistics = cacheController.get(expectedCacheKey);
    if (cachedStatistics != null) {
      logger.i('getStatisticsForActivity: $activityId, $origin, found in cache');
      return cachedStatistics;
    }

    logger.i('getStatisticsForActivity: $activityId, $origin, not found in cache');
    cacheController.add(key: expectedCacheKey, value: statistics);
    return statistics;
  }

  // ReactionStatistics offsetReactionCountForActivity({
  //   required String activityId,
  //   required String userId,
  //   required String origin,
  //   required String reactionType,
  //   int offset = 1,
  // }) {
  //   final Logger logger = providerContainer.read(loggerProvider);
  //   final CacheController cacheController = ref.read(cacheControllerProvider);

  //   logger.i('offsetReactionCountForActivity: $activityId, $origin, $reactionType, $offset');
  //   ReactionStatistics statistics = getStatisticsForActivity(activityId, origin);
  //   if (offset == 0) {
  //     return statistics;
  //   }

  //   final Map<String, int> newCounts = Map<String, int>.from(statistics.counts);
  //   final Map<String, bool> newUniqueUserReactions = Map<String, bool>.from(statistics.uniqueUserReactions);

  //   // Add defaults for each unique reaction kind
  //   for (final String kind in kUniqueReactionTypes) {
  //     newUniqueUserReactions[kind] = newUniqueUserReactions[kind] ?? false;
  //   }

  //   final bool newUniqueFlag = offset > 0;
  //   newUniqueUserReactions[reactionType] = newUniqueFlag;
  //   newCounts[reactionType] = (newCounts[reactionType] ?? 0) + offset;

  //   statistics = statistics.copyWith(
  //     counts: newCounts,
  //     uniqueUserReactions: newUniqueUserReactions,
  //   );

  //   final String expectedCacheKey = ReactionStatistics.buildCacheKey(statistics);
  //   cacheController.add(key: expectedCacheKey, value: statistics);

  //   return statistics;
  // }

  void addReactionToStatistics({
    required String activityId,
    required String origin,
    required Reaction reaction,
  }) {
    final Logger logger = ref.read(loggerProvider);
    final String reactionId = reaction.flMeta?.id ?? '';
    if (reactionId.isEmpty) {
      logger.w('CommunitiesController - addReactionToStatistics - No reaction id found for activity: $activityId');
      return;
    }

    final ReactionStatistics statistics = getStatisticsForActivity(activityId, origin);
    final Map<String, int> newCounts = Map<String, int>.from(statistics.counts);

    final String reactionType = ReactionType.toJson(reaction.kind);
    newCounts[reactionType] = (newCounts[reactionType] ?? 0) + 1;

    final Map<String, bool> newUniqueUserReactions = Map<String, bool>.from(statistics.uniqueUserReactions);
    newUniqueUserReactions[reactionType] = true;

    final ReactionStatistics newStatistics = statistics.copyWith(
      counts: newCounts,
      uniqueUserReactions: newUniqueUserReactions,
    );

    final String expectedCacheKey = ReactionStatistics.buildCacheKey(newStatistics);

    logger.i('CommunitiesController - addReactionToStatistics - Added reaction to statistics: $activityId, $origin, $reactionId');
  }

  void updateReactionInStatistics({
    required String activityId,
    required String origin,
    required Reaction reaction,
  }) {
    final Logger logger = ref.read(loggerProvider);
    final ReactionsController reactionsController = ref.read(reactionsControllerProvider.notifier);

    final String reactionId = reaction.flMeta?.id ?? '';
    if (reactionId.isEmpty) {
      logger.w('CommunitiesController - updateReactionInStatistics - No reaction id found for activity: $activityId');
      return;
    }

    logger.i('CommunitiesController - updateReactionInStatistics - Updated reaction in statistics: $activityId, $origin, $reactionId');
  }

  void removeReactionFromStatistics({
    required String activityId,
    required String origin,
    required Reaction reaction,
  }) {
    final Logger logger = ref.read(loggerProvider);
    final ReactionsController reactionsController = ref.read(reactionsControllerProvider.notifier);

    final String reactionId = reaction.flMeta?.id ?? '';
    if (reactionId.isEmpty) {
      logger.w('CommunitiesController - removeReactionFromStatistics - No reaction id found for activity: $activityId');
      return;
    }

    logger.i('CommunitiesController - removeReactionFromStatistics - Removed reaction from statistics: $activityId, $origin, $reactionId');
  }

  bool isActivityBookmarked(String activityId, String feed) {
    final ReactionsController reactionsController = ref.read(reactionsControllerProvider.notifier);
    return reactionsController.getStatisticsForActivity(activityId, feed).uniqueUserReactions['bookmark'] ?? false;
  }

  Future<void> bookmarkActivity({
    required String activityId,
    required String origin,
  }) async {
    final Logger logger = ref.read(loggerProvider);
    final UserController userController = ref.read(userControllerProvider.notifier);
    logger.i('CommunitiesController - bookmarkActivity - Bookmarking activity: $activityId');

    if (userController.currentUser == null) {
      throw Exception('User is null');
    }

    final ReactionApiService reactionApiService = await ref.read(reactionApiServiceProvider.future);
    await reactionApiService.postReaction(
      activityId: activityId,
      origin: origin,
      kind: 'bookmark',
    );

    logger.i('CommunitiesController - bookmarkActivity - Bookmarked activity: $activityId');
  }

  Future<void> removeBookmarkActivity({
    required String activityId,
    required String origin,
    required String uid,
  }) async {
    final Logger logger = ref.read(loggerProvider);
    logger.i('CommunitiesController - removeBookmarkActivity - Removing bookmark from activity: $activityId');

    final ReactionApiService reactionApiService = await ref.read(reactionApiServiceProvider.future);
    final ReactionsController reactionsController = ref.read(reactionsControllerProvider.notifier);
    final CacheController cacheController = ref.read(cacheControllerProvider);
    final List<Reaction> reactions = reactionsController.getOwnReactionsForFeedActivity(
      activityId: activityId,
      origin: origin,
      kind: 'bookmark',
      uid: uid,
    );

    if (reactions.isEmpty) {
      throw Exception('No bookmark found for activity: $activityId');
    }

    final Reaction reaction = reactions.first;
    final String reactionId = reaction.flMeta?.id ?? '';
    if (reactionId.isEmpty) {
      throw Exception('No reaction id found for activity: $activityId');
    }

    await reactionApiService.deleteReaction(reactionId: reactionId);
    cacheController.remove(reactionId);
    logger.i('CommunitiesController - removeBookmarkActivity - Removed bookmark from activity: $activityId');
  }

  bool hasLikedActivity({
    required String uid,
    required String activityId,
    required String origin,
  }) {
    final ReactionsController reactionsController = ref.read(reactionsControllerProvider.notifier);
    return reactionsController.getStatisticsForActivity(activityId, feed).uniqueUserReactions['like'] ?? false;
  }

  Future<void> likeActivity({
    required String activityId,
    required String origin,
    required String uid,
  }) async {
    final Logger logger = ref.read(loggerProvider);
    logger.i('CommunitiesController - likeActivity - Liking activity: $activityId');

    final ReactionApiService reactionApiService = await ref.read(reactionApiServiceProvider.future);
    await reactionApiService.postReaction(
      activityId: activityId,
      origin: origin,
      kind: 'like',
    );

    logger.i('CommunitiesController - likeActivity - Liked activity: $activityId');
  }

  Future<void> unlikeActivity({
    required String activityId,
    required String origin,
    required String uid,
  }) async {
    final Logger logger = ref.read(loggerProvider);

    logger.i('CommunitiesController - unlikeActivity - Removing like from activity: $activityId');
    final ReactionApiService reactionApiService = await ref.read(reactionApiServiceProvider.future);
    final ReactionsController reactionsController = ref.read(reactionsControllerProvider.notifier);
    final CacheController cacheController = ref.read(cacheControllerProvider);
    final List<Reaction> reactions = reactionsController.getOwnReactionsForFeedActivity(
      activityId: activityId,
      origin: origin,
      uid: uid,
      kind: 'like',
    );

    if (reactions.isEmpty) {
      throw Exception('No like found for activity: $activityId');
    }

    final Reaction reaction = reactions.first;
    final String reactionId = reaction.flMeta?.id ?? '';
    if (reactionId.isEmpty) {
      throw Exception('No reaction id found for activity: $activityId');
    }

    await reactionApiService.deleteReaction(reactionId: reactionId);
    cacheController.remove(reactionId);

    logger.i('CommunitiesController - unlikeActivity - Removed like from activity: $activityId');
  }
}
