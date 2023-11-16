// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tags.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TagImpl _$$TagImplFromJson(Map<String, dynamic> json) => _$TagImpl(
      flMeta: json['_fl_meta_'] == null
          ? null
          : FlMeta.fromJson(json['_fl_meta_'] as Map<String, dynamic>),
      key: json['key'] as String? ?? '',
      fallback: json['fallback'] as String? ?? '',
      popularity: json['popularity'] as int? ?? -1,
      promoted: json['promoted'] as bool? ?? false,
      localizations: json['localizations'] == null
          ? const []
          : TagLocalization.fromJsonLocalizations(json['localizations']),
      topic: json['topic'] == null
          ? null
          : TagTopic.fromJson(json['topic'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$TagImplToJson(_$TagImpl instance) => <String, dynamic>{
      '_fl_meta_': instance.flMeta?.toJson(),
      'key': instance.key,
      'fallback': instance.fallback,
      'popularity': instance.popularity,
      'promoted': instance.promoted,
      'localizations':
          TagLocalization.toJsonLocalizations(instance.localizations),
      'topic': instance.topic?.toJson(),
    };

_$TagLocalizationImpl _$$TagLocalizationImplFromJson(
        Map<String, dynamic> json) =>
    _$TagLocalizationImpl(
      locale: json['locale'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );

Map<String, dynamic> _$$TagLocalizationImplToJson(
        _$TagLocalizationImpl instance) =>
    <String, dynamic>{
      'locale': instance.locale,
      'value': instance.value,
    };

_$TagTopicImpl _$$TagTopicImplFromJson(Map<String, dynamic> json) =>
    _$TagTopicImpl(
      fallback: json['fallback'] as String? ?? '',
      localizations: json['localizations'] == null
          ? const []
          : TagLocalization.fromJsonLocalizations(json['localizations']),
      isEnabled: json['isEnabled'] as bool? ?? false,
    );

Map<String, dynamic> _$$TagTopicImplToJson(_$TagTopicImpl instance) =>
    <String, dynamic>{
      'fallback': instance.fallback,
      'localizations':
          TagLocalization.toJsonLocalizations(instance.localizations),
      'isEnabled': instance.isEnabled,
    };
