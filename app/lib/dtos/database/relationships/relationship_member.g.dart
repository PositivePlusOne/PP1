// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relationship_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RelationshipMemberImpl _$$RelationshipMemberImplFromJson(
        Map<String, dynamic> json) =>
    _$RelationshipMemberImpl(
      hasBlocked: json['hasBlocked'] as bool? ?? false,
      hasConnected: json['hasConnected'] as bool? ?? false,
      hasFollowed: json['hasFollowed'] as bool? ?? false,
      hasHidden: json['hasHidden'] as bool? ?? false,
      hasMuted: json['hasMuted'] as bool? ?? false,
      canManage: json['canManage'] as bool? ?? false,
      memberId: json['memberId'] as String? ?? '',
    );

Map<String, dynamic> _$$RelationshipMemberImplToJson(
        _$RelationshipMemberImpl instance) =>
    <String, dynamic>{
      'hasBlocked': instance.hasBlocked,
      'hasConnected': instance.hasConnected,
      'hasFollowed': instance.hasFollowed,
      'hasHidden': instance.hasHidden,
      'hasMuted': instance.hasMuted,
      'canManage': instance.canManage,
      'memberId': instance.memberId,
    };
