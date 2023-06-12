// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_type.freezed.dart';

@freezed
class ReportType with _$ReportType {
  const factory ReportType.unknown() = Unknown;
  const factory ReportType.inappropriateContent() = InappropriateContent;
  const factory ReportType.spam() = Spam;
  const factory ReportType.harassment() = Harassment;
  const factory ReportType.other() = Other;

  static const List<ReportType> values = [
    Unknown(),
    InappropriateContent(),
    Spam(),
    Harassment(),
    Other(),
  ];

  static ReportType fromJson(String value) {
    switch (value) {
      case 'unknown':
        return const Unknown();
      case 'inappropriateContent':
        return const InappropriateContent();
      case 'spam':
        return const Spam();
      case 'harassment':
        return const Harassment();
      case 'other':
        return const Other();
      default:
        throw ArgumentError('Invalid report type');
    }
  }

  static String toJson(ReportType value) {
    return value.when(
      unknown: () => 'unknown',
      inappropriateContent: () => 'inappropriateContent',
      spam: () => 'spam',
      harassment: () => 'harassment',
      other: () => 'other',
    );
  }
}
