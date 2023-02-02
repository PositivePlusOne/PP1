// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'page_decoration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PageDecoration _$PageDecorationFromJson(Map<String, dynamic> json) {
  return _PageDecoration.fromJson(json);
}

/// @nodoc
mixin _$PageDecoration {
  String get asset => throw _privateConstructorUsedError;
  @JsonKey(fromJson: alignmentFromJson, toJson: alignmentToJson)
  Alignment get alignment => throw _privateConstructorUsedError;
  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  Color get color => throw _privateConstructorUsedError;
  double get scale => throw _privateConstructorUsedError;
  double get offsetX => throw _privateConstructorUsedError;
  double get offsetY => throw _privateConstructorUsedError;
  double get rotationDegrees => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PageDecorationCopyWith<PageDecoration> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PageDecorationCopyWith<$Res> {
  factory $PageDecorationCopyWith(
          PageDecoration value, $Res Function(PageDecoration) then) =
      _$PageDecorationCopyWithImpl<$Res, PageDecoration>;
  @useResult
  $Res call(
      {String asset,
      @JsonKey(fromJson: alignmentFromJson, toJson: alignmentToJson)
          Alignment alignment,
      @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
          Color color,
      double scale,
      double offsetX,
      double offsetY,
      double rotationDegrees});
}

/// @nodoc
class _$PageDecorationCopyWithImpl<$Res, $Val extends PageDecoration>
    implements $PageDecorationCopyWith<$Res> {
  _$PageDecorationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? asset = null,
    Object? alignment = null,
    Object? color = null,
    Object? scale = null,
    Object? offsetX = null,
    Object? offsetY = null,
    Object? rotationDegrees = null,
  }) {
    return _then(_value.copyWith(
      asset: null == asset
          ? _value.asset
          : asset // ignore: cast_nullable_to_non_nullable
              as String,
      alignment: null == alignment
          ? _value.alignment
          : alignment // ignore: cast_nullable_to_non_nullable
              as Alignment,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
      scale: null == scale
          ? _value.scale
          : scale // ignore: cast_nullable_to_non_nullable
              as double,
      offsetX: null == offsetX
          ? _value.offsetX
          : offsetX // ignore: cast_nullable_to_non_nullable
              as double,
      offsetY: null == offsetY
          ? _value.offsetY
          : offsetY // ignore: cast_nullable_to_non_nullable
              as double,
      rotationDegrees: null == rotationDegrees
          ? _value.rotationDegrees
          : rotationDegrees // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PageDecorationCopyWith<$Res>
    implements $PageDecorationCopyWith<$Res> {
  factory _$$_PageDecorationCopyWith(
          _$_PageDecoration value, $Res Function(_$_PageDecoration) then) =
      __$$_PageDecorationCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String asset,
      @JsonKey(fromJson: alignmentFromJson, toJson: alignmentToJson)
          Alignment alignment,
      @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
          Color color,
      double scale,
      double offsetX,
      double offsetY,
      double rotationDegrees});
}

/// @nodoc
class __$$_PageDecorationCopyWithImpl<$Res>
    extends _$PageDecorationCopyWithImpl<$Res, _$_PageDecoration>
    implements _$$_PageDecorationCopyWith<$Res> {
  __$$_PageDecorationCopyWithImpl(
      _$_PageDecoration _value, $Res Function(_$_PageDecoration) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? asset = null,
    Object? alignment = null,
    Object? color = null,
    Object? scale = null,
    Object? offsetX = null,
    Object? offsetY = null,
    Object? rotationDegrees = null,
  }) {
    return _then(_$_PageDecoration(
      asset: null == asset
          ? _value.asset
          : asset // ignore: cast_nullable_to_non_nullable
              as String,
      alignment: null == alignment
          ? _value.alignment
          : alignment // ignore: cast_nullable_to_non_nullable
              as Alignment,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
      scale: null == scale
          ? _value.scale
          : scale // ignore: cast_nullable_to_non_nullable
              as double,
      offsetX: null == offsetX
          ? _value.offsetX
          : offsetX // ignore: cast_nullable_to_non_nullable
              as double,
      offsetY: null == offsetY
          ? _value.offsetY
          : offsetY // ignore: cast_nullable_to_non_nullable
              as double,
      rotationDegrees: null == rotationDegrees
          ? _value.rotationDegrees
          : rotationDegrees // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$_PageDecoration implements _PageDecoration {
  const _$_PageDecoration(
      {required this.asset,
      @JsonKey(fromJson: alignmentFromJson, toJson: alignmentToJson)
          required this.alignment,
      @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
          required this.color,
      required this.scale,
      required this.offsetX,
      required this.offsetY,
      required this.rotationDegrees});

  factory _$_PageDecoration.fromJson(Map<String, dynamic> json) =>
      _$$_PageDecorationFromJson(json);

  @override
  final String asset;
  @override
  @JsonKey(fromJson: alignmentFromJson, toJson: alignmentToJson)
  final Alignment alignment;
  @override
  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  final Color color;
  @override
  final double scale;
  @override
  final double offsetX;
  @override
  final double offsetY;
  @override
  final double rotationDegrees;

  @override
  String toString() {
    return 'PageDecoration(asset: $asset, alignment: $alignment, color: $color, scale: $scale, offsetX: $offsetX, offsetY: $offsetY, rotationDegrees: $rotationDegrees)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PageDecoration &&
            (identical(other.asset, asset) || other.asset == asset) &&
            (identical(other.alignment, alignment) ||
                other.alignment == alignment) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.scale, scale) || other.scale == scale) &&
            (identical(other.offsetX, offsetX) || other.offsetX == offsetX) &&
            (identical(other.offsetY, offsetY) || other.offsetY == offsetY) &&
            (identical(other.rotationDegrees, rotationDegrees) ||
                other.rotationDegrees == rotationDegrees));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, asset, alignment, color, scale,
      offsetX, offsetY, rotationDegrees);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PageDecorationCopyWith<_$_PageDecoration> get copyWith =>
      __$$_PageDecorationCopyWithImpl<_$_PageDecoration>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PageDecorationToJson(
      this,
    );
  }
}

abstract class _PageDecoration implements PageDecoration {
  const factory _PageDecoration(
      {required final String asset,
      @JsonKey(fromJson: alignmentFromJson, toJson: alignmentToJson)
          required final Alignment alignment,
      @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
          required final Color color,
      required final double scale,
      required final double offsetX,
      required final double offsetY,
      required final double rotationDegrees}) = _$_PageDecoration;

  factory _PageDecoration.fromJson(Map<String, dynamic> json) =
      _$_PageDecoration.fromJson;

  @override
  String get asset;
  @override
  @JsonKey(fromJson: alignmentFromJson, toJson: alignmentToJson)
  Alignment get alignment;
  @override
  @JsonKey(fromJson: colorFromJson, toJson: colorToJson)
  Color get color;
  @override
  double get scale;
  @override
  double get offsetX;
  @override
  double get offsetY;
  @override
  double get rotationDegrees;
  @override
  @JsonKey(ignore: true)
  _$$_PageDecorationCopyWith<_$_PageDecoration> get copyWith =>
      throw _privateConstructorUsedError;
}
