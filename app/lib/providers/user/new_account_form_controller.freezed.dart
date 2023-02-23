// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'new_account_form_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$NewAccountFormState {
  String get emailAddress => throw _privateConstructorUsedError;
  String get password => throw _privateConstructorUsedError;
  Country get country => throw _privateConstructorUsedError;
  String get phoneNumber => throw _privateConstructorUsedError;
  String get pin => throw _privateConstructorUsedError;
  bool get isBusy => throw _privateConstructorUsedError;
  Object? get currentError => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NewAccountFormStateCopyWith<NewAccountFormState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NewAccountFormStateCopyWith<$Res> {
  factory $NewAccountFormStateCopyWith(
          NewAccountFormState value, $Res Function(NewAccountFormState) then) =
      _$NewAccountFormStateCopyWithImpl<$Res, NewAccountFormState>;
  @useResult
  $Res call(
      {String emailAddress,
      String password,
      Country country,
      String phoneNumber,
      String pin,
      bool isBusy,
      Object? currentError});

  $CountryCopyWith<$Res> get country;
}

/// @nodoc
class _$NewAccountFormStateCopyWithImpl<$Res, $Val extends NewAccountFormState>
    implements $NewAccountFormStateCopyWith<$Res> {
  _$NewAccountFormStateCopyWithImpl(this._value, this._then);

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
    Object? currentError = freezed,
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
      currentError:
          freezed == currentError ? _value.currentError : currentError,
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
abstract class _$$_NewAccountFormStateCopyWith<$Res>
    implements $NewAccountFormStateCopyWith<$Res> {
  factory _$$_NewAccountFormStateCopyWith(_$_NewAccountFormState value,
          $Res Function(_$_NewAccountFormState) then) =
      __$$_NewAccountFormStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String emailAddress,
      String password,
      Country country,
      String phoneNumber,
      String pin,
      bool isBusy,
      Object? currentError});

  @override
  $CountryCopyWith<$Res> get country;
}

/// @nodoc
class __$$_NewAccountFormStateCopyWithImpl<$Res>
    extends _$NewAccountFormStateCopyWithImpl<$Res, _$_NewAccountFormState>
    implements _$$_NewAccountFormStateCopyWith<$Res> {
  __$$_NewAccountFormStateCopyWithImpl(_$_NewAccountFormState _value,
      $Res Function(_$_NewAccountFormState) _then)
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
    Object? currentError = freezed,
  }) {
    return _then(_$_NewAccountFormState(
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
      currentError:
          freezed == currentError ? _value.currentError : currentError,
    ));
  }
}

/// @nodoc

class _$_NewAccountFormState implements _NewAccountFormState {
  const _$_NewAccountFormState(
      {required this.emailAddress,
      required this.password,
      required this.country,
      required this.phoneNumber,
      required this.pin,
      required this.isBusy,
      this.currentError});

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
  final Object? currentError;

  @override
  String toString() {
    return 'NewAccountFormState(emailAddress: $emailAddress, password: $password, country: $country, phoneNumber: $phoneNumber, pin: $pin, isBusy: $isBusy, currentError: $currentError)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_NewAccountFormState &&
            (identical(other.emailAddress, emailAddress) ||
                other.emailAddress == emailAddress) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.pin, pin) || other.pin == pin) &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy) &&
            const DeepCollectionEquality()
                .equals(other.currentError, currentError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      emailAddress,
      password,
      country,
      phoneNumber,
      pin,
      isBusy,
      const DeepCollectionEquality().hash(currentError));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_NewAccountFormStateCopyWith<_$_NewAccountFormState> get copyWith =>
      __$$_NewAccountFormStateCopyWithImpl<_$_NewAccountFormState>(
          this, _$identity);
}

abstract class _NewAccountFormState implements NewAccountFormState {
  const factory _NewAccountFormState(
      {required final String emailAddress,
      required final String password,
      required final Country country,
      required final String phoneNumber,
      required final String pin,
      required final bool isBusy,
      final Object? currentError}) = _$_NewAccountFormState;

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
  Object? get currentError;
  @override
  @JsonKey(ignore: true)
  _$$_NewAccountFormStateCopyWith<_$_NewAccountFormState> get copyWith =>
      throw _privateConstructorUsedError;
}
