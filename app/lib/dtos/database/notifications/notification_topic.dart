// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:app/constants/application_constants.dart';

part 'notification_topic.freezed.dart';

extension NotificationTopicExt on NotificationTopic {
  String get toTopicLocale {
    return when(
      other: () => "Other",
      postLike: () => "Post Likes",
      newFollower: () => "New Follower",
      connectionRequest: () => "Connection Request",
      newComment: () => "New Comment",
      newMessage: () => "New Message",
      postShared: () => "Post Shared",
      sharedEvent: () => "Shared Event",
    );
  }

  String get toSharedPreferencesKey => '$kKeyPrefix-${NotificationTopic.toJson(this)}';
}

@freezed
class NotificationTopic with _$NotificationTopic {
  const factory NotificationTopic.other() = Other;
  const factory NotificationTopic.postLike() = PostLike;
  const factory NotificationTopic.newFollower() = NewFollower;
  const factory NotificationTopic.connectionRequest() = ConnectionRequest;
  const factory NotificationTopic.newComment() = NewComment;
  const factory NotificationTopic.newMessage() = NewMessage;
  const factory NotificationTopic.postShared() = PostShared;
  const factory NotificationTopic.sharedEvent() = SharedEvent;

  static Set<NotificationTopic> get allTopics => {
        const NotificationTopic.postLike(),
        // const NotificationTopic.newFollower(),
        const NotificationTopic.connectionRequest(),
        const NotificationTopic.newComment(),
        const NotificationTopic.newMessage(),
        // const NotificationTopic.postShared(),
        const NotificationTopic.other(),
        //! PP1-984
        // const NotificationTopic.sharedEvent(),
      };

  static String toPascalCase(NotificationTopic type) {
    return type.when(
      other: () => 'Other',
      postLike: () => 'PostLike',
      newFollower: () => 'NewFollower',
      connectionRequest: () => 'ConnectionRequest',
      newComment: () => 'NewComment',
      newMessage: () => 'NewMessage',
      postShared: () => 'PostShared',
      sharedEvent: () => 'SharedEvent',
    );
  }

  static String toJson(NotificationTopic type) {
    return type.when(
      other: () => 'other',
      postLike: () => 'post_like',
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
      case 'post_like':
        return const NotificationTopic.postLike();
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
