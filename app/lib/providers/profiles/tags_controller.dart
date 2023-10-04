// Dart imports:

// Dart imports:
import 'dart:async';
import 'dart:collection';

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
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/providers/system/event/cache_key_updated_event.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/state/positive_feed_state.dart';

part 'tags_controller.freezed.dart';
part 'tags_controller.g.dart';

@freezed
class TagsControllerState with _$TagsControllerState {
  const factory TagsControllerState({
    required HashMap<String, Tag> allTags,
    required HashMap<String, Tag> popularTags,
    required HashMap<String, Tag> recentTags,
    required HashMap<String, Tag> topicTags,
  }) = _TagsControllerState;

  factory TagsControllerState.initialState() => TagsControllerState(
        allTags: HashMap<String, Tag>(),
        popularTags: HashMap<String, Tag>(),
        recentTags: HashMap<String, Tag>(),
        topicTags: HashMap<String, Tag>(),
      );
}

@Riverpod(keepAlive: true)
class TagsController extends _$TagsController {
  StreamSubscription<CacheKeyUpdatedEvent>? _onCacheKeyUpdatedSubscription;

  @override
  TagsControllerState build() {
    return TagsControllerState.initialState();
  }

  Iterable<Tag> get byAscendingPopularity {
    return state.allTags.values.where((Tag tag) => tag.popularity > 0).toList()..sort((Tag a, Tag b) => a.popularity.compareTo(b.popularity));
  }

  bool tagExists(String key) {
    return state.allTags.values.any((Tag tag) => tag.key == key);
  }

  Future<void> setupListeners() async {
    final EventBus eventBus = providerContainer.read(eventBusProvider);
    await _onCacheKeyUpdatedSubscription?.cancel();
    _onCacheKeyUpdatedSubscription = eventBus.on<CacheKeyUpdatedEvent>().listen(onCacheKeyUpdated);
  }

  void onCacheKeyUpdated(CacheKeyUpdatedEvent event) {
    if (event.value.runtimeType is Tag) {
      switch (event.eventType) {
        case CacheKeyUpdatedEventType.created:
          state = state.copyWith(allTags: state.allTags..[event.value.key] = event.value);
          break;
        case CacheKeyUpdatedEventType.updated:
          break;
        case CacheKeyUpdatedEventType.deleted:
          state = state.copyWith(allTags: state.allTags..remove(event.value.key));
          break;
      }
    }

    if (event.value.runtimeType is Activity) {
      switch (event.eventType) {
        case CacheKeyUpdatedEventType.created:
          addActivityToTagFeeds(event.value);
          break;
        case CacheKeyUpdatedEventType.updated:
          break;
        case CacheKeyUpdatedEventType.deleted:
          removeActivityFromTagFeeds(event.value);
          break;
      }
    }
  }

  void addActivityToTagFeeds(Activity activity) {
    final Logger logger = ref.read(loggerProvider);
    final List<String> tags = activity.enrichmentConfiguration?.tags ?? [];
    final CacheController cacheController = ref.read(cacheControllerProvider);
    logger.i('Adding activity to tag feeds: $tags');

    for (final String tag in tags) {
      final String expectedCacheKey = 'feeds:tags-$tag';
      final PositiveFeedState? feedState = cacheController.get<PositiveFeedState>(expectedCacheKey);
      if (feedState != null) {
        logger.d('Adding activity to tag feed $tag');
        feedState.pagingController.itemList?.insert(0, activity);
      }
    }
  }

  void removeActivityFromTagFeeds(Activity activity) {
    final Logger logger = ref.read(loggerProvider);
    final List<String> tags = activity.enrichmentConfiguration?.tags ?? [];
    final CacheController cacheController = ref.read(cacheControllerProvider);
    logger.i('Removing activity from tag feeds: $tags');

    for (final String tag in tags) {
      final String expectedCacheKey = 'feeds:tags-$tag';
      final PositiveFeedState? feedState = cacheController.get<PositiveFeedState>(expectedCacheKey);
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
    final HashMap<String, Tag> popularTags = HashMap<String, Tag>.fromIterable(tags, key: (tag) => tag?.key, value: (tag) => tag);
    state = state.copyWith(popularTags: popularTags);
  }

  void updateTopicTags(List<dynamic> rawStatuses) {
    final Logger logger = ref.read(loggerProvider);
    final List<Tag> tags = Tag.fromJsonList(rawStatuses);

    logger.d('Updating recommended tags with $tags');
    final HashMap<String, Tag> topicTags = HashMap<String, Tag>.fromIterable(tags, key: (tag) => tag?.key, value: (tag) => tag);
    state = state.copyWith(topicTags: topicTags);
  }

  void updateRecentTags(List<dynamic> rawStatuses) {
    final Logger logger = ref.read(loggerProvider);
    final List<Tag> tags = Tag.fromJsonList(rawStatuses);

    logger.d('Updating recommended tags with $tags');
    final HashMap<String, Tag> recentTags = HashMap<String, Tag>.fromIterable(tags, key: (tag) => tag?.key, value: (tag) => tag);
    state = state.copyWith(recentTags: recentTags);
  }

//? get Tags From Tags Controller, else return a new tag
  List<Tag> getTagsFromString(List<String> strings) {
    final List<Tag> tags = <Tag>[];

    for (final String string in strings) {
      final Tag? tag = state.allTags.values.firstWhereOrNull((Tag t) => t.key == string);
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
      final Tag? existingTag = state.recentTags[tag];
      if (existingTag == null) {
        final Tag? newTag = state.allTags.values.firstWhereOrNull((Tag t) => t.key == tag);
        if (newTag != null) {
          newTags.add(newTag);
        }
      }
    }

    logger.d('Adding tags to recent tags: $newTags');
    final HashMap<String, Tag> recentTags = HashMap<String, Tag>.from(state.recentTags);
    for (final Tag tag in newTags) {
      recentTags[tag.key] = tag;
    }
  }

  List<Tag> resolveTags(List<String> tagStrings) {
    final Logger logger = ref.read(loggerProvider);
    final List<Tag> tags = [];

    for (final String tag in tagStrings) {
      final Tag? existingTag = state.allTags[tag];
      if (existingTag != null) {
        tags.add(existingTag);
      }
    }

    if (tags.isEmpty) {
      logger.d('No tags to resolve');
      return tags;
    }

    logger.d('Resolved tags: $tags');
    return tags;
  }
}
