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
  DateTime get last2FACheck => throw _privateConstructorUsedError;

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
  $Res call({DateTime last2FACheck});
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
    Object? last2FACheck = null,
  }) {
    return _then(_value.copyWith(
      last2FACheck: null == last2FACheck
          ? _value.last2FACheck
          : last2FACheck // ignore: cast_nullable_to_non_nullable
              as DateTime,
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
  $Res call({DateTime last2FACheck});
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
    Object? last2FACheck = null,
  }) {
    return _then(_$_UserControllerState(
      last2FACheck: null == last2FACheck
          ? _value.last2FACheck
          : last2FACheck // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$_UserControllerState implements _UserControllerState {
  const _$_UserControllerState({required this.last2FACheck});

  @override
  final DateTime last2FACheck;

  @override
  String toString() {
    return 'UserControllerState(last2FACheck: $last2FACheck)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserControllerState &&
            (identical(other.last2FACheck, last2FACheck) ||
                other.last2FACheck == last2FACheck));
  }

  @override
  int get hashCode => Object.hash(runtimeType, last2FACheck);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserControllerStateCopyWith<_$_UserControllerState> get copyWith =>
      __$$_UserControllerStateCopyWithImpl<_$_UserControllerState>(
          this, _$identity);
}

abstract class _UserControllerState implements UserControllerState {
  const factory _UserControllerState({required final DateTime last2FACheck}) =
      _$_UserControllerState;

  @override
  DateTime get last2FACheck;
  @override
  @JsonKey(ignore: true)
  _$$_UserControllerStateCopyWith<_$_UserControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}
