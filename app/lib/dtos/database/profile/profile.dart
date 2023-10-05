// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:app/dtos/database/common/fl_meta.dart';
import 'package:app/dtos/database/common/media.dart';
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
    @Default('') String biography,
    @Default([]) List<Media> media,
  }) = _Profile;

  factory Profile.empty() => const Profile();
  factory Profile.fromJson(Map<String, Object?> json) => _$ProfileFromJson(json);
}

@freezed
class ProfileStatistics with _$ProfileStatistics {
  const factory ProfileStatistics({
    @JsonKey(name: '_fl_meta_') FlMeta? flMeta,
    @Default('') String profileId,
    @Default({}) Map<String, int> counts,
  }) = _ProfileStatistics;

  static Map<String, String> buildData(ProfileStatistics? profileStatistics) {
    final Map<String, String> data = {
      'Posts': '0',
      'Shares': '0',
      'Followers': '0',
      'Following': '0',
    };

    for (final MapEntry<String, int> entry in profileStatistics?.counts.entries ?? []) {
      switch (entry.key) {
        case 'post':
          data['Posts'] = entry.value.toString();
          break;
        case 'share':
          data['Shares'] = entry.value.toString();
          break;
        case 'follow':
          data['Followers'] = entry.value.toString();
          break;
        case 'following':
          data['Following'] = entry.value.toString();
          break;
      }
    }

    return data;
  }

  factory ProfileStatistics.fromJson(Map<String, Object?> json) => _$ProfileStatisticsFromJson(json);
}
