// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_action.freezed.dart';

@freezed
class NotificationAction with _$NotificationAction {
  const factory NotificationAction.none() = None;
  const factory NotificationAction.connectionRequestAccepted() = ConnectionRequestAccepted;
  const factory NotificationAction.connectionRequestRejected() = ConnectionRequestRejected;
  const factory NotificationAction.connectionRequestSent() = ConnectionRequestSent;
  const factory NotificationAction.connectionRequestReceived() = ConnectionRequestReceived;
  const factory NotificationAction.relationshipUpdated() = RelationshipUpdated;

  static String toJson(NotificationAction type) {
    return type.when(
      none: () => 'none',
      connectionRequestAccepted: () => 'connection_request_accepted',
      connectionRequestRejected: () => 'connection_request_rejected',
      connectionRequestSent: () => 'connection_request_sent',
      connectionRequestReceived: () => 'connection_request_received',
      relationshipUpdated: () => 'relationship_updated',
    );
  }

  factory NotificationAction.fromJson(String value) {
    switch (value) {
      case 'connection_request_accepted':
        return const NotificationAction.connectionRequestAccepted();
      case 'connection_request_rejected':
        return const NotificationAction.connectionRequestRejected();
      case 'connection_request_sent':
        return const NotificationAction.connectionRequestSent();
      case 'connection_request_received':
        return const NotificationAction.connectionRequestReceived();
      case 'relationship_updated':
        return const NotificationAction.relationshipUpdated();
      default:
        return const NotificationAction.none();
    }
  }
}
