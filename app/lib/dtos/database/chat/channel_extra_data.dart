// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:app/dtos/database/chat/archived_member.dart';

part 'channel_extra_data.freezed.dart';
part 'channel_extra_data.g.dart';

@freezed
class ChannelExtraData with _$ChannelExtraData {
  const factory ChannelExtraData({
    bool? hidden,
    bool? disabled,
    @JsonKey(name: 'archived_members') List<ArchivedMember>? archivedMembers,
  }) = _ChannelExtraData;

  factory ChannelExtraData.fromJson(Map<String, dynamic> json) => _$ChannelExtraDataFromJson(json);
}
