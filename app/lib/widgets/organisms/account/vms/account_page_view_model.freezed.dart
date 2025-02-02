// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_page_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AccountPageViewModelState {
  bool get isBusy => throw _privateConstructorUsedError;
  Color get profileAccentColour => throw _privateConstructorUsedError;
  Color get organisationAccentColour => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AccountPageViewModelStateCopyWith<AccountPageViewModelState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountPageViewModelStateCopyWith<$Res> {
  factory $AccountPageViewModelStateCopyWith(AccountPageViewModelState value,
          $Res Function(AccountPageViewModelState) then) =
      _$AccountPageViewModelStateCopyWithImpl<$Res, AccountPageViewModelState>;
  @useResult
  $Res call(
      {bool isBusy, Color profileAccentColour, Color organisationAccentColour});
}

/// @nodoc
class _$AccountPageViewModelStateCopyWithImpl<$Res,
        $Val extends AccountPageViewModelState>
    implements $AccountPageViewModelStateCopyWith<$Res> {
  _$AccountPageViewModelStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
    Object? profileAccentColour = null,
    Object? organisationAccentColour = null,
  }) {
    return _then(_value.copyWith(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      profileAccentColour: null == profileAccentColour
          ? _value.profileAccentColour
          : profileAccentColour // ignore: cast_nullable_to_non_nullable
              as Color,
      organisationAccentColour: null == organisationAccentColour
          ? _value.organisationAccentColour
          : organisationAccentColour // ignore: cast_nullable_to_non_nullable
              as Color,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AccountPageViewModelStateImplCopyWith<$Res>
    implements $AccountPageViewModelStateCopyWith<$Res> {
  factory _$$AccountPageViewModelStateImplCopyWith(
          _$AccountPageViewModelStateImpl value,
          $Res Function(_$AccountPageViewModelStateImpl) then) =
      __$$AccountPageViewModelStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isBusy, Color profileAccentColour, Color organisationAccentColour});
}

/// @nodoc
class __$$AccountPageViewModelStateImplCopyWithImpl<$Res>
    extends _$AccountPageViewModelStateCopyWithImpl<$Res,
        _$AccountPageViewModelStateImpl>
    implements _$$AccountPageViewModelStateImplCopyWith<$Res> {
  __$$AccountPageViewModelStateImplCopyWithImpl(
      _$AccountPageViewModelStateImpl _value,
      $Res Function(_$AccountPageViewModelStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
    Object? profileAccentColour = null,
    Object? organisationAccentColour = null,
  }) {
    return _then(_$AccountPageViewModelStateImpl(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      profileAccentColour: null == profileAccentColour
          ? _value.profileAccentColour
          : profileAccentColour // ignore: cast_nullable_to_non_nullable
              as Color,
      organisationAccentColour: null == organisationAccentColour
          ? _value.organisationAccentColour
          : organisationAccentColour // ignore: cast_nullable_to_non_nullable
              as Color,
    ));
  }
}

/// @nodoc

class _$AccountPageViewModelStateImpl implements _AccountPageViewModelState {
  const _$AccountPageViewModelStateImpl(
      {this.isBusy = false,
      this.profileAccentColour = Colors.white,
      this.organisationAccentColour = Colors.white});

  @override
  @JsonKey()
  final bool isBusy;
  @override
  @JsonKey()
  final Color profileAccentColour;
  @override
  @JsonKey()
  final Color organisationAccentColour;

  @override
  String toString() {
    return 'AccountPageViewModelState(isBusy: $isBusy, profileAccentColour: $profileAccentColour, organisationAccentColour: $organisationAccentColour)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountPageViewModelStateImpl &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy) &&
            (identical(other.profileAccentColour, profileAccentColour) ||
                other.profileAccentColour == profileAccentColour) &&
            (identical(
                    other.organisationAccentColour, organisationAccentColour) ||
                other.organisationAccentColour == organisationAccentColour));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, isBusy, profileAccentColour, organisationAccentColour);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountPageViewModelStateImplCopyWith<_$AccountPageViewModelStateImpl>
      get copyWith => __$$AccountPageViewModelStateImplCopyWithImpl<
          _$AccountPageViewModelStateImpl>(this, _$identity);
}

abstract class _AccountPageViewModelState implements AccountPageViewModelState {
  const factory _AccountPageViewModelState(
      {final bool isBusy,
      final Color profileAccentColour,
      final Color organisationAccentColour}) = _$AccountPageViewModelStateImpl;

  @override
  bool get isBusy;
  @override
  Color get profileAccentColour;
  @override
  Color get organisationAccentColour;
  @override
  @JsonKey(ignore: true)
  _$$AccountPageViewModelStateImplCopyWith<_$AccountPageViewModelStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
