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
    @JsonKey(fromJson: stringSetFromJson) @Default({}) Set<String> tags,
    @JsonKey(fromJson: stringSetFromJson) @Default({}) Set<String> featureFlags,
    @JsonKey(fromJson: stringSetFromJson) @Default({}) Set<String> companySectors,
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

  /// private keys for the data as expected from the data store
  static const kInternalPostKey = 'post';
  static const kInternalShareKey = 'share';
  static const kInternalFollowersKey = 'follow';
  static const kInternalFollowingKey = 'following';
  static const kInternalPromotionsPermittedKey = 'promotionsPermitted';

  /// public facing key into the data as created and returned from [buildData] function on this class
  static const kPostsKey = 'Posts';

  /// public facing key into the data as created and returned from [buildData] function on this class
  static const kSharesKey = 'Shares';

  /// public facing key into the data as created and returned from [buildData] function on this class
  static const kFollowersKey = 'Followers';

  /// public facing key into the data as created and returned from [buildData] function on this class
  static const kFollowingKey = 'Following';

  /// public facing key into the data as created and returned from [buildData] function on this class, data will be -1 when never permitted
  static const kPromotionsPermittedKey = 'PromotionsPermitted';

  /// static def for the value to signify that no promotions are ever allowed for this profile
  static const kPromotionsNotPermitted = -1;

  /// helper to build the raw data as expected from the internal map of data to the external map of data with keys with Caps and longer words
  /// and the data as strings instead of numbers
  static Map<String, String> buildData(ProfileStatistics? profileStatistics) {
    final Map<String, String> data = {
      kPostsKey: '0',
      kSharesKey: '0',
      kFollowersKey: '0',
      kFollowingKey: '0',
      // will initialise the promotions permitted to be an error value (they haven't even subscribed rather than have run out)
      kPromotionsPermittedKey: kPromotionsNotPermitted.toString(),
    };
    // map each internal data key to the external data expected
    for (final MapEntry<String, int> entry in profileStatistics?.counts.entries ?? []) {
      switch (entry.key) {
        case kInternalPostKey:
          data[kPostsKey] = entry.value.toString();
          break;
        case kInternalShareKey:
          data[kSharesKey] = entry.value.toString();
          break;
        case kInternalFollowersKey:
          data[kFollowersKey] = entry.value.toString();
          break;
        case kInternalFollowingKey:
          data[kFollowingKey] = entry.value.toString();
          break;
        case kInternalPromotionsPermittedKey:
          data[kPromotionsPermittedKey] = entry.value.toString();
          break;
      }
    }

    return data;
  }

  factory ProfileStatistics.fromJson(Map<String, Object?> json) => _$ProfileStatisticsFromJson(json);
}
