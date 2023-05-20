// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relationship.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Relationship _$$_RelationshipFromJson(Map<String, dynamic> json) =>
    _$_Relationship(
      flMeta: json['_fl_meta_'] == null
          ? null
          : FlMeta.fromJson(json['_fl_meta_'] as Map<String, dynamic>),
      blocked: json['blocked'] as bool? ?? false,
      channelId: json['channelId'] as String? ?? '',
      connected: json['connected'] as bool? ?? false,
      following: json['following'] as bool? ?? false,
      hidden: json['hidden'] as bool? ?? false,
      id: json['id'] as String? ?? '',
      muted: json['muted'] as bool? ?? false,
      members: (json['members'] as List<dynamic>?)
              ?.map(
                  (e) => RelationshipMember.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$_RelationshipToJson(_$_Relationship instance) =>
    <String, dynamic>{
      '_fl_meta_': instance.flMeta?.toJson(),
      'blocked': instance.blocked,
      'channelId': instance.channelId,
      'connected': instance.connected,
      'following': instance.following,
      'hidden': instance.hidden,
      'id': instance.id,
      'muted': instance.muted,
      'members': instance.members.map((e) => e.toJson()).toList(),
    };
