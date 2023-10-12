// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relationship.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RelationshipImpl _$$RelationshipImplFromJson(Map<String, dynamic> json) =>
    _$RelationshipImpl(
      flMeta: json['_fl_meta_'] == null
          ? null
          : FlMeta.fromJson(json['_fl_meta_'] as Map<String, dynamic>),
      members: (json['members'] as List<dynamic>?)
              ?.map(
                  (e) => RelationshipMember.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      flags: json['flags'] == null
          ? const []
          : RelationshipFlag.fromJsonList(json['flags'] as List),
      blocked: json['blocked'] as bool? ?? false,
      channelId: json['channelId'] as String? ?? '',
      connected: json['connected'] as bool? ?? false,
      following: json['following'] as bool? ?? false,
      hidden: json['hidden'] as bool? ?? false,
      muted: json['muted'] as bool? ?? false,
      managed: json['managed'] as bool? ?? false,
    );

Map<String, dynamic> _$$RelationshipImplToJson(_$RelationshipImpl instance) =>
    <String, dynamic>{
      '_fl_meta_': instance.flMeta?.toJson(),
      'members': instance.members.map((e) => e.toJson()).toList(),
      'flags': RelationshipFlag.toJsonList(instance.flags),
      'blocked': instance.blocked,
      'channelId': instance.channelId,
      'connected': instance.connected,
      'following': instance.following,
      'hidden': instance.hidden,
      'muted': instance.muted,
      'managed': instance.managed,
    };
