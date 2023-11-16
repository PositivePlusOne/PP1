// Dart imports:
import 'dart:async';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/extensions/activity_extensions.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/services/reaction_api_service.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/state/positive_reactions_state.dart';

part 'reactions_controller.freezed.dart';
part 'reactions_controller.g.dart';

@freezed
class ReactionsControllerState with _$ReactionsControllerState {
  const factory ReactionsControllerState() = _ReactionsControllerState;
  factory ReactionsControllerState.initialState() => const ReactionsControllerState();
}

@Riverpod(keepAlive: true)
class ReactionsController extends _$ReactionsController {
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

  bool isUniqueReactionKind(String kind) {
    return kUniqueReactionTypes.contains(kind);
  }

  List<String> buildExpectedUniqueReactionKeysForActivityAndProfile({
    required Activity? activity,
    required Profile? currentProfile,
  }) {
    final List<String> cacheKeys = [];
    if (currentProfile?.flMeta?.id?.isEmpty ?? true) {
      return cacheKeys;
    }

    for (final String uniqueKind in kUniqueReactionTypes) {
      final ReactionType reactionType = ReactionType.fromJson(uniqueKind);
      final Reaction stubReaction = Reaction(
        kind: reactionType,
        userId: currentProfile?.flMeta?.id ?? '',
        activityId: activity?.flMeta?.id ?? '',
      );

      final String cacheKey = buildExpectedReactionKey(stubReaction);
      cacheKeys.add(cacheKey);
    }

    return cacheKeys;
  }

  String buildExpectedReactionKey(Reaction reaction) {
    if (reaction.flMeta?.id?.isNotEmpty ?? false) {
      return reaction.flMeta!.id!;
    }

    return 'reaction:${ReactionType.toJson(reaction.kind)}:${reaction.activityId}:${reaction.reactionId}:${reaction.userId}';
  }

  String buildExpectedStatisticsCacheKey({
    required String activityId,
  }) {
    return 'statistics:activity:$activityId';
  }

  ReactionStatistics getStatisticsForActivity({
    required String activityId,
  }) {
    final CacheController cacheController = ref.read(cacheControllerProvider);
    final String cacheKey = buildExpectedStatisticsCacheKey(
      activityId: activityId,
    );

    final ReactionStatistics? statistics = cacheController.get(cacheKey);
    if (statistics != null) {
      return statistics;
    }

    final ReactionStatistics newStatistics = ReactionStatistics.newEntry(activityId);
    cacheController.add(key: cacheKey, value: newStatistics, metadata: newStatistics.flMeta);

    return newStatistics;
  }

  PositiveReactionsState getPositiveReactionsStateForActivity({
    required Activity activity,
    required Profile? currentProfile,
  }) {
    final String activityId = activity.flMeta?.id ?? '';
    final String currentProfileId = currentProfile?.flMeta?.id ?? '';
    final Logger logger = ref.read(loggerProvider);
    if (activityId.isEmpty || currentProfileId.isEmpty) {
      logger.w('Cannot build positive reactions state for activity: $activityId and profile: $currentProfileId');
      return PositiveReactionsState.createNewFeedState('', '');
    }

    final CacheController cacheController = ref.read(cacheControllerProvider);
    final String cacheKey = PositiveReactionsState.buildReactionsCacheKey(
      activityId: activityId,
      profileId: currentProfileId,
    );

    // Check if we have the state in the cache, if not, add it
    final PositiveReactionsState? cachedState = cacheController.get(cacheKey);
    if (cachedState != null) {
      return cachedState;
    }

    logger.i('Adding positive reactions state to cache: $cacheKey');
    final PositiveReactionsState state = PositiveReactionsState.createNewFeedState(activityId, currentProfileId);
    cacheController.add(key: cacheKey, value: state);

    return state;
  }

  List<Reaction> getOwnReactionsForActivityAndProfile({
    required Activity activity,
    required Profile? currentProfile,
  }) {
    final String currentProfileId = currentProfile?.flMeta?.id ?? '';
    if (currentProfileId.isEmpty) {
      return [];
    }

    final PositiveReactionsState state = getPositiveReactionsStateForActivity(
      activity: activity,
      currentProfile: currentProfile,
    );

    return state.pagingController.itemList?.where((reaction) {
          return reaction.userId == currentProfileId;
        }).toList() ??
        [];
  }

