// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'design_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$DesignControllerState {
  DesignTypographyModel get typography => throw _privateConstructorUsedError;
  DesignColorsModel get colors => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DesignControllerStateCopyWith<DesignControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DesignControllerStateCopyWith<$Res> {
  factory $DesignControllerStateCopyWith(DesignControllerState value,
          $Res Function(DesignControllerState) then) =
      _$DesignControllerStateCopyWithImpl<$Res, DesignControllerState>;
  @useResult
  $Res call({DesignTypographyModel typography, DesignColorsModel colors});

  $DesignTypographyModelCopyWith<$Res> get typography;
  $DesignColorsModelCopyWith<$Res> get colors;
}

/// @nodoc
class _$DesignControllerStateCopyWithImpl<$Res,
        $Val extends DesignControllerState>
    implements $DesignControllerStateCopyWith<$Res> {
  _$DesignControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? typography = null,
    Object? colors = null,
  }) {
    return _then(_value.copyWith(
      typography: null == typography
          ? _value.typography
          : typography // ignore: cast_nullable_to_non_nullable
              as DesignTypographyModel,
      colors: null == colors
          ? _value.colors
          : colors // ignore: cast_nullable_to_non_nullable
              as DesignColorsModel,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $DesignTypographyModelCopyWith<$Res> get typography {
    return $DesignTypographyModelCopyWith<$Res>(_value.typography, (value) {
      return _then(_value.copyWith(typography: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $DesignColorsModelCopyWith<$Res> get colors {
    return $DesignColorsModelCopyWith<$Res>(_value.colors, (value) {
      return _then(_value.copyWith(colors: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$DesignControllerStateImplCopyWith<$Res>
    implements $DesignControllerStateCopyWith<$Res> {
  factory _$$DesignControllerStateImplCopyWith(
          _$DesignControllerStateImpl value,
          $Res Function(_$DesignControllerStateImpl) then) =
      __$$DesignControllerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DesignTypographyModel typography, DesignColorsModel colors});

  @override
  $DesignTypographyModelCopyWith<$Res> get typography;
  @override
  $DesignColorsModelCopyWith<$Res> get colors;
}

/// @nodoc
class __$$DesignControllerStateImplCopyWithImpl<$Res>
    extends _$DesignControllerStateCopyWithImpl<$Res,
        _$DesignControllerStateImpl>
    implements _$$DesignControllerStateImplCopyWith<$Res> {
  __$$DesignControllerStateImplCopyWithImpl(_$DesignControllerStateImpl _value,
      $Res Function(_$DesignControllerStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? typography = null,
    Object? colors = null,
  }) {
    return _then(_$DesignControllerStateImpl(
      typography: null == typography
          ? _value.typography
          : typography // ignore: cast_nullable_to_non_nullable
              as DesignTypographyModel,
      colors: null == colors
          ? _value.colors
          : colors // ignore: cast_nullable_to_non_nullable
              as DesignColorsModel,
    ));
  }
}

/// @nodoc

class _$DesignControllerStateImpl implements _DesignControllerState {
  const _$DesignControllerStateImpl(
      {required this.typography, required this.colors});

  @override
  final DesignTypographyModel typography;
  @override
  final DesignColorsModel colors;

  @override
  String toString() {
    return 'DesignControllerState(typography: $typography, colors: $colors)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DesignControllerStateImpl &&
            (identical(other.typography, typography) ||
                other.typography == typography) &&
            (identical(other.colors, colors) || other.colors == colors));
  }

  @override
  int get hashCode => Object.hash(runtimeType, typography, colors);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DesignControllerStateImplCopyWith<_$DesignControllerStateImpl>
      get copyWith => __$$DesignControllerStateImplCopyWithImpl<
          _$DesignControllerStateImpl>(this, _$identity);
}

abstract class _DesignControllerState implements DesignControllerState {
  const factory _DesignControllerState(
      {required final DesignTypographyModel typography,
      required final DesignColorsModel colors}) = _$DesignControllerStateImpl;

  @override
  DesignTypographyModel get typography;
  @override
  DesignColorsModel get colors;
  @override
  @JsonKey(ignore: true)
  _$$DesignControllerStateImplCopyWith<_$DesignControllerStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
