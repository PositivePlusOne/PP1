// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_details_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AccountDetailsViewModelState {
  bool get isBusy => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AccountDetailsViewModelStateCopyWith<AccountDetailsViewModelState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountDetailsViewModelStateCopyWith<$Res> {
  factory $AccountDetailsViewModelStateCopyWith(
          AccountDetailsViewModelState value,
          $Res Function(AccountDetailsViewModelState) then) =
      _$AccountDetailsViewModelStateCopyWithImpl<$Res,
          AccountDetailsViewModelState>;
  @useResult
  $Res call({bool isBusy});
}

/// @nodoc
class _$AccountDetailsViewModelStateCopyWithImpl<$Res,
        $Val extends AccountDetailsViewModelState>
    implements $AccountDetailsViewModelStateCopyWith<$Res> {
  _$AccountDetailsViewModelStateCopyWithImpl(this._value, this._then);

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
abstract class _$$_AccountDetailsViewModelStateCopyWith<$Res>
    implements $AccountDetailsViewModelStateCopyWith<$Res> {
  factory _$$_AccountDetailsViewModelStateCopyWith(
          _$_AccountDetailsViewModelState value,
          $Res Function(_$_AccountDetailsViewModelState) then) =
      __$$_AccountDetailsViewModelStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isBusy});
}

/// @nodoc
class __$$_AccountDetailsViewModelStateCopyWithImpl<$Res>
    extends _$AccountDetailsViewModelStateCopyWithImpl<$Res,
        _$_AccountDetailsViewModelState>
    implements _$$_AccountDetailsViewModelStateCopyWith<$Res> {
  __$$_AccountDetailsViewModelStateCopyWithImpl(
      _$_AccountDetailsViewModelState _value,
      $Res Function(_$_AccountDetailsViewModelState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
  }) {
    return _then(_$_AccountDetailsViewModelState(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_AccountDetailsViewModelState implements _AccountDetailsViewModelState {
  const _$_AccountDetailsViewModelState({this.isBusy = false});

  @override
  @JsonKey()
  final bool isBusy;

  @override
  String toString() {
    return 'AccountDetailsViewModelState(isBusy: $isBusy)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AccountDetailsViewModelState &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isBusy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AccountDetailsViewModelStateCopyWith<_$_AccountDetailsViewModelState>
      get copyWith => __$$_AccountDetailsViewModelStateCopyWithImpl<
          _$_AccountDetailsViewModelState>(this, _$identity);
}

abstract class _AccountDetailsViewModelState
    implements AccountDetailsViewModelState {
  const factory _AccountDetailsViewModelState({final bool isBusy}) =
      _$_AccountDetailsViewModelState;

  @override
  bool get isBusy;
  @override
  @JsonKey(ignore: true)
  _$$_AccountDetailsViewModelStateCopyWith<_$_AccountDetailsViewModelState>
      get copyWith => throw _privateConstructorUsedError;
}
