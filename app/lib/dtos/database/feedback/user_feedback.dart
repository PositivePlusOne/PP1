// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:app/dtos/database/common/fl_meta.dart';

part 'user_feedback.freezed.dart';
part 'user_feedback.g.dart';

@freezed
class UserFeedback with _$UserFeedback {
  const factory UserFeedback({
    @Default('') String content,
    @JsonKey(name: '_fl_meta_') FlMeta? flMeta,
  }) = _UserFeedback;

  factory UserFeedback.empty() => const UserFeedback();

  factory UserFeedback.fromJson(Map<String, Object?> json) => _$UserFeedbackFromJson(json);
}
