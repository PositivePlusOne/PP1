// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_location.freezed.dart';
part 'user_location.g.dart';

@freezed
class UserLocation with _$UserLocation {
  const factory UserLocation({
    @JsonKey(name: '_latitude') required num latitude,
    @JsonKey(name: '_longitude') required num longitude,
  }) = _UserLocation;

  factory UserLocation.fromJson(Map<String, dynamic> json) => _$UserLocationFromJson(json);

  static UserLocation? fromJsonSafe(dynamic json) {
    if (json is! Map<String, Object?>) {
      return null;
    }

    if (!json.containsKey('_latitude') || json['_latitude'] is! num) {
      return null;
    }

    if (!json.containsKey('_longitude') || json['_longitude'] is! num) {
      return null;
    }

    return _$UserLocationFromJson(json);
  }
}
