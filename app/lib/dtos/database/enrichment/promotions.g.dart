// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PromotionImpl _$$PromotionImplFromJson(Map<String, dynamic> json) =>
    _$PromotionImpl(
      flMeta: json['_fl_meta_'] == null
          ? null
          : FlMeta.fromJson(json['_fl_meta_'] as Map<String, dynamic>),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      link: json['link'] as String? ?? '',
      linkText: json['linkText'] as String? ?? '',
      ownerId: json['ownerId'] as String? ?? '',
      activityId: json['activityId'] as String? ?? '',
      chatPromotionEnabled: json['chatPromotionEnabled'] as bool? ?? false,
      postPromotionEnabled: json['postPromotionEnabled'] as bool? ?? false,
      locationRestrictions: json['locationRestrictions'] == null
          ? const []
          : PositiveRestrictedPlace.fromJsonList(
              json['locationRestrictions'] as List),
    );

Map<String, dynamic> _$$PromotionImplToJson(_$PromotionImpl instance) =>
    <String, dynamic>{
      '_fl_meta_': instance.flMeta?.toJson(),
      'title': instance.title,
      'description': instance.description,
      'link': instance.link,
      'linkText': instance.linkText,
      'ownerId': instance.ownerId,
      'activityId': instance.activityId,
      'chatPromotionEnabled': instance.chatPromotionEnabled,
      'postPromotionEnabled': instance.postPromotionEnabled,
      'locationRestrictions':
          PositiveRestrictedPlace.toJsonList(instance.locationRestrictions),
    };

_$PromotionOwnerImpl _$$PromotionOwnerImplFromJson(Map<String, dynamic> json) =>
    _$PromotionOwnerImpl(
      profileId: json['profileId'] as String? ?? '',
      role: json['role'] as String? ?? '',
    );

Map<String, dynamic> _$$PromotionOwnerImplToJson(
        _$PromotionOwnerImpl instance) =>
    <String, dynamic>{
      'profileId': instance.profileId,
      'role': instance.role,
    };

_$PromotedActivityImpl _$$PromotedActivityImplFromJson(
        Map<String, dynamic> json) =>
    _$PromotedActivityImpl(
      activityId: json['activityId'] as String? ?? '',
    );

Map<String, dynamic> _$$PromotedActivityImplToJson(
        _$PromotedActivityImpl instance) =>
    <String, dynamic>{
      'activityId': instance.activityId,
    };
