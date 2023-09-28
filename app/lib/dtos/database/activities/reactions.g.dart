// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reactions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Reaction _$$_ReactionFromJson(Map<String, dynamic> json) => _$_Reaction(
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
      origin: json['origin'] as String? ?? '',
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$$_ReactionToJson(_$_Reaction instance) =>
    <String, dynamic>{
      '_fl_meta_': instance.flMeta?.toJson(),
      'activity_id': instance.activityId,
      'reaction_id': instance.reactionId,
      'entry_id': instance.entryId,
      'user_id': instance.userId,
      'kind': ReactionType.toJson(instance.kind),
      'text': instance.text,
      'origin': instance.origin,
      'tags': instance.tags,
    };

_$_ReactionStatistics _$$_ReactionStatisticsFromJson(
        Map<String, dynamic> json) =>
    _$_ReactionStatistics(
      flMeta: json['_fl_meta_'] == null
          ? null
          : FlMeta.fromJson(json['_fl_meta_'] as Map<String, dynamic>),
      feed: json['feed'] == null
          ? ''
          : TargetFeed.fromJson(json['feed'] as Map<String, dynamic>),
      counts: (json['counts'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as int),
          ) ??
          const {},
      uniqueUserReactions:
          (json['unique_user_reactions'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, Map<String, bool>.from(e as Map)),
              ) ??
              const {},
      activityId: json['activity_id'] as String? ?? '',
      reactionId: json['reaction_id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      allReactions: (json['all_reactions'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, Reaction.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
    );

Map<String, dynamic> _$$_ReactionStatisticsToJson(
        _$_ReactionStatistics instance) =>
    <String, dynamic>{
      '_fl_meta_': instance.flMeta?.toJson(),
      'feed': instance.feed.toJson(),
      'counts': instance.counts,
      'unique_user_reactions': instance.uniqueUserReactions,
      'activity_id': instance.activityId,
      'reaction_id': instance.reactionId,
      'user_id': instance.userId,
      'all_reactions':
          instance.allReactions.map((k, e) => MapEntry(k, e.toJson())),
    };

_$_TargetFeed _$$_TargetFeedFromJson(Map<String, dynamic> json) =>
    _$_TargetFeed(
      targetSlug: json['targetSlug'] as String? ?? '',
      targetUserId: json['targetUserId'] as String? ?? '',
    );

Map<String, dynamic> _$$_TargetFeedToJson(_$_TargetFeed instance) =>
    <String, dynamic>{
      'targetSlug': instance.targetSlug,
      'targetUserId': instance.targetUserId,
    };
