// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:app/dtos/converters/date_converters.dart';
import 'package:app/dtos/database/notifications/notification_action.dart';
import 'package:app/dtos/database/notifications/notification_topic.dart';

part 'notification_payload.freezed.dart';
part 'notification_payload.g.dart';

@freezed
abstract class NotificationPayload with _$NotificationPayload {
  const factory NotificationPayload({
    @Default('') String id,
    @Default('') @JsonKey(name: 'group_id') String groupId,
    @Default('') @JsonKey(name: 'user_id') String userId,
    @Default('') String sender,
    @Default('') String title,
    @Default('') String body,
    @Default('') String bodyMarkdown,
    @Default('') String icon,
    @JsonKey(name: 'created_at', fromJson: dateFromUnknown) String? createdAt,
    @Default({}) @JsonKey(name: 'extra_data') Map<String, dynamic> extraData,
    @Default(NotificationTopic.other()) @JsonKey(fromJson: NotificationTopic.fromJson, toJson: NotificationTopic.toJson) NotificationTopic topic,
    @Default(NotificationAction.none()) @JsonKey(fromJson: NotificationAction.fromJson, toJson: NotificationAction.toJson) NotificationAction action,
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
