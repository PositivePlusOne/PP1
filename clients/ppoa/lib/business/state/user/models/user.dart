// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  @JsonSerializable(
    fieldRename: FieldRename.snake,
  )
  const factory User({
    required String displayName,
    required String emailAddress,
  }) = _User;

  factory User.empty() => const User(displayName: '', emailAddress: '');

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}
