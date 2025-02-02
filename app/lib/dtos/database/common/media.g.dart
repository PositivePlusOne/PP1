// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MediaImpl _$$MediaImplFromJson(Map<String, dynamic> json) => _$MediaImpl(
      name: json['name'] as String? ?? '',
      bucketPath: json['bucketPath'] as String? ?? '',
      url: json['url'] as String? ?? '',
      altText: json['altText'] as String? ?? '',
      width: json['width'] as int? ?? -1,
      height: json['height'] as int? ?? -1,
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

Map<String, dynamic> _$$MediaImplToJson(_$MediaImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'bucketPath': instance.bucketPath,
      'url': instance.url,
      'altText': instance.altText,
      'width': instance.width,
      'height': instance.height,
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
  MediaType.svg_link: 'svg_link',
  MediaType.video_link: 'video_link',
  MediaType.bucket_path: 'bucket_path',
};

_$MediaThumbnailImpl _$$MediaThumbnailImplFromJson(Map<String, dynamic> json) =>
    _$MediaThumbnailImpl(
      bucketPath: json['bucketPath'] as String? ?? '',
      url: json['url'] as String? ?? '',
      width: json['width'] as int? ?? -1,
      height: json['height'] as int? ?? -1,
    );

Map<String, dynamic> _$$MediaThumbnailImplToJson(
        _$MediaThumbnailImpl instance) =>
    <String, dynamic>{
      'bucketPath': instance.bucketPath,
      'url': instance.url,
      'width': instance.width,
      'height': instance.height,
    };
