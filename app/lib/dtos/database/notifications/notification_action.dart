// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_action.freezed.dart';

@freezed
class NotificationAction with _$NotificationAction {
  const factory NotificationAction.none() = None;
  const factory NotificationAction.test() = Test;
  const factory NotificationAction.connectionRequestAccepted() = ConnectionRequestAccepted;
  const factory NotificationAction.connectionRequestRejected() = ConnectionRequestRejected;
  const factory NotificationAction.connectionRequestSent() = ConnectionRequestSent;
  const factory NotificationAction.connectionRequestReceived() = ConnectionRequestReceived;
  const factory NotificationAction.postCommented() = PostCommented;
  const factory NotificationAction.postCommentedGrouped() = PostCommentedGrouped;
  const factory NotificationAction.postLiked() = PostLiked;
  const factory NotificationAction.postLikedGrouped() = PostLikedGrouped;
  const factory NotificationAction.postShared() = PostShared;
  const factory NotificationAction.postSharedGrouped() = PostSharedGrouped;
  const factory NotificationAction.postBookmarked() = PostBookmarked;
  const factory NotificationAction.postBookmarkedGrouped() = PostBookmarkedGrouped;
  const factory NotificationAction.postMentioned() = PostMentioned;
  const factory NotificationAction.reactionMentioned() = ReactionMentioned;
  const factory NotificationAction.relationshipUpdated() = RelationshipUpdated;

  static String toJson(NotificationAction type) {
    return type.when(
      none: () => 'none',
      test: () => 'test',
      connectionRequestAccepted: () => 'connection_request_accepted',
      connectionRequestRejected: () => 'connection_request_rejected',
      connectionRequestSent: () => 'connection_request_sent',
      connectionRequestReceived: () => 'connection_request_received',
      postCommented: () => 'post_commented',
      postCommentedGrouped: () => 'post_commented_grouped',
      postLiked: () => 'post_liked',
      postLikedGrouped: () => 'post_liked_grouped',
      postShared: () => 'post_shared',
      postSharedGrouped: () => 'post_shared_grouped',
      postBookmarked: () => 'post_bookmarked',
      postBookmarkedGrouped: () => 'post_bookmarked_grouped',
      postMentioned: () => 'post_mentioned',
      reactionMentioned: () => 'reaction_mentioned',
      relationshipUpdated: () => 'relationship_updated',
    );
  }

  factory NotificationAction.fromJson(String value) {
    switch (value) {
      case 'none':
        return const NotificationAction.none();
      case 'test':
        return const NotificationAction.test();
      case 'connection_request_accepted':
        return const NotificationAction.connectionRequestAccepted();
      case 'connection_request_rejected':
        return const NotificationAction.connectionRequestRejected();
      case 'connection_request_sent':
        return const NotificationAction.connectionRequestSent();
      case 'connection_request_received':
        return const NotificationAction.connectionRequestReceived();
      case 'post_commented':
        return const NotificationAction.postCommented();
      case 'post_commented_group':
        return const NotificationAction.postCommentedGrouped();
      case 'post_liked':
        return const NotificationAction.postLiked();
      case 'post_liked_group':
        return const NotificationAction.postLikedGrouped();
      case 'post_shared':
        return const NotificationAction.postShared();
      case 'post_shared_group':
        return const NotificationAction.postSharedGrouped();
      case 'post_mentioned':
        return const NotificationAction.postMentioned();
      case 'reaction_mentioned':
        return const NotificationAction.reactionMentioned();
      case 'post_bookmarked':
        return const NotificationAction.postBookmarked();
      case 'relationship_updated':
        return const NotificationAction.relationshipUpdated();
      default:
        return const NotificationAction.none();
    }
  }
}
