// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comments.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Comment _$$_CommentFromJson(Map<String, dynamic> json) => _$_Comment(
      content: json['content'] as String? ?? '',
      reactionId: json['reactionId'] as String? ?? '',
      activityId: json['activityId'] as String? ?? '',
      senderId: json['senderId'] as String? ?? '',
      mentions: json['mentions'] == null
          ? const []
          : Mention.fromJsonList(json['mentions'] as List),
      media: json['media'] == null
          ? const []
          : Media.fromJsonList(json['media'] as List),
    );

Map<String, dynamic> _$$_CommentToJson(_$_Comment instance) =>
    <String, dynamic>{
      'content': instance.content,
      'reactionId': instance.reactionId,
      'activityId': instance.activityId,
      'senderId': instance.senderId,
      'mentions': Mention.toJsonList(instance.mentions),
      'media': Media.toJsonList(instance.media),
    };
