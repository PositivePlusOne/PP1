// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_location.freezed.dart';
part 'user_location.g.dart';

@freezed
class UserLocation with _$UserLocation {
  const factory UserLocation({
    @Default(0.0) num latitude,
    @Default(0.0) num longitude,
  }) = _UserLocation;

  factory UserLocation.empty() => const UserLocation();
  factory UserLocation.fromJson(Map<String, Object?> json) => _$UserLocationFromJson(json);

  factory UserLocation.fromJsonSafe(Map<String, Object?> json) {
    if (!json.containsKey('latitude') || json['latitude'] is! num) {
      json['latitude'] = 0.0;
    }

    if (!json.containsKey('longitude') || json['longitude'] is! num) {
      json['longitude'] = 0.0;
    }

    return _$UserLocationFromJson(json);
  }
}
