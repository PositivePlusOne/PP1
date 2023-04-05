// Project imports:
import '../constants/key_constants.dart';

PositiveNotificationTopic notificationTopicFromKey(String key) {
  return PositiveNotificationTopic.values.firstWhere(
    (e) => e.key == key,
    orElse: () => PositiveNotificationTopic.other,
  );
}

enum PositiveNotificationTopic {
  other('TOPIC_OTHER'),
  postLikes('TOPIC_POST_LIKE'),
  newFollower('TOPIC_NEW_FOLLOWER'),
  connectionRequest('TOPIC_CONNECTION_REQUEST'),
  newComment('TOPIC_NEW_COMMENT'),
  newMessage('TOPIC_NEW_MESSAGE'),
  postShared('TOPIC_POST_SHARED'),
  sharedEvent('TOPIC_SHARED_EVENT');

  const PositiveNotificationTopic(this.key);

  final String key;

  String get toLocalizedTopic {
    switch (this) {
      case PositiveNotificationTopic.postLikes:
        return 'Post Likes';
      case PositiveNotificationTopic.newFollower:
        return 'New Follower';
      case PositiveNotificationTopic.connectionRequest:
        return 'Connection Request';
      case PositiveNotificationTopic.newComment:
        return 'New Comment';
      case PositiveNotificationTopic.newMessage:
        return 'New Message';
      case PositiveNotificationTopic.postShared:
        return 'Post Shared';
      case PositiveNotificationTopic.sharedEvent:
        return 'Shared Event';
      default:
        break;
    }

    return 'General Notifications';
  }

  String get toSharedPreferencesKey => '$kKeyPrefix-${key.toLowerCase().replaceAll('_', '-')}';

  static PositiveNotificationTopic fromString(String key) {
    return PositiveNotificationTopic.values.firstWhere(
      (e) => e.key == key,
      orElse: () => PositiveNotificationTopic.other,
    );
  }
}
