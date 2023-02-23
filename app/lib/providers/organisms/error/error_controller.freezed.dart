// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'error_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ErrorControllerState {
  bool get isBusy => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ErrorControllerStateCopyWith<ErrorControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ErrorControllerStateCopyWith<$Res> {
  factory $ErrorControllerStateCopyWith(ErrorControllerState value,
          $Res Function(ErrorControllerState) then) =
      _$ErrorControllerStateCopyWithImpl<$Res, ErrorControllerState>;
  @useResult
  $Res call({bool isBusy});
}

/// @nodoc
class _$ErrorControllerStateCopyWithImpl<$Res,
        $Val extends ErrorControllerState>
    implements $ErrorControllerStateCopyWith<$Res> {
  _$ErrorControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
  }) {
    return _then(_value.copyWith(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ErrorControllerStateCopyWith<$Res>
    implements $ErrorControllerStateCopyWith<$Res> {
  factory _$$_ErrorControllerStateCopyWith(_$_ErrorControllerState value,
          $Res Function(_$_ErrorControllerState) then) =
      __$$_ErrorControllerStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isBusy});
}

/// @nodoc
class __$$_ErrorControllerStateCopyWithImpl<$Res>
    extends _$ErrorControllerStateCopyWithImpl<$Res, _$_ErrorControllerState>
    implements _$$_ErrorControllerStateCopyWith<$Res> {
  __$$_ErrorControllerStateCopyWithImpl(_$_ErrorControllerState _value,
      $Res Function(_$_ErrorControllerState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
  }) {
    return _then(_$_ErrorControllerState(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_ErrorControllerState implements _ErrorControllerState {
  const _$_ErrorControllerState({this.isBusy = false});

  @override
  @JsonKey()
  final bool isBusy;

  @override
  String toString() {
    return 'ErrorControllerState(isBusy: $isBusy)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ErrorControllerState &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isBusy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ErrorControllerStateCopyWith<_$_ErrorControllerState> get copyWith =>
      __$$_ErrorControllerStateCopyWithImpl<_$_ErrorControllerState>(
          this, _$identity);
}

abstract class _ErrorControllerState implements ErrorControllerState {
  const factory _ErrorControllerState({final bool isBusy}) =
      _$_ErrorControllerState;

  @override
  bool get isBusy;
  @override
  @JsonKey(ignore: true)
  _$$_ErrorControllerStateCopyWith<_$_ErrorControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}
