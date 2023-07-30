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
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      markdown: json['markdown'] as String? ?? '',
      place: json['place'] == null
          ? null
          : PositivePlace.fromJson(json['place'] as Map<String, dynamic>),
      websiteUrl: json['websiteUrl'] as String? ?? '',
      logoUrl: json['logoUrl'] as String? ?? '',
      profile: firestoreDocRefFromJson(json['profile']),
      services: (json['services'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$_GuidanceDirectoryEntryToJson(
        _$_GuidanceDirectoryEntry instance) =>
    <String, dynamic>{
      '_fl_meta_': instance.flMeta?.toJson(),
      'title': instance.title,
      'description': instance.description,
      'markdown': instance.markdown,
      'place': instance.place?.toJson(),
      'websiteUrl': instance.websiteUrl,
      'logoUrl': instance.logoUrl,
      'profile': firestoreDocRefToJson(instance.profile),
      'services': instance.services,
    };
