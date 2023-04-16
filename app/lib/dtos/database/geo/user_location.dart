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

  static UserLocation? fromJsonSafe(dynamic json) {
    if (json is! Map<String, Object?>) {
      return null;
    }

    if (!json.containsKey('latitude') || json['latitude'] is! num) {
      return null;
    }

    if (!json.containsKey('longitude') || json['longitude'] is! num) {
      return null;
    }

    return _$UserLocationFromJson(json);
  }
}
