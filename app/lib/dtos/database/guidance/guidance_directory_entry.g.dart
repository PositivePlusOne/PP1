// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guidance_directory_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GuidanceDirectoryEntryImpl _$$GuidanceDirectoryEntryImplFromJson(
        Map<String, dynamic> json) =>
    _$GuidanceDirectoryEntryImpl(
      flMeta: json['_fl_meta_'] == null
          ? null
          : FlMeta.fromJson(json['_fl_meta_'] as Map<String, dynamic>),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      markdown: json['markdown'] as String? ?? '',
      place: json['place'] == null
          ? null
          : PositivePlace.fromJson(json['place'] as Map<String, dynamic>),
      websiteUrl: json['websiteUrl'] as String? ?? '',
      logoUrl: json['logoUrl'] as String? ?? '',
      services: json['services'] == null
          ? const []
          : GuidanceDirectoryEntryService.listFromJson(
              json['services'] as List),
    );

Map<String, dynamic> _$$GuidanceDirectoryEntryImplToJson(
        _$GuidanceDirectoryEntryImpl instance) =>
    <String, dynamic>{
      '_fl_meta_': instance.flMeta?.toJson(),
      'title': instance.title,
      'description': instance.description,
      'markdown': instance.markdown,
      'place': instance.place?.toJson(),
      'websiteUrl': instance.websiteUrl,
      'logoUrl': instance.logoUrl,
      'services': GuidanceDirectoryEntryService.listToJson(instance.services),
    };
