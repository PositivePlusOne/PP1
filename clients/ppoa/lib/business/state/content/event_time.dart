// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_time.freezed.dart';
part 'event_time.g.dart';

@freezed
class EventTime with _$EventTime {
  @JsonSerializable(
    fieldRename: FieldRename.snake,
  )
  const factory EventTime({
    required DateTime startTime,
    DateTime? endTime,
  }) = _EventTime;

  factory EventTime.fromJson(Map<String, Object?> json) => _$EventTimeFromJson(json);
}
