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
  DateTime? get lastNotificationReceivedTime =>
      throw _privateConstructorUsedError;
  DateTime? get lastNotificationCheckTime => throw _privateConstructorUsedError;

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
      bool remoteNotificationsInitialized,
      DateTime? lastNotificationReceivedTime,
      DateTime? lastNotificationCheckTime});
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
    Object? lastNotificationReceivedTime = freezed,
    Object? lastNotificationCheckTime = freezed,
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
      lastNotificationReceivedTime: freezed == lastNotificationReceivedTime
          ? _value.lastNotificationReceivedTime
          : lastNotificationReceivedTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastNotificationCheckTime: freezed == lastNotificationCheckTime
          ? _value.lastNotificationCheckTime
          : lastNotificationCheckTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
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
      bool remoteNotificationsInitialized,
      DateTime? lastNotificationReceivedTime,
      DateTime? lastNotificationCheckTime});
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
    Object? lastNotificationReceivedTime = freezed,
    Object? lastNotificationCheckTime = freezed,
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
      lastNotificationReceivedTime: freezed == lastNotificationReceivedTime
          ? _value.lastNotificationReceivedTime
          : lastNotificationReceivedTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastNotificationCheckTime: freezed == lastNotificationCheckTime
          ? _value.lastNotificationCheckTime
          : lastNotificationCheckTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$NotificationsControllerStateImpl
    implements _NotificationsControllerState {
  const _$NotificationsControllerStateImpl(
      {required this.localNotificationsInitialized,
      required this.remoteNotificationsInitialized,
      this.lastNotificationReceivedTime,
      this.lastNotificationCheckTime});

  @override
  final bool localNotificationsInitialized;
  @override
  final bool remoteNotificationsInitialized;
  @override
  final DateTime? lastNotificationReceivedTime;
  @override
  final DateTime? lastNotificationCheckTime;

  @override
  String toString() {
    return 'NotificationsControllerState(localNotificationsInitialized: $localNotificationsInitialized, remoteNotificationsInitialized: $remoteNotificationsInitialized, lastNotificationReceivedTime: $lastNotificationReceivedTime, lastNotificationCheckTime: $lastNotificationCheckTime)';
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
                    remoteNotificationsInitialized) &&
            (identical(other.lastNotificationReceivedTime,
                    lastNotificationReceivedTime) ||
                other.lastNotificationReceivedTime ==
                    lastNotificationReceivedTime) &&
            (identical(other.lastNotificationCheckTime,
                    lastNotificationCheckTime) ||
                other.lastNotificationCheckTime == lastNotificationCheckTime));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      localNotificationsInitialized,
      remoteNotificationsInitialized,
      lastNotificationReceivedTime,
      lastNotificationCheckTime);

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
          required final bool remoteNotificationsInitialized,
          final DateTime? lastNotificationReceivedTime,
          final DateTime? lastNotificationCheckTime}) =
      _$NotificationsControllerStateImpl;

  @override
  bool get localNotificationsInitialized;
  @override
  bool get remoteNotificationsInitialized;
  @override
  DateTime? get lastNotificationReceivedTime;
  @override
  DateTime? get lastNotificationCheckTime;
  @override
  @JsonKey(ignore: true)
  _$$NotificationsControllerStateImplCopyWith<
          _$NotificationsControllerStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
