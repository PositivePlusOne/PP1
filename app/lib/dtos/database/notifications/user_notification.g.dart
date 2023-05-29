// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserNotification _$$_UserNotificationFromJson(Map<String, dynamic> json) =>
    _$_UserNotification(
      key: json['key'] as String? ?? '',
      action: json['action'] as String? ?? '',
      receiver: json['receiver'] as String? ?? '',
      hasDismissed: json['hasDismissed'] as bool? ?? false,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      payload: json['payload'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      type: json['type'] as String? ?? '',
      topic: json['topic'] as String? ?? '',
      flMeta: json['_fl_meta_'] == null
          ? null
          : FlMeta.fromJson(json['_fl_meta_'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_UserNotificationToJson(_$_UserNotification instance) =>
    <String, dynamic>{
      'key': instance.key,
      'action': instance.action,
      'receiver': instance.receiver,
      'hasDismissed': instance.hasDismissed,
      'title': instance.title,
      'body': instance.body,
      'payload': instance.payload,
      'icon': instance.icon,
      'type': instance.type,
      'topic': instance.topic,
      '_fl_meta_': instance.flMeta?.toJson(),
    };
