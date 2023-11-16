// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'archived_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ArchivedMemberImpl _$$ArchivedMemberImplFromJson(Map<String, dynamic> json) =>
    _$ArchivedMemberImpl(
      memberId: json['member_id'] as String?,
      dateArchived: dateTimeFromUnknown(json['date_archived']),
      lastMessageId: json['last_message_id'] as String?,
    );

Map<String, dynamic> _$$ArchivedMemberImplToJson(
        _$ArchivedMemberImpl instance) =>
    <String, dynamic>{
      'member_id': instance.memberId,
      'date_archived': instance.dateArchived?.toIso8601String(),
      'last_message_id': instance.lastMessageId,
    };
