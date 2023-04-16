// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fl_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_FlFile _$$_FlFileFromJson(Map<String, dynamic> json) => _$_FlFile(
      contentType: json['contentType'] as String? ?? 'application/octet-stream',
      file: json['file'] as String? ?? '',
      folderId: json['folderId'] as String? ?? '',
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? '',
      flMeta: json['_fl_meta_'] == null
          ? null
          : FlMeta.fromJson(json['_fl_meta_'] as Map<String, dynamic>),
      sizes: (json['sizes'] as List<dynamic>?)
          ?.map((e) => FlFileSize.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$_FlFileToJson(_$_FlFile instance) => <String, dynamic>{
      'contentType': instance.contentType,
      'file': instance.file,
      'folderId': instance.folderId,
      'id': instance.id,
      'type': instance.type,
      '_fl_meta_': instance.flMeta?.toJson(),
      'sizes': instance.sizes?.map((e) => e.toJson()).toList(),
    };

_$_FlFileSize _$$_FlFileSizeFromJson(Map<String, dynamic> json) =>
    _$_FlFileSize(
      path: json['path'] as String? ?? '',
      quality: (json['quality'] as num?)?.toDouble() ?? 0.0,
      height: json['height'] as int? ?? 0,
      width: json['width'] as int? ?? 0,
    );

Map<String, dynamic> _$$_FlFileSizeToJson(_$_FlFileSize instance) =>
    <String, dynamic>{
      'path': instance.path,
      'quality': instance.quality,
      'height': instance.height,
      'width': instance.width,
    };
