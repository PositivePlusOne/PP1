// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_NotificationPayload _$$_NotificationPayloadFromJson(
        Map<String, dynamic> json) =>
    _$_NotificationPayload(
      flMeta: json['_fl_meta_'] == null
          ? null
          : FlMeta.fromJson(json['_fl_meta_'] as Map<String, dynamic>),
      key: json['key'] as String? ?? '',
      sender: json['sender'] as String? ?? '',
      receiver: json['receiver'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      icon: json['icon'] as String? ?? '',
      topic: $enumDecodeNullable(_$NotificationTopicEnumMap, json['topic']) ??
          NotificationTopic.other,
      type: json['type'] as String? ?? '',
      action: json['action'] == null
          ? const NotificationAction.none()
          : NotificationAction.fromJson(json['action'] as String),
      hasDismissed: json['hasDismissed'] as bool? ?? false,
      extraData: json['extraData'] as Map<String, dynamic>? ?? const {},
      priority: json['priority'] == null
          ? const NotificationPriority.defaultPriority()
          : NotificationPriority.fromJson(json['priority'] as String),
    );

Map<String, dynamic> _$$_NotificationPayloadToJson(
        _$_NotificationPayload instance) =>
    <String, dynamic>{
      '_fl_meta_': instance.flMeta?.toJson(),
      'key': instance.key,
      'sender': instance.sender,
      'receiver': instance.receiver,
      'title': instance.title,
      'body': instance.body,
      'icon': instance.icon,
      'topic': _$NotificationTopicEnumMap[instance.topic]!,
      'type': instance.type,
      'action': NotificationAction.toJson(instance.action),
      'hasDismissed': instance.hasDismissed,
      'extraData': instance.extraData,
      'priority': NotificationPriority.toJson(instance.priority),
    };

const _$NotificationTopicEnumMap = {
  NotificationTopic.other: 'other',
  NotificationTopic.postLikes: 'postLikes',
  NotificationTopic.newFollower: 'newFollower',
  NotificationTopic.connectionRequest: 'connectionRequest',
  NotificationTopic.newComment: 'newComment',
  NotificationTopic.newMessage: 'newMessage',
  NotificationTopic.postShared: 'postShared',
  NotificationTopic.sharedEvent: 'sharedEvent',
};
