// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_stream_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$GetStreamControllerState {
  bool get isBusy => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GetStreamControllerStateCopyWith<GetStreamControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetStreamControllerStateCopyWith<$Res> {
  factory $GetStreamControllerStateCopyWith(GetStreamControllerState value,
          $Res Function(GetStreamControllerState) then) =
      _$GetStreamControllerStateCopyWithImpl<$Res, GetStreamControllerState>;
  @useResult
  $Res call({bool isBusy});
}

/// @nodoc
class _$GetStreamControllerStateCopyWithImpl<$Res,
        $Val extends GetStreamControllerState>
    implements $GetStreamControllerStateCopyWith<$Res> {
  _$GetStreamControllerStateCopyWithImpl(this._value, this._then);

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
abstract class _$$_GetStreamControllerStateCopyWith<$Res>
    implements $GetStreamControllerStateCopyWith<$Res> {
  factory _$$_GetStreamControllerStateCopyWith(
          _$_GetStreamControllerState value,
          $Res Function(_$_GetStreamControllerState) then) =
      __$$_GetStreamControllerStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isBusy});
}

/// @nodoc
class __$$_GetStreamControllerStateCopyWithImpl<$Res>
    extends _$GetStreamControllerStateCopyWithImpl<$Res,
        _$_GetStreamControllerState>
    implements _$$_GetStreamControllerStateCopyWith<$Res> {
  __$$_GetStreamControllerStateCopyWithImpl(_$_GetStreamControllerState _value,
      $Res Function(_$_GetStreamControllerState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
  }) {
    return _then(_$_GetStreamControllerState(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_GetStreamControllerState implements _GetStreamControllerState {
  const _$_GetStreamControllerState({this.isBusy = false});

  @override
  @JsonKey()
  final bool isBusy;

  @override
  String toString() {
    return 'GetStreamControllerState(isBusy: $isBusy)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GetStreamControllerState &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isBusy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GetStreamControllerStateCopyWith<_$_GetStreamControllerState>
      get copyWith => __$$_GetStreamControllerStateCopyWithImpl<
          _$_GetStreamControllerState>(this, _$identity);
}

abstract class _GetStreamControllerState implements GetStreamControllerState {
  const factory _GetStreamControllerState({final bool isBusy}) =
      _$_GetStreamControllerState;

  @override
  bool get isBusy;
  @override
  @JsonKey(ignore: true)
  _$$_GetStreamControllerStateCopyWith<_$_GetStreamControllerState>
      get copyWith => throw _privateConstructorUsedError;
}
