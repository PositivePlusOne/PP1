// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'design_system_buttons.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

DesignSystemButtons _$DesignSystemButtonsFromJson(Map<String, dynamic> json) {
  return _DesignSystemButtons.fromJson(json);
}

/// @nodoc
mixin _$DesignSystemButtons {
  String get buttonLabel => throw _privateConstructorUsedError;
  ButtonStyle get buttonStyle => throw _privateConstructorUsedError;
  bool get isEnabled => throw _privateConstructorUsedError;
  String get iconType => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DesignSystemButtonsCopyWith<DesignSystemButtons> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DesignSystemButtonsCopyWith<$Res> {
  factory $DesignSystemButtonsCopyWith(
          DesignSystemButtons value, $Res Function(DesignSystemButtons) then) =
      _$DesignSystemButtonsCopyWithImpl<$Res>;
  $Res call(
      {String buttonLabel,
      ButtonStyle buttonStyle,
      bool isEnabled,
      String iconType});
}

/// @nodoc
class _$DesignSystemButtonsCopyWithImpl<$Res>
    implements $DesignSystemButtonsCopyWith<$Res> {
  _$DesignSystemButtonsCopyWithImpl(this._value, this._then);

  final DesignSystemButtons _value;
  // ignore: unused_field
  final $Res Function(DesignSystemButtons) _then;

  @override
  $Res call({
    Object? buttonLabel = freezed,
    Object? buttonStyle = freezed,
    Object? isEnabled = freezed,
    Object? iconType = freezed,
  }) {
    return _then(_value.copyWith(
      buttonLabel: buttonLabel == freezed
          ? _value.buttonLabel
          : buttonLabel // ignore: cast_nullable_to_non_nullable
              as String,
      buttonStyle: buttonStyle == freezed
          ? _value.buttonStyle
          : buttonStyle // ignore: cast_nullable_to_non_nullable
              as ButtonStyle,
      isEnabled: isEnabled == freezed
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      iconType: iconType == freezed
          ? _value.iconType
          : iconType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_DesignSystemButtonsCopyWith<$Res>
    implements $DesignSystemButtonsCopyWith<$Res> {
  factory _$$_DesignSystemButtonsCopyWith(_$_DesignSystemButtons value,
          $Res Function(_$_DesignSystemButtons) then) =
      __$$_DesignSystemButtonsCopyWithImpl<$Res>;
  @override
  $Res call(
      {String buttonLabel,
      ButtonStyle buttonStyle,
      bool isEnabled,
      String iconType});
}

/// @nodoc
class __$$_DesignSystemButtonsCopyWithImpl<$Res>
    extends _$DesignSystemButtonsCopyWithImpl<$Res>
    implements _$$_DesignSystemButtonsCopyWith<$Res> {
  __$$_DesignSystemButtonsCopyWithImpl(_$_DesignSystemButtons _value,
      $Res Function(_$_DesignSystemButtons) _then)
      : super(_value, (v) => _then(v as _$_DesignSystemButtons));

  @override
  _$_DesignSystemButtons get _value => super._value as _$_DesignSystemButtons;

  @override
  $Res call({
    Object? buttonLabel = freezed,
    Object? buttonStyle = freezed,
    Object? isEnabled = freezed,
    Object? iconType = freezed,
  }) {
    return _then(_$_DesignSystemButtons(
      buttonLabel: buttonLabel == freezed
          ? _value.buttonLabel
          : buttonLabel // ignore: cast_nullable_to_non_nullable
              as String,
      buttonStyle: buttonStyle == freezed
          ? _value.buttonStyle
          : buttonStyle // ignore: cast_nullable_to_non_nullable
              as ButtonStyle,
      isEnabled: isEnabled == freezed
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      iconType: iconType == freezed
          ? _value.iconType
          : iconType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$_DesignSystemButtons implements _DesignSystemButtons {
  const _$_DesignSystemButtons(
      {required this.buttonLabel,
      required this.buttonStyle,
      required this.isEnabled,
      required this.iconType});

  factory _$_DesignSystemButtons.fromJson(Map<String, dynamic> json) =>
      _$$_DesignSystemButtonsFromJson(json);

  @override
  final String buttonLabel;
  @override
  final ButtonStyle buttonStyle;
  @override
  final bool isEnabled;
  @override
  final String iconType;

  @override
  String toString() {
    return 'DesignSystemButtons(buttonLabel: $buttonLabel, buttonStyle: $buttonStyle, isEnabled: $isEnabled, iconType: $iconType)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_DesignSystemButtons &&
            const DeepCollectionEquality()
                .equals(other.buttonLabel, buttonLabel) &&
            const DeepCollectionEquality()
                .equals(other.buttonStyle, buttonStyle) &&
            const DeepCollectionEquality().equals(other.isEnabled, isEnabled) &&
            const DeepCollectionEquality().equals(other.iconType, iconType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(buttonLabel),
      const DeepCollectionEquality().hash(buttonStyle),
      const DeepCollectionEquality().hash(isEnabled),
      const DeepCollectionEquality().hash(iconType));

  @JsonKey(ignore: true)
  @override
  _$$_DesignSystemButtonsCopyWith<_$_DesignSystemButtons> get copyWith =>
      __$$_DesignSystemButtonsCopyWithImpl<_$_DesignSystemButtons>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_DesignSystemButtonsToJson(
      this,
    );
  }
}

abstract class _DesignSystemButtons implements DesignSystemButtons {
  const factory _DesignSystemButtons(
      {required final String buttonLabel,
      required final ButtonStyle buttonStyle,
      required final bool isEnabled,
      required final String iconType}) = _$_DesignSystemButtons;

  factory _DesignSystemButtons.fromJson(Map<String, dynamic> json) =
      _$_DesignSystemButtons.fromJson;

  @override
  String get buttonLabel;
  @override
  ButtonStyle get buttonStyle;
  @override
  bool get isEnabled;
  @override
  String get iconType;
  @override
  @JsonKey(ignore: true)
  _$$_DesignSystemButtonsCopyWith<_$_DesignSystemButtons> get copyWith =>
      throw _privateConstructorUsedError;
}
