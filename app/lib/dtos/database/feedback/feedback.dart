// Package imports:
import 'package:app/dtos/database/feedback/feedback_type.dart';
import 'package:app/dtos/database/feedback/report_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:app/dtos/database/common/fl_meta.dart';

part 'feedback.freezed.dart';
part 'feedback.g.dart';

@freezed
class Feedback with _$Feedback {
  const factory Feedback({
    @JsonKey(name: '_fl_meta_') FlMeta? flMeta,
    @JsonKey(fromJson: FeedbackType.fromJson, toJson: FeedbackType.toJson) @Default(FeedbackType.unknown()) FeedbackType feedbackType,
    @JsonKey(fromJson: ReportType.fromJson, toJson: ReportType.toJson) @Default(ReportType.unknown()) ReportType reportType,
    @Default('') String content,
  }) = _Feedback;

  factory Feedback.empty() => const Feedback();

  factory Feedback.fromJson(Map<String, Object?> json) => _$FeedbackFromJson(json);
}
