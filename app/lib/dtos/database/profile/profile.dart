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
    @JsonKey(fromJson: stringSetFromJson) @Default({}) Set<String> tags,
    @Default(false) bool placeSkipped,
    @Default(false) bool suppressEmail,
    PositivePlace? place,
    @Default('') String biography,
    @Default([]) List<Media> media,
    @JsonKey(fromJson: stringSetFromJson) @Default({}) Set<String> accountFlags,
    @JsonKey(fromJson: stringSetFromJson) @Default({}) Set<String> visibilityFlags,
    @JsonKey(fromJson: stringSetFromJson) @Default({}) Set<String> featureFlags,
    @JsonKey(fromJson: stringSetFromJson) @Default({}) Set<String> companySectors,
    @Default(ProfileCompanySize.unknown()) @JsonKey(fromJson: ProfileCompanySize.fromJson, toJson: ProfileCompanySize.toJson, name: 'companySize') ProfileCompanySize companySize,
    @Default(0) int availablePromotionsCount,
    @Default(0) int activePromotionsCount,
  }) = _Profile;

  factory Profile.empty() => const Profile();
  factory Profile.fromJson(Map<String, Object?> json) => _$ProfileFromJson(json);
}

@freezed
class ProfileCompanySize with _$ProfileCompanySize {
  const factory ProfileCompanySize.unknown() = _ProfileCompanySizeUnknown;
  const factory ProfileCompanySize.lessThanFive() = _ProfileCompanySizeLessThanFive;
  const factory ProfileCompanySize.lessThanTwentyFive() = _ProfileCompanySizeLessThanTwentyFive;
  const factory ProfileCompanySize.lessThanOneHundred() = _ProfileCompanySizeLessThanOneHundred;
  const factory ProfileCompanySize.moreThanOneHundred() = _ProfileCompanySizeMoreThanOneHundred;

  static String toLocale(ProfileCompanySize type) {
    return type.when(
      unknown: () => '',
      lessThanFive: () => '0 - 4',
      lessThanTwentyFive: () => '5 - 24',
      lessThanOneHundred: () => '25 - 99',
      moreThanOneHundred: () => '100+',
    );
  }

  static String toJson(ProfileCompanySize type) {
    return type.when(
      unknown: () => '',
      lessThanFive: () => 'lessThanFive',
      lessThanTwentyFive: () => 'lessThanTwentyFive',
      lessThanOneHundred: () => 'lessThanOneHundred',
      moreThanOneHundred: () => 'moreThanOneHundred',
    );
  }

  factory ProfileCompanySize.fromJson(String value) {
    switch (value) {
      case 'lessThanFive':
        return const ProfileCompanySize.lessThanFive();
      case 'lessThanTwentyFive':
        return const ProfileCompanySize.lessThanTwentyFive();
      case 'lessThanOneHundred':
        return const ProfileCompanySize.lessThanOneHundred();
      case 'moreThanOneHundred':
        return const ProfileCompanySize.moreThanOneHundred();
      default:
        return const ProfileCompanySize.unknown();
    }
  }
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
  static const kLikeKey = 'like';
  static const kShareKey = 'share';
  static const kFollowersKey = 'follower';
  static const kFollowingKey = 'follow';
  static const kPromotionsPermittedKey = 'promotionsPermitted';

  static const kGivenSuffix = '_given';
  static const kReceivedSuffix = '_received';

  /// static def for the value to signify that no promotions are ever allowed for this profile
  static const kPromotionsNotPermitted = -1;

  /// helper that will return a map of keys which are the internationalised titles of the items of data, the data
  /// being the value for each to display
  static Map<String, String> getDisplayItems(ProfileStatistics? profileStatistics, AppLocalizations localizations) {
    // we will return a map of data (keyed with the internationalised string) and the data being the value for each
    final Map<String, String> data = {
      localizations.page_profile_personal_data_posts: '0',
      localizations.page_profile_personal_data_likes: '0',
      localizations.page_profile_personal_data_followers: '0',
      // localizations.page_profile_personal_data_following: '0',
      // localizations.page_profile_personal_data_promotioms ommitted to as not to show when default (-1)
    };

    // map each internal data key to the external data expected
    for (final MapEntry<String, int> entry in profileStatistics?.counts.entries ?? []) {
      switch (entry.key) {
        //? Reaction counts have both given and received values
        case '$kLikeKey$kReceivedSuffix':
          data[localizations.page_profile_personal_data_likes] = entry.value.toString();
          break;
        case kPostKey:
          data[localizations.page_profile_personal_data_posts] = entry.value.toString();
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
