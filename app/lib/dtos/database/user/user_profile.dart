// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:app/dtos/database/common/fl_meta.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    @Default('') String id,
    @Default('') String name,
    @Default('') String displayName,
    @Default('') String fcmToken,
    @Default(0) int connectionCount,
    @Default('en-GB') String locale,
    @JsonKey(name: '_fl_meta_') FlMeta? flMeta,
    @Default([]) Object? referenceImages, //* This can be an unknown type, as we only use it as a flag for the current user.
  }) = _UserProfile;

  factory UserProfile.empty() => const UserProfile();

  factory UserProfile.fromJson(Map<String, Object?> json) => _$UserProfileFromJson(json);
}

extension UserProfileExtensions on UserProfile {
  bool get hasReferenceImages => referenceImages != null && referenceImages is Iterable && (referenceImages as Iterable).isNotEmpty;
}
