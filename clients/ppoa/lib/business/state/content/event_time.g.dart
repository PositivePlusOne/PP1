// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_time.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_EventTime _$$_EventTimeFromJson(Map<String, dynamic> json) => _$_EventTime(
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: json['end_time'] == null
          ? null
          : DateTime.parse(json['end_time'] as String),
    );

Map<String, dynamic> _$$_EventTimeToJson(_$_EventTime instance) =>
    <String, dynamic>{
      'start_time': instance.startTime.toIso8601String(),
      'end_time': instance.endTime?.toIso8601String(),
    };
