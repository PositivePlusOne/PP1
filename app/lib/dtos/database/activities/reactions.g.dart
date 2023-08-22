// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reactions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Reaction _$$_ReactionFromJson(Map<String, dynamic> json) => _$_Reaction(
      activityId: json['activity_id'] as String? ?? '',
      reactionId: json['reaction_id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      kind: json['kind'] == null
          ? const ReactionType.unknownReaction()
          : ReactionType.fromJson(json['kind'] as String),
    );

Map<String, dynamic> _$$_ReactionToJson(_$_Reaction instance) =>
    <String, dynamic>{
      'activity_id': instance.activityId,
      'reaction_id': instance.reactionId,
      'user_id': instance.userId,
      'kind': ReactionType.toJson(instance.kind),
    };
