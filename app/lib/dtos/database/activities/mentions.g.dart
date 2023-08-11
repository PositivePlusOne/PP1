// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mentions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Mention _$$_MentionFromJson(Map<String, dynamic> json) => _$_Mention(
      startIndex: json['startIndex'] as int? ?? -1,
      endIndex: json['endIndex'] as int? ?? -1,
      foreignKey: json['foreignKey'] as String? ?? '',
      schema: json['schema'] as String? ?? '',
    );

Map<String, dynamic> _$$_MentionToJson(_$_Mention instance) =>
    <String, dynamic>{
      'startIndex': instance.startIndex,
      'endIndex': instance.endIndex,
      'foreignKey': instance.foreignKey,
      'schema': instance.schema,
    };
