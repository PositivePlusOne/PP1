// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'positive_place.freezed.dart';
part 'positive_place.g.dart';

@freezed
class PositivePlace with _$PositivePlace {
  const factory PositivePlace({
    @Default('') String description,
    @Default('') String placeId,
    @JsonKey(name: 'latitudeCoordinates') double? latitude,
    @JsonKey(name: 'longitudeCoordinates') double? longitude,
    @Default(false) bool optOut,
  }) = _PositivePlace;

  factory PositivePlace.empty() => const PositivePlace();

  factory PositivePlace.fromJsonSafe(dynamic json) {
    if (json == null || json is! Map || json['description'] == null || json['placeId'] == null || json['optOut'] == null) {
      return PositivePlace.empty();
    }

    return PositivePlace.fromJson(json as Map<String, Object?>);
  }

  factory PositivePlace.fromJson(Map<String, Object?> json) => _$PositivePlaceFromJson(json);
}
