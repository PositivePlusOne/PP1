// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'design_system_brand.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

DesignSystemBrand _$DesignSystemBrandFromJson(Map<String, dynamic> json) {
  return _DesignSystemBrand.fromJson(json);
}

/// @nodoc
mixin _$DesignSystemBrand {
  DesignSystemColors get colors => throw _privateConstructorUsedError;
  DesignSystemTypography get typography => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $DesignSystemBrandCopyWith<DesignSystemBrand> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DesignSystemBrandCopyWith<$Res> {
  factory $DesignSystemBrandCopyWith(
          DesignSystemBrand value, $Res Function(DesignSystemBrand) then) =
      _$DesignSystemBrandCopyWithImpl<$Res, DesignSystemBrand>;
  @useResult
  $Res call({DesignSystemColors colors, DesignSystemTypography typography});

  $DesignSystemColorsCopyWith<$Res> get colors;
  $DesignSystemTypographyCopyWith<$Res> get typography;
}

/// @nodoc
class _$DesignSystemBrandCopyWithImpl<$Res, $Val extends DesignSystemBrand>
    implements $DesignSystemBrandCopyWith<$Res> {
  _$DesignSystemBrandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? colors = null,
    Object? typography = null,
  }) {
    return _then(_value.copyWith(
      colors: null == colors
          ? _value.colors
          : colors // ignore: cast_nullable_to_non_nullable
              as DesignSystemColors,
      typography: null == typography
          ? _value.typography
          : typography // ignore: cast_nullable_to_non_nullable
              as DesignSystemTypography,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $DesignSystemColorsCopyWith<$Res> get colors {
    return $DesignSystemColorsCopyWith<$Res>(_value.colors, (value) {
      return _then(_value.copyWith(colors: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $DesignSystemTypographyCopyWith<$Res> get typography {
    return $DesignSystemTypographyCopyWith<$Res>(_value.typography, (value) {
      return _then(_value.copyWith(typography: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_DesignSystemBrandCopyWith<$Res>
    implements $DesignSystemBrandCopyWith<$Res> {
  factory _$$_DesignSystemBrandCopyWith(_$_DesignSystemBrand value,
          $Res Function(_$_DesignSystemBrand) then) =
      __$$_DesignSystemBrandCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DesignSystemColors colors, DesignSystemTypography typography});

  @override
  $DesignSystemColorsCopyWith<$Res> get colors;
  @override
  $DesignSystemTypographyCopyWith<$Res> get typography;
}

/// @nodoc
class __$$_DesignSystemBrandCopyWithImpl<$Res>
    extends _$DesignSystemBrandCopyWithImpl<$Res, _$_DesignSystemBrand>
    implements _$$_DesignSystemBrandCopyWith<$Res> {
  __$$_DesignSystemBrandCopyWithImpl(
      _$_DesignSystemBrand _value, $Res Function(_$_DesignSystemBrand) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? colors = null,
    Object? typography = null,
  }) {
    return _then(_$_DesignSystemBrand(
      colors: null == colors
          ? _value.colors
          : colors // ignore: cast_nullable_to_non_nullable
              as DesignSystemColors,
      typography: null == typography
          ? _value.typography
          : typography // ignore: cast_nullable_to_non_nullable
              as DesignSystemTypography,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$_DesignSystemBrand implements _DesignSystemBrand {
  const _$_DesignSystemBrand({required this.colors, required this.typography});

  factory _$_DesignSystemBrand.fromJson(Map<String, dynamic> json) =>
      _$$_DesignSystemBrandFromJson(json);

  @override
  final DesignSystemColors colors;
  @override
  final DesignSystemTypography typography;

  @override
  String toString() {
    return 'DesignSystemBrand(colors: $colors, typography: $typography)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_DesignSystemBrand &&
            (identical(other.colors, colors) || other.colors == colors) &&
            (identical(other.typography, typography) ||
                other.typography == typography));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, colors, typography);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_DesignSystemBrandCopyWith<_$_DesignSystemBrand> get copyWith =>
      __$$_DesignSystemBrandCopyWithImpl<_$_DesignSystemBrand>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_DesignSystemBrandToJson(
      this,
    );
  }
}

abstract class _DesignSystemBrand implements DesignSystemBrand {
  const factory _DesignSystemBrand(
      {required final DesignSystemColors colors,
      required final DesignSystemTypography typography}) = _$_DesignSystemBrand;

  factory _DesignSystemBrand.fromJson(Map<String, dynamic> json) =
      _$_DesignSystemBrand.fromJson;

  @override
  DesignSystemColors get colors;
  @override
  DesignSystemTypography get typography;
  @override
  @JsonKey(ignore: true)
  _$$_DesignSystemBrandCopyWith<_$_DesignSystemBrand> get copyWith =>
      throw _privateConstructorUsedError;
}
