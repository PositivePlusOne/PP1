// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_preferences_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AccountPreferencesViewModelState {
  bool get isBusy => throw _privateConstructorUsedError;
  bool get isIncognitoModeEnabled => throw _privateConstructorUsedError;
  bool get isBiometricsEnabled => throw _privateConstructorUsedError;
  bool get isMarketingEmailsEnabled => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AccountPreferencesViewModelStateCopyWith<AccountPreferencesViewModelState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountPreferencesViewModelStateCopyWith<$Res> {
  factory $AccountPreferencesViewModelStateCopyWith(
          AccountPreferencesViewModelState value,
          $Res Function(AccountPreferencesViewModelState) then) =
      _$AccountPreferencesViewModelStateCopyWithImpl<$Res,
          AccountPreferencesViewModelState>;
  @useResult
  $Res call(
      {bool isBusy,
      bool isIncognitoModeEnabled,
      bool isBiometricsEnabled,
      bool isMarketingEmailsEnabled});
}

/// @nodoc
class _$AccountPreferencesViewModelStateCopyWithImpl<$Res,
        $Val extends AccountPreferencesViewModelState>
    implements $AccountPreferencesViewModelStateCopyWith<$Res> {
  _$AccountPreferencesViewModelStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
    Object? isIncognitoModeEnabled = null,
    Object? isBiometricsEnabled = null,
    Object? isMarketingEmailsEnabled = null,
  }) {
    return _then(_value.copyWith(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      isIncognitoModeEnabled: null == isIncognitoModeEnabled
          ? _value.isIncognitoModeEnabled
          : isIncognitoModeEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isBiometricsEnabled: null == isBiometricsEnabled
          ? _value.isBiometricsEnabled
          : isBiometricsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isMarketingEmailsEnabled: null == isMarketingEmailsEnabled
          ? _value.isMarketingEmailsEnabled
          : isMarketingEmailsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AccountPreferencesViewModelStateCopyWith<$Res>
    implements $AccountPreferencesViewModelStateCopyWith<$Res> {
  factory _$$_AccountPreferencesViewModelStateCopyWith(
          _$_AccountPreferencesViewModelState value,
          $Res Function(_$_AccountPreferencesViewModelState) then) =
      __$$_AccountPreferencesViewModelStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isBusy,
      bool isIncognitoModeEnabled,
      bool isBiometricsEnabled,
      bool isMarketingEmailsEnabled});
}

/// @nodoc
class __$$_AccountPreferencesViewModelStateCopyWithImpl<$Res>
    extends _$AccountPreferencesViewModelStateCopyWithImpl<$Res,
        _$_AccountPreferencesViewModelState>
    implements _$$_AccountPreferencesViewModelStateCopyWith<$Res> {
  __$$_AccountPreferencesViewModelStateCopyWithImpl(
      _$_AccountPreferencesViewModelState _value,
      $Res Function(_$_AccountPreferencesViewModelState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
    Object? isIncognitoModeEnabled = null,
    Object? isBiometricsEnabled = null,
    Object? isMarketingEmailsEnabled = null,
  }) {
    return _then(_$_AccountPreferencesViewModelState(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      isIncognitoModeEnabled: null == isIncognitoModeEnabled
          ? _value.isIncognitoModeEnabled
          : isIncognitoModeEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isBiometricsEnabled: null == isBiometricsEnabled
          ? _value.isBiometricsEnabled
          : isBiometricsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      isMarketingEmailsEnabled: null == isMarketingEmailsEnabled
          ? _value.isMarketingEmailsEnabled
          : isMarketingEmailsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_AccountPreferencesViewModelState
    implements _AccountPreferencesViewModelState {
  const _$_AccountPreferencesViewModelState(
      {this.isBusy = false,
      this.isIncognitoModeEnabled = false,
      this.isBiometricsEnabled = false,
      this.isMarketingEmailsEnabled = false});

  @override
  @JsonKey()
  final bool isBusy;
  @override
  @JsonKey()
  final bool isIncognitoModeEnabled;
  @override
  @JsonKey()
  final bool isBiometricsEnabled;
  @override
  @JsonKey()
  final bool isMarketingEmailsEnabled;

  @override
  String toString() {
    return 'AccountPreferencesViewModelState(isBusy: $isBusy, isIncognitoModeEnabled: $isIncognitoModeEnabled, isBiometricsEnabled: $isBiometricsEnabled, isMarketingEmailsEnabled: $isMarketingEmailsEnabled)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AccountPreferencesViewModelState &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy) &&
            (identical(other.isIncognitoModeEnabled, isIncognitoModeEnabled) ||
                other.isIncognitoModeEnabled == isIncognitoModeEnabled) &&
            (identical(other.isBiometricsEnabled, isBiometricsEnabled) ||
                other.isBiometricsEnabled == isBiometricsEnabled) &&
            (identical(
                    other.isMarketingEmailsEnabled, isMarketingEmailsEnabled) ||
                other.isMarketingEmailsEnabled == isMarketingEmailsEnabled));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isBusy, isIncognitoModeEnabled,
      isBiometricsEnabled, isMarketingEmailsEnabled);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AccountPreferencesViewModelStateCopyWith<
          _$_AccountPreferencesViewModelState>
      get copyWith => __$$_AccountPreferencesViewModelStateCopyWithImpl<
          _$_AccountPreferencesViewModelState>(this, _$identity);
}

abstract class _AccountPreferencesViewModelState
    implements AccountPreferencesViewModelState {
  const factory _AccountPreferencesViewModelState(
          {final bool isBusy,
          final bool isIncognitoModeEnabled,
          final bool isBiometricsEnabled,
          final bool isMarketingEmailsEnabled}) =
      _$_AccountPreferencesViewModelState;

  @override
  bool get isBusy;
  @override
  bool get isIncognitoModeEnabled;
  @override
  bool get isBiometricsEnabled;
  @override
  bool get isMarketingEmailsEnabled;
  @override
  @JsonKey(ignore: true)
  _$$_AccountPreferencesViewModelStateCopyWith<
          _$_AccountPreferencesViewModelState>
      get copyWith => throw _privateConstructorUsedError;
}
