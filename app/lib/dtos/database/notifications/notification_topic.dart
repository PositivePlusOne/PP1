// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:app/constants/key_constants.dart';

part 'notification_topic.freezed.dart';

extension NotificationTopicExt on NotificationTopic {
  String get toLocalizedTopic {
    return when(
      other: () => 'Post Likes',
      newFollower: () => 'New Follower',
      connectionRequest: () => 'Connection Request',
      newComment: () => 'New Comment',
      newMessage: () => 'New Message',
      postShared: () => 'Post Shared',
      sharedEvent: () => 'Shared Event',
      postLikes: () => 'Post Likes',
    );
  }

  String get toSharedPreferencesKey => '$kKeyPrefix-${NotificationTopic.toJson(this)}';
}

@freezed
class NotificationTopic with _$NotificationTopic {
  const factory NotificationTopic.other() = Other;
  const factory NotificationTopic.postLikes() = PostLikes;
  const factory NotificationTopic.newFollower() = NewFollower;
  const factory NotificationTopic.connectionRequest() = ConnectionRequest;
  const factory NotificationTopic.newComment() = NewComment;
  const factory NotificationTopic.newMessage() = NewMessage;
  const factory NotificationTopic.postShared() = PostShared;
  const factory NotificationTopic.sharedEvent() = SharedEvent;

  static Set<NotificationTopic> get allTopics => {
        const NotificationTopic.other(),
        const NotificationTopic.postLikes(),
        const NotificationTopic.newFollower(),
        const NotificationTopic.connectionRequest(),
        const NotificationTopic.newComment(),
        const NotificationTopic.newMessage(),
        const NotificationTopic.postShared(),
        const NotificationTopic.sharedEvent(),
      };

  static String toJson(NotificationTopic type) {
    return type.when(
      other: () => 'other',
      postLikes: () => 'post_likes',
      newFollower: () => 'new_follower',
      connectionRequest: () => 'connection_request',
      newComment: () => 'new_comment',
      newMessage: () => 'new_message',
      postShared: () => 'post_shared',
      sharedEvent: () => 'shared_event',
    );
  }

  factory NotificationTopic.fromJson(String value) {
    switch (value) {
      case 'other':
        return const NotificationTopic.other();
      case 'post_likes':
        return const NotificationTopic.postLikes();
      case 'new_follower':
        return const NotificationTopic.newFollower();
      case 'connection_request':
        return const NotificationTopic.connectionRequest();
      case 'new_comment':
        return const NotificationTopic.newComment();
      case 'new_message':
        return const NotificationTopic.newMessage();
      case 'post_shared':
        return const NotificationTopic.postShared();
      case 'shared_event':
        return const NotificationTopic.sharedEvent();
      default:
        return const NotificationTopic.other();
    }
  }
}
