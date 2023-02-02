// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'system_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

SystemState _$SystemStateFromJson(Map<String, dynamic> json) {
  return _SystemState.fromJson(json);
}

/// @nodoc
mixin _$SystemState {
  bool get isBusy => throw _privateConstructorUsedError;
  String? get appCheckToken => throw _privateConstructorUsedError;
  Object? get currentException => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SystemStateCopyWith<SystemState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SystemStateCopyWith<$Res> {
  factory $SystemStateCopyWith(
          SystemState value, $Res Function(SystemState) then) =
      _$SystemStateCopyWithImpl<$Res, SystemState>;
  @useResult
  $Res call({bool isBusy, String? appCheckToken, Object? currentException});
}

/// @nodoc
class _$SystemStateCopyWithImpl<$Res, $Val extends SystemState>
    implements $SystemStateCopyWith<$Res> {
  _$SystemStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
    Object? appCheckToken = freezed,
    Object? currentException = freezed,
  }) {
    return _then(_value.copyWith(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      appCheckToken: freezed == appCheckToken
          ? _value.appCheckToken
          : appCheckToken // ignore: cast_nullable_to_non_nullable
              as String?,
      currentException: freezed == currentException
          ? _value.currentException
          : currentException,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SystemStateCopyWith<$Res>
    implements $SystemStateCopyWith<$Res> {
  factory _$$_SystemStateCopyWith(
          _$_SystemState value, $Res Function(_$_SystemState) then) =
      __$$_SystemStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isBusy, String? appCheckToken, Object? currentException});
}

/// @nodoc
class __$$_SystemStateCopyWithImpl<$Res>
    extends _$SystemStateCopyWithImpl<$Res, _$_SystemState>
    implements _$$_SystemStateCopyWith<$Res> {
  __$$_SystemStateCopyWithImpl(
      _$_SystemState _value, $Res Function(_$_SystemState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
    Object? appCheckToken = freezed,
    Object? currentException = freezed,
  }) {
    return _then(_$_SystemState(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      appCheckToken: freezed == appCheckToken
          ? _value.appCheckToken
          : appCheckToken // ignore: cast_nullable_to_non_nullable
              as String?,
      currentException: freezed == currentException
          ? _value.currentException
          : currentException,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$_SystemState implements _SystemState {
  const _$_SystemState(
      {required this.isBusy, this.appCheckToken, this.currentException});

  factory _$_SystemState.fromJson(Map<String, dynamic> json) =>
      _$$_SystemStateFromJson(json);

  @override
  final bool isBusy;
  @override
  final String? appCheckToken;
  @override
  final Object? currentException;

  @override
  String toString() {
    return 'SystemState(isBusy: $isBusy, appCheckToken: $appCheckToken, currentException: $currentException)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SystemState &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy) &&
            (identical(other.appCheckToken, appCheckToken) ||
                other.appCheckToken == appCheckToken) &&
            const DeepCollectionEquality()
                .equals(other.currentException, currentException));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, isBusy, appCheckToken,
      const DeepCollectionEquality().hash(currentException));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SystemStateCopyWith<_$_SystemState> get copyWith =>
      __$$_SystemStateCopyWithImpl<_$_SystemState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_SystemStateToJson(
      this,
    );
  }
}

abstract class _SystemState implements SystemState {
  const factory _SystemState(
      {required final bool isBusy,
      final String? appCheckToken,
      final Object? currentException}) = _$_SystemState;

  factory _SystemState.fromJson(Map<String, dynamic> json) =
      _$_SystemState.fromJson;

  @override
  bool get isBusy;
  @override
  String? get appCheckToken;
  @override
  Object? get currentException;
  @override
  @JsonKey(ignore: true)
  _$$_SystemStateCopyWith<_$_SystemState> get copyWith =>
      throw _privateConstructorUsedError;
}
