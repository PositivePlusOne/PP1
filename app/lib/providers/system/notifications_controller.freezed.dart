// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notifications_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$NotificationsControllerState {
  bool get localNotificationsInitialized => throw _privateConstructorUsedError;
  bool get remoteNotificationsInitialized => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NotificationsControllerStateCopyWith<NotificationsControllerState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationsControllerStateCopyWith<$Res> {
  factory $NotificationsControllerStateCopyWith(
          NotificationsControllerState value,
          $Res Function(NotificationsControllerState) then) =
      _$NotificationsControllerStateCopyWithImpl<$Res,
          NotificationsControllerState>;
  @useResult
  $Res call(
      {bool localNotificationsInitialized,
      bool remoteNotificationsInitialized});
}

/// @nodoc
class _$NotificationsControllerStateCopyWithImpl<$Res,
        $Val extends NotificationsControllerState>
    implements $NotificationsControllerStateCopyWith<$Res> {
  _$NotificationsControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? localNotificationsInitialized = null,
    Object? remoteNotificationsInitialized = null,
  }) {
    return _then(_value.copyWith(
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
abstract class _$$NotificationsControllerStateImplCopyWith<$Res>
    implements $NotificationsControllerStateCopyWith<$Res> {
  factory _$$NotificationsControllerStateImplCopyWith(
          _$NotificationsControllerStateImpl value,
          $Res Function(_$NotificationsControllerStateImpl) then) =
      __$$NotificationsControllerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool localNotificationsInitialized,
      bool remoteNotificationsInitialized});
}

/// @nodoc
class __$$NotificationsControllerStateImplCopyWithImpl<$Res>
    extends _$NotificationsControllerStateCopyWithImpl<$Res,
        _$NotificationsControllerStateImpl>
    implements _$$NotificationsControllerStateImplCopyWith<$Res> {
  __$$NotificationsControllerStateImplCopyWithImpl(
      _$NotificationsControllerStateImpl _value,
      $Res Function(_$NotificationsControllerStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? localNotificationsInitialized = null,
    Object? remoteNotificationsInitialized = null,
  }) {
    return _then(_$NotificationsControllerStateImpl(
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

class _$NotificationsControllerStateImpl
    implements _NotificationsControllerState {
  const _$NotificationsControllerStateImpl(
      {required this.localNotificationsInitialized,
      required this.remoteNotificationsInitialized});

  @override
  final bool localNotificationsInitialized;
  @override
  final bool remoteNotificationsInitialized;

  @override
  String toString() {
    return 'NotificationsControllerState(localNotificationsInitialized: $localNotificationsInitialized, remoteNotificationsInitialized: $remoteNotificationsInitialized)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationsControllerStateImpl &&
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
  int get hashCode => Object.hash(runtimeType, localNotificationsInitialized,
      remoteNotificationsInitialized);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationsControllerStateImplCopyWith<
          _$NotificationsControllerStateImpl>
      get copyWith => __$$NotificationsControllerStateImplCopyWithImpl<
          _$NotificationsControllerStateImpl>(this, _$identity);
}

abstract class _NotificationsControllerState
    implements NotificationsControllerState {
  const factory _NotificationsControllerState(
          {required final bool localNotificationsInitialized,
          required final bool remoteNotificationsInitialized}) =
      _$NotificationsControllerStateImpl;

  @override
  bool get localNotificationsInitialized;
  @override
  bool get remoteNotificationsInitialized;
  @override
  @JsonKey(ignore: true)
  _$$NotificationsControllerStateImplCopyWith<
          _$NotificationsControllerStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
