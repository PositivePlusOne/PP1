// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_NotificationPayload _$$_NotificationPayloadFromJson(
        Map<String, dynamic> json) =>
    _$_NotificationPayload(
      id: json['id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      sender: json['sender'] as String? ?? '',
      createdAt: dateFromUnknown(json['created_at']),
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      type: json['type'] as String? ?? '',
      extraData: json['extra_data'] as Map<String, dynamic>? ?? const {},
      topic: json['topic'] == null
          ? const NotificationTopic.other()
          : NotificationTopic.fromJson(json['topic'] as String),
      action: json['action'] == null
          ? const NotificationAction.none()
          : NotificationAction.fromJson(json['action'] as String),
      priority: json['priority'] == null
          ? const NotificationPriority.defaultPriority()
          : NotificationPriority.fromJson(json['priority'] as String),
    );

Map<String, dynamic> _$$_NotificationPayloadToJson(
        _$_NotificationPayload instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'sender': instance.sender,
      'created_at': dateToUnknown(instance.createdAt),
      'title': instance.title,
      'body': instance.body,
      'icon': instance.icon,
      'type': instance.type,
      'extra_data': instance.extraData,
      'topic': NotificationTopic.toJson(instance.topic),
      'action': NotificationAction.toJson(instance.action),
      'priority': NotificationPriority.toJson(instance.priority),
    };
