// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:app/dtos/database/common/fl_meta.dart';

part 'user_notification.freezed.dart';
part 'user_notification.g.dart';

@freezed
class UserNotification with _$UserNotification {
  const factory UserNotification({
    @Default('') String key,
    @Default('') String action,
    @Default('') String receiver,
    @Default(false) bool hasDismissed,
    @Default('') String title,
    @Default('') String body,
    @Default('') String payload,
    @Default('') String icon,
    @Default('') String type,
    @Default('') String topic,
    @JsonKey(name: '_fl_meta_') FlMeta? flMeta,
  }) = _UserNotification;

  factory UserNotification.empty() => const UserNotification();
  factory UserNotification.fromJson(Map<String, Object?> json) => _$UserNotificationFromJson(json);
}
