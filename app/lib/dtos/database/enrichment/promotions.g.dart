// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Promotion _$$_PromotionFromJson(Map<String, dynamic> json) => _$_Promotion(
      flMeta: json['_fl_meta_'] == null
          ? null
          : FlMeta.fromJson(json['_fl_meta_'] as Map<String, dynamic>),
      title: json['title'] as String? ?? '',
      descriptionMarkdown: json['descriptionMarkdown'] as String? ?? '',
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
      startTime: dateFromUnknown(json['startTime']),
      endTime: dateFromUnknown(json['endTime']),
    );

Map<String, dynamic> _$$_PromotionToJson(_$_Promotion instance) =>
    <String, dynamic>{
      '_fl_meta_': instance.flMeta?.toJson(),
      'title': instance.title,
      'descriptionMarkdown': instance.descriptionMarkdown,
      'link': instance.link,
      'linkText': instance.linkText,
      'owners': instance.owners.map((e) => e.toJson()).toList(),
      'activities': instance.activities.map((e) => e.toJson()).toList(),
      'startTime': dateToUnknown(instance.startTime),
      'endTime': dateToUnknown(instance.endTime),
    };

_$_PromotionOwner _$$_PromotionOwnerFromJson(Map<String, dynamic> json) =>
    _$_PromotionOwner(
      activityId: json['activityId'] as String? ?? '',
    );

Map<String, dynamic> _$$_PromotionOwnerToJson(_$_PromotionOwner instance) =>
    <String, dynamic>{
      'activityId': instance.activityId,
    };

_$_PromotedActivity _$$_PromotedActivityFromJson(Map<String, dynamic> json) =>
    _$_PromotedActivity(
      activityId: json['activityId'] as String? ?? '',
    );

Map<String, dynamic> _$$_PromotedActivityToJson(_$_PromotedActivity instance) =>
    <String, dynamic>{
      'activityId': instance.activityId,
    };
