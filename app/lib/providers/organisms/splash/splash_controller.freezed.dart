// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'splash_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SplashControllerState {
  SplashStyle get style => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SplashControllerStateCopyWith<SplashControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SplashControllerStateCopyWith<$Res> {
  factory $SplashControllerStateCopyWith(SplashControllerState value,
          $Res Function(SplashControllerState) then) =
      _$SplashControllerStateCopyWithImpl<$Res, SplashControllerState>;
  @useResult
  $Res call({SplashStyle style});
}

/// @nodoc
class _$SplashControllerStateCopyWithImpl<$Res,
        $Val extends SplashControllerState>
    implements $SplashControllerStateCopyWith<$Res> {
  _$SplashControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? style = null,
  }) {
    return _then(_value.copyWith(
      style: null == style
          ? _value.style
          : style // ignore: cast_nullable_to_non_nullable
              as SplashStyle,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SplashControllerStateCopyWith<$Res>
    implements $SplashControllerStateCopyWith<$Res> {
  factory _$$_SplashControllerStateCopyWith(_$_SplashControllerState value,
          $Res Function(_$_SplashControllerState) then) =
      __$$_SplashControllerStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({SplashStyle style});
}

/// @nodoc
class __$$_SplashControllerStateCopyWithImpl<$Res>
    extends _$SplashControllerStateCopyWithImpl<$Res, _$_SplashControllerState>
    implements _$$_SplashControllerStateCopyWith<$Res> {
  __$$_SplashControllerStateCopyWithImpl(_$_SplashControllerState _value,
      $Res Function(_$_SplashControllerState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? style = null,
  }) {
    return _then(_$_SplashControllerState(
      style: null == style
          ? _value.style
          : style // ignore: cast_nullable_to_non_nullable
              as SplashStyle,
    ));
  }
}

/// @nodoc

class _$_SplashControllerState implements _SplashControllerState {
  const _$_SplashControllerState({required this.style});

  @override
  final SplashStyle style;

  @override
  String toString() {
    return 'SplashControllerState(style: $style)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SplashControllerState &&
            (identical(other.style, style) || other.style == style));
  }

  @override
  int get hashCode => Object.hash(runtimeType, style);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SplashControllerStateCopyWith<_$_SplashControllerState> get copyWith =>
      __$$_SplashControllerStateCopyWithImpl<_$_SplashControllerState>(
          this, _$identity);
}

abstract class _SplashControllerState implements SplashControllerState {
  const factory _SplashControllerState({required final SplashStyle style}) =
      _$_SplashControllerState;

  @override
  SplashStyle get style;
  @override
  @JsonKey(ignore: true)
  _$$_SplashControllerStateCopyWith<_$_SplashControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}
