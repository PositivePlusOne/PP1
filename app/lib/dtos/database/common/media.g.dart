// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Media _$$_MediaFromJson(Map<String, dynamic> json) => _$_Media(
      name: json['name'] as String? ?? '',
      folder: json['folder'] as String? ?? '',
      url: json['url'] as String? ?? '',
      thumbnails: (json['thumbnails'] as List<dynamic>?)
              ?.map((e) => MediaThumbnail.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      type: $enumDecodeNullable(_$MediaTypeEnumMap, json['type']) ??
          MediaType.unknown,
      priority: json['priority'] as int? ?? kMediaPriorityDefault,
      isSensitive: json['isSensitive'] ?? false,
      isPrivate: json['isPrivate'] ?? false,
    );

Map<String, dynamic> _$$_MediaToJson(_$_Media instance) => <String, dynamic>{
      'name': instance.name,
      'folder': instance.folder,
      'url': instance.url,
      'thumbnails': instance.thumbnails.map((e) => e.toJson()).toList(),
      'type': _$MediaTypeEnumMap[instance.type]!,
      'priority': instance.priority,
      'isSensitive': instance.isSensitive,
      'isPrivate': instance.isPrivate,
    };

const _$MediaTypeEnumMap = {
  MediaType.unknown: 'unknown',
  MediaType.website_link: 'website_link',
  MediaType.ticket_link: 'ticket_link',
  MediaType.photo_link: 'photo_link',
  MediaType.video_link: 'video_link',
  MediaType.bucket_path: 'bucket_path',
};

_$_MediaThumbnail _$$_MediaThumbnailFromJson(Map<String, dynamic> json) =>
    _$_MediaThumbnail(
      width: json['width'] as int? ?? 0,
      height: json['height'] as int? ?? 0,
      url: json['url'] as String? ?? '',
    );

Map<String, dynamic> _$$_MediaThumbnailToJson(_$_MediaThumbnail instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'url': instance.url,
    };
