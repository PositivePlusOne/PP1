// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserProfile _$$_UserProfileFromJson(Map<String, dynamic> json) =>
    _$_UserProfile(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      fcmToken: json['fcmToken'] as String? ?? '',
      connectionCount: json['connectionCount'] as int? ?? 0,
      locale: json['locale'] as String? ?? 'en-GB',
      flMeta: json['_fl_meta_'] == null
          ? null
          : FlMeta.fromJson(json['_fl_meta_'] as Map<String, dynamic>),
      referenceImages: json['referenceImages'] ?? const [],
    );

Map<String, dynamic> _$$_UserProfileToJson(_$_UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'displayName': instance.displayName,
      'fcmToken': instance.fcmToken,
      'connectionCount': instance.connectionCount,
      'locale': instance.locale,
      '_fl_meta_': instance.flMeta,
      'referenceImages': instance.referenceImages,
    };
