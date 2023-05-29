// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'development_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$DevelopmentViewModelState {
  String get status => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DevelopmentViewModelStateCopyWith<DevelopmentViewModelState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DevelopmentViewModelStateCopyWith<$Res> {
  factory $DevelopmentViewModelStateCopyWith(DevelopmentViewModelState value,
          $Res Function(DevelopmentViewModelState) then) =
      _$DevelopmentViewModelStateCopyWithImpl<$Res, DevelopmentViewModelState>;
  @useResult
  $Res call({String status});
}

/// @nodoc
class _$DevelopmentViewModelStateCopyWithImpl<$Res,
        $Val extends DevelopmentViewModelState>
    implements $DevelopmentViewModelStateCopyWith<$Res> {
  _$DevelopmentViewModelStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_DevelopmentViewModelStateCopyWith<$Res>
    implements $DevelopmentViewModelStateCopyWith<$Res> {
  factory _$$_DevelopmentViewModelStateCopyWith(
          _$_DevelopmentViewModelState value,
          $Res Function(_$_DevelopmentViewModelState) then) =
      __$$_DevelopmentViewModelStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String status});
}

/// @nodoc
class __$$_DevelopmentViewModelStateCopyWithImpl<$Res>
    extends _$DevelopmentViewModelStateCopyWithImpl<$Res,
        _$_DevelopmentViewModelState>
    implements _$$_DevelopmentViewModelStateCopyWith<$Res> {
  __$$_DevelopmentViewModelStateCopyWithImpl(
      _$_DevelopmentViewModelState _value,
      $Res Function(_$_DevelopmentViewModelState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = null,
  }) {
    return _then(_$_DevelopmentViewModelState(
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_DevelopmentViewModelState implements _DevelopmentViewModelState {
  const _$_DevelopmentViewModelState({this.status = 'Pending...'});

  @override
  @JsonKey()
  final String status;

  @override
  String toString() {
    return 'DevelopmentViewModelState(status: $status)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_DevelopmentViewModelState &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_DevelopmentViewModelStateCopyWith<_$_DevelopmentViewModelState>
      get copyWith => __$$_DevelopmentViewModelStateCopyWithImpl<
          _$_DevelopmentViewModelState>(this, _$identity);
}

abstract class _DevelopmentViewModelState implements DevelopmentViewModelState {
  const factory _DevelopmentViewModelState({final String status}) =
      _$_DevelopmentViewModelState;

  @override
  String get status;
  @override
  @JsonKey(ignore: true)
  _$$_DevelopmentViewModelStateCopyWith<_$_DevelopmentViewModelState>
      get copyWith => throw _privateConstructorUsedError;
}
