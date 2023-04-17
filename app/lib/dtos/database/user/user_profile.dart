// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:app/dtos/database/common/fl_meta.dart';
import '../../converters/profile_converters.dart';
import '../geo/user_location.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    @Default('') String id,
    @Default('') String email,
    @Default('') String phoneNumber,
    @Default('en-GB') String locale,
    @Default('') String fcmToken,
    @Default('') String name,
    @Default('') String displayName,
    @Default('') String birthday,
    @Default('') String accentColor,
    @Default('') String hivStatus,
    @JsonKey(fromJson: stringSetFromJson) @Default({}) Set<String> genders,
    @JsonKey(fromJson: stringSetFromJson) @Default({}) Set<String> interests,
    @JsonKey(fromJson: stringSetFromJson) @Default({}) Set<String> visibilityFlags,
    @JsonKey(fromJson: stringSetFromJson) @Default({}) Set<String> featureFlags,
    @Default(false) bool locationSkipped,
    @JsonKey(fromJson: UserLocation.fromJsonSafe) UserLocation? location,
    @JsonKey(name: '_fl_meta_') FlMeta? flMeta,
    @Default('') String referenceImage,
    @Default('') String profileImage,
    @Default('') String biography,
    @Default(0) int connectionCount,
    @Default(0) int followerCount,
  }) = _UserProfile;

  factory UserProfile.empty() => const UserProfile();

  factory UserProfile.fromJson(Map<String, Object?> json) => _$UserProfileFromJson(json);
}
