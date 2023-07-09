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
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta => throw _privateConstructorUsedError;
  String get key => throw _privateConstructorUsedError;
  String get sender => throw _privateConstructorUsedError;
  String get receiver => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  String get icon => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: NotificationTopic.fromJson, toJson: NotificationTopic.toJson)
  NotificationTopic get topic => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: NotificationAction.fromJson, toJson: NotificationAction.toJson)
  NotificationAction get action => throw _privateConstructorUsedError;
  bool get hasDismissed => throw _privateConstructorUsedError;
  Map<String, dynamic> get extraData => throw _privateConstructorUsedError;
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
      {@JsonKey(name: '_fl_meta_') FlMeta? flMeta,
      String key,
      String sender,
      String receiver,
      String title,
      String body,
      String icon,
      @JsonKey(
          fromJson: NotificationTopic.fromJson,
          toJson: NotificationTopic.toJson)
      NotificationTopic topic,
      String type,
      @JsonKey(
          fromJson: NotificationAction.fromJson,
          toJson: NotificationAction.toJson)
      NotificationAction action,
      bool hasDismissed,
      Map<String, dynamic> extraData,
      @JsonKey(
          fromJson: NotificationPriority.fromJson,
          toJson: NotificationPriority.toJson)
      NotificationPriority priority});

  $FlMetaCopyWith<$Res>? get flMeta;
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
    Object? flMeta = freezed,
    Object? key = null,
    Object? sender = null,
    Object? receiver = null,
    Object? title = null,
    Object? body = null,
    Object? icon = null,
    Object? topic = null,
    Object? type = null,
    Object? action = null,
    Object? hasDismissed = null,
    Object? extraData = null,
    Object? priority = null,
  }) {
    return _then(_value.copyWith(
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      sender: null == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as String,
      receiver: null == receiver
          ? _value.receiver
          : receiver // ignore: cast_nullable_to_non_nullable
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
      topic: null == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as NotificationTopic,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as NotificationAction,
      hasDismissed: null == hasDismissed
          ? _value.hasDismissed
          : hasDismissed // ignore: cast_nullable_to_non_nullable
              as bool,
      extraData: null == extraData
          ? _value.extraData
          : extraData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as NotificationPriority,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $FlMetaCopyWith<$Res>? get flMeta {
    if (_value.flMeta == null) {
      return null;
    }

    return $FlMetaCopyWith<$Res>(_value.flMeta!, (value) {
      return _then(_value.copyWith(flMeta: value) as $Val);
    });
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
abstract class _$$_NotificationPayloadCopyWith<$Res>
    implements $NotificationPayloadCopyWith<$Res> {
  factory _$$_NotificationPayloadCopyWith(_$_NotificationPayload value,
          $Res Function(_$_NotificationPayload) then) =
      __$$_NotificationPayloadCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_fl_meta_') FlMeta? flMeta,
      String key,
      String sender,
      String receiver,
      String title,
      String body,
      String icon,
      @JsonKey(
          fromJson: NotificationTopic.fromJson,
          toJson: NotificationTopic.toJson)
      NotificationTopic topic,
      String type,
      @JsonKey(
          fromJson: NotificationAction.fromJson,
          toJson: NotificationAction.toJson)
      NotificationAction action,
      bool hasDismissed,
      Map<String, dynamic> extraData,
      @JsonKey(
          fromJson: NotificationPriority.fromJson,
          toJson: NotificationPriority.toJson)
      NotificationPriority priority});

  @override
  $FlMetaCopyWith<$Res>? get flMeta;
  @override
  $NotificationTopicCopyWith<$Res> get topic;
  @override
  $NotificationActionCopyWith<$Res> get action;
  @override
  $NotificationPriorityCopyWith<$Res> get priority;
}

/// @nodoc
class __$$_NotificationPayloadCopyWithImpl<$Res>
    extends _$NotificationPayloadCopyWithImpl<$Res, _$_NotificationPayload>
    implements _$$_NotificationPayloadCopyWith<$Res> {
  __$$_NotificationPayloadCopyWithImpl(_$_NotificationPayload _value,
      $Res Function(_$_NotificationPayload) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flMeta = freezed,
    Object? key = null,
    Object? sender = null,
    Object? receiver = null,
    Object? title = null,
    Object? body = null,
    Object? icon = null,
    Object? topic = null,
    Object? type = null,
    Object? action = null,
    Object? hasDismissed = null,
    Object? extraData = null,
    Object? priority = null,
  }) {
    return _then(_$_NotificationPayload(
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      sender: null == sender
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as String,
      receiver: null == receiver
          ? _value.receiver
          : receiver // ignore: cast_nullable_to_non_nullable
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
      topic: null == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as NotificationTopic,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as NotificationAction,
      hasDismissed: null == hasDismissed
          ? _value.hasDismissed
          : hasDismissed // ignore: cast_nullable_to_non_nullable
              as bool,
      extraData: null == extraData
          ? _value._extraData
          : extraData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as NotificationPriority,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_NotificationPayload implements _NotificationPayload {
  const _$_NotificationPayload(
      {@JsonKey(name: '_fl_meta_') this.flMeta,
      this.key = '',
      this.sender = '',
      this.receiver = '',
      this.title = '',
      this.body = '',
      this.icon = '',
      @JsonKey(
          fromJson: NotificationTopic.fromJson,
          toJson: NotificationTopic.toJson)
      this.topic = const NotificationTopic.other(),
      this.type = '',
      @JsonKey(
          fromJson: NotificationAction.fromJson,
          toJson: NotificationAction.toJson)
      this.action = const NotificationAction.none(),
      this.hasDismissed = false,
      final Map<String, dynamic> extraData = const {},
      @JsonKey(
          fromJson: NotificationPriority.fromJson,
          toJson: NotificationPriority.toJson)
      this.priority = const NotificationPriority.defaultPriority()})
      : _extraData = extraData;

  factory _$_NotificationPayload.fromJson(Map<String, dynamic> json) =>
      _$$_NotificationPayloadFromJson(json);

  @override
  @JsonKey(name: '_fl_meta_')
  final FlMeta? flMeta;
  @override
  @JsonKey()
  final String key;
  @override
  @JsonKey()
  final String sender;
  @override
  @JsonKey()
  final String receiver;
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
  @JsonKey(
      fromJson: NotificationTopic.fromJson, toJson: NotificationTopic.toJson)
  final NotificationTopic topic;
  @override
  @JsonKey()
  final String type;
  @override
  @JsonKey(
      fromJson: NotificationAction.fromJson, toJson: NotificationAction.toJson)
  final NotificationAction action;
  @override
  @JsonKey()
  final bool hasDismissed;
  final Map<String, dynamic> _extraData;
  @override
  @JsonKey()
  Map<String, dynamic> get extraData {
    if (_extraData is EqualUnmodifiableMapView) return _extraData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_extraData);
  }

  @override
  @JsonKey(
      fromJson: NotificationPriority.fromJson,
      toJson: NotificationPriority.toJson)
  final NotificationPriority priority;

  @override
  String toString() {
    return 'NotificationPayload(flMeta: $flMeta, key: $key, sender: $sender, receiver: $receiver, title: $title, body: $body, icon: $icon, topic: $topic, type: $type, action: $action, hasDismissed: $hasDismissed, extraData: $extraData, priority: $priority)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_NotificationPayload &&
            (identical(other.flMeta, flMeta) || other.flMeta == flMeta) &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.sender, sender) || other.sender == sender) &&
            (identical(other.receiver, receiver) ||
                other.receiver == receiver) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.topic, topic) || other.topic == topic) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.hasDismissed, hasDismissed) ||
                other.hasDismissed == hasDismissed) &&
            const DeepCollectionEquality()
                .equals(other._extraData, _extraData) &&
            (identical(other.priority, priority) ||
                other.priority == priority));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      flMeta,
      key,
      sender,
      receiver,
      title,
      body,
      icon,
      topic,
      type,
      action,
      hasDismissed,
      const DeepCollectionEquality().hash(_extraData),
      priority);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_NotificationPayloadCopyWith<_$_NotificationPayload> get copyWith =>
      __$$_NotificationPayloadCopyWithImpl<_$_NotificationPayload>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_NotificationPayloadToJson(
      this,
    );
  }
}

