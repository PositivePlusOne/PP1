// Dart imports:

// Dart imports:

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/main.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
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

  List<Reaction> getOwnReactionsForFeedActivity({
    required String activityId,
    required String origin,
    String? kind,
  }) {
    final ProfileController profileController = providerContainer.read(profileControllerProvider.notifier);
    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);
    final String userId = profileController.currentProfileId!;
    final List<Reaction> cachedReactions = cacheController.getAllFromCache<Reaction>().toList();
    final Iterable<Reaction> targetReactions = cachedReactions.where((element) {
      final String expectedKind = ReactionType.toJson(element.kind);
      return element.activityId == activityId && element.origin == origin && element.userId == userId && (kind == null || expectedKind == kind);
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
    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);
    final ReactionStatistics? cachedStatistics = cacheController.getFromCache(expectedCacheKey);
    if (cachedStatistics != null) {
      logger.i('getStatisticsForActivity: $activityId, $origin, found in cache');
      return cachedStatistics;
    }

    logger.i('getStatisticsForActivity: $activityId, $origin, not found in cache');
    cacheController.addToCache(key: expectedCacheKey, value: statistics);
    return statistics;
  }

  ReactionStatistics offsetReactionCountForActivity({
    required String activityId,
    required String userId,
    required String origin,
    required String reactionType,
    int offset = 1,
  }) {
    final Logger logger = providerContainer.read(loggerProvider);
    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);

    logger.i('offsetReactionCountForActivity: $activityId, $origin, $reactionType, $offset');
    ReactionStatistics statistics = getStatisticsForActivity(activityId, origin);
    if (offset == 0) {
      return statistics;
    }

    final Map<String, int> newCounts = Map<String, int>.from(statistics.counts);
    final Map<String, bool> newUniqueUserReactions = Map<String, bool>.from(statistics.uniqueUserReactions);

    // Add defaults for each unique reaction kind
    for (final String kind in kUniqueReactionTypes) {
      newUniqueUserReactions[kind] = newUniqueUserReactions[kind] ?? false;
    }

    final bool newUniqueFlag = offset > 0;
    newUniqueUserReactions[reactionType] = newUniqueFlag;
    newCounts[reactionType] = (newCounts[reactionType] ?? 0) + offset;

    statistics = statistics.copyWith(
      counts: newCounts,
      uniqueUserReactions: newUniqueUserReactions,
    );

    final String expectedCacheKey = ReactionStatistics.buildCacheKey(statistics);
    cacheController.addToCache(key: expectedCacheKey, value: statistics);

    return statistics;
  }
}