  Future<void> bookmarkActivity({
    required String activityId,
  }) async {
    final Logger logger = ref.read(loggerProvider);
    logger.i('CommunitiesController - bookmarkActivity - Bookmarking activity: $activityId');

    final ReactionApiService reactionApiService = await ref.read(reactionApiServiceProvider.future);
    await reactionApiService.postReaction(
      activityId: activityId,
      kind: 'bookmark',
    );

    logger.i('CommunitiesController - bookmarkActivity - Bookmarked activity: $activityId');
  }

  Future<void> removeBookmarkActivity({
    required Activity activity,
    required Profile? currentProfile,
    required PositiveReactionsState? reactionsFeedState,
  }) async {
    final Logger logger = ref.read(loggerProvider);
    logger.i('CommunitiesController - removeBookmarkActivity - Removing bookmark from activity: $activity');

    final ReactionApiService reactionApiService = await ref.read(reactionApiServiceProvider.future);
    final CacheController cacheController = ref.read(cacheControllerProvider);
    final Reaction? bookmarkReaction = activity.getUniqueReaction(currentProfile: currentProfile, kind: const ReactionType.bookmark());

    if (bookmarkReaction == null) {
      throw Exception('No bookmark found for activity: $activity');
    }

    final String reactionId = bookmarkReaction.flMeta?.id ?? '';
    if (reactionId.isEmpty) {
      throw Exception('No reaction id found for activity: $activity');
    }

    await reactionApiService.deleteReaction(reactionId: reactionId);
    cacheController.remove(reactionId);

    logger.i('CommunitiesController - removeBookmarkActivity - Removed bookmark from activity: $activity');
  }

  Future<void> likeActivity({
    required String activityId,
  }) async {
    final Logger logger = ref.read(loggerProvider);
    logger.i('CommunitiesController - likeActivity - Liking activity: $activityId');

    final ReactionApiService reactionApiService = await ref.read(reactionApiServiceProvider.future);
    await reactionApiService.postReaction(
      activityId: activityId,
      kind: 'like',
    );

    logger.i('CommunitiesController - likeActivity - Liked activity: $activityId');
  }

  Future<void> unlikeActivity({
    required Activity activity,
    required Profile? currentProfile,
  }) async {
    final Logger logger = ref.read(loggerProvider);

    logger.i('CommunitiesController - unlikeActivity - Removing like from activity: $activity');
    final ReactionApiService reactionApiService = await ref.read(reactionApiServiceProvider.future);
    final CacheController cacheController = ref.read(cacheControllerProvider);
    final Reaction? likeReaction = activity.getUniqueReaction(currentProfile: currentProfile, kind: const ReactionType.like());
    if (likeReaction == null) {
      throw Exception('No like found for activity: $activity');
    }

    final String reactionId = likeReaction.flMeta?.id ?? '';
    if (reactionId.isEmpty) {
      throw Exception('No reaction id found for activity: $activity');
    }

    await reactionApiService.deleteReaction(reactionId: reactionId);
    cacheController.remove(reactionId);

    logger.i('CommunitiesController - unlikeActivity - Removed like from activity: $activity');
  }

  Future<void> deleteComment({required Reaction comment, required Profile? currentProfile, required PositiveReactionsState feedState}) async {
    final Logger logger = ref.read(loggerProvider);

    logger.i('CommunitiesController - unlikeComment - Removing like from comment: $comment');
    final ReactionApiService reactionApiService = await ref.read(reactionApiServiceProvider.future);
    final CacheController cacheController = ref.read(cacheControllerProvider);

    final String reactionId = comment.flMeta?.id ?? '';
    if (reactionId.isEmpty) {
      throw Exception('No reaction id found for comment: $comment');
    }

    await reactionApiService.deleteReaction(reactionId: reactionId);
    cacheController.remove(reactionId);
    feedState.pagingController.itemList?.removeWhere((element) => element.flMeta?.id == reactionId);
    feedState.pagingController.notifyListeners();

    logger.i('CommunitiesController - unlikeComment - Removed like from comment: $comment');
  }
}
