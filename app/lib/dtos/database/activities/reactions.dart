// Dart imports:

// Package imports:
import 'package:app/dtos/database/activities/mentions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:app/dtos/database/activities/tags.dart';
import 'package:app/dtos/database/common/fl_meta.dart';
import 'package:app/dtos/database/notifications/notification_payload.dart';

part 'reactions.freezed.dart';
part 'reactions.g.dart';

@freezed
class Reaction with _$Reaction {
  const factory Reaction({
    @JsonKey(name: '_fl_meta_') FlMeta? flMeta,
    @Default('') @JsonKey(name: 'activity_id') String activityId,
    @Default('') @JsonKey(name: 'reaction_id') String reactionId,
    @Default('') @JsonKey(name: 'entry_id') String entryId,
    @Default('') @JsonKey(name: 'user_id') String userId,
    @Default(ReactionType.unknownReaction()) @JsonKey(fromJson: ReactionType.fromJson, toJson: ReactionType.toJson) ReactionType kind,
    @Default('') @JsonKey(name: 'text') String text,
    @Default([]) @JsonKey(name: 'tags') List<String> tags,
    @JsonKey(fromJson: Mention.fromJsonList, toJson: Mention.toJsonList) @Default([]) List<Mention> mentions,
  }) = _Reaction;

  factory Reaction.fromJson(Map<String, dynamic> json) => _$ReactionFromJson(json);
}

@freezed
class ReactionType with _$ReactionType {
  const factory ReactionType.unknownReaction() = _ReactionTypeUnknownReaction;
  const factory ReactionType.like() = _ReactionTypeLike;
  const factory ReactionType.dislike() = _ReactionTypeDislike;
  const factory ReactionType.comment() = _ReactionTypeComment;
  const factory ReactionType.bookmark() = _ReactionTypeBookmark;
  const factory ReactionType.share() = _ReactionTypeShare;

  factory ReactionType.fromJson(String json) {
    switch (json) {
      case 'like':
        return const ReactionType.like();
      case 'dislike':
        return const ReactionType.dislike();
      case 'comment':
        return const ReactionType.comment();
      case 'bookmark':
        return const ReactionType.bookmark();
      case 'share':
        return const ReactionType.share();
      default:
        return const ReactionType.unknownReaction();
    }
  }

  static List<ReactionType> values() {
    return const <ReactionType>[
      ReactionType.like(),
      ReactionType.dislike(),
      ReactionType.comment(),
      ReactionType.bookmark(),
      ReactionType.share(),
    ];
  }

  static String toJson(ReactionType reactionType) {
    return reactionType.when(
      unknownReaction: () => 'unknownReaction',
      like: () => 'like',
      dislike: () => 'dislike',
      comment: () => 'comment',
      bookmark: () => 'bookmark',
      share: () => 'share',
    );
  }
}

@freezed
class ReactionStatistics with _$ReactionStatistics {
  const factory ReactionStatistics({
    @JsonKey(name: '_fl_meta_') FlMeta? flMeta,
    @Default({}) @JsonKey(name: 'counts') Map<String, int> counts,
    @Default('') @JsonKey(name: 'activity_id') String activityId,
    @Default('') @JsonKey(name: 'reaction_id') String reactionId,
    @Default('') @JsonKey(name: 'user_id') String userId,
  }) = _ReactionStatistics;

  factory ReactionStatistics.fromJson(Map<String, dynamic> json) => _$ReactionStatisticsFromJson(json);

  static ReactionStatistics newEntry(String activityId) {
    return ReactionStatistics(
      activityId: activityId,
      reactionId: '',
      userId: '',
      counts: {},
    );
  }
}

@freezed
class TargetFeed with _$TargetFeed {
  const factory TargetFeed({
    @Default('') String targetSlug,
    @Default('') String targetUserId,
  }) = _TargetFeed;

  factory TargetFeed.fromJson(Map<String, dynamic> json) => _$TargetFeedFromJson(json);

  /// static helper to return the target feed properly formatted to get all activities with the specifed tag
  static TargetFeed fromTag(String tag) => TargetFeed(targetSlug: 'tags', targetUserId: tag);

  /// static helper to return the feed to collect all 'promoted' activities, if you pass a {userId} then this will return all the promoted activities
  /// posted by that particular user. uses tags:
  /// tags:promoted
  /// tags:promoted-{userId}
  static TargetFeed fromPromoted({String? userId}) => TargetFeed(targetSlug: 'tags', targetUserId: TagHelpers.createPromotedTag(userId: userId));

  static TargetFeed fromNotificationPayload(NotificationPayload payload) => TargetFeed(targetSlug: 'notification', targetUserId: payload.userId);

  static TargetFeed fromOrigin(String origin) {
    final List<String> parts = origin.split(':');
    if (parts.length != 2) {
      return TargetFeed.empty();
    }

    final String feed = parts[0];
    final String slug = parts[1];

    return TargetFeed(targetSlug: feed, targetUserId: slug);
  }

  static TargetFeed search() {
    return const TargetFeed(targetSlug: 'search', targetUserId: '');
  }

  static TargetFeed tag(String tag) {
    return TargetFeed(targetSlug: 'tags', targetUserId: tag);
  }

  static TargetFeed empty() {
    return const TargetFeed(targetSlug: '', targetUserId: '');
  }

  static String toOrigin(TargetFeed targetFeed) {
    String slug = targetFeed.targetSlug;

    //! If we have more aggregated feeds, we need to add them here
    if (slug == 'timeline') {
      slug = 'user';
    }

    return '$slug:${targetFeed.targetUserId}';
  }
}
