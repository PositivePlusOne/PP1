// Package imports:
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import '../../../constants/notification_constants.dart';
import '../../../enumerations/positive_notification_preference.dart';

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

  factory PositiveNotificationModel.fromRemoteMessage(RemoteMessage message) => PositiveNotificationModel(
        title: message.data['title'] ?? '',
        body: message.data['body'] ?? '',
        icon: message.data['icon'] ?? '',
        key: message.data['key'] ?? '',
        action: message.data['action'] ?? kActionNavigationNone,
        actionData: message.data['actionData'] ?? '',
        topic: message.data['topic'] ?? PositiveNotificationPreference.other.topicKey,
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
