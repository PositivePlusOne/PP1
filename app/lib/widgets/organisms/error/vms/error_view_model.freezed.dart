// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'error_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ErrorViewModelState {
  bool get isBusy => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ErrorViewModelStateCopyWith<ErrorViewModelState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ErrorViewModelStateCopyWith<$Res> {
  factory $ErrorViewModelStateCopyWith(
          ErrorViewModelState value, $Res Function(ErrorViewModelState) then) =
      _$ErrorViewModelStateCopyWithImpl<$Res, ErrorViewModelState>;
  @useResult
  $Res call({bool isBusy});
}

/// @nodoc
class _$ErrorViewModelStateCopyWithImpl<$Res, $Val extends ErrorViewModelState>
    implements $ErrorViewModelStateCopyWith<$Res> {
  _$ErrorViewModelStateCopyWithImpl(this._value, this._then);

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
abstract class _$$ErrorViewModelStateImplCopyWith<$Res>
    implements $ErrorViewModelStateCopyWith<$Res> {
  factory _$$ErrorViewModelStateImplCopyWith(_$ErrorViewModelStateImpl value,
          $Res Function(_$ErrorViewModelStateImpl) then) =
      __$$ErrorViewModelStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isBusy});
}

/// @nodoc
class __$$ErrorViewModelStateImplCopyWithImpl<$Res>
    extends _$ErrorViewModelStateCopyWithImpl<$Res, _$ErrorViewModelStateImpl>
    implements _$$ErrorViewModelStateImplCopyWith<$Res> {
  __$$ErrorViewModelStateImplCopyWithImpl(_$ErrorViewModelStateImpl _value,
      $Res Function(_$ErrorViewModelStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
  }) {
    return _then(_$ErrorViewModelStateImpl(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$ErrorViewModelStateImpl implements _ErrorViewModelState {
  const _$ErrorViewModelStateImpl({this.isBusy = false});

  @override
  @JsonKey()
  final bool isBusy;

  @override
  String toString() {
    return 'ErrorViewModelState(isBusy: $isBusy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorViewModelStateImpl &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isBusy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorViewModelStateImplCopyWith<_$ErrorViewModelStateImpl> get copyWith =>
      __$$ErrorViewModelStateImplCopyWithImpl<_$ErrorViewModelStateImpl>(
          this, _$identity);
}

abstract class _ErrorViewModelState implements ErrorViewModelState {
  const factory _ErrorViewModelState({final bool isBusy}) =
      _$ErrorViewModelStateImpl;

  @override
  bool get isBusy;
  @override
  @JsonKey(ignore: true)
  _$$ErrorViewModelStateImplCopyWith<_$ErrorViewModelStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
