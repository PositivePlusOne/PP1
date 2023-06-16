// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_extra_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_ChannelExtraData _$$_ChannelExtraDataFromJson(Map<String, dynamic> json) =>
    _$_ChannelExtraData(
      hidden: json['hidden'] as bool?,
      disabled: json['disabled'] as bool?,
      archivedMembers: (json['archived_members'] as List<dynamic>?)
          ?.map((e) => ArchivedMember.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$_ChannelExtraDataToJson(_$_ChannelExtraData instance) =>
    <String, dynamic>{
      'hidden': instance.hidden,
      'disabled': instance.disabled,
      'archived_members':
          instance.archivedMembers?.map((e) => e.toJson()).toList(),
    };
