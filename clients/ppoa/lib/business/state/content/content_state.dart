// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:ppoa/business/state/content/recommended_content.dart';

part 'content_state.freezed.dart';
part 'content_state.g.dart';

@freezed
class ContentState with _$ContentState {
  @JsonSerializable(
    fieldRename: FieldRename.snake,
  )
  const factory ContentState({
    required List<RecommendedContent> recommendedContent,
  }) = _ContentState;

  factory ContentState.empty() => const ContentState(
        recommendedContent: <RecommendedContent>[],
      );

  factory ContentState.fromJson(Map<String, Object?> json) => _$ContentStateFromJson(json);
}
