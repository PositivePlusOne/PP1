// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'app_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

AppState _$AppStateFromJson(Map<String, dynamic> json) {
  return _AppState.fromJson(json);
}

/// @nodoc
mixin _$AppState {
  DesignSystemState get designSystem => throw _privateConstructorUsedError;
  Environment get environment => throw _privateConstructorUsedError;
  User get user => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AppStateCopyWith<AppState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppStateCopyWith<$Res> {
  factory $AppStateCopyWith(AppState value, $Res Function(AppState) then) =
      _$AppStateCopyWithImpl<$Res>;
  $Res call(
      {DesignSystemState designSystem, Environment environment, User user});

  $DesignSystemStateCopyWith<$Res> get designSystem;
  $EnvironmentCopyWith<$Res> get environment;
  $UserCopyWith<$Res> get user;
}

/// @nodoc
class _$AppStateCopyWithImpl<$Res> implements $AppStateCopyWith<$Res> {
  _$AppStateCopyWithImpl(this._value, this._then);

  final AppState _value;
  // ignore: unused_field
  final $Res Function(AppState) _then;

  @override
  $Res call({
    Object? designSystem = freezed,
    Object? environment = freezed,
    Object? user = freezed,
  }) {
    return _then(_value.copyWith(
      designSystem: designSystem == freezed
          ? _value.designSystem
          : designSystem // ignore: cast_nullable_to_non_nullable
              as DesignSystemState,
      environment: environment == freezed
          ? _value.environment
          : environment // ignore: cast_nullable_to_non_nullable
              as Environment,
      user: user == freezed
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
    ));
  }

  @override
  $DesignSystemStateCopyWith<$Res> get designSystem {
    return $DesignSystemStateCopyWith<$Res>(_value.designSystem, (value) {
      return _then(_value.copyWith(designSystem: value));
    });
  }

  @override
  $EnvironmentCopyWith<$Res> get environment {
    return $EnvironmentCopyWith<$Res>(_value.environment, (value) {
      return _then(_value.copyWith(environment: value));
    });
  }

  @override
  $UserCopyWith<$Res> get user {
    return $UserCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value));
    });
  }
}

/// @nodoc
abstract class _$$_AppStateCopyWith<$Res> implements $AppStateCopyWith<$Res> {
  factory _$$_AppStateCopyWith(
          _$_AppState value, $Res Function(_$_AppState) then) =
      __$$_AppStateCopyWithImpl<$Res>;
  @override
  $Res call(
      {DesignSystemState designSystem, Environment environment, User user});

  @override
  $DesignSystemStateCopyWith<$Res> get designSystem;
  @override
  $EnvironmentCopyWith<$Res> get environment;
  @override
  $UserCopyWith<$Res> get user;
}

/// @nodoc
class __$$_AppStateCopyWithImpl<$Res> extends _$AppStateCopyWithImpl<$Res>
    implements _$$_AppStateCopyWith<$Res> {
  __$$_AppStateCopyWithImpl(
      _$_AppState _value, $Res Function(_$_AppState) _then)
      : super(_value, (v) => _then(v as _$_AppState));

  @override
  _$_AppState get _value => super._value as _$_AppState;

  @override
  $Res call({
    Object? designSystem = freezed,
    Object? environment = freezed,
    Object? user = freezed,
  }) {
    return _then(_$_AppState(
      designSystem: designSystem == freezed
          ? _value.designSystem
          : designSystem // ignore: cast_nullable_to_non_nullable
              as DesignSystemState,
      environment: environment == freezed
          ? _value.environment
          : environment // ignore: cast_nullable_to_non_nullable
              as Environment,
      user: user == freezed
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$_AppState implements _AppState {
  const _$_AppState(
      {required this.designSystem,
      required this.environment,
      required this.user});

  factory _$_AppState.fromJson(Map<String, dynamic> json) =>
      _$$_AppStateFromJson(json);

  @override
  final DesignSystemState designSystem;
  @override
  final Environment environment;
  @override
  final User user;

  @override
  String toString() {
    return 'AppState(designSystem: $designSystem, environment: $environment, user: $user)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AppState &&
            const DeepCollectionEquality()
                .equals(other.designSystem, designSystem) &&
            const DeepCollectionEquality()
                .equals(other.environment, environment) &&
            const DeepCollectionEquality().equals(other.user, user));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(designSystem),
      const DeepCollectionEquality().hash(environment),
      const DeepCollectionEquality().hash(user));

  @JsonKey(ignore: true)
  @override
  _$$_AppStateCopyWith<_$_AppState> get copyWith =>
      __$$_AppStateCopyWithImpl<_$_AppState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AppStateToJson(
      this,
    );
  }
}

abstract class _AppState implements AppState {
  const factory _AppState(
      {required final DesignSystemState designSystem,
      required final Environment environment,
      required final User user}) = _$_AppState;

  factory _AppState.fromJson(Map<String, dynamic> json) = _$_AppState.fromJson;

  @override
  DesignSystemState get designSystem;
  @override
  Environment get environment;
  @override
  User get user;
  @override
  @JsonKey(ignore: true)
  _$$_AppStateCopyWith<_$_AppState> get copyWith =>
      throw _privateConstructorUsedError;
}
