// Project imports:
import 'package:app/constants/key_constants.dart';

NotificationTopic notificationTopicFromKey(String key) {
  return NotificationTopic.values.firstWhere(
    (e) => e.key == key,
    orElse: () => NotificationTopic.other,
  );
}

enum NotificationTopic {
  other('other'),
  postLikes('post_like'),
  newFollower('new_follower'),
  connectionRequest('connection_request'),
  newComment('new_comment'),
  newMessage('new_message'),
  postShared('post_shared'),
  sharedEvent('shared_event');

  const NotificationTopic(this.key);

  final String key;

  String get toLocalizedTopic {
    switch (this) {
      case NotificationTopic.postLikes:
        return 'Post Likes';
      case NotificationTopic.newFollower:
        return 'New Follower';
      case NotificationTopic.connectionRequest:
        return 'Connection Request';
      case NotificationTopic.newComment:
        return 'New Comment';
      case NotificationTopic.newMessage:
        return 'New Message';
      case NotificationTopic.postShared:
        return 'Post Shared';
      case NotificationTopic.sharedEvent:
        return 'Shared Event';
      default:
        break;
    }

    return 'General Notifications';
  }

  String get toSharedPreferencesKey => '$kKeyPrefix-${key.toLowerCase().replaceAll('_', '-')}';

  static NotificationTopic fromString(String key) {
    return NotificationTopic.values.firstWhere(
      (e) => e.key == key,
      orElse: () => NotificationTopic.other,
    );
  }
}
