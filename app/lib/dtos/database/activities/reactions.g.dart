// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reactions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Reaction _$$_ReactionFromJson(Map<String, dynamic> json) => _$_Reaction(
      activityId: json['activityId'] as String? ?? '',
      reactionId: json['reactionId'] as String? ?? '',
      senderId: json['senderId'] as String? ?? '',
      reactionType: json['reactionType'] == null
          ? const ReactionType.unknownReaction()
          : ReactionType.fromJson(json['reactionType'] as String),
    );

Map<String, dynamic> _$$_ReactionToJson(_$_Reaction instance) =>
    <String, dynamic>{
      'activityId': instance.activityId,
      'reactionId': instance.reactionId,
      'senderId': instance.senderId,
      'reactionType': ReactionType.toJson(instance.reactionType),
    };
