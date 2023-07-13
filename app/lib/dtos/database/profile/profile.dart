// Package imports:
import 'package:app/dtos/database/common/media.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:app/dtos/database/common/fl_meta.dart';
import '../../converters/profile_converters.dart';
import '../geo/positive_place.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

@freezed
class Profile with _$Profile {
  const factory Profile({
    @JsonKey(name: '_fl_meta_') FlMeta? flMeta,
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
    @Default(false) bool placeSkipped,
    PositivePlace? place,
    @Default('') String referenceImage,
    @Default('') String profileImage,
    @Default('') String biography,
    @Default([]) List<Media> media,
  }) = _Profile;

  factory Profile.empty() => const Profile();

  factory Profile.fromJson(Map<String, Object?> json) => _$ProfileFromJson(json);
}
