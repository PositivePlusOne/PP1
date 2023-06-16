// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archived_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ArchivedMember _$$_ArchivedMemberFromJson(Map<String, dynamic> json) =>
    _$_ArchivedMember(
      memberId: json['member_id'] as String?,
      dateArchived: json['date_archived'] == null
          ? null
          : DateTime.parse(json['date_archived'] as String),
      lastMessageId: json['last_message_id'] as String?,
    );

Map<String, dynamic> _$$_ArchivedMemberToJson(_$_ArchivedMember instance) =>
    <String, dynamic>{
      'member_id': instance.memberId,
      'date_archived': instance.dateArchived?.toIso8601String(),
      'last_message_id': instance.lastMessageId,
    };
