// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Metadata _$$_MetadataFromJson(Map<String, dynamic> json) => _$_Metadata(
      description: json['description'] as String,
      mimeType: json['mime_type'] as String? ?? '',
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const <String>[],
    );

Map<String, dynamic> _$$_MetadataToJson(_$_Metadata instance) =>
    <String, dynamic>{
      'description': instance.description,
      'mime_type': instance.mimeType,
      'tags': instance.tags,
    };
