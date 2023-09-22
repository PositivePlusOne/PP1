// Dart imports:

// Dart imports:
import 'dart:async';

// Package imports:
import 'package:collection/collection.dart';
import 'package:event_bus/event_bus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/activities/tags.dart';
import 'package:app/main.dart';
import 'package:app/providers/events/content/activity_events.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/state/positive_feed_state.dart';

part 'tags_controller.freezed.dart';
part 'tags_controller.g.dart';

@freezed
class TagsControllerState with _$TagsControllerState {
  const factory TagsControllerState({
    @Default(<Tag>[]) List<Tag> popularTags,
    @Default(<Tag>[]) List<Tag> recentTags,
    @Default(<Tag>[]) List<Tag> topicTags,
  }) = _TagsControllerState;

  factory TagsControllerState.initialState() => const TagsControllerState();
}

@Riverpod(keepAlive: true)
class TagsController extends _$TagsController {
  StreamSubscription<ActivityCreatedEvent>? _onActivityCreatedSubscription;
  StreamSubscription<ActivityUpdatedEvent>? _onActivityUpdatedSubscription;
  StreamSubscription<ActivityDeletedEvent>? _onActivityDeletedSubscription;

  @override
  TagsControllerState build() {
    return TagsControllerState.initialState();
  }

  Iterable<Tag> get allTags {
    final CacheControllerState cacheControllerState = providerContainer.read(cacheControllerProvider);
    return cacheControllerState.cacheData.values.where((record) => record.value is Tag).map((record) => record.value as Tag);
  }

  Iterable<Tag> get byAscendingPopularity {
    return allTags.where((Tag tag) => tag.popularity > 0).toList()..sort((Tag a, Tag b) => a.popularity.compareTo(b.popularity));
  }

  bool tagExists(String key) {
    return allTags.any((Tag tag) => tag.key == key);
  }

  Future<void> setupListeners() async {
    await _onActivityCreatedSubscription?.cancel();
    await _onActivityUpdatedSubscription?.cancel();
    await _onActivityDeletedSubscription?.cancel();

    final EventBus eventBus = providerContainer.read(eventBusProvider);

    _onActivityCreatedSubscription = eventBus.on<ActivityCreatedEvent>().listen(onActivityCreated);
    _onActivityUpdatedSubscription = eventBus.on<ActivityUpdatedEvent>().listen(onActivityUpdated);
    _onActivityDeletedSubscription = eventBus.on<ActivityDeletedEvent>().listen(onActivityDeleted);
  }

  void onActivityCreated(ActivityCreatedEvent event) {
    addActivityToTagFeeds(event.activity);
  }

  void onActivityUpdated(ActivityUpdatedEvent event) {
    removeActivityFromTagFeeds(event.activity);
    addActivityToTagFeeds(event.activity);
  }

  void onActivityDeleted(ActivityDeletedEvent event) {
    removeActivityFromTagFeeds(event.activity);
  }

  void addActivityToTagFeeds(Activity activity) {
    final Logger logger = ref.read(loggerProvider);
    final List<String> tags = activity.enrichmentConfiguration?.tags ?? [];
    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);
    logger.i('Adding activity to tag feeds: $tags');

    for (final String tag in tags) {
      final String expectedCacheKey = 'feeds:tags-$tag';
      final PositiveFeedState? feedState = cacheController.getFromCache<PositiveFeedState>(expectedCacheKey);
      if (feedState != null) {
        logger.d('Adding activity to tag feed $tag');
        feedState.pagingController.itemList?.insert(0, activity);
      }
    }
  }

  void removeActivityFromTagFeeds(Activity activity) {
    final Logger logger = ref.read(loggerProvider);
    final List<String> tags = activity.enrichmentConfiguration?.tags ?? [];
    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);
    logger.i('Removing activity from tag feeds: $tags');

    for (final String tag in tags) {
      final String expectedCacheKey = 'feeds:tags-$tag';
      final PositiveFeedState? feedState = cacheController.getFromCache<PositiveFeedState>(expectedCacheKey);
      if (feedState != null) {
        logger.d('Removing activity from tag feed $tag');
        feedState.pagingController.itemList?.removeWhere((Activity a) => a.flMeta?.id == activity.flMeta?.id);
      }
    }
  }

  void updatePopularTags(List<dynamic> rawStatuses) {
    final Logger logger = ref.read(loggerProvider);
    final List<Tag> tags = Tag.fromJsonList(rawStatuses);

    logger.d('Updating recommended tags with $tags');
    state = state.copyWith(popularTags: tags);
  }

  void updateTopicTags(List<dynamic> rawStatuses) {
    final Logger logger = ref.read(loggerProvider);
    final List<Tag> tags = Tag.fromJsonList(rawStatuses);

    logger.d('Updating recommended tags with $tags');
    state = state.copyWith(topicTags: tags);
  }

  void updateRecentTags(List<dynamic> rawStatuses) {
    final Logger logger = ref.read(loggerProvider);
    final List<Tag> tags = Tag.fromJsonList(rawStatuses);

    logger.d('Updating recommended tags with $tags');
    state = state.copyWith(recentTags: tags);
  }

//? get Tags From Tags Controller, else return a new tag
  List<Tag> getTagsFromString(List<String> strings) {
    final List<Tag> tags = <Tag>[];

    for (final String string in strings) {
      final Tag? tag = allTags.firstWhereOrNull((Tag t) => t.key == string);
      if (tag != null) {
        tags.add(tag);
      } else {
        tags.add(
          Tag(
            key: string,
            fallback: string,
            localizations: <TagLocalization>[
              TagLocalization(
                locale: 'en',
                value: string,
              ),
            ],
          ),
        );
      }
    }

    return tags;
  }

  void addTagsToRecentTags({
    required List<String> tags,
  }) {
    final Logger logger = ref.read(loggerProvider);
    final List<Tag> newTags = [];

    if (tags.isEmpty) {
      logger.d('No tags to add to recent tags');
      return;
    }

    for (final String tag in tags) {
      final Tag? existingTag = state.recentTags.firstWhereOrNull((Tag t) => t.key == tag);
      if (existingTag == null) {
        final Tag? newTag = allTags.firstWhereOrNull((Tag t) => t.key == tag);
        if (newTag != null) {
          newTags.add(newTag);
        }
      }
    }

    logger.d('Adding tags to recent tags: $newTags');
    state = state.copyWith(recentTags: [...state.recentTags, ...newTags]);
  }

  List<Tag> resolveTags(List<String> tagStrings) {
    final Logger logger = ref.read(loggerProvider);
    final List<Tag> tags = [];

    for (final String tag in tagStrings) {
      for (final Tag existingTag in allTags) {
        if (existingTag.key == tag) {
          tags.add(existingTag);
        }
      }
    }

    logger.d('Resolved tags: $tags');
    return tags;
  }
}
