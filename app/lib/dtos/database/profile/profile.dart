// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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
    @JsonKey(fromJson: stringSetFromJson) @Default({}) Set<String> tags,
    @JsonKey(fromJson: stringSetFromJson) @Default({}) Set<String> featureFlags,
    @JsonKey(fromJson: stringSetFromJson) @Default({}) Set<String> companySectors,
    @Default(false) bool placeSkipped,
    PositivePlace? place,
    @Default('') String biography,
    @Default([]) List<Media> media,
    @Default(false) bool isBanned,
    @Default('') String bannedUntil,
    @Default('') String bannedReason,
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

  /// private keys for the data as expected from the data store
  static const kPostKey = 'post';
  static const kShareKey = 'share';
  static const kFollowersKey = 'follow';
  static const kFollowingKey = 'following';
  static const kPromotionsPermittedKey = 'promotionsPermitted';

  /// static def for the value to signify that no promotions are ever allowed for this profile
  static const kPromotionsNotPermitted = -1;

  /// helper that will return a map of keys which are the internationalised titles of the items of data, the data
  /// being the value for each to display
  static Map<String, String> getDisplayItems(ProfileStatistics? profileStatistics, AppLocalizations localizations) {
    // we will return a map of data (keyed with the internationalised string) and the data being the value for each
    final Map<String, String> data = {
      localizations.page_profile_personal_data_posts: '0',
      localizations.page_profile_personal_data_shares: '0',
      localizations.page_profile_personal_data_followers: '0',
      localizations.page_profile_personal_data_following: '0',
      // localizations.page_profile_personal_data_promotioms ommitted to as not to show when default (-1)
    };
    // map each internal data key to the external data expected
    for (final MapEntry<String, int> entry in profileStatistics?.counts.entries ?? []) {
      switch (entry.key) {
        case kPostKey:
          data[localizations.page_profile_personal_data_posts] = entry.value.toString();
          break;
        case kShareKey:
          data[localizations.page_profile_personal_data_shares] = entry.value.toString();
          break;
        case kFollowersKey:
          data[localizations.page_profile_personal_data_followers] = entry.value.toString();
          break;
        case kFollowingKey:
          data[localizations.page_profile_personal_data_following] = entry.value.toString();
          break;
        case kPromotionsPermittedKey:
          // we don't really want to show this data anywhere important
          break;
      }
    }
    // returning the map of data
    return data;
  }

  factory ProfileStatistics.fromJson(Map<String, Object?> json) => _$ProfileStatisticsFromJson(json);
}
