// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'system_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SystemState _$SystemStateFromJson(Map<String, dynamic> json) {
  return _SystemState.fromJson(json);
}

/// @nodoc
mixin _$SystemState {
  bool get isBusy => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SystemStateCopyWith<SystemState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SystemStateCopyWith<$Res> {
  factory $SystemStateCopyWith(
          SystemState value, $Res Function(SystemState) then) =
      _$SystemStateCopyWithImpl<$Res>;
  $Res call({bool isBusy});
}

/// @nodoc
class _$SystemStateCopyWithImpl<$Res> implements $SystemStateCopyWith<$Res> {
  _$SystemStateCopyWithImpl(this._value, this._then);

  final SystemState _value;
  // ignore: unused_field
  final $Res Function(SystemState) _then;

  @override
  $Res call({
    Object? isBusy = freezed,
  }) {
    return _then(_value.copyWith(
      isBusy: isBusy == freezed
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$$_SystemStateCopyWith<$Res>
    implements $SystemStateCopyWith<$Res> {
  factory _$$_SystemStateCopyWith(
          _$_SystemState value, $Res Function(_$_SystemState) then) =
      __$$_SystemStateCopyWithImpl<$Res>;
  @override
  $Res call({bool isBusy});
}

/// @nodoc
class __$$_SystemStateCopyWithImpl<$Res> extends _$SystemStateCopyWithImpl<$Res>
    implements _$$_SystemStateCopyWith<$Res> {
  __$$_SystemStateCopyWithImpl(
      _$_SystemState _value, $Res Function(_$_SystemState) _then)
      : super(_value, (v) => _then(v as _$_SystemState));

  @override
  _$_SystemState get _value => super._value as _$_SystemState;

  @override
  $Res call({
    Object? isBusy = freezed,
  }) {
    return _then(_$_SystemState(
      isBusy: isBusy == freezed
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$_SystemState implements _SystemState {
  const _$_SystemState({required this.isBusy});

  factory _$_SystemState.fromJson(Map<String, dynamic> json) =>
      _$$_SystemStateFromJson(json);

  @override
  final bool isBusy;

  @override
  String toString() {
    return 'SystemState(isBusy: $isBusy)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SystemState &&
            const DeepCollectionEquality().equals(other.isBusy, isBusy));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(isBusy));

  @JsonKey(ignore: true)
  @override
  _$$_SystemStateCopyWith<_$_SystemState> get copyWith =>
      __$$_SystemStateCopyWithImpl<_$_SystemState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SystemStateToJson(
      this,
    );
  }
}

abstract class _SystemState implements SystemState {
  const factory _SystemState({required final bool isBusy}) = _$_SystemState;

  factory _SystemState.fromJson(Map<String, dynamic> json) =
      _$_SystemState.fromJson;

  @override
  bool get isBusy;
  @override
  @JsonKey(ignore: true)
  _$$_SystemStateCopyWith<_$_SystemState> get copyWith =>
      throw _privateConstructorUsedError;
}
