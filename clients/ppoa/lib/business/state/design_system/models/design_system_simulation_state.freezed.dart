// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'design_system_simulation_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

DesignSystemSimulationState _$DesignSystemSimulationStateFromJson(
    Map<String, dynamic> json) {
  return _DesignSystemSimulationState.fromJson(json);
}

/// @nodoc
mixin _$DesignSystemSimulationState {
  DesignSystemButtonSimulationState get buttons =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DesignSystemSimulationStateCopyWith<DesignSystemSimulationState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DesignSystemSimulationStateCopyWith<$Res> {
  factory $DesignSystemSimulationStateCopyWith(
          DesignSystemSimulationState value,
          $Res Function(DesignSystemSimulationState) then) =
      _$DesignSystemSimulationStateCopyWithImpl<$Res>;
  $Res call({DesignSystemButtonSimulationState buttons});

  $DesignSystemButtonSimulationStateCopyWith<$Res> get buttons;
}

/// @nodoc
class _$DesignSystemSimulationStateCopyWithImpl<$Res>
    implements $DesignSystemSimulationStateCopyWith<$Res> {
  _$DesignSystemSimulationStateCopyWithImpl(this._value, this._then);

  final DesignSystemSimulationState _value;
  // ignore: unused_field
  final $Res Function(DesignSystemSimulationState) _then;

  @override
  $Res call({
    Object? buttons = freezed,
  }) {
    return _then(_value.copyWith(
      buttons: buttons == freezed
          ? _value.buttons
          : buttons // ignore: cast_nullable_to_non_nullable
              as DesignSystemButtonSimulationState,
    ));
  }

  @override
  $DesignSystemButtonSimulationStateCopyWith<$Res> get buttons {
    return $DesignSystemButtonSimulationStateCopyWith<$Res>(_value.buttons,
        (value) {
      return _then(_value.copyWith(buttons: value));
    });
  }
}

/// @nodoc
abstract class _$$_DesignSystemSimulationStateCopyWith<$Res>
    implements $DesignSystemSimulationStateCopyWith<$Res> {
  factory _$$_DesignSystemSimulationStateCopyWith(
          _$_DesignSystemSimulationState value,
          $Res Function(_$_DesignSystemSimulationState) then) =
      __$$_DesignSystemSimulationStateCopyWithImpl<$Res>;
  @override
  $Res call({DesignSystemButtonSimulationState buttons});

  @override
  $DesignSystemButtonSimulationStateCopyWith<$Res> get buttons;
}

/// @nodoc
class __$$_DesignSystemSimulationStateCopyWithImpl<$Res>
    extends _$DesignSystemSimulationStateCopyWithImpl<$Res>
    implements _$$_DesignSystemSimulationStateCopyWith<$Res> {
  __$$_DesignSystemSimulationStateCopyWithImpl(
      _$_DesignSystemSimulationState _value,
      $Res Function(_$_DesignSystemSimulationState) _then)
      : super(_value, (v) => _then(v as _$_DesignSystemSimulationState));

  @override
  _$_DesignSystemSimulationState get _value =>
      super._value as _$_DesignSystemSimulationState;

  @override
  $Res call({
    Object? buttons = freezed,
  }) {
    return _then(_$_DesignSystemSimulationState(
      buttons: buttons == freezed
          ? _value.buttons
          : buttons // ignore: cast_nullable_to_non_nullable
              as DesignSystemButtonSimulationState,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$_DesignSystemSimulationState implements _DesignSystemSimulationState {
  const _$_DesignSystemSimulationState({required this.buttons});

  factory _$_DesignSystemSimulationState.fromJson(Map<String, dynamic> json) =>
      _$$_DesignSystemSimulationStateFromJson(json);

  @override
  final DesignSystemButtonSimulationState buttons;

  @override
  String toString() {
    return 'DesignSystemSimulationState(buttons: $buttons)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_DesignSystemSimulationState &&
            const DeepCollectionEquality().equals(other.buttons, buttons));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(buttons));

  @JsonKey(ignore: true)
  @override
  _$$_DesignSystemSimulationStateCopyWith<_$_DesignSystemSimulationState>
      get copyWith => __$$_DesignSystemSimulationStateCopyWithImpl<
          _$_DesignSystemSimulationState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_DesignSystemSimulationStateToJson(
      this,
    );
  }
}

abstract class _DesignSystemSimulationState
    implements DesignSystemSimulationState {
  const factory _DesignSystemSimulationState(
          {required final DesignSystemButtonSimulationState buttons}) =
      _$_DesignSystemSimulationState;

  factory _DesignSystemSimulationState.fromJson(Map<String, dynamic> json) =
      _$_DesignSystemSimulationState.fromJson;

  @override
  DesignSystemButtonSimulationState get buttons;
  @override
  @JsonKey(ignore: true)
  _$$_DesignSystemSimulationStateCopyWith<_$_DesignSystemSimulationState>
      get copyWith => throw _privateConstructorUsedError;
}
