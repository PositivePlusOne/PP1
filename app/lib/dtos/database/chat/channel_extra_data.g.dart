// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_extra_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChannelExtraDataImpl _$$ChannelExtraDataImplFromJson(
        Map<String, dynamic> json) =>
    _$ChannelExtraDataImpl(
      hidden: json['hidden'] as bool?,
      disabled: json['disabled'] as bool?,
      archivedMembers: (json['archived_members'] as List<dynamic>?)
          ?.map((e) => ArchivedMember.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ChannelExtraDataImplToJson(
        _$ChannelExtraDataImpl instance) =>
    <String, dynamic>{
      'hidden': instance.hidden,
      'disabled': instance.disabled,
      'archived_members':
          instance.archivedMembers?.map((e) => e.toJson()).toList(),
    };
