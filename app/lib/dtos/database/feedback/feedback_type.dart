// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'feedback_type.freezed.dart';

@freezed
class FeedbackType with _$FeedbackType {
  const factory FeedbackType.unknown() = Unknown;
  const factory FeedbackType.userReport() = UserReport;
  const factory FeedbackType.genericFeedback() = GenericFeedback;

  static const List<FeedbackType> values = [
    Unknown(),
    UserReport(),
    GenericFeedback(),
  ];

  static FeedbackType fromJson(String value) {
    switch (value) {
      case 'unknown':
        return const Unknown();
      case 'userReport':
        return const UserReport();
      case 'genericFeedback':
        return const GenericFeedback();
      default:
        throw ArgumentError('Invalid feedback type');
    }
  }

  static String toJson(FeedbackType value) {
    return value.when(
      unknown: () => 'unknown',
      userReport: () => 'userReport',
      genericFeedback: () => 'genericFeedback',
    );
  }
}
