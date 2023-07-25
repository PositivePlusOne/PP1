// Dart imports:
import 'dart:async';
import 'dart:convert';

// Package imports:
import 'package:app/dtos/database/activities/tags.dart';
import 'package:app/main.dart';
import 'package:app/providers/system/event/cache_key_updated_event.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/extensions/json_extensions.dart';
import 'package:app/services/third_party.dart';
import '../../dtos/database/content/topic.dart';

part 'tags_controller.freezed.dart';
part 'tags_controller.g.dart';

@freezed
class TagsControllerState with _$TagsControllerState {
  const factory TagsControllerState({
    @Default([]) List<Tag> tags,
  }) = _TagsControllerState;

  factory TagsControllerState.initialState() => const TagsControllerState();
}

@Riverpod(keepAlive: true)
class TagsController extends _$TagsController {
  StreamSubscription<CacheKeyUpdatedEvent>? _cacheKeyUpdatedEventSubscription;

  @override
  TagsControllerState build() {
    return TagsControllerState.initialState();
  }

  Iterable<Tag> get byAscendingPopularity {
    return state.tags.where((Tag tag) => tag.popularity > 0).toList()..sort((Tag a, Tag b) => a.popularity.compareTo(b.popularity));
  }

  Future<void> setupListeners() async {
    final EventBus eventBus = providerContainer.read(eventBusProvider);

    await _cacheKeyUpdatedEventSubscription?.cancel();
    _cacheKeyUpdatedEventSubscription = eventBus.on<CacheKeyUpdatedEvent>().listen(onCacheUpdated);
  }

  void onCacheUpdated(CacheKeyUpdatedEvent event) {
    if (event.value is! Tag) {
      return;
    }

    final Logger logger = providerContainer.read(loggerProvider);
    final Tag tag = event.value as Tag;

    final List<Tag> tags = state.tags.map((Tag t) => t.flMeta?.id == tag.flMeta?.id ? tag : t).toList();
    logger.d('onCacheUpdated() - tags: $tags');
    state = state.copyWith(tags: tags);
  }
}
