// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'design_system_button_simulation_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

DesignSystemButtonSimulationState _$DesignSystemButtonSimulationStateFromJson(
    Map<String, dynamic> json) {
  return _DesignSystemButtonSimulationState.fromJson(json);
}

/// @nodoc
mixin _$DesignSystemButtonSimulationState {
  String get buttonLabel => throw _privateConstructorUsedError;
  bool get isEnabled => throw _privateConstructorUsedError;
  String get iconStyle => throw _privateConstructorUsedError;
  ButtonIconAlignment get iconAlignment => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DesignSystemButtonSimulationStateCopyWith<DesignSystemButtonSimulationState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DesignSystemButtonSimulationStateCopyWith<$Res> {
  factory $DesignSystemButtonSimulationStateCopyWith(
          DesignSystemButtonSimulationState value,
          $Res Function(DesignSystemButtonSimulationState) then) =
      _$DesignSystemButtonSimulationStateCopyWithImpl<$Res>;
  $Res call(
      {String buttonLabel,
      bool isEnabled,
      String iconStyle,
      ButtonIconAlignment iconAlignment});
}

/// @nodoc
class _$DesignSystemButtonSimulationStateCopyWithImpl<$Res>
    implements $DesignSystemButtonSimulationStateCopyWith<$Res> {
  _$DesignSystemButtonSimulationStateCopyWithImpl(this._value, this._then);

  final DesignSystemButtonSimulationState _value;
  // ignore: unused_field
  final $Res Function(DesignSystemButtonSimulationState) _then;

  @override
  $Res call({
    Object? buttonLabel = freezed,
    Object? isEnabled = freezed,
    Object? iconStyle = freezed,
    Object? iconAlignment = freezed,
  }) {
    return _then(_value.copyWith(
      buttonLabel: buttonLabel == freezed
          ? _value.buttonLabel
          : buttonLabel // ignore: cast_nullable_to_non_nullable
              as String,
      isEnabled: isEnabled == freezed
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      iconStyle: iconStyle == freezed
          ? _value.iconStyle
          : iconStyle // ignore: cast_nullable_to_non_nullable
              as String,
      iconAlignment: iconAlignment == freezed
          ? _value.iconAlignment
          : iconAlignment // ignore: cast_nullable_to_non_nullable
              as ButtonIconAlignment,
    ));
  }
}

/// @nodoc
abstract class _$$_DesignSystemButtonSimulationStateCopyWith<$Res>
    implements $DesignSystemButtonSimulationStateCopyWith<$Res> {
  factory _$$_DesignSystemButtonSimulationStateCopyWith(
          _$_DesignSystemButtonSimulationState value,
          $Res Function(_$_DesignSystemButtonSimulationState) then) =
      __$$_DesignSystemButtonSimulationStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {String buttonLabel,
      bool isEnabled,
      String iconStyle,
      ButtonIconAlignment iconAlignment});
}

/// @nodoc
class __$$_DesignSystemButtonSimulationStateCopyWithImpl<$Res>
    extends _$DesignSystemButtonSimulationStateCopyWithImpl<$Res>
    implements _$$_DesignSystemButtonSimulationStateCopyWith<$Res> {
  __$$_DesignSystemButtonSimulationStateCopyWithImpl(
      _$_DesignSystemButtonSimulationState _value,
      $Res Function(_$_DesignSystemButtonSimulationState) _then)
      : super(_value, (v) => _then(v as _$_DesignSystemButtonSimulationState));

  @override
  _$_DesignSystemButtonSimulationState get _value =>
      super._value as _$_DesignSystemButtonSimulationState;

  @override
  $Res call({
    Object? buttonLabel = freezed,
    Object? isEnabled = freezed,
    Object? iconStyle = freezed,
    Object? iconAlignment = freezed,
  }) {
    return _then(_$_DesignSystemButtonSimulationState(
      buttonLabel: buttonLabel == freezed
          ? _value.buttonLabel
          : buttonLabel // ignore: cast_nullable_to_non_nullable
              as String,
      isEnabled: isEnabled == freezed
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      iconStyle: iconStyle == freezed
          ? _value.iconStyle
          : iconStyle // ignore: cast_nullable_to_non_nullable
              as String,
      iconAlignment: iconAlignment == freezed
          ? _value.iconAlignment
          : iconAlignment // ignore: cast_nullable_to_non_nullable
              as ButtonIconAlignment,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$_DesignSystemButtonSimulationState
    implements _DesignSystemButtonSimulationState {
  const _$_DesignSystemButtonSimulationState(
      {required this.buttonLabel,
      required this.isEnabled,
      required this.iconStyle,
      required this.iconAlignment});

  factory _$_DesignSystemButtonSimulationState.fromJson(
          Map<String, dynamic> json) =>
      _$$_DesignSystemButtonSimulationStateFromJson(json);

  @override
  final String buttonLabel;
  @override
  final bool isEnabled;
  @override
  final String iconStyle;
  @override
  final ButtonIconAlignment iconAlignment;

  @override
  String toString() {
    return 'DesignSystemButtonSimulationState(buttonLabel: $buttonLabel, isEnabled: $isEnabled, iconStyle: $iconStyle, iconAlignment: $iconAlignment)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_DesignSystemButtonSimulationState &&
            const DeepCollectionEquality()
                .equals(other.buttonLabel, buttonLabel) &&
            const DeepCollectionEquality().equals(other.isEnabled, isEnabled) &&
            const DeepCollectionEquality().equals(other.iconStyle, iconStyle) &&
            const DeepCollectionEquality()
                .equals(other.iconAlignment, iconAlignment));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(buttonLabel),
      const DeepCollectionEquality().hash(isEnabled),
      const DeepCollectionEquality().hash(iconStyle),
      const DeepCollectionEquality().hash(iconAlignment));

  @JsonKey(ignore: true)
  @override
  _$$_DesignSystemButtonSimulationStateCopyWith<
          _$_DesignSystemButtonSimulationState>
      get copyWith => __$$_DesignSystemButtonSimulationStateCopyWithImpl<
          _$_DesignSystemButtonSimulationState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_DesignSystemButtonSimulationStateToJson(
      this,
    );
  }
}

abstract class _DesignSystemButtonSimulationState
    implements DesignSystemButtonSimulationState {
  const factory _DesignSystemButtonSimulationState(
          {required final String buttonLabel,
          required final bool isEnabled,
          required final String iconStyle,
          required final ButtonIconAlignment iconAlignment}) =
      _$_DesignSystemButtonSimulationState;

  factory _DesignSystemButtonSimulationState.fromJson(
          Map<String, dynamic> json) =
      _$_DesignSystemButtonSimulationState.fromJson;

  @override
  String get buttonLabel;
  @override
  bool get isEnabled;
  @override
  String get iconStyle;
  @override
  ButtonIconAlignment get iconAlignment;
  @override
  @JsonKey(ignore: true)
  _$$_DesignSystemButtonSimulationStateCopyWith<
          _$_DesignSystemButtonSimulationState>
      get copyWith => throw _privateConstructorUsedError;
}
