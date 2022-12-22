// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

import '../enumerations/notification_preference.dart';

part 'user.freezed.dart';
part 'user.g.dart';

enum UserAuthProvider {
  google,
  apple,
  facebook,
  email,
}

@freezed
class User with _$User {
  @JsonSerializable(
    fieldRename: FieldRename.snake,
  )
  const factory User({
    required String id,
    required bool hasCreatedProfile,
    @Default({}) Map<String, dynamic> publicData,
    @Default({}) Map<String, dynamic> privateData,
    @Default({}) Map<String, dynamic> systemData,
    @Default(<UserAuthProvider>[]) List<UserAuthProvider> authProviders,
    @Default(<NotificationPreference>[]) List<NotificationPreference> notificationPreferences,
  }) = _User;

  factory User.empty() => const User(
        id: '',
        hasCreatedProfile: false,
      );

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}
