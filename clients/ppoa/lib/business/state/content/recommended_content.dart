// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:ppoa/business/state/content/event_location.dart';
import 'package:ppoa/business/state/content/event_time.dart';
import 'enumerations/content_type.dart';

part 'recommended_content.freezed.dart';
part 'recommended_content.g.dart';

@freezed
class RecommendedContent with _$RecommendedContent {
  @JsonSerializable(
    fieldRename: FieldRename.snake,
  )
  const factory RecommendedContent({
    required String contentTitle,
    required String contentCreatorDisplayName,
    required String contentCreatorDisplayImage,
    @Default(ContentType.na) ContentType contentType,
    EventLocation? eventLocation,
    EventTime? eventTime,
  }) = _RecommendedContent;

  factory RecommendedContent.fromJson(Map<String, Object?> json) => _$RecommendedContentFromJson(json);
}
