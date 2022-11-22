// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flamelink_localization.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_FlamelinkLocalization _$$_FlamelinkLocalizationFromJson(
        Map<String, dynamic> json) =>
    _$_FlamelinkLocalization(
      metadata: Metadata.fromJson(json['metadata'] as Map<String, dynamic>),
      key: json['key'] as String,
      locale: json['locale'] as String,
      text: json['text'] as String,
      isMarkdown: json['is_markdown'] as bool? ?? false,
    );

Map<String, dynamic> _$$_FlamelinkLocalizationToJson(
        _$_FlamelinkLocalization instance) =>
    <String, dynamic>{
      'metadata': instance.metadata,
      'key': instance.key,
      'locale': instance.locale,
      'text': instance.text,
      'is_markdown': instance.isMarkdown,
    };
