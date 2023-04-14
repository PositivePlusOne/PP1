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
      connectionCount: json['connectionCount'] as int? ?? 0,
      locationSkipped: json['locationSkipped'] as bool? ?? false,
      location: json['location'] == null
          ? null
          : ProfileGeoPoint.fromJson(json['location'] as Map<String, dynamic>),
      flMeta: json['_fl_meta_'] == null
          ? null
          : FlMeta.fromJson(json['_fl_meta_'] as Map<String, dynamic>),
      relationship: json['relationship'] == null
          ? null
          : FlRelationship.fromJson(
              json['relationship'] as Map<String, dynamic>),
      referenceImages: json['referenceImages'],
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
      'connectionCount': instance.connectionCount,
      'locationSkipped': instance.locationSkipped,
      'location': instance.location?.toJson(),
      '_fl_meta_': instance.flMeta?.toJson(),
      'relationship': instance.relationship?.toJson(),
      'referenceImages': instance.referenceImages,
    };

_$_ProfileGeoPoint _$$_ProfileGeoPointFromJson(Map<String, dynamic> json) =>
    _$_ProfileGeoPoint(
      latitude: (json['_latitude'] as num).toDouble(),
      longitude: (json['_longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$$_ProfileGeoPointToJson(_$_ProfileGeoPoint instance) =>
    <String, dynamic>{
      '_latitude': instance.latitude,
      '_longitude': instance.longitude,
    };
