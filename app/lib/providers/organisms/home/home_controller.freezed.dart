// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$HomeControllerState {
  bool get isRefreshing => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HomeControllerStateCopyWith<HomeControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeControllerStateCopyWith<$Res> {
  factory $HomeControllerStateCopyWith(
          HomeControllerState value, $Res Function(HomeControllerState) then) =
      _$HomeControllerStateCopyWithImpl<$Res, HomeControllerState>;
  @useResult
  $Res call({bool isRefreshing});
}

/// @nodoc
class _$HomeControllerStateCopyWithImpl<$Res, $Val extends HomeControllerState>
    implements $HomeControllerStateCopyWith<$Res> {
  _$HomeControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isRefreshing = null,
  }) {
    return _then(_value.copyWith(
      isRefreshing: null == isRefreshing
          ? _value.isRefreshing
          : isRefreshing // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_HomeControllerStateCopyWith<$Res>
    implements $HomeControllerStateCopyWith<$Res> {
  factory _$$_HomeControllerStateCopyWith(_$_HomeControllerState value,
          $Res Function(_$_HomeControllerState) then) =
      __$$_HomeControllerStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isRefreshing});
}

/// @nodoc
class __$$_HomeControllerStateCopyWithImpl<$Res>
    extends _$HomeControllerStateCopyWithImpl<$Res, _$_HomeControllerState>
    implements _$$_HomeControllerStateCopyWith<$Res> {
  __$$_HomeControllerStateCopyWithImpl(_$_HomeControllerState _value,
      $Res Function(_$_HomeControllerState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isRefreshing = null,
  }) {
    return _then(_$_HomeControllerState(
      isRefreshing: null == isRefreshing
          ? _value.isRefreshing
          : isRefreshing // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_HomeControllerState implements _HomeControllerState {
  const _$_HomeControllerState({this.isRefreshing = false});

  @override
  @JsonKey()
  final bool isRefreshing;

  @override
  String toString() {
    return 'HomeControllerState(isRefreshing: $isRefreshing)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_HomeControllerState &&
            (identical(other.isRefreshing, isRefreshing) ||
                other.isRefreshing == isRefreshing));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isRefreshing);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_HomeControllerStateCopyWith<_$_HomeControllerState> get copyWith =>
      __$$_HomeControllerStateCopyWithImpl<_$_HomeControllerState>(
          this, _$identity);
}

abstract class _HomeControllerState implements HomeControllerState {
  const factory _HomeControllerState({final bool isRefreshing}) =
      _$_HomeControllerState;

  @override
  bool get isRefreshing;
  @override
  @JsonKey(ignore: true)
  _$$_HomeControllerStateCopyWith<_$_HomeControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}
