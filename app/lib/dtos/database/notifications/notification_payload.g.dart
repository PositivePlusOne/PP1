// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationPayloadImpl _$$NotificationPayloadImplFromJson(
        Map<String, dynamic> json) =>
    _$NotificationPayloadImpl(
      id: json['id'] as String? ?? '',
      foreignKey: json['foreign_id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      sender: json['sender'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      bodyMarkdown: json['bodyMarkdown'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      createdAt: dateFromUnknown(json['created_at']),
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

Map<String, dynamic> _$$NotificationPayloadImplToJson(
        _$NotificationPayloadImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'foreign_id': instance.foreignKey,
      'user_id': instance.userId,
      'sender': instance.sender,
      'title': instance.title,
      'body': instance.body,
      'bodyMarkdown': instance.bodyMarkdown,
      'icon': instance.icon,
      'created_at': instance.createdAt,
      'extra_data': instance.extraData,
      'topic': NotificationTopic.toJson(instance.topic),
      'action': NotificationAction.toJson(instance.action),
      'priority': NotificationPriority.toJson(instance.priority),
    };
