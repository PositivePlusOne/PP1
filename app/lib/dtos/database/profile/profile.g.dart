// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Profile _$$_ProfileFromJson(Map<String, dynamic> json) => _$_Profile(
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
      placeSkipped: json['placeSkipped'] as bool? ?? false,
      place: json['place'] == null
          ? null
          : PositivePlace.fromJson(json['place'] as Map<String, dynamic>),
      referenceImage: json['referenceImage'] as String? ?? '',
      profileImage: json['profileImage'] as String? ?? '',
      biography: json['biography'] as String? ?? '',
      media: (json['media'] as List<dynamic>?)
              ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$_ProfileToJson(_$_Profile instance) =>
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
      'placeSkipped': instance.placeSkipped,
      'place': instance.place?.toJson(),
      'referenceImage': instance.referenceImage,
      'profileImage': instance.profileImage,
      'biography': instance.biography,
      'media': instance.media.map((e) => e.toJson()).toList(),
    };
