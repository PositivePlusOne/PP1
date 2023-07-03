// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:app/dtos/database/common/fl_meta.dart';
import 'package:app/dtos/database/notifications/notification_action.dart';
import 'package:app/dtos/database/notifications/notification_topic.dart';

part 'notification_payload.freezed.dart';
part 'notification_payload.g.dart';

@freezed
abstract class NotificationPayload with _$NotificationPayload {
  const factory NotificationPayload({
    @JsonKey(name: '_fl_meta_') FlMeta? flMeta,
    @Default('') String key,
    @Default('') String sender,
    @Default('') String receiver,
    @Default('') String title,
    @Default('') String body,
    @Default('') String icon,
    @Default(NotificationTopic.other()) @JsonKey(fromJson: NotificationTopic.fromJson, toJson: NotificationTopic.toJson) NotificationTopic topic,
    @Default('') String type,
    @Default(NotificationAction.none()) @JsonKey(fromJson: NotificationAction.fromJson, toJson: NotificationAction.toJson) NotificationAction action,
    @Default(false) bool hasDismissed,
    @Default({}) Map<String, dynamic> extraData,
    @Default(NotificationPriority.defaultPriority()) @JsonKey(fromJson: NotificationPriority.fromJson, toJson: NotificationPriority.toJson) NotificationPriority priority,
  }) = _NotificationPayload;

  factory NotificationPayload.fromJson(Map<String, dynamic> json) => _$NotificationPayloadFromJson(json);
}

@freezed
class NotificationPriority with _$NotificationPriority {
  const factory NotificationPriority.lowPriority() = _NotificationPriorityLow;
  const factory NotificationPriority.defaultPriority() = _NotificationPriorityDefault;
  const factory NotificationPriority.highPriority() = _NotificationPriorityHigh;

  static String toJson(NotificationPriority type) {
    return type.when(
      lowPriority: () => 'low',
      defaultPriority: () => 'default',
      highPriority: () => 'high',
    );
  }

  factory NotificationPriority.fromJson(String value) {
    switch (value) {
      case 'low':
        return const NotificationPriority.lowPriority();
      case 'high':
        return const NotificationPriority.highPriority();
      default:
        return const NotificationPriority.defaultPriority();
    }
  }
}
