// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'design_system_typography.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

DesignSystemTypography _$DesignSystemTypographyFromJson(
    Map<String, dynamic> json) {
  return _DesignSystemTypography.fromJson(json);
}

/// @nodoc
mixin _$DesignSystemTypography {
  @JsonKey(fromJson: textStyleFromJson, toJson: textStyleToJson)
  TextStyle get styleHero => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DesignSystemTypographyCopyWith<DesignSystemTypography> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DesignSystemTypographyCopyWith<$Res> {
  factory $DesignSystemTypographyCopyWith(DesignSystemTypography value,
          $Res Function(DesignSystemTypography) then) =
      _$DesignSystemTypographyCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(fromJson: textStyleFromJson, toJson: textStyleToJson)
          TextStyle styleHero});
}

/// @nodoc
class _$DesignSystemTypographyCopyWithImpl<$Res>
    implements $DesignSystemTypographyCopyWith<$Res> {
  _$DesignSystemTypographyCopyWithImpl(this._value, this._then);

  final DesignSystemTypography _value;
  // ignore: unused_field
  final $Res Function(DesignSystemTypography) _then;

  @override
  $Res call({
    Object? styleHero = freezed,
  }) {
    return _then(_value.copyWith(
      styleHero: styleHero == freezed
          ? _value.styleHero
          : styleHero // ignore: cast_nullable_to_non_nullable
              as TextStyle,
    ));
  }
}

/// @nodoc
abstract class _$$_DesignSystemTypographyCopyWith<$Res>
    implements $DesignSystemTypographyCopyWith<$Res> {
  factory _$$_DesignSystemTypographyCopyWith(_$_DesignSystemTypography value,
          $Res Function(_$_DesignSystemTypography) then) =
      __$$_DesignSystemTypographyCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(fromJson: textStyleFromJson, toJson: textStyleToJson)
          TextStyle styleHero});
}

/// @nodoc
class __$$_DesignSystemTypographyCopyWithImpl<$Res>
    extends _$DesignSystemTypographyCopyWithImpl<$Res>
    implements _$$_DesignSystemTypographyCopyWith<$Res> {
  __$$_DesignSystemTypographyCopyWithImpl(_$_DesignSystemTypography _value,
      $Res Function(_$_DesignSystemTypography) _then)
      : super(_value, (v) => _then(v as _$_DesignSystemTypography));

  @override
  _$_DesignSystemTypography get _value =>
      super._value as _$_DesignSystemTypography;

  @override
  $Res call({
    Object? styleHero = freezed,
  }) {
    return _then(_$_DesignSystemTypography(
      styleHero: styleHero == freezed
          ? _value.styleHero
          : styleHero // ignore: cast_nullable_to_non_nullable
              as TextStyle,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$_DesignSystemTypography implements _DesignSystemTypography {
  _$_DesignSystemTypography(
      {@JsonKey(fromJson: textStyleFromJson, toJson: textStyleToJson)
          required this.styleHero});

  factory _$_DesignSystemTypography.fromJson(Map<String, dynamic> json) =>
      _$$_DesignSystemTypographyFromJson(json);

  @override
  @JsonKey(fromJson: textStyleFromJson, toJson: textStyleToJson)
  final TextStyle styleHero;

  @override
  String toString() {
    return 'DesignSystemTypography(styleHero: $styleHero)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_DesignSystemTypography &&
            const DeepCollectionEquality().equals(other.styleHero, styleHero));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(styleHero));

  @JsonKey(ignore: true)
  @override
  _$$_DesignSystemTypographyCopyWith<_$_DesignSystemTypography> get copyWith =>
      __$$_DesignSystemTypographyCopyWithImpl<_$_DesignSystemTypography>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_DesignSystemTypographyToJson(
      this,
    );
  }
}

abstract class _DesignSystemTypography implements DesignSystemTypography {
  factory _DesignSystemTypography(
      {@JsonKey(fromJson: textStyleFromJson, toJson: textStyleToJson)
          required final TextStyle styleHero}) = _$_DesignSystemTypography;

  factory _DesignSystemTypography.fromJson(Map<String, dynamic> json) =
      _$_DesignSystemTypography.fromJson;

  @override
  @JsonKey(fromJson: textStyleFromJson, toJson: textStyleToJson)
  TextStyle get styleHero;
  @override
  @JsonKey(ignore: true)
  _$$_DesignSystemTypographyCopyWith<_$_DesignSystemTypography> get copyWith =>
      throw _privateConstructorUsedError;
}
