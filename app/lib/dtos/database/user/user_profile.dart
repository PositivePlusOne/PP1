// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:app/dtos/database/common/fl_meta.dart';
import '../../converters/profile_converters.dart';

part 'user_profile.freezed.dart';

part 'user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    @Default('') String id,
    @Default('') String email,
    @Default('') String phoneNumber,
    @Default('en-GB') String locale,
    @Default('') String name,
    @Default('') String displayName,
    @Default('') String birthday,
    @JsonKey(fromJson: stringListFromJson) @Default([]) List<String> genders,
    @JsonKey(fromJson: stringListFromJson) @Default(<String>[]) List<String> interests,
    @JsonKey(fromJson: stringListFromJson) @Default(<String>[]) List<String> visibilityFlags,
    @Default('') String fcmToken,
    @Default(0) int connectionCount,
    @JsonKey(name: '_fl_meta_') FlMeta? flMeta,
    Object? referenceImages, //* This can be an unknown type, as we only use it as a flag for the current user.
  }) = _UserProfile;

  factory UserProfile.empty() => const UserProfile();

  factory UserProfile.fromJson(Map<String, Object?> json) => _$UserProfileFromJson(json);
}
