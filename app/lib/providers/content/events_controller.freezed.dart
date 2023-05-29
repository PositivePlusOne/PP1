// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'events_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$EventsControllerState {
  List<Activity> get events => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EventsControllerStateCopyWith<EventsControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventsControllerStateCopyWith<$Res> {
  factory $EventsControllerStateCopyWith(EventsControllerState value,
          $Res Function(EventsControllerState) then) =
      _$EventsControllerStateCopyWithImpl<$Res, EventsControllerState>;
  @useResult
  $Res call({List<Activity> events});
}

/// @nodoc
class _$EventsControllerStateCopyWithImpl<$Res,
        $Val extends EventsControllerState>
    implements $EventsControllerStateCopyWith<$Res> {
  _$EventsControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? events = null,
  }) {
    return _then(_value.copyWith(
      events: null == events
          ? _value.events
          : events // ignore: cast_nullable_to_non_nullable
              as List<Activity>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_EventsControllerStateCopyWith<$Res>
    implements $EventsControllerStateCopyWith<$Res> {
  factory _$$_EventsControllerStateCopyWith(_$_EventsControllerState value,
          $Res Function(_$_EventsControllerState) then) =
      __$$_EventsControllerStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Activity> events});
}

/// @nodoc
class __$$_EventsControllerStateCopyWithImpl<$Res>
    extends _$EventsControllerStateCopyWithImpl<$Res, _$_EventsControllerState>
    implements _$$_EventsControllerStateCopyWith<$Res> {
  __$$_EventsControllerStateCopyWithImpl(_$_EventsControllerState _value,
      $Res Function(_$_EventsControllerState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? events = null,
  }) {
    return _then(_$_EventsControllerState(
      events: null == events
          ? _value._events
          : events // ignore: cast_nullable_to_non_nullable
              as List<Activity>,
    ));
  }
}

/// @nodoc

class _$_EventsControllerState extends _EventsControllerState {
  const _$_EventsControllerState({final List<Activity> events = const []})
      : _events = events,
        super._();

  final List<Activity> _events;
  @override
  @JsonKey()
  List<Activity> get events {
    if (_events is EqualUnmodifiableListView) return _events;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_events);
  }

  @override
  String toString() {
    return 'EventsControllerState(events: $events)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_EventsControllerState &&
            const DeepCollectionEquality().equals(other._events, _events));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_events));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_EventsControllerStateCopyWith<_$_EventsControllerState> get copyWith =>
      __$$_EventsControllerStateCopyWithImpl<_$_EventsControllerState>(
          this, _$identity);
}

abstract class _EventsControllerState extends EventsControllerState {
  const factory _EventsControllerState({final List<Activity> events}) =
      _$_EventsControllerState;
  const _EventsControllerState._() : super._();

  @override
  List<Activity> get events;
  @override
  @JsonKey(ignore: true)
  _$$_EventsControllerStateCopyWith<_$_EventsControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}
