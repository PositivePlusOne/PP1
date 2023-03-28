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
      name: json['name'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      birthday: json['birthday'] as String? ?? '',
      interests: json['interests'] == null
          ? const <String>[]
          : stringListFromJson(json['interests'] as List?),
      visibilityFlags: json['visibilityFlags'] == null
          ? const <String>[]
          : stringListFromJson(json['visibilityFlags'] as List?),
      fcmToken: json['fcmToken'] as String? ?? '',
      connectionCount: json['connectionCount'] as int? ?? 0,
      flMeta: json['_fl_meta_'] == null
          ? null
          : FlMeta.fromJson(json['_fl_meta_'] as Map<String, dynamic>),
      referenceImages: json['referenceImages'],
    );

Map<String, dynamic> _$$_UserProfileToJson(_$_UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'locale': instance.locale,
      'name': instance.name,
      'displayName': instance.displayName,
      'birthday': instance.birthday,
      'interests': instance.interests,
      'visibilityFlags': instance.visibilityFlags,
      'fcmToken': instance.fcmToken,
      'connectionCount': instance.connectionCount,
      '_fl_meta_': instance.flMeta?.toJson(),
      'referenceImages': instance.referenceImages,
    };
