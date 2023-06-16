// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'archived_member.freezed.dart';
part 'archived_member.g.dart';

@freezed
class ArchivedMember with _$ArchivedMember {
  const factory ArchivedMember({
    @JsonKey(name: 'member_id') String? memberId,
    @JsonKey(name: 'date_archived') DateTime? dateArchived,
    @JsonKey(name: 'last_message_id') String? lastMessageId,
  }) = _ArchivedMember;

  factory ArchivedMember.fromJson(Map<String, dynamic> json) => _$ArchivedMemberFromJson(json);
}
