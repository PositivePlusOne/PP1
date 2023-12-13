// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mentions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MentionImpl _$$MentionImplFromJson(Map<String, dynamic> json) =>
    _$MentionImpl(
      startIndex: json['startIndex'] as int? ?? -1,
      endIndex: json['endIndex'] as int? ?? -1,
      displayName: json['displayName'] as String? ?? '',
      foreignKey: json['foreignKey'] as String? ?? '',
      schema: json['schema'] as String? ?? '',
    );

Map<String, dynamic> _$$MentionImplToJson(_$MentionImpl instance) =>
    <String, dynamic>{
      'startIndex': instance.startIndex,
      'endIndex': instance.endIndex,
      'displayName': instance.displayName,
      'foreignKey': instance.foreignKey,
      'schema': instance.schema,
    };
