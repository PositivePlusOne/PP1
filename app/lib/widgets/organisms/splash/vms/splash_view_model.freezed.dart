// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'splash_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SplashViewModelState {
  SplashStyle get style => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SplashViewModelStateCopyWith<SplashViewModelState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SplashViewModelStateCopyWith<$Res> {
  factory $SplashViewModelStateCopyWith(SplashViewModelState value,
          $Res Function(SplashViewModelState) then) =
      _$SplashViewModelStateCopyWithImpl<$Res, SplashViewModelState>;
  @useResult
  $Res call({SplashStyle style});
}

/// @nodoc
class _$SplashViewModelStateCopyWithImpl<$Res,
        $Val extends SplashViewModelState>
    implements $SplashViewModelStateCopyWith<$Res> {
  _$SplashViewModelStateCopyWithImpl(this._value, this._then);

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
abstract class _$$SplashViewModelStateImplCopyWith<$Res>
    implements $SplashViewModelStateCopyWith<$Res> {
  factory _$$SplashViewModelStateImplCopyWith(_$SplashViewModelStateImpl value,
          $Res Function(_$SplashViewModelStateImpl) then) =
      __$$SplashViewModelStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({SplashStyle style});
}

/// @nodoc
class __$$SplashViewModelStateImplCopyWithImpl<$Res>
    extends _$SplashViewModelStateCopyWithImpl<$Res, _$SplashViewModelStateImpl>
    implements _$$SplashViewModelStateImplCopyWith<$Res> {
  __$$SplashViewModelStateImplCopyWithImpl(_$SplashViewModelStateImpl _value,
      $Res Function(_$SplashViewModelStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? style = null,
  }) {
    return _then(_$SplashViewModelStateImpl(
      style: null == style
          ? _value.style
          : style // ignore: cast_nullable_to_non_nullable
              as SplashStyle,
    ));
  }
}

/// @nodoc

class _$SplashViewModelStateImpl implements _SplashViewModelState {
  const _$SplashViewModelStateImpl({required this.style});

  @override
  final SplashStyle style;

  @override
  String toString() {
    return 'SplashViewModelState(style: $style)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SplashViewModelStateImpl &&
            (identical(other.style, style) || other.style == style));
  }

  @override
  int get hashCode => Object.hash(runtimeType, style);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SplashViewModelStateImplCopyWith<_$SplashViewModelStateImpl>
      get copyWith =>
          __$$SplashViewModelStateImplCopyWithImpl<_$SplashViewModelStateImpl>(
              this, _$identity);
}

abstract class _SplashViewModelState implements SplashViewModelState {
  const factory _SplashViewModelState({required final SplashStyle style}) =
      _$SplashViewModelStateImpl;

  @override
  SplashStyle get style;
  @override
  @JsonKey(ignore: true)
  _$$SplashViewModelStateImplCopyWith<_$SplashViewModelStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
