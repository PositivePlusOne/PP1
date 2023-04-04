import '../constants/key_constants.dart';

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

  String get toSharedPreferencesKey => '$kKeyPrefix-${topicKey.toLowerCase().replaceAll('_', '-')}';

  static PositiveNotificationPreference fromString(String key) {
    return PositiveNotificationPreference.values.firstWhere(
      (e) => e.topicKey == key,
      orElse: () => PositiveNotificationPreference.other,
    );
  }
}
