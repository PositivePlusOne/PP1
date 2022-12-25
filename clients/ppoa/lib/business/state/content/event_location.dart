// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_location.freezed.dart';
part 'event_location.g.dart';

@freezed
class EventLocation with _$EventLocation {
  @JsonSerializable(
    fieldRename: FieldRename.snake,
  )
  const factory EventLocation({
    @Default(double.nan) double eventLatitude,
    @Default(double.nan) double eventLongitude,
    @Default('') String locationFirstLine,
    @Default('') String locationCity,
    @Default('') String locationTown,
    @Default('') String locationCountry,
    @Default('') String locationZipCode,
  }) = _EventLocation;

  factory EventLocation.fromJson(Map<String, Object?> json) => _$EventLocationFromJson(json);
}
