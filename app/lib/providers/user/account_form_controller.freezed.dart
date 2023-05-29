// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_form_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AccountFormState {
  String get emailAddress => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  Country get country => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;
  String get pin => throw _privateConstructorUsedError;
  bool get isBusy => throw _privateConstructorUsedError;
  FormMode get formMode => throw _privateConstructorUsedError;
  AccountEditTarget get editTarget => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AccountFormStateCopyWith<AccountFormState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountFormStateCopyWith<$Res> {
  factory $AccountFormStateCopyWith(
          AccountFormState value, $Res Function(AccountFormState) then) =
      _$AccountFormStateCopyWithImpl<$Res, AccountFormState>;
  @useResult
  $Res call(
      {String emailAddress,
      String password,
      Country country,
      String phoneNumber,
      String pin,
      bool isBusy,
      FormMode formMode,
      AccountEditTarget editTarget});

  $CountryCopyWith<$Res> get country;
}

/// @nodoc
class _$AccountFormStateCopyWithImpl<$Res, $Val extends AccountFormState>
    implements $AccountFormStateCopyWith<$Res> {
  _$AccountFormStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? emailAddress = null,
    Object? password = null,
    Object? country = null,
    Object? phoneNumber = null,
    Object? pin = null,
    Object? isBusy = null,
    Object? formMode = null,
    Object? editTarget = null,
  }) {
    return _then(_value.copyWith(
      emailAddress: null == emailAddress
          ? _value.emailAddress
          : emailAddress // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as Country,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      pin: null == pin
          ? _value.pin
          : pin // ignore: cast_nullable_to_non_nullable
              as String,
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      formMode: null == formMode
          ? _value.formMode
          : formMode // ignore: cast_nullable_to_non_nullable
              as FormMode,
      editTarget: null == editTarget
          ? _value.editTarget
          : editTarget // ignore: cast_nullable_to_non_nullable
              as AccountEditTarget,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CountryCopyWith<$Res> get country {
    return $CountryCopyWith<$Res>(_value.country, (value) {
      return _then(_value.copyWith(country: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_AccountFormStateCopyWith<$Res>
    implements $AccountFormStateCopyWith<$Res> {
  factory _$$_AccountFormStateCopyWith(
          _$_AccountFormState value, $Res Function(_$_AccountFormState) then) =
      __$$_AccountFormStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String emailAddress,
      String password,
      Country country,
      String phoneNumber,
      String pin,
      bool isBusy,
      FormMode formMode,
      AccountEditTarget editTarget});

  @override
  $CountryCopyWith<$Res> get country;
}

/// @nodoc
class __$$_AccountFormStateCopyWithImpl<$Res>
    extends _$AccountFormStateCopyWithImpl<$Res, _$_AccountFormState>
    implements _$$_AccountFormStateCopyWith<$Res> {
  __$$_AccountFormStateCopyWithImpl(
      _$_AccountFormState _value, $Res Function(_$_AccountFormState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? emailAddress = null,
    Object? password = null,
    Object? country = null,
    Object? phoneNumber = null,
    Object? pin = null,
    Object? isBusy = null,
    Object? formMode = null,
    Object? editTarget = null,
  }) {
    return _then(_$_AccountFormState(
      emailAddress: null == emailAddress
          ? _value.emailAddress
          : emailAddress // ignore: cast_nullable_to_non_nullable
              as String,
      password: null == password
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String,
      country: null == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as Country,
      phoneNumber: null == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String,
      pin: null == pin
          ? _value.pin
          : pin // ignore: cast_nullable_to_non_nullable
              as String,
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      formMode: null == formMode
          ? _value.formMode
          : formMode // ignore: cast_nullable_to_non_nullable
              as FormMode,
      editTarget: null == editTarget
          ? _value.editTarget
          : editTarget // ignore: cast_nullable_to_non_nullable
              as AccountEditTarget,
    ));
  }
}

/// @nodoc

class _$_AccountFormState implements _AccountFormState {
  const _$_AccountFormState(
      {required this.emailAddress,
      required this.password,
      required this.country,
      required this.phoneNumber,
      required this.pin,
      required this.isBusy,
      required this.formMode,
      required this.editTarget});

  @override
  final String emailAddress;
  @override
  final String password;
  @override
  final Country country;
  @override
  final String phoneNumber;
  @override
  final String pin;
  @override
  final bool isBusy;
  @override
  final FormMode formMode;
  @override
  final AccountEditTarget editTarget;

  @override
  String toString() {
    return 'AccountFormState(emailAddress: $emailAddress, password: $password, country: $country, phoneNumber: $phoneNumber, pin: $pin, isBusy: $isBusy, formMode: $formMode, editTarget: $editTarget)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AccountFormState &&
            (identical(other.emailAddress, emailAddress) ||
                other.emailAddress == emailAddress) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.pin, pin) || other.pin == pin) &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy) &&
            (identical(other.formMode, formMode) ||
                other.formMode == formMode) &&
            (identical(other.editTarget, editTarget) ||
                other.editTarget == editTarget));
  }

  @override
  int get hashCode => Object.hash(runtimeType, emailAddress, password, country,
      phoneNumber, pin, isBusy, formMode, editTarget);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AccountFormStateCopyWith<_$_AccountFormState> get copyWith =>
      __$$_AccountFormStateCopyWithImpl<_$_AccountFormState>(this, _$identity);
}

abstract class _AccountFormState implements AccountFormState {
  const factory _AccountFormState(
      {required final String emailAddress,
      required final String password,
      required final Country country,
      required final String phoneNumber,
      required final String pin,
      required final bool isBusy,
      required final FormMode formMode,
      required final AccountEditTarget editTarget}) = _$_AccountFormState;

  @override
  String get emailAddress;
  @override
  String get password;
  @override
  Country get country;
  @override
  String get phoneNumber;
  @override
  String get pin;
  @override
  bool get isBusy;
  @override
  FormMode get formMode;
  @override
  AccountEditTarget get editTarget;
  @override
  @JsonKey(ignore: true)
  _$$_AccountFormStateCopyWith<_$_AccountFormState> get copyWith =>
      throw _privateConstructorUsedError;
}
