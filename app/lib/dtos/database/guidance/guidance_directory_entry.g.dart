// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guidance_directory_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_GuidanceDirectoryEntry _$$_GuidanceDirectoryEntryFromJson(
        Map<String, dynamic> json) =>
    _$_GuidanceDirectoryEntry(
      documentId: json['id'] as String,
      title: json['title'] as String? ?? '',
      blurb: json['blurb'] as String? ?? '',
      body: json['body'] as String? ?? '',
      logoUrl: json['logoUrl'] as String? ?? '',
      flMeta: json['_fl_meta_'] == null
          ? null
          : FlMeta.fromJson(json['_fl_meta_'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_GuidanceDirectoryEntryToJson(
        _$_GuidanceDirectoryEntry instance) =>
    <String, dynamic>{
      'id': instance.documentId,
      'title': instance.title,
      'blurb': instance.blurb,
      'body': instance.body,
      'logoUrl': instance.logoUrl,
      '_fl_meta_': instance.flMeta?.toJson(),
    };
