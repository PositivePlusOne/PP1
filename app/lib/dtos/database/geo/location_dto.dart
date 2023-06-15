// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_dto.freezed.dart';
part 'location_dto.g.dart';

@freezed
class LocationDto with _$LocationDto {
  const factory LocationDto({
    @Default(0.0) num latitude,
    @Default(0.0) num longitude,
    @Default('') String description,
    @Default('') String locality,
    @Default('') String subLocality,
    @Default('') String postalCode,
    @Default('') String administrativeArea,
    @Default('') String subAdministrativeArea,
    @Default('') String country,
  }) = _LocationDto;

  factory LocationDto.fromJson(Map<String, dynamic> json) => _$LocationDtoFromJson(json);

  static LocationDto? fromJsonSafe(dynamic json) {
    if (json is! Map<String, Object?>) {
      return null;
    }

    if (!json.containsKey('latitude') || json['latitude'] is! num) {
      return null;
    }

    if (!json.containsKey('longitude') || json['longitude'] is! num) {
      return null;
    }

    return _$LocationDtoFromJson(json);
  }
}
