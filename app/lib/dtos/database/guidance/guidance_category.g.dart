// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guidance_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_GuidanceCategory _$$_GuidanceCategoryFromJson(Map<String, dynamic> json) =>
    _$_GuidanceCategory(
      documentId: json['id'] as String,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      locale: json['locale'] as String? ?? 'en',
      parent: json['parent'] == null
          ? null
          : firestoreDocRefFromJson(json['parent']),
      priority: json['priority'] as int? ?? 0,
      flMeta: json['_fl_meta_'] == null
          ? null
          : FlMeta.fromJson(json['_fl_meta_'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_GuidanceCategoryToJson(_$_GuidanceCategory instance) =>
    <String, dynamic>{
      'id': instance.documentId,
      'title': instance.title,
      'body': instance.body,
      'locale': instance.locale,
      'parent': firestoreDocRefToJson(instance.parent),
      'priority': instance.priority,
      '_fl_meta_': instance.flMeta?.toJson(),
    };
