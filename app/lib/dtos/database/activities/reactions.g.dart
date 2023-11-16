// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reactions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReactionImpl _$$ReactionImplFromJson(Map<String, dynamic> json) =>
    _$ReactionImpl(
      flMeta: json['_fl_meta_'] == null
          ? null
          : FlMeta.fromJson(json['_fl_meta_'] as Map<String, dynamic>),
      activityId: json['activity_id'] as String? ?? '',
      reactionId: json['reaction_id'] as String? ?? '',
      entryId: json['entry_id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      kind: json['kind'] == null
          ? const ReactionType.unknownReaction()
          : ReactionType.fromJson(json['kind'] as String),
      text: json['text'] as String? ?? '',
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$$ReactionImplToJson(_$ReactionImpl instance) =>
    <String, dynamic>{
      '_fl_meta_': instance.flMeta?.toJson(),
      'activity_id': instance.activityId,
      'reaction_id': instance.reactionId,
      'entry_id': instance.entryId,
      'user_id': instance.userId,
      'kind': ReactionType.toJson(instance.kind),
      'text': instance.text,
      'tags': instance.tags,
    };

_$ReactionStatisticsImpl _$$ReactionStatisticsImplFromJson(
        Map<String, dynamic> json) =>
    _$ReactionStatisticsImpl(
      flMeta: json['_fl_meta_'] == null
          ? null
          : FlMeta.fromJson(json['_fl_meta_'] as Map<String, dynamic>),
      counts: (json['counts'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as int),
          ) ??
          const {},
      activityId: json['activity_id'] as String? ?? '',
      reactionId: json['reaction_id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
    );

Map<String, dynamic> _$$ReactionStatisticsImplToJson(
        _$ReactionStatisticsImpl instance) =>
    <String, dynamic>{
      '_fl_meta_': instance.flMeta?.toJson(),
      'counts': instance.counts,
      'activity_id': instance.activityId,
      'reaction_id': instance.reactionId,
      'user_id': instance.userId,
    };

_$TargetFeedImpl _$$TargetFeedImplFromJson(Map<String, dynamic> json) =>
    _$TargetFeedImpl(
      targetSlug: json['targetSlug'] as String? ?? '',
      targetUserId: json['targetUserId'] as String? ?? '',
    );

Map<String, dynamic> _$$TargetFeedImplToJson(_$TargetFeedImpl instance) =>
    <String, dynamic>{
      'targetSlug': instance.targetSlug,
      'targetUserId': instance.targetUserId,
    };
