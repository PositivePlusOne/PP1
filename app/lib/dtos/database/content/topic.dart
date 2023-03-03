// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:app/dtos/database/common/fl_meta.dart';

part 'topic.freezed.dart';
part 'topic.g.dart';

@freezed
class Topic with _$Topic {
  const factory Topic({
    @Default('') String name,
    @Default('') String locale,
    @JsonKey(name: '_fl_meta_') FlMeta? flMeta,
  }) = _Topic;

  factory Topic.empty() => const Topic();

  factory Topic.fromJson(Map<String, Object?> json) => _$TopicFromJson(json);
}
