// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

NotificationPayload _$NotificationPayloadFromJson(Map<String, dynamic> json) {
  return _NotificationPayload.fromJson(json);
}

/// @nodoc
mixin _$NotificationPayload {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  String get sender => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at', fromJson: dateFromUnknown, toJson: dateToUnknown)
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'extra_data')
  Map<String, dynamic> get extraData => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: NotificationTopic.fromJson, toJson: NotificationTopic.toJson)
  NotificationTopic get topic => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: NotificationAction.fromJson, toJson: NotificationAction.toJson)
  NotificationAction get action => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: NotificationPriority.fromJson,
      toJson: NotificationPriority.toJson)
  NotificationPriority get priority => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NotificationPayloadCopyWith<NotificationPayload> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationPayloadCopyWith<$Res> {
  factory $NotificationPayloadCopyWith(
          NotificationPayload value, $Res Function(NotificationPayload) then) =
      _$NotificationPayloadCopyWithImpl<$Res, NotificationPayload>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String sender,
      String title,
      String body,
      String icon,
      @JsonKey(
          name: 'created_at', fromJson: dateFromUnknown, toJson: dateToUnknown)
      String? createdAt,
      @JsonKey(name: 'extra_data') Map<String, dynamic> extraData,
      @JsonKey(
          fromJson: NotificationTopic.fromJson,
          toJson: NotificationTopic.toJson)
      NotificationTopic topic,
      @JsonKey(
          fromJson: NotificationAction.fromJson,
          toJson: NotificationAction.toJson)
      NotificationAction action,
      @JsonKey(
          fromJson: NotificationPriority.fromJson,
          toJson: NotificationPriority.toJson)
      NotificationPriority priority});

  $NotificationTopicCopyWith<$Res> get topic;
  $NotificationActionCopyWith<$Res> get action;
  $NotificationPriorityCopyWith<$Res> get priority;
}

