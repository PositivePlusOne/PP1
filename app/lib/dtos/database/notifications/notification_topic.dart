// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Project imports:
import 'package:app/constants/key_constants.dart';

part 'notification_topic.freezed.dart';

extension NotificationTopicExt on NotificationTopic {
  String toLocalizedTopic(AppLocalizations localizations) {
    return when(
      other: () => localizations.notification_topic_title_other,
      newFollower: () => localizations.notification_topic_title_new_follower,
      connectionRequest: () => localizations.notification_topic_title_connection_request,
      newComment: () => localizations.notification_topic_title_new_comment,
      newMessage: () => localizations.notification_topic_title_new_message,
      postShared: () => localizations.notification_topic_title_post_shared,
      sharedEvent: () => localizations.notification_topic_title_shared_event,
      postLikes: () => localizations.notification_topic_title_post_likes,
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
        //! PP1-984
        // const NotificationTopic.sharedEvent(),
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
