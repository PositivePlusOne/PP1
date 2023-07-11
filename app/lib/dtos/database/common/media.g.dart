// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MediaDto _$$_MediaDtoFromJson(Map<String, dynamic> json) => _$_MediaDto(
      type: $enumDecodeNullable(_$MediaTypeEnumMap, json['type']) ??
          MediaType.unknown,
      url: json['url'] as String? ?? '',
      priority: json['priority'] as int? ?? kMediaPriorityDefault,
    );

Map<String, dynamic> _$$_MediaDtoToJson(_$_MediaDto instance) =>
    <String, dynamic>{
      'type': _$MediaTypeEnumMap[instance.type]!,
      'url': instance.url,
      'priority': instance.priority,
    };

const _$MediaTypeEnumMap = {
  MediaType.unknown: 'unknown',
  MediaType.website_link: 'website_link',
  MediaType.ticket_link: 'ticket_link',
  MediaType.photo_link: 'photo_link',
  MediaType.video_link: 'video_link',
  MediaType.bucket_path: 'bucket_path',
};
