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
      link: json['link'] as String? ?? '',
      linkText: json['linkText'] as String? ?? '',
      owners: (json['owners'] as List<dynamic>?)
              ?.map((e) => PromotionOwner.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      activities: (json['activities'] as List<dynamic>?)
              ?.map((e) => PromotedActivity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      isActive: json['isActive'] as bool? ?? false,
      totalViewsSinceLastUpdate: json['totalViewsSinceLastUpdate'] as int? ?? 0,
      totalViewsAllotment: json['totalViewsAllotment'] as int? ?? 0,
      startDate: dateFromUnknown(json['startDate']),
      endDate: dateFromUnknown(json['endDate']),
    );

Map<String, dynamic> _$$PromotionImplToJson(_$PromotionImpl instance) =>
    <String, dynamic>{
      '_fl_meta_': instance.flMeta?.toJson(),
      'title': instance.title,
      'link': instance.link,
      'linkText': instance.linkText,
      'owners': instance.owners.map((e) => e.toJson()).toList(),
      'activities': instance.activities.map((e) => e.toJson()).toList(),
      'isActive': instance.isActive,
      'totalViewsSinceLastUpdate': instance.totalViewsSinceLastUpdate,
      'totalViewsAllotment': instance.totalViewsAllotment,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
    };

_$PromotionOwnerImpl _$$PromotionOwnerImplFromJson(Map<String, dynamic> json) =>
    _$PromotionOwnerImpl(
      activityId: json['activityId'] as String? ?? '',
    );

Map<String, dynamic> _$$PromotionOwnerImplToJson(
        _$PromotionOwnerImpl instance) =>
    <String, dynamic>{
      'activityId': instance.activityId,
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
