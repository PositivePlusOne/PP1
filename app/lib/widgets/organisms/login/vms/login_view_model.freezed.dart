// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$LoginViewModelState {
  bool get isBusy => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  String get serverError => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $LoginViewModelStateCopyWith<LoginViewModelState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginViewModelStateCopyWith<$Res> {
  factory $LoginViewModelStateCopyWith(
          LoginViewModelState value, $Res Function(LoginViewModelState) then) =
      _$LoginViewModelStateCopyWithImpl<$Res, LoginViewModelState>;
  @useResult
  $Res call({bool isBusy, String email, String password, String serverError});
}

/// @nodoc
class _$LoginViewModelStateCopyWithImpl<$Res, $Val extends LoginViewModelState>
    implements $LoginViewModelStateCopyWith<$Res> {
  _$LoginViewModelStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
    Object? email = null,
    Object? password = null,
    Object? serverError = null,
  }) {
    return _then(_value.copyWith(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      serverError: null == serverError
          ? _value.serverError
          : serverError // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_LoginViewModelStateCopyWith<$Res>
    implements $LoginViewModelStateCopyWith<$Res> {
  factory _$$_LoginViewModelStateCopyWith(_$_LoginViewModelState value,
          $Res Function(_$_LoginViewModelState) then) =
      __$$_LoginViewModelStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isBusy, String email, String password, String serverError});
}

/// @nodoc
class __$$_LoginViewModelStateCopyWithImpl<$Res>
    extends _$LoginViewModelStateCopyWithImpl<$Res, _$_LoginViewModelState>
    implements _$$_LoginViewModelStateCopyWith<$Res> {
  __$$_LoginViewModelStateCopyWithImpl(_$_LoginViewModelState _value,
      $Res Function(_$_LoginViewModelState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
    Object? email = null,
    Object? password = null,
    Object? serverError = null,
  }) {
    return _then(_$_LoginViewModelState(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      serverError: null == serverError
          ? _value.serverError
          : serverError // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_LoginViewModelState implements _LoginViewModelState {
  const _$_LoginViewModelState(
      {this.isBusy = false,
      this.email = '',
      this.password = '',
      this.serverError = ''});

  @override
  @JsonKey()
  final bool isBusy;
  @override
  @JsonKey()
  final String email;
  @override
  @JsonKey()
  final String password;
  @override
  @JsonKey()
  final String serverError;

  @override
  String toString() {
    return 'LoginViewModelState(isBusy: $isBusy, email: $email, password: $password, serverError: $serverError)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LoginViewModelState &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.serverError, serverError) ||
                other.serverError == serverError));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isBusy, email, password, serverError);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_LoginViewModelStateCopyWith<_$_LoginViewModelState> get copyWith =>
      __$$_LoginViewModelStateCopyWithImpl<_$_LoginViewModelState>(
          this, _$identity);
}

abstract class _LoginViewModelState implements LoginViewModelState {
  const factory _LoginViewModelState(
      {final bool isBusy,
      final String email,
      final String password,
      final String serverError}) = _$_LoginViewModelState;

  @override
  bool get isBusy;
  @override
  String get email;
  @override
  String get password;
  @override
  String get serverError;
  @override
  @JsonKey(ignore: true)
  _$$_LoginViewModelStateCopyWith<_$_LoginViewModelState> get copyWith =>
      throw _privateConstructorUsedError;
}
