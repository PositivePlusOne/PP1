// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_form_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ProfileFormState {
  String get name => throw _privateConstructorUsedError;
  String get displayName => throw _privateConstructorUsedError;
  bool get isBusy => throw _privateConstructorUsedError;
  Object? get currentError => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ProfileFormStateCopyWith<ProfileFormState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileFormStateCopyWith<$Res> {
  factory $ProfileFormStateCopyWith(
          ProfileFormState value, $Res Function(ProfileFormState) then) =
      _$ProfileFormStateCopyWithImpl<$Res, ProfileFormState>;
  @useResult
  $Res call(
      {String name, String displayName, bool isBusy, Object? currentError});
}

/// @nodoc
class _$ProfileFormStateCopyWithImpl<$Res, $Val extends ProfileFormState>
    implements $ProfileFormStateCopyWith<$Res> {
  _$ProfileFormStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? displayName = null,
    Object? isBusy = null,
    Object? currentError = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
              as String,
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      currentError:
          freezed == currentError ? _value.currentError : currentError,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ProfileFormStateCopyWith<$Res>
    implements $ProfileFormStateCopyWith<$Res> {
  factory _$$_ProfileFormStateCopyWith(
          _$_ProfileFormState value, $Res Function(_$_ProfileFormState) then) =
      __$$_ProfileFormStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name, String displayName, bool isBusy, Object? currentError});
}

/// @nodoc
class __$$_ProfileFormStateCopyWithImpl<$Res>
    extends _$ProfileFormStateCopyWithImpl<$Res, _$_ProfileFormState>
    implements _$$_ProfileFormStateCopyWith<$Res> {
  __$$_ProfileFormStateCopyWithImpl(
      _$_ProfileFormState _value, $Res Function(_$_ProfileFormState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? displayName = null,
    Object? isBusy = null,
    Object? currentError = freezed,
  }) {
    return _then(_$_ProfileFormState(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      displayName: null == displayName
          ? _value.displayName
          : displayName // ignore: cast_nullable_to_non_nullable
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

class _$_ProfileFormState implements _ProfileFormState {
  const _$_ProfileFormState(
      {required this.name,
      required this.displayName,
      required this.isBusy,
      this.currentError});

  @override
  final String name;
  @override
  final String displayName;
  @override
  final bool isBusy;
  @override
  final Object? currentError;

  @override
  String toString() {
    return 'ProfileFormState(name: $name, displayName: $displayName, isBusy: $isBusy, currentError: $currentError)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ProfileFormState &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy) &&
            const DeepCollectionEquality()
                .equals(other.currentError, currentError));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, displayName, isBusy,
      const DeepCollectionEquality().hash(currentError));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ProfileFormStateCopyWith<_$_ProfileFormState> get copyWith =>
      __$$_ProfileFormStateCopyWithImpl<_$_ProfileFormState>(this, _$identity);
}

abstract class _ProfileFormState implements ProfileFormState {
  const factory _ProfileFormState(
      {required final String name,
      required final String displayName,
      required final bool isBusy,
      final Object? currentError}) = _$_ProfileFormState;

  @override
  String get name;
  @override
  String get displayName;
  @override
  bool get isBusy;
  @override
  Object? get currentError;
  @override
  @JsonKey(ignore: true)
  _$$_ProfileFormStateCopyWith<_$_ProfileFormState> get copyWith =>
      throw _privateConstructorUsedError;
}