/// @nodoc
class _$NotificationPayloadCopyWithImpl<$Res, $Val extends NotificationPayload>
    implements $NotificationPayloadCopyWith<$Res> {
  _$NotificationPayloadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? sender = null,
    Object? title = null,
    Object? body = null,
    Object? icon = null,
    Object? createdAt = freezed,
    Object? extraData = null,
    Object? topic = null,
    Object? action = null,
    Object? priority = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      sender: null == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      extraData: null == extraData
          ? _value.extraData
          : extraData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      topic: null == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as NotificationTopic,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as NotificationAction,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as NotificationPriority,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $NotificationTopicCopyWith<$Res> get topic {
    return $NotificationTopicCopyWith<$Res>(_value.topic, (value) {
      return _then(_value.copyWith(topic: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $NotificationActionCopyWith<$Res> get action {
    return $NotificationActionCopyWith<$Res>(_value.action, (value) {
      return _then(_value.copyWith(action: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $NotificationPriorityCopyWith<$Res> get priority {
    return $NotificationPriorityCopyWith<$Res>(_value.priority, (value) {
      return _then(_value.copyWith(priority: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NotificationPayloadImplCopyWith<$Res>
    implements $NotificationPayloadCopyWith<$Res> {
  factory _$$NotificationPayloadImplCopyWith(_$NotificationPayloadImpl value,
          $Res Function(_$NotificationPayloadImpl) then) =
      __$$NotificationPayloadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'user_id') String userId,
      String sender,
      String title,
      String body,
      String icon,
      @JsonKey(
          name: 'created_at', fromJson: dateFromUnknown, toJson: dateToUnknown)
      String? createdAt,
      @JsonKey(name: 'extra_data') Map<String, dynamic> extraData,
      @JsonKey(
          fromJson: NotificationTopic.fromJson,
          toJson: NotificationTopic.toJson)
      NotificationTopic topic,
      @JsonKey(
          fromJson: NotificationAction.fromJson,
          toJson: NotificationAction.toJson)
      NotificationAction action,
      @JsonKey(
          fromJson: NotificationPriority.fromJson,
          toJson: NotificationPriority.toJson)
      NotificationPriority priority});

  @override
  $NotificationTopicCopyWith<$Res> get topic;
  @override
  $NotificationActionCopyWith<$Res> get action;
  @override
  $NotificationPriorityCopyWith<$Res> get priority;
}

/// @nodoc
class __$$NotificationPayloadImplCopyWithImpl<$Res>
    extends _$NotificationPayloadCopyWithImpl<$Res, _$NotificationPayloadImpl>
    implements _$$NotificationPayloadImplCopyWith<$Res> {
  __$$NotificationPayloadImplCopyWithImpl(_$NotificationPayloadImpl _value,
      $Res Function(_$NotificationPayloadImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? sender = null,
    Object? title = null,
    Object? body = null,
    Object? icon = null,
    Object? createdAt = freezed,
    Object? extraData = null,
    Object? topic = null,
    Object? action = null,
    Object? priority = null,
  }) {
    return _then(_$NotificationPayloadImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      sender: null == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      extraData: null == extraData
          ? _value._extraData
          : extraData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      topic: null == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as NotificationTopic,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as NotificationAction,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as NotificationPriority,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationPayloadImpl implements _NotificationPayload {
  const _$NotificationPayloadImpl(
      {this.id = '',
      @JsonKey(name: 'user_id') this.userId = '',
      this.sender = '',
      this.title = '',
      this.body = '',
      this.icon = '',
      @JsonKey(
          name: 'created_at', fromJson: dateFromUnknown, toJson: dateToUnknown)
      this.createdAt,
      @JsonKey(name: 'extra_data')
      final Map<String, dynamic> extraData = const {},
      @JsonKey(
          fromJson: NotificationTopic.fromJson,
          toJson: NotificationTopic.toJson)
      this.topic = const NotificationTopic.other(),
      @JsonKey(
          fromJson: NotificationAction.fromJson,
          toJson: NotificationAction.toJson)
      this.action = const NotificationAction.none(),
      @JsonKey(
          fromJson: NotificationPriority.fromJson,
          toJson: NotificationPriority.toJson)
      this.priority = const NotificationPriority.defaultPriority()})
      : _extraData = extraData;

  factory _$NotificationPayloadImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationPayloadImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey()
  final String sender;
  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String body;
  @override
  @JsonKey()
  final String icon;
  @override
  @JsonKey(name: 'created_at', fromJson: dateFromUnknown, toJson: dateToUnknown)
  final String? createdAt;
  final Map<String, dynamic> _extraData;
  @override
  @JsonKey(name: 'extra_data')
  Map<String, dynamic> get extraData {
    if (_extraData is EqualUnmodifiableMapView) return _extraData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_extraData);
  }

  @override
  @JsonKey(
      fromJson: NotificationTopic.fromJson, toJson: NotificationTopic.toJson)
  final NotificationTopic topic;
  @override
  @JsonKey(
      fromJson: NotificationAction.fromJson, toJson: NotificationAction.toJson)
  final NotificationAction action;
  @override
  @JsonKey(
      fromJson: NotificationPriority.fromJson,
      toJson: NotificationPriority.toJson)
  final NotificationPriority priority;

  @override
  String toString() {
    return 'NotificationPayload(id: $id, userId: $userId, sender: $sender, title: $title, body: $body, icon: $icon, createdAt: $createdAt, extraData: $extraData, topic: $topic, action: $action, priority: $priority)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationPayloadImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality()
                .equals(other._extraData, _extraData) &&
            (identical(other.topic, topic) || other.topic == topic) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.priority, priority) ||
                other.priority == priority));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      sender,
      title,
      body,
      icon,
      createdAt,
      const DeepCollectionEquality().hash(_extraData),
      topic,
      action,
      priority);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationPayloadImplCopyWith<_$NotificationPayloadImpl> get copyWith =>
      __$$NotificationPayloadImplCopyWithImpl<_$NotificationPayloadImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationPayloadImplToJson(
      this,
    );
  }
}

abstract class _NotificationPayload implements NotificationPayload {
  const factory _NotificationPayload(
      {final String id,
      @JsonKey(name: 'user_id') final String userId,
      final String sender,
      final String title,
      final String body,
      final String icon,
      @JsonKey(
          name: 'created_at', fromJson: dateFromUnknown, toJson: dateToUnknown)
      final String? createdAt,
      @JsonKey(name: 'extra_data') final Map<String, dynamic> extraData,
      @JsonKey(
          fromJson: NotificationTopic.fromJson,
          toJson: NotificationTopic.toJson)
      final NotificationTopic topic,
      @JsonKey(
          fromJson: NotificationAction.fromJson,
          toJson: NotificationAction.toJson)
      final NotificationAction action,
      @JsonKey(
          fromJson: NotificationPriority.fromJson,
          toJson: NotificationPriority.toJson)
      final NotificationPriority priority}) = _$NotificationPayloadImpl;

  factory _NotificationPayload.fromJson(Map<String, dynamic> json) =
      _$NotificationPayloadImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  String get sender;
  @override
  String get title;
  @override
  String get body;
  @override
  String get icon;
  @override
  @JsonKey(name: 'created_at', fromJson: dateFromUnknown, toJson: dateToUnknown)
  String? get createdAt;
  @override
  @JsonKey(name: 'extra_data')
  Map<String, dynamic> get extraData;
  @override
  @JsonKey(
      fromJson: NotificationTopic.fromJson, toJson: NotificationTopic.toJson)
  NotificationTopic get topic;
  @override
  @JsonKey(
      fromJson: NotificationAction.fromJson, toJson: NotificationAction.toJson)
  NotificationAction get action;
  @override
  @JsonKey(
      fromJson: NotificationPriority.fromJson,
      toJson: NotificationPriority.toJson)
  NotificationPriority get priority;
  @override
  @JsonKey(ignore: true)
  _$$NotificationPayloadImplCopyWith<_$NotificationPayloadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$NotificationPriority {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() lowPriority,
    required TResult Function() defaultPriority,
    required TResult Function() highPriority,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? lowPriority,
    TResult? Function()? defaultPriority,
    TResult? Function()? highPriority,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? lowPriority,
    TResult Function()? defaultPriority,
    TResult Function()? highPriority,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_NotificationPriorityLow value) lowPriority,
    required TResult Function(_NotificationPriorityDefault value)
        defaultPriority,
    required TResult Function(_NotificationPriorityHigh value) highPriority,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_NotificationPriorityLow value)? lowPriority,
    TResult? Function(_NotificationPriorityDefault value)? defaultPriority,
    TResult? Function(_NotificationPriorityHigh value)? highPriority,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_NotificationPriorityLow value)? lowPriority,
    TResult Function(_NotificationPriorityDefault value)? defaultPriority,
    TResult Function(_NotificationPriorityHigh value)? highPriority,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationPriorityCopyWith<$Res> {
  factory $NotificationPriorityCopyWith(NotificationPriority value,
          $Res Function(NotificationPriority) then) =
      _$NotificationPriorityCopyWithImpl<$Res, NotificationPriority>;
}

/// @nodoc
class _$NotificationPriorityCopyWithImpl<$Res,
        $Val extends NotificationPriority>
    implements $NotificationPriorityCopyWith<$Res> {
  _$NotificationPriorityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$NotificationPriorityLowImplCopyWith<$Res> {
  factory _$$NotificationPriorityLowImplCopyWith(
          _$NotificationPriorityLowImpl value,
          $Res Function(_$NotificationPriorityLowImpl) then) =
      __$$NotificationPriorityLowImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NotificationPriorityLowImplCopyWithImpl<$Res>
    extends _$NotificationPriorityCopyWithImpl<$Res,
        _$NotificationPriorityLowImpl>
    implements _$$NotificationPriorityLowImplCopyWith<$Res> {
  __$$NotificationPriorityLowImplCopyWithImpl(
      _$NotificationPriorityLowImpl _value,
      $Res Function(_$NotificationPriorityLowImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$NotificationPriorityLowImpl implements _NotificationPriorityLow {
  const _$NotificationPriorityLowImpl();

  @override
  String toString() {
    return 'NotificationPriority.lowPriority()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationPriorityLowImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() lowPriority,
    required TResult Function() defaultPriority,
    required TResult Function() highPriority,
  }) {
    return lowPriority();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? lowPriority,
    TResult? Function()? defaultPriority,
    TResult? Function()? highPriority,
  }) {
    return lowPriority?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? lowPriority,
    TResult Function()? defaultPriority,
    TResult Function()? highPriority,
    required TResult orElse(),
  }) {
    if (lowPriority != null) {
      return lowPriority();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_NotificationPriorityLow value) lowPriority,
    required TResult Function(_NotificationPriorityDefault value)
        defaultPriority,
    required TResult Function(_NotificationPriorityHigh value) highPriority,
  }) {
    return lowPriority(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_NotificationPriorityLow value)? lowPriority,
    TResult? Function(_NotificationPriorityDefault value)? defaultPriority,
    TResult? Function(_NotificationPriorityHigh value)? highPriority,
  }) {
    return lowPriority?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_NotificationPriorityLow value)? lowPriority,
    TResult Function(_NotificationPriorityDefault value)? defaultPriority,
    TResult Function(_NotificationPriorityHigh value)? highPriority,
    required TResult orElse(),
  }) {
    if (lowPriority != null) {
      return lowPriority(this);
    }
    return orElse();
  }
}

abstract class _NotificationPriorityLow implements NotificationPriority {
  const factory _NotificationPriorityLow() = _$NotificationPriorityLowImpl;
}

/// @nodoc
abstract class _$$NotificationPriorityDefaultImplCopyWith<$Res> {
  factory _$$NotificationPriorityDefaultImplCopyWith(
          _$NotificationPriorityDefaultImpl value,
          $Res Function(_$NotificationPriorityDefaultImpl) then) =
      __$$NotificationPriorityDefaultImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NotificationPriorityDefaultImplCopyWithImpl<$Res>
    extends _$NotificationPriorityCopyWithImpl<$Res,
        _$NotificationPriorityDefaultImpl>
    implements _$$NotificationPriorityDefaultImplCopyWith<$Res> {
  __$$NotificationPriorityDefaultImplCopyWithImpl(
      _$NotificationPriorityDefaultImpl _value,
      $Res Function(_$NotificationPriorityDefaultImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$NotificationPriorityDefaultImpl
    implements _NotificationPriorityDefault {
  const _$NotificationPriorityDefaultImpl();

  @override
  String toString() {
    return 'NotificationPriority.defaultPriority()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationPriorityDefaultImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() lowPriority,
    required TResult Function() defaultPriority,
    required TResult Function() highPriority,
  }) {
    return defaultPriority();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? lowPriority,
    TResult? Function()? defaultPriority,
    TResult? Function()? highPriority,
  }) {
    return defaultPriority?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? lowPriority,
    TResult Function()? defaultPriority,
    TResult Function()? highPriority,
    required TResult orElse(),
  }) {
    if (defaultPriority != null) {
      return defaultPriority();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_NotificationPriorityLow value) lowPriority,
    required TResult Function(_NotificationPriorityDefault value)
        defaultPriority,
    required TResult Function(_NotificationPriorityHigh value) highPriority,
  }) {
    return defaultPriority(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_NotificationPriorityLow value)? lowPriority,
    TResult? Function(_NotificationPriorityDefault value)? defaultPriority,
    TResult? Function(_NotificationPriorityHigh value)? highPriority,
  }) {
    return defaultPriority?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_NotificationPriorityLow value)? lowPriority,
    TResult Function(_NotificationPriorityDefault value)? defaultPriority,
    TResult Function(_NotificationPriorityHigh value)? highPriority,
    required TResult orElse(),
  }) {
    if (defaultPriority != null) {
      return defaultPriority(this);
    }
    return orElse();
  }
}

abstract class _NotificationPriorityDefault implements NotificationPriority {
  const factory _NotificationPriorityDefault() =
      _$NotificationPriorityDefaultImpl;
}

/// @nodoc
abstract class _$$NotificationPriorityHighImplCopyWith<$Res> {
  factory _$$NotificationPriorityHighImplCopyWith(
          _$NotificationPriorityHighImpl value,
          $Res Function(_$NotificationPriorityHighImpl) then) =
      __$$NotificationPriorityHighImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NotificationPriorityHighImplCopyWithImpl<$Res>
    extends _$NotificationPriorityCopyWithImpl<$Res,
        _$NotificationPriorityHighImpl>
    implements _$$NotificationPriorityHighImplCopyWith<$Res> {
  __$$NotificationPriorityHighImplCopyWithImpl(
      _$NotificationPriorityHighImpl _value,
      $Res Function(_$NotificationPriorityHighImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$NotificationPriorityHighImpl implements _NotificationPriorityHigh {
  const _$NotificationPriorityHighImpl();

  @override
  String toString() {
    return 'NotificationPriority.highPriority()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationPriorityHighImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() lowPriority,
    required TResult Function() defaultPriority,
    required TResult Function() highPriority,
  }) {
    return highPriority();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? lowPriority,
    TResult? Function()? defaultPriority,
    TResult? Function()? highPriority,
  }) {
    return highPriority?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? lowPriority,
    TResult Function()? defaultPriority,
    TResult Function()? highPriority,
    required TResult orElse(),
  }) {
    if (highPriority != null) {
      return highPriority();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_NotificationPriorityLow value) lowPriority,
    required TResult Function(_NotificationPriorityDefault value)
        defaultPriority,
    required TResult Function(_NotificationPriorityHigh value) highPriority,
  }) {
    return highPriority(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_NotificationPriorityLow value)? lowPriority,
    TResult? Function(_NotificationPriorityDefault value)? defaultPriority,
    TResult? Function(_NotificationPriorityHigh value)? highPriority,
  }) {
    return highPriority?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_NotificationPriorityLow value)? lowPriority,
    TResult Function(_NotificationPriorityDefault value)? defaultPriority,
    TResult Function(_NotificationPriorityHigh value)? highPriority,
    required TResult orElse(),
  }) {
    if (highPriority != null) {
      return highPriority(this);
    }
    return orElse();
  }
}

abstract class _NotificationPriorityHigh implements NotificationPriority {
  const factory _NotificationPriorityHigh() = _$NotificationPriorityHighImpl;
}
