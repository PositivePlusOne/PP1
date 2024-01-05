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
  UserInfo? get googleUserInfo => throw _privateConstructorUsedError;
  UserInfo? get facebookUserInfo => throw _privateConstructorUsedError;
  UserInfo? get appleUserInfo => throw _privateConstructorUsedError;

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
  $Res call(
      {bool isBusy,
      UserInfo? googleUserInfo,
      UserInfo? facebookUserInfo,
      UserInfo? appleUserInfo});
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
    Object? googleUserInfo = freezed,
    Object? facebookUserInfo = freezed,
    Object? appleUserInfo = freezed,
  }) {
    return _then(_value.copyWith(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      googleUserInfo: freezed == googleUserInfo
          ? _value.googleUserInfo
          : googleUserInfo // ignore: cast_nullable_to_non_nullable
              as UserInfo?,
      facebookUserInfo: freezed == facebookUserInfo
          ? _value.facebookUserInfo
          : facebookUserInfo // ignore: cast_nullable_to_non_nullable
              as UserInfo?,
      appleUserInfo: freezed == appleUserInfo
          ? _value.appleUserInfo
          : appleUserInfo // ignore: cast_nullable_to_non_nullable
              as UserInfo?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AccountDetailsViewModelStateImplCopyWith<$Res>
    implements $AccountDetailsViewModelStateCopyWith<$Res> {
  factory _$$AccountDetailsViewModelStateImplCopyWith(
          _$AccountDetailsViewModelStateImpl value,
          $Res Function(_$AccountDetailsViewModelStateImpl) then) =
      __$$AccountDetailsViewModelStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isBusy,
      UserInfo? googleUserInfo,
      UserInfo? facebookUserInfo,
      UserInfo? appleUserInfo});
}

/// @nodoc
class __$$AccountDetailsViewModelStateImplCopyWithImpl<$Res>
    extends _$AccountDetailsViewModelStateCopyWithImpl<$Res,
        _$AccountDetailsViewModelStateImpl>
    implements _$$AccountDetailsViewModelStateImplCopyWith<$Res> {
  __$$AccountDetailsViewModelStateImplCopyWithImpl(
      _$AccountDetailsViewModelStateImpl _value,
      $Res Function(_$AccountDetailsViewModelStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
    Object? googleUserInfo = freezed,
    Object? facebookUserInfo = freezed,
    Object? appleUserInfo = freezed,
  }) {
    return _then(_$AccountDetailsViewModelStateImpl(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      googleUserInfo: freezed == googleUserInfo
          ? _value.googleUserInfo
          : googleUserInfo // ignore: cast_nullable_to_non_nullable
              as UserInfo?,
      facebookUserInfo: freezed == facebookUserInfo
          ? _value.facebookUserInfo
          : facebookUserInfo // ignore: cast_nullable_to_non_nullable
              as UserInfo?,
      appleUserInfo: freezed == appleUserInfo
          ? _value.appleUserInfo
          : appleUserInfo // ignore: cast_nullable_to_non_nullable
              as UserInfo?,
    ));
  }
}

/// @nodoc

class _$AccountDetailsViewModelStateImpl
    implements _AccountDetailsViewModelState {
  const _$AccountDetailsViewModelStateImpl(
      {this.isBusy = false,
      this.googleUserInfo,
      this.facebookUserInfo,
      this.appleUserInfo});

  @override
  @JsonKey()
  final bool isBusy;
  @override
  final UserInfo? googleUserInfo;
  @override
  final UserInfo? facebookUserInfo;
  @override
  final UserInfo? appleUserInfo;

  @override
  String toString() {
    return 'AccountDetailsViewModelState(isBusy: $isBusy, googleUserInfo: $googleUserInfo, facebookUserInfo: $facebookUserInfo, appleUserInfo: $appleUserInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountDetailsViewModelStateImpl &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy) &&
            (identical(other.googleUserInfo, googleUserInfo) ||
                other.googleUserInfo == googleUserInfo) &&
            (identical(other.facebookUserInfo, facebookUserInfo) ||
                other.facebookUserInfo == facebookUserInfo) &&
            (identical(other.appleUserInfo, appleUserInfo) ||
                other.appleUserInfo == appleUserInfo));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, isBusy, googleUserInfo, facebookUserInfo, appleUserInfo);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountDetailsViewModelStateImplCopyWith<
          _$AccountDetailsViewModelStateImpl>
      get copyWith => __$$AccountDetailsViewModelStateImplCopyWithImpl<
          _$AccountDetailsViewModelStateImpl>(this, _$identity);
}

abstract class _AccountDetailsViewModelState
    implements AccountDetailsViewModelState {
  const factory _AccountDetailsViewModelState(
      {final bool isBusy,
      final UserInfo? googleUserInfo,
      final UserInfo? facebookUserInfo,
      final UserInfo? appleUserInfo}) = _$AccountDetailsViewModelStateImpl;

  @override
  bool get isBusy;
  @override
  UserInfo? get googleUserInfo;
  @override
  UserInfo? get facebookUserInfo;
  @override
  UserInfo? get appleUserInfo;
  @override
  @JsonKey(ignore: true)
  _$$AccountDetailsViewModelStateImplCopyWith<
          _$AccountDetailsViewModelStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
