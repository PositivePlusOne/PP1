// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'system_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SystemControllerState {
  SystemEnvironment get environment => throw _privateConstructorUsedError;
  bool get localNotificationsInitialized => throw _privateConstructorUsedError;
  bool get remoteNotificationsInitialized => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SystemControllerStateCopyWith<SystemControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SystemControllerStateCopyWith<$Res> {
  factory $SystemControllerStateCopyWith(SystemControllerState value,
          $Res Function(SystemControllerState) then) =
      _$SystemControllerStateCopyWithImpl<$Res, SystemControllerState>;
  @useResult
  $Res call(
      {SystemEnvironment environment,
      bool localNotificationsInitialized,
      bool remoteNotificationsInitialized});
}

/// @nodoc
class _$SystemControllerStateCopyWithImpl<$Res,
        $Val extends SystemControllerState>
    implements $SystemControllerStateCopyWith<$Res> {
  _$SystemControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? environment = null,
    Object? localNotificationsInitialized = null,
    Object? remoteNotificationsInitialized = null,
  }) {
    return _then(_value.copyWith(
      environment: null == environment
          ? _value.environment
          : environment // ignore: cast_nullable_to_non_nullable
              as SystemEnvironment,
      localNotificationsInitialized: null == localNotificationsInitialized
          ? _value.localNotificationsInitialized
          : localNotificationsInitialized // ignore: cast_nullable_to_non_nullable
              as bool,
      remoteNotificationsInitialized: null == remoteNotificationsInitialized
          ? _value.remoteNotificationsInitialized
          : remoteNotificationsInitialized // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SystemControllerStateCopyWith<$Res>
    implements $SystemControllerStateCopyWith<$Res> {
  factory _$$_SystemControllerStateCopyWith(_$_SystemControllerState value,
          $Res Function(_$_SystemControllerState) then) =
      __$$_SystemControllerStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {SystemEnvironment environment,
      bool localNotificationsInitialized,
      bool remoteNotificationsInitialized});
}

/// @nodoc
class __$$_SystemControllerStateCopyWithImpl<$Res>
    extends _$SystemControllerStateCopyWithImpl<$Res, _$_SystemControllerState>
    implements _$$_SystemControllerStateCopyWith<$Res> {
  __$$_SystemControllerStateCopyWithImpl(_$_SystemControllerState _value,
      $Res Function(_$_SystemControllerState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? environment = null,
    Object? localNotificationsInitialized = null,
    Object? remoteNotificationsInitialized = null,
  }) {
    return _then(_$_SystemControllerState(
      environment: null == environment
          ? _value.environment
          : environment // ignore: cast_nullable_to_non_nullable
              as SystemEnvironment,
      localNotificationsInitialized: null == localNotificationsInitialized
          ? _value.localNotificationsInitialized
          : localNotificationsInitialized // ignore: cast_nullable_to_non_nullable
              as bool,
      remoteNotificationsInitialized: null == remoteNotificationsInitialized
          ? _value.remoteNotificationsInitialized
          : remoteNotificationsInitialized // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_SystemControllerState implements _SystemControllerState {
  const _$_SystemControllerState(
      {required this.environment,
      required this.localNotificationsInitialized,
      required this.remoteNotificationsInitialized});

  @override
  final SystemEnvironment environment;
  @override
  final bool localNotificationsInitialized;
  @override
  final bool remoteNotificationsInitialized;

  @override
  String toString() {
    return 'SystemControllerState(environment: $environment, localNotificationsInitialized: $localNotificationsInitialized, remoteNotificationsInitialized: $remoteNotificationsInitialized)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SystemControllerState &&
            (identical(other.environment, environment) ||
                other.environment == environment) &&
            (identical(other.localNotificationsInitialized,
                    localNotificationsInitialized) ||
                other.localNotificationsInitialized ==
                    localNotificationsInitialized) &&
            (identical(other.remoteNotificationsInitialized,
                    remoteNotificationsInitialized) ||
                other.remoteNotificationsInitialized ==
                    remoteNotificationsInitialized));
  }

  @override
  int get hashCode => Object.hash(runtimeType, environment,
      localNotificationsInitialized, remoteNotificationsInitialized);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SystemControllerStateCopyWith<_$_SystemControllerState> get copyWith =>
      __$$_SystemControllerStateCopyWithImpl<_$_SystemControllerState>(
          this, _$identity);
}

abstract class _SystemControllerState implements SystemControllerState {
  const factory _SystemControllerState(
          {required final SystemEnvironment environment,
          required final bool localNotificationsInitialized,
          required final bool remoteNotificationsInitialized}) =
      _$_SystemControllerState;

  @override
  SystemEnvironment get environment;
  @override
  bool get localNotificationsInitialized;
  @override
  bool get remoteNotificationsInitialized;
  @override
  @JsonKey(ignore: true)
  _$$_SystemControllerStateCopyWith<_$_SystemControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}
