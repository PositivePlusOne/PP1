// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guidance_directory_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_GuidanceDirectoryEntry _$$_GuidanceDirectoryEntryFromJson(
        Map<String, dynamic> json) =>
    _$_GuidanceDirectoryEntry(
      flMeta: json['_fl_meta_'] == null
          ? null
          : FlMeta.fromJson(json['_fl_meta_'] as Map<String, dynamic>),
      documentId: json['id'] as String,
      title: json['title'] as String? ?? '',
      blurb: json['blurb'] as String? ?? '',
      body: json['body'] as String? ?? '',
      websiteUrl: json['websiteUrl'] as String? ?? '',
      logoUrl: json['logoUrl'] as String? ?? '',
      profile: json['profile'] as String? ?? '',
      services: (json['services'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$_GuidanceDirectoryEntryToJson(
        _$_GuidanceDirectoryEntry instance) =>
    <String, dynamic>{
      '_fl_meta_': instance.flMeta?.toJson(),
      'id': instance.documentId,
      'title': instance.title,
      'blurb': instance.blurb,
      'body': instance.body,
      'websiteUrl': instance.websiteUrl,
      'logoUrl': instance.logoUrl,
      'profile': instance.profile,
      'services': instance.services,
    };
