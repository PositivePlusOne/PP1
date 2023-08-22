// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comments.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Comment _$$_CommentFromJson(Map<String, dynamic> json) => _$_Comment(
      flMeta: json['_fl_meta_'] == null
          ? null
          : FlMeta.fromJson(json['_fl_meta_'] as Map<String, dynamic>),
      data: json['data'] as String? ?? '',
      reactionId: json['reaction_id'] as String? ?? '',
      activityId: json['activity_id'] as String? ?? '',
      userId: json['user_id'] ?? '',
      mentions: json['mentions'] == null
          ? const []
          : Mention.fromJsonList(json['mentions'] as List),
      media: json['media'] == null
          ? const []
          : Media.fromJsonList(json['media'] as List),
    );

Map<String, dynamic> _$$_CommentToJson(_$_Comment instance) =>
    <String, dynamic>{
      '_fl_meta_': instance.flMeta?.toJson(),
      'data': instance.data,
      'reaction_id': instance.reactionId,
      'activity_id': instance.activityId,
      'user_id': instance.userId,
      'mentions': Mention.toJsonList(instance.mentions),
      'media': Media.toJsonList(instance.media),
    };
