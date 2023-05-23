// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MediaDto _$$_MediaDtoFromJson(Map<String, dynamic> json) => _$_MediaDto(
      type: $enumDecode(_$MediaTypeEnumMap, json['type']),
      url: json['url'] as String,
      priority: json['priority'] as int,
    );

Map<String, dynamic> _$$_MediaDtoToJson(_$_MediaDto instance) =>
    <String, dynamic>{
      'type': _$MediaTypeEnumMap[instance.type]!,
      'url': instance.url,
      'priority': instance.priority,
    };

const _$MediaTypeEnumMap = {
  MediaType.websiteLink: 'websiteLink',
  MediaType.ticketLink: 'ticketLink',
  MediaType.photoLink: 'photoLink',
  MediaType.videoLink: 'videoLink',
};
