// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$UserControllerState {
  User? get user => throw _privateConstructorUsedError;
  int? get phoneVerificationResendToken => throw _privateConstructorUsedError;
  String? get phoneVerificationId => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $UserControllerStateCopyWith<UserControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserControllerStateCopyWith<$Res> {
  factory $UserControllerStateCopyWith(
          UserControllerState value, $Res Function(UserControllerState) then) =
      _$UserControllerStateCopyWithImpl<$Res, UserControllerState>;
  @useResult
  $Res call(
      {User? user,
      int? phoneVerificationResendToken,
      String? phoneVerificationId});
}

/// @nodoc
class _$UserControllerStateCopyWithImpl<$Res, $Val extends UserControllerState>
    implements $UserControllerStateCopyWith<$Res> {
  _$UserControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = freezed,
    Object? phoneVerificationResendToken = freezed,
    Object? phoneVerificationId = freezed,
  }) {
    return _then(_value.copyWith(
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      phoneVerificationResendToken: freezed == phoneVerificationResendToken
          ? _value.phoneVerificationResendToken
          : phoneVerificationResendToken // ignore: cast_nullable_to_non_nullable
              as int?,
      phoneVerificationId: freezed == phoneVerificationId
          ? _value.phoneVerificationId
          : phoneVerificationId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_UserControllerStateCopyWith<$Res>
    implements $UserControllerStateCopyWith<$Res> {
  factory _$$_UserControllerStateCopyWith(_$_UserControllerState value,
          $Res Function(_$_UserControllerState) then) =
      __$$_UserControllerStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {User? user,
      int? phoneVerificationResendToken,
      String? phoneVerificationId});
}

/// @nodoc
class __$$_UserControllerStateCopyWithImpl<$Res>
    extends _$UserControllerStateCopyWithImpl<$Res, _$_UserControllerState>
    implements _$$_UserControllerStateCopyWith<$Res> {
  __$$_UserControllerStateCopyWithImpl(_$_UserControllerState _value,
      $Res Function(_$_UserControllerState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = freezed,
    Object? phoneVerificationResendToken = freezed,
    Object? phoneVerificationId = freezed,
  }) {
    return _then(_$_UserControllerState(
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      phoneVerificationResendToken: freezed == phoneVerificationResendToken
          ? _value.phoneVerificationResendToken
          : phoneVerificationResendToken // ignore: cast_nullable_to_non_nullable
              as int?,
      phoneVerificationId: freezed == phoneVerificationId
          ? _value.phoneVerificationId
          : phoneVerificationId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$_UserControllerState implements _UserControllerState {
  const _$_UserControllerState(
      {this.user, this.phoneVerificationResendToken, this.phoneVerificationId});

  @override
  final User? user;
  @override
  final int? phoneVerificationResendToken;
  @override
  final String? phoneVerificationId;

  @override
  String toString() {
    return 'UserControllerState(user: $user, phoneVerificationResendToken: $phoneVerificationResendToken, phoneVerificationId: $phoneVerificationId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserControllerState &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.phoneVerificationResendToken,
                    phoneVerificationResendToken) ||
                other.phoneVerificationResendToken ==
                    phoneVerificationResendToken) &&
            (identical(other.phoneVerificationId, phoneVerificationId) ||
                other.phoneVerificationId == phoneVerificationId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, user, phoneVerificationResendToken, phoneVerificationId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserControllerStateCopyWith<_$_UserControllerState> get copyWith =>
      __$$_UserControllerStateCopyWithImpl<_$_UserControllerState>(
          this, _$identity);
}

abstract class _UserControllerState implements UserControllerState {
  const factory _UserControllerState(
      {final User? user,
      final int? phoneVerificationResendToken,
      final String? phoneVerificationId}) = _$_UserControllerState;

  @override
  User? get user;
  @override
  int? get phoneVerificationResendToken;
  @override
  String? get phoneVerificationId;
  @override
  @JsonKey(ignore: true)
  _$$_UserControllerStateCopyWith<_$_UserControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}
