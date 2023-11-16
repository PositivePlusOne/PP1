// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guidance_article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GuidanceArticleImpl _$$GuidanceArticleImplFromJson(
        Map<String, dynamic> json) =>
    _$GuidanceArticleImpl(
      documentId: json['id'] as String,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      locale: json['locale'] as String? ?? 'en',
      flMeta: json['_fl_meta_'] == null
          ? null
          : FlMeta.fromJson(json['_fl_meta_'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$GuidanceArticleImplToJson(
        _$GuidanceArticleImpl instance) =>
    <String, dynamic>{
      'id': instance.documentId,
      'title': instance.title,
      'body': instance.body,
      'locale': instance.locale,
      '_fl_meta_': instance.flMeta?.toJson(),
    };