abstract class _NotificationPayload implements NotificationPayload {
  const factory _NotificationPayload(
      {@JsonKey(name: '_fl_meta_') final FlMeta? flMeta,
      final String key,
      final String sender,
      final String receiver,
      final String title,
      final String body,
      final String icon,
      @JsonKey(
          fromJson: NotificationTopic.fromJson,
          toJson: NotificationTopic.toJson)
      final NotificationTopic topic,
      final String type,
      @JsonKey(
          fromJson: NotificationAction.fromJson,
          toJson: NotificationAction.toJson)
      final NotificationAction action,
      final bool hasDismissed,
      final Map<String, dynamic> extraData,
      @JsonKey(
          fromJson: NotificationPriority.fromJson,
          toJson: NotificationPriority.toJson)
      final NotificationPriority priority}) = _$_NotificationPayload;

  factory _NotificationPayload.fromJson(Map<String, dynamic> json) =
      _$_NotificationPayload.fromJson;

  @override
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta;
  @override
  String get key;
  @override
  String get sender;
  @override
  String get receiver;
  @override
  String get title;
  @override
  String get body;
  @override
  String get icon;
  @override
  @JsonKey(
      fromJson: NotificationTopic.fromJson, toJson: NotificationTopic.toJson)
  NotificationTopic get topic;
  @override
  String get type;
  @override
  @JsonKey(
      fromJson: NotificationAction.fromJson, toJson: NotificationAction.toJson)
  NotificationAction get action;
  @override
  bool get hasDismissed;
  @override
  Map<String, dynamic> get extraData;
  @override
  @JsonKey(
      fromJson: NotificationPriority.fromJson,
      toJson: NotificationPriority.toJson)
  NotificationPriority get priority;
  @override
  @JsonKey(ignore: true)
  _$$_NotificationPayloadCopyWith<_$_NotificationPayload> get copyWith =>
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
abstract class _$$_NotificationPriorityLowCopyWith<$Res> {
  factory _$$_NotificationPriorityLowCopyWith(_$_NotificationPriorityLow value,
          $Res Function(_$_NotificationPriorityLow) then) =
      __$$_NotificationPriorityLowCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_NotificationPriorityLowCopyWithImpl<$Res>
    extends _$NotificationPriorityCopyWithImpl<$Res, _$_NotificationPriorityLow>
    implements _$$_NotificationPriorityLowCopyWith<$Res> {
  __$$_NotificationPriorityLowCopyWithImpl(_$_NotificationPriorityLow _value,
      $Res Function(_$_NotificationPriorityLow) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_NotificationPriorityLow implements _NotificationPriorityLow {
  const _$_NotificationPriorityLow();

  @override
  String toString() {
    return 'NotificationPriority.lowPriority()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_NotificationPriorityLow);
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
  const factory _NotificationPriorityLow() = _$_NotificationPriorityLow;
}

/// @nodoc
abstract class _$$_NotificationPriorityDefaultCopyWith<$Res> {
  factory _$$_NotificationPriorityDefaultCopyWith(
          _$_NotificationPriorityDefault value,
          $Res Function(_$_NotificationPriorityDefault) then) =
      __$$_NotificationPriorityDefaultCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_NotificationPriorityDefaultCopyWithImpl<$Res>
    extends _$NotificationPriorityCopyWithImpl<$Res,
        _$_NotificationPriorityDefault>
    implements _$$_NotificationPriorityDefaultCopyWith<$Res> {
  __$$_NotificationPriorityDefaultCopyWithImpl(
      _$_NotificationPriorityDefault _value,
      $Res Function(_$_NotificationPriorityDefault) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_NotificationPriorityDefault implements _NotificationPriorityDefault {
  const _$_NotificationPriorityDefault();

  @override
  String toString() {
    return 'NotificationPriority.defaultPriority()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_NotificationPriorityDefault);
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
  const factory _NotificationPriorityDefault() = _$_NotificationPriorityDefault;
}

/// @nodoc
abstract class _$$_NotificationPriorityHighCopyWith<$Res> {
  factory _$$_NotificationPriorityHighCopyWith(
          _$_NotificationPriorityHigh value,
          $Res Function(_$_NotificationPriorityHigh) then) =
      __$$_NotificationPriorityHighCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_NotificationPriorityHighCopyWithImpl<$Res>
    extends _$NotificationPriorityCopyWithImpl<$Res,
        _$_NotificationPriorityHigh>
    implements _$$_NotificationPriorityHighCopyWith<$Res> {
  __$$_NotificationPriorityHighCopyWithImpl(_$_NotificationPriorityHigh _value,
      $Res Function(_$_NotificationPriorityHigh) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_NotificationPriorityHigh implements _NotificationPriorityHigh {
  const _$_NotificationPriorityHigh();

  @override
  String toString() {
    return 'NotificationPriority.highPriority()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_NotificationPriorityHigh);
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
  const factory _NotificationPriorityHigh() = _$_NotificationPriorityHigh;
}
