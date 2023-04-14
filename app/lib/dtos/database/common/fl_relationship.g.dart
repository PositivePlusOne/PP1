// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fl_relationship.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_FlRelationship _$$_FlRelationshipFromJson(Map<String, dynamic> json) =>
    _$_FlRelationship(
      blocked: json['blocked'] as bool? ?? false,
      muted: json['muted'] as bool? ?? false,
      connected: json['connected'] as bool? ?? false,
      following: json['following'] as bool? ?? false,
      hidden: json['hidden'] as bool? ?? false,
    );

Map<String, dynamic> _$$_FlRelationshipToJson(_$_FlRelationship instance) =>
    <String, dynamic>{
      'blocked': instance.blocked,
      'muted': instance.muted,
      'connected': instance.connected,
      'following': instance.following,
      'hidden': instance.hidden,
    };
