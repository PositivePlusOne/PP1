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
      owner:
          json['owner'] == null ? null : firestoreDocRefFromJson(json['owner']),
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
      'owner': firestoreDocRefToJson(instance.owner),
      'startTime': dateToUnknown(instance.startTime),
      'endTime': dateToUnknown(instance.endTime),
    };
