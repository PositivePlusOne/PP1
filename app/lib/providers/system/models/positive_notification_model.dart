// Package imports:
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// Project imports:
import '../../../constants/notification_constants.dart';
import '../../../enumerations/positive_notification_topic.dart';

part 'positive_notification_model.freezed.dart';

@freezed
class PositiveNotificationModel with _$PositiveNotificationModel {
  const factory PositiveNotificationModel({
    @Default('') String title,
    @Default('') String topic,
    @Default('') String type,
    @Default('') String key,
    @Default('') String body,
    @Default('') String icon,
    @Default('') String action,
    @Default('') String actionData,
  }) = _PositiveNotificationModel;

  factory PositiveNotificationModel.fromMessage(GetMessageResponse response) => PositiveNotificationModel(
        title: response.message.user?.name ?? '',
        body: response.message.text ?? '',
        icon: '',
        key: '',
        action: kActionNavigationNone,
        actionData: '',
        topic: PositiveNotificationTopic.newMessage.key,
        type: kTypeDefault,
      );

  factory PositiveNotificationModel.fromRemoteMessage(RemoteMessage message) => PositiveNotificationModel(
        title: message.data['title'] ?? '',
        body: message.data['body'] ?? '',
        icon: message.data['icon'] ?? '',
        key: message.data['key'] ?? '',
        action: message.data['action'] ?? kActionNavigationNone,
        actionData: message.data['actionData'] ?? '',
        topic: message.data['topic'] ?? PositiveNotificationTopic.other.key,
        type: message.data['type'] ?? kTypeDefault,
      );

  factory PositiveNotificationModel.initialState() => const PositiveNotificationModel(
        body: '',
        icon: '',
        title: '',
        key: '',
        action: '',
        actionData: '',
        topic: '',
        type: '',
      );
}
