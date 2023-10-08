// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProfileImpl _$$ProfileImplFromJson(Map<String, dynamic> json) =>
    _$ProfileImpl(
      flMeta: json['_fl_meta_'] == null
          ? null
          : FlMeta.fromJson(json['_fl_meta_'] as Map<String, dynamic>),
      email: json['email'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      locale: json['locale'] as String? ?? 'en-GB',
      fcmToken: json['fcmToken'] as String? ?? '',
      name: json['name'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      birthday: json['birthday'] as String? ?? '',
      accentColor: json['accentColor'] as String? ?? '',
      hivStatus: json['hivStatus'] as String? ?? '',
      genders: json['genders'] == null
          ? const {}
          : stringSetFromJson(json['genders']),
      interests: json['interests'] == null
          ? const {}
          : stringSetFromJson(json['interests']),
      visibilityFlags: json['visibilityFlags'] == null
          ? const {}
          : stringSetFromJson(json['visibilityFlags']),
      featureFlags: json['featureFlags'] == null
          ? const {}
          : stringSetFromJson(json['featureFlags']),
      companySectors: json['companySectors'] == null
          ? const {}
          : stringSetFromJson(json['companySectors']),
      placeSkipped: json['placeSkipped'] as bool? ?? false,
      place: json['place'] == null
          ? null
          : PositivePlace.fromJson(json['place'] as Map<String, dynamic>),
      biography: json['biography'] as String? ?? '',
      media: (json['media'] as List<dynamic>?)
              ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ProfileImplToJson(_$ProfileImpl instance) =>
    <String, dynamic>{
      '_fl_meta_': instance.flMeta?.toJson(),
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'locale': instance.locale,
      'fcmToken': instance.fcmToken,
      'name': instance.name,
      'displayName': instance.displayName,
      'birthday': instance.birthday,
      'accentColor': instance.accentColor,
      'hivStatus': instance.hivStatus,
      'genders': instance.genders.toList(),
      'interests': instance.interests.toList(),
      'visibilityFlags': instance.visibilityFlags.toList(),
      'featureFlags': instance.featureFlags.toList(),
      'companySectors': instance.companySectors.toList(),
      'placeSkipped': instance.placeSkipped,
      'place': instance.place?.toJson(),
      'biography': instance.biography,
      'media': instance.media.map((e) => e.toJson()).toList(),
    };

_$ProfileStatisticsImpl _$$ProfileStatisticsImplFromJson(
        Map<String, dynamic> json) =>
    _$ProfileStatisticsImpl(
      flMeta: json['_fl_meta_'] == null
          ? null
          : FlMeta.fromJson(json['_fl_meta_'] as Map<String, dynamic>),
      profileId: json['profileId'] as String? ?? '',
      counts: (json['counts'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as int),
          ) ??
          const {},
    );

Map<String, dynamic> _$$ProfileStatisticsImplToJson(
        _$ProfileStatisticsImpl instance) =>
    <String, dynamic>{
      '_fl_meta_': instance.flMeta?.toJson(),
      'profileId': instance.profileId,
      'counts': instance.counts,
    };
