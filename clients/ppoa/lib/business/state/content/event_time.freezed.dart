// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'event_time.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

EventTime _$EventTimeFromJson(Map<String, dynamic> json) {
  return _EventTime.fromJson(json);
}

/// @nodoc
mixin _$EventTime {
  DateTime? get startTime => throw _privateConstructorUsedError;
  DateTime? get endTime => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventTimeCopyWith<EventTime> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventTimeCopyWith<$Res> {
  factory $EventTimeCopyWith(EventTime value, $Res Function(EventTime) then) =
      _$EventTimeCopyWithImpl<$Res>;
  $Res call({DateTime? startTime, DateTime? endTime});
}

/// @nodoc
class _$EventTimeCopyWithImpl<$Res> implements $EventTimeCopyWith<$Res> {
  _$EventTimeCopyWithImpl(this._value, this._then);

  final EventTime _value;
  // ignore: unused_field
  final $Res Function(EventTime) _then;

  @override
  $Res call({
    Object? startTime = freezed,
    Object? endTime = freezed,
  }) {
    return _then(_value.copyWith(
      startTime: startTime == freezed
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endTime: endTime == freezed
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
abstract class _$$_EventTimeCopyWith<$Res> implements $EventTimeCopyWith<$Res> {
  factory _$$_EventTimeCopyWith(
          _$_EventTime value, $Res Function(_$_EventTime) then) =
      __$$_EventTimeCopyWithImpl<$Res>;
  @override
  $Res call({DateTime? startTime, DateTime? endTime});
}

/// @nodoc
class __$$_EventTimeCopyWithImpl<$Res> extends _$EventTimeCopyWithImpl<$Res>
    implements _$$_EventTimeCopyWith<$Res> {
  __$$_EventTimeCopyWithImpl(
      _$_EventTime _value, $Res Function(_$_EventTime) _then)
      : super(_value, (v) => _then(v as _$_EventTime));

  @override
  _$_EventTime get _value => super._value as _$_EventTime;

  @override
  $Res call({
    Object? startTime = freezed,
    Object? endTime = freezed,
  }) {
    return _then(_$_EventTime(
      startTime: startTime == freezed
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endTime: endTime == freezed
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$_EventTime implements _EventTime {
  const _$_EventTime({this.startTime, this.endTime});

  factory _$_EventTime.fromJson(Map<String, dynamic> json) =>
      _$$_EventTimeFromJson(json);

  @override
  final DateTime? startTime;
  @override
  final DateTime? endTime;

  @override
  String toString() {
    return 'EventTime(startTime: $startTime, endTime: $endTime)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_EventTime &&
            const DeepCollectionEquality().equals(other.startTime, startTime) &&
            const DeepCollectionEquality().equals(other.endTime, endTime));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(startTime),
      const DeepCollectionEquality().hash(endTime));

  @JsonKey(ignore: true)
  @override
  _$$_EventTimeCopyWith<_$_EventTime> get copyWith =>
      __$$_EventTimeCopyWithImpl<_$_EventTime>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_EventTimeToJson(
      this,
    );
  }
}

abstract class _EventTime implements EventTime {
  const factory _EventTime(
      {final DateTime? startTime, final DateTime? endTime}) = _$_EventTime;

  factory _EventTime.fromJson(Map<String, dynamic> json) =
      _$_EventTime.fromJson;

  @override
  DateTime? get startTime;
  @override
  DateTime? get endTime;
  @override
  @JsonKey(ignore: true)
  _$$_EventTimeCopyWith<_$_EventTime> get copyWith =>
      throw _privateConstructorUsedError;
}
