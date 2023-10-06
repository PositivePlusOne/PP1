// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archived_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ArchivedMemberImpl _$$ArchivedMemberImplFromJson(Map<String, dynamic> json) =>
    _$ArchivedMemberImpl(
      memberId: json['member_id'] as String?,
      dateArchived: json['date_archived'] == null
          ? null
          : DateTime.parse(json['date_archived'] as String),
      lastMessageId: json['last_message_id'] as String?,
    );

Map<String, dynamic> _$$ArchivedMemberImplToJson(
        _$ArchivedMemberImpl instance) =>
    <String, dynamic>{
      'member_id': instance.memberId,
      'date_archived': instance.dateArchived?.toIso8601String(),
      'last_message_id': instance.lastMessageId,
    };
