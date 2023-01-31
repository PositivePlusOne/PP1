// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recommended_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_RecommendedContent _$$_RecommendedContentFromJson(
        Map<String, dynamic> json) =>
    _$_RecommendedContent(
      contentTitle: json['content_title'] as String,
      contentCreatorDisplayName: json['content_creator_display_name'] as String,
      contentCreatorDisplayImage:
          json['content_creator_display_image'] as String,
      contentType:
          $enumDecodeNullable(_$ContentTypeEnumMap, json['content_type']) ??
              ContentType.na,
      eventLocation: json['event_location'] == null
          ? null
          : EventLocation.fromJson(
              json['event_location'] as Map<String, dynamic>),
      eventTime: json['event_time'] == null
          ? null
          : EventTime.fromJson(json['event_time'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_RecommendedContentToJson(
        _$_RecommendedContent instance) =>
    <String, dynamic>{
      'content_title': instance.contentTitle,
      'content_creator_display_name': instance.contentCreatorDisplayName,
      'content_creator_display_image': instance.contentCreatorDisplayImage,
      'content_type': _$ContentTypeEnumMap[instance.contentType]!,
      'event_location': instance.eventLocation,
      'event_time': instance.eventTime,
    };

const _$ContentTypeEnumMap = {
  ContentType.event: 'event',
  ContentType.na: 'na',
};
