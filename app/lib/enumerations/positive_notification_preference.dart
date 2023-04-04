// Project imports:
import '../constants/key_constants.dart';

PositiveNotificationPreference notificationPreferenceFromTopicKey(String key) {
  return PositiveNotificationPreference.values.firstWhere(
    (e) => e.topicKey == key,
    orElse: () => PositiveNotificationPreference.other,
  );
}

enum PositiveNotificationPreference {
  other('TOPIC_OTHER'),
  postLikes('TOPIC_POST_LIKE'),
  newFollower('TOPIC_NEW_FOLLOWER'),
  connectionRequest('TOPIC_CONNECTION_REQUEST'),
  newComment('TOPIC_NEW_COMMENT'),
  newMessage('TOPIC_NEW_MESSAGE'),
  postShared('TOPIC_POST_SHARED'),
  sharedEvent('TOPIC_SHARED_EVENT');

  const PositiveNotificationPreference(this.topicKey);

  final String topicKey;

  String get toLocalizedTopic {
    switch (this) {
      case PositiveNotificationPreference.postLikes:
        return 'Post Likes';
      case PositiveNotificationPreference.newFollower:
        return 'New Follower';
      case PositiveNotificationPreference.connectionRequest:
        return 'Connection Request';
      case PositiveNotificationPreference.newComment:
        return 'New Comment';
      case PositiveNotificationPreference.newMessage:
        return 'New Message';
      case PositiveNotificationPreference.postShared:
        return 'Post Shared';
      case PositiveNotificationPreference.sharedEvent:
        return 'Shared Event';
      default:
        break;
    }

    return 'General Notifications';
  }

  String get toSharedPreferencesKey => '$kKeyPrefix-${topicKey.toLowerCase().replaceAll('_', '-')}';

  static PositiveNotificationPreference fromString(String key) {
    return PositiveNotificationPreference.values.firstWhere(
      (e) => e.topicKey == key,
      orElse: () => PositiveNotificationPreference.other,
    );
  }
}
