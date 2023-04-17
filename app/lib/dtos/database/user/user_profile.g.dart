// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserProfile _$$_UserProfileFromJson(Map<String, dynamic> json) =>
    _$_UserProfile(
      id: json['id'] as String? ?? '',
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
      locationSkipped: json['locationSkipped'] as bool? ?? false,
      location: UserLocation.fromJsonSafe(json['location']),
      flMeta: json['_fl_meta_'] == null
          ? null
          : FlMeta.fromJson(json['_fl_meta_'] as Map<String, dynamic>),
      referenceImage: json['referenceImage'] as String? ?? '',
      profileImage: json['profileImage'] as String? ?? '',
      biography: json['biography'] as String? ?? '',
      connectionCount: json['connectionCount'] as int? ?? 0,
      followerCount: json['followerCount'] as int? ?? 0,
    );

Map<String, dynamic> _$$_UserProfileToJson(_$_UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
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
      'locationSkipped': instance.locationSkipped,
      'location': instance.location?.toJson(),
      '_fl_meta_': instance.flMeta?.toJson(),
      'referenceImage': instance.referenceImage,
      'profileImage': instance.profileImage,
      'biography': instance.biography,
      'connectionCount': instance.connectionCount,
      'followerCount': instance.followerCount,
    };
