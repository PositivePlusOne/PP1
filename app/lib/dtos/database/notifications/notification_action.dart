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
  const factory NotificationAction.postLiked() = PostLiked;
  const factory NotificationAction.postShared() = PostShared;
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
      postLiked: () => 'post_liked',
      postShared: () => 'post_shared',
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
      case 'post_liked':
        return const NotificationAction.postLiked();
      case 'post_shared':
        return const NotificationAction.postShared();
      case 'relationship_updated':
        return const NotificationAction.relationshipUpdated();
      default:
        return const NotificationAction.none();
    }
  }
}
