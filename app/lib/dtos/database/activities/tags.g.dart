// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tags.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Tag _$$_TagFromJson(Map<String, dynamic> json) => _$_Tag(
      flMeta: json['_fl_meta_'] == null
          ? null
          : FlMeta.fromJson(json['_fl_meta_'] as Map<String, dynamic>),
      key: json['key'] as String? ?? '',
      fallback: json['fallback'] as String? ?? '',
      promoted: json['promoted'] as bool? ?? false,
      localizations:
          TagLocalization.fromJsonLocalizations(json['localizations'] as List),
    );

Map<String, dynamic> _$$_TagToJson(_$_Tag instance) => <String, dynamic>{
      '_fl_meta_': instance.flMeta?.toJson(),
      'key': instance.key,
      'fallback': instance.fallback,
      'promoted': instance.promoted,
      'localizations':
          TagLocalization.toJsonLocalizations(instance.localizations),
    };

_$_TagLocalization _$$_TagLocalizationFromJson(Map<String, dynamic> json) =>
    _$_TagLocalization(
      locale: json['locale'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );

Map<String, dynamic> _$$_TagLocalizationToJson(_$_TagLocalization instance) =>
    <String, dynamic>{
      'locale': instance.locale,
      'value': instance.value,
    };
