// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'system_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_SystemState _$$_SystemStateFromJson(Map<String, dynamic> json) =>
    _$_SystemState(
      isBusy: json['is_busy'] as bool,
      appCheckToken: json['app_check_token'] as String?,
      currentException: json['current_exception'],
    );

Map<String, dynamic> _$$_SystemStateToJson(_$_SystemState instance) =>
    <String, dynamic>{
      'is_busy': instance.isBusy,
      'app_check_token': instance.appCheckToken,
      'current_exception': instance.currentException,
    };
