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
  Map<String, UserNotification> get notifications =>
      throw _privateConstructorUsedError;

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
      Map<String, UserNotification> notifications});
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
    Object? notifications = null,
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
      notifications: null == notifications
          ? _value.notifications
          : notifications // ignore: cast_nullable_to_non_nullable
              as Map<String, UserNotification>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_NotificationsControllerStateCopyWith<$Res>
    implements $NotificationsControllerStateCopyWith<$Res> {
  factory _$$_NotificationsControllerStateCopyWith(
          _$_NotificationsControllerState value,
          $Res Function(_$_NotificationsControllerState) then) =
      __$$_NotificationsControllerStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool localNotificationsInitialized,
      bool remoteNotificationsInitialized,
      Map<String, UserNotification> notifications});
}

/// @nodoc
class __$$_NotificationsControllerStateCopyWithImpl<$Res>
    extends _$NotificationsControllerStateCopyWithImpl<$Res,
        _$_NotificationsControllerState>
    implements _$$_NotificationsControllerStateCopyWith<$Res> {
  __$$_NotificationsControllerStateCopyWithImpl(
      _$_NotificationsControllerState _value,
      $Res Function(_$_NotificationsControllerState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? localNotificationsInitialized = null,
    Object? remoteNotificationsInitialized = null,
    Object? notifications = null,
  }) {
    return _then(_$_NotificationsControllerState(
      localNotificationsInitialized: null == localNotificationsInitialized
          ? _value.localNotificationsInitialized
          : localNotificationsInitialized // ignore: cast_nullable_to_non_nullable
              as bool,
      remoteNotificationsInitialized: null == remoteNotificationsInitialized
          ? _value.remoteNotificationsInitialized
          : remoteNotificationsInitialized // ignore: cast_nullable_to_non_nullable
              as bool,
      notifications: null == notifications
          ? _value._notifications
          : notifications // ignore: cast_nullable_to_non_nullable
              as Map<String, UserNotification>,
    ));
  }
}

/// @nodoc

class _$_NotificationsControllerState implements _NotificationsControllerState {
  const _$_NotificationsControllerState(
      {required this.localNotificationsInitialized,
      required this.remoteNotificationsInitialized,
      final Map<String, UserNotification> notifications = const {}})
      : _notifications = notifications;

  @override
  final bool localNotificationsInitialized;
  @override
  final bool remoteNotificationsInitialized;
  final Map<String, UserNotification> _notifications;
  @override
  @JsonKey()
  Map<String, UserNotification> get notifications {
    if (_notifications is EqualUnmodifiableMapView) return _notifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_notifications);
  }

  @override
  String toString() {
    return 'NotificationsControllerState(localNotificationsInitialized: $localNotificationsInitialized, remoteNotificationsInitialized: $remoteNotificationsInitialized, notifications: $notifications)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_NotificationsControllerState &&
            (identical(other.localNotificationsInitialized,
                    localNotificationsInitialized) ||
                other.localNotificationsInitialized ==
                    localNotificationsInitialized) &&
            (identical(other.remoteNotificationsInitialized,
                    remoteNotificationsInitialized) ||
                other.remoteNotificationsInitialized ==
                    remoteNotificationsInitialized) &&
            const DeepCollectionEquality()
                .equals(other._notifications, _notifications));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      localNotificationsInitialized,
      remoteNotificationsInitialized,
      const DeepCollectionEquality().hash(_notifications));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_NotificationsControllerStateCopyWith<_$_NotificationsControllerState>
      get copyWith => __$$_NotificationsControllerStateCopyWithImpl<
          _$_NotificationsControllerState>(this, _$identity);
}

abstract class _NotificationsControllerState
    implements NotificationsControllerState {
  const factory _NotificationsControllerState(
          {required final bool localNotificationsInitialized,
          required final bool remoteNotificationsInitialized,
          final Map<String, UserNotification> notifications}) =
      _$_NotificationsControllerState;

  @override
  bool get localNotificationsInitialized;
  @override
  bool get remoteNotificationsInitialized;
  @override
  Map<String, UserNotification> get notifications;
  @override
  @JsonKey(ignore: true)
  _$$_NotificationsControllerStateCopyWith<_$_NotificationsControllerState>
      get copyWith => throw _privateConstructorUsedError;
}
