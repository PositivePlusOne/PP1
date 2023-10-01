// Dart imports:
import 'dart:async';
import 'dart:collection';

// Package imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/helpers/cache_helpers.dart';
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
    required Activity activity,
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
        activityId: activity.flMeta?.id ?? '',
        origin: activity.publisherInformation?.originFeed ?? '',
      );

      final List<String> keys = buildExpectedCacheKeysForReaction(currentProfile, stubReaction);
      cacheKeys.addAll(keys);
    }

    return cacheKeys;
  }

  String buildExpectedReactionKey(Reaction reaction) {
    if (reaction.flMeta?.id?.isNotEmpty ?? false) {
      return reaction.flMeta!.id!;
    }

    return 'reaction:${reaction.kind}:${reaction.origin}:${reaction.activityId}:${reaction.reactionId}:${reaction.userId}';
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

  bool isActivityBookmarked(String activityId, String feed) {
    final ReactionsController reactionsController = ref.read(reactionsControllerProvider.notifier);
    return reactionsController.getStatisticsForActivity(activityId, feed).uniqueUserReactions['bookmark'] ?? false;
  }

  Future<void> bookmarkActivity({
    required String activityId,
    required String origin,
  }) async {
    final Logger logger = ref.read(loggerProvider);
    logger.i('CommunitiesController - bookmarkActivity - Bookmarking activity: $activityId');

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
