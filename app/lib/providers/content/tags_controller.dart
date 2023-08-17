// Dart imports:

// Package imports:
import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/activities/tags.dart';
import 'package:app/main.dart';
import 'package:app/providers/system/cache_controller.dart';

part 'tags_controller.freezed.dart';
part 'tags_controller.g.dart';

@freezed
class TagsControllerState with _$TagsControllerState {
  const factory TagsControllerState() = _TagsControllerState;

  factory TagsControllerState.initialState() => const TagsControllerState();
}

@Riverpod(keepAlive: true)
class TagsController extends _$TagsController {
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
}
