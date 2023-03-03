// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserProfile _$$_UserProfileFromJson(Map<String, dynamic> json) =>
    _$_UserProfile(
      id: json['id'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      fcmToken: json['fcmToken'] as String? ?? '',
      referenceImageURL: json['referenceImageURL'] as String? ?? '',
    );

Map<String, dynamic> _$$_UserProfileToJson(_$_UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'fcmToken': instance.fcmToken,
      'referenceImageURL': instance.referenceImageURL,
    };
