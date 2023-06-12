// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:app/dtos/database/common/fl_meta.dart';
import 'package:app/dtos/database/feedback/feedback_type.dart';
import 'package:app/dtos/database/feedback/report_type.dart';

part 'feedback_wrapper.freezed.dart';
part 'feedback_wrapper.g.dart';

@freezed
class FeedbackWrapper with _$FeedbackWrapper {
  const factory FeedbackWrapper({
    @JsonKey(name: '_fl_meta_') FlMeta? flMeta,
    @JsonKey(fromJson: FeedbackType.fromJson, toJson: FeedbackType.toJson) @Default(FeedbackType.unknown()) FeedbackType feedbackType,
    @JsonKey(fromJson: ReportType.fromJson, toJson: ReportType.toJson) @Default(ReportType.unknown()) ReportType reportType,
    @Default('') String content,
  }) = _FeedbackWrapper;

  factory FeedbackWrapper.empty() => const FeedbackWrapper();

  factory FeedbackWrapper.fromJson(Map<String, Object?> json) => _$FeedbackWrapperFromJson(json);
}
