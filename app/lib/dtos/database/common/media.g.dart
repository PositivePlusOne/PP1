// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Media _$$_MediaFromJson(Map<String, dynamic> json) => _$_Media(
      name: json['name'] as String? ?? '',
      folder: json['folder'] as String? ?? '',
      type: $enumDecodeNullable(_$MediaTypeEnumMap, json['type']) ??
          MediaType.unknown,
      url: json['url'] as String? ?? '',
      priority: json['priority'] as int? ?? kMediaPriorityDefault,
    );

Map<String, dynamic> _$$_MediaToJson(_$_Media instance) => <String, dynamic>{
      'name': instance.name,
      'folder': instance.folder,
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
