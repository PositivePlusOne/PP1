// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

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
    required String displayName,
    required String emailAddress,
    required bool hasCreatedProfile,
    @Default(<UserAuthProvider>[]) List<UserAuthProvider> authProviders,
  }) = _User;

  factory User.empty() => const User(
        id: '',
        displayName: '',
        emailAddress: '',
        hasCreatedProfile: false,
      );

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}
