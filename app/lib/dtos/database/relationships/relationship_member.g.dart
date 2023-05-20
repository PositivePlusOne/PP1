// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relationship_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_RelationshipMember _$$_RelationshipMemberFromJson(
        Map<String, dynamic> json) =>
    _$_RelationshipMember(
      hasBlocked: json['hasBlocked'] as bool? ?? false,
      hasConnected: json['hasConnected'] as bool? ?? false,
      hasFollowed: json['hasFollowed'] as bool? ?? false,
      hasHidden: json['hasHidden'] as bool? ?? false,
      hasMuted: json['hasMuted'] as bool? ?? false,
      memberId: json['memberId'] as String? ?? '',
    );

Map<String, dynamic> _$$_RelationshipMemberToJson(
        _$_RelationshipMember instance) =>
    <String, dynamic>{
      'hasBlocked': instance.hasBlocked,
      'hasConnected': instance.hasConnected,
      'hasFollowed': instance.hasFollowed,
      'hasHidden': instance.hasHidden,
      'hasMuted': instance.hasMuted,
      'memberId': instance.memberId,
    };
