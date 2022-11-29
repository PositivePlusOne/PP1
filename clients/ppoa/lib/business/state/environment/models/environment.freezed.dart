// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'environment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Environment _$EnvironmentFromJson(Map<String, dynamic> json) {
  return _Environment.fromJson(json);
}

/// @nodoc
mixin _$Environment {
  EnvironmentType get type => throw _privateConstructorUsedError;
  List<OnboardingStep> get onboardingSteps =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EnvironmentCopyWith<Environment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EnvironmentCopyWith<$Res> {
  factory $EnvironmentCopyWith(
          Environment value, $Res Function(Environment) then) =
      _$EnvironmentCopyWithImpl<$Res>;
  $Res call({EnvironmentType type, List<OnboardingStep> onboardingSteps});
}

/// @nodoc
class _$EnvironmentCopyWithImpl<$Res> implements $EnvironmentCopyWith<$Res> {
  _$EnvironmentCopyWithImpl(this._value, this._then);

  final Environment _value;
  // ignore: unused_field
  final $Res Function(Environment) _then;

  @override
  $Res call({
    Object? type = freezed,
    Object? onboardingSteps = freezed,
  }) {
    return _then(_value.copyWith(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as EnvironmentType,
      onboardingSteps: onboardingSteps == freezed
          ? _value.onboardingSteps
          : onboardingSteps // ignore: cast_nullable_to_non_nullable
              as List<OnboardingStep>,
    ));
  }
}

/// @nodoc
abstract class _$$_EnvironmentCopyWith<$Res>
    implements $EnvironmentCopyWith<$Res> {
  factory _$$_EnvironmentCopyWith(
          _$_Environment value, $Res Function(_$_Environment) then) =
      __$$_EnvironmentCopyWithImpl<$Res>;
  @override
  $Res call({EnvironmentType type, List<OnboardingStep> onboardingSteps});
}

/// @nodoc
class __$$_EnvironmentCopyWithImpl<$Res> extends _$EnvironmentCopyWithImpl<$Res>
    implements _$$_EnvironmentCopyWith<$Res> {
  __$$_EnvironmentCopyWithImpl(
      _$_Environment _value, $Res Function(_$_Environment) _then)
      : super(_value, (v) => _then(v as _$_Environment));

  @override
  _$_Environment get _value => super._value as _$_Environment;

  @override
  $Res call({
    Object? type = freezed,
    Object? onboardingSteps = freezed,
  }) {
    return _then(_$_Environment(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as EnvironmentType,
      onboardingSteps: onboardingSteps == freezed
          ? _value._onboardingSteps
          : onboardingSteps // ignore: cast_nullable_to_non_nullable
              as List<OnboardingStep>,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$_Environment implements _Environment {
  const _$_Environment(
      {required this.type, required final List<OnboardingStep> onboardingSteps})
      : _onboardingSteps = onboardingSteps;

  factory _$_Environment.fromJson(Map<String, dynamic> json) =>
      _$$_EnvironmentFromJson(json);

  @override
  final EnvironmentType type;
  final List<OnboardingStep> _onboardingSteps;
  @override
  List<OnboardingStep> get onboardingSteps {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_onboardingSteps);
  }

  @override
  String toString() {
    return 'Environment(type: $type, onboardingSteps: $onboardingSteps)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Environment &&
            const DeepCollectionEquality().equals(other.type, type) &&
            const DeepCollectionEquality()
                .equals(other._onboardingSteps, _onboardingSteps));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(type),
      const DeepCollectionEquality().hash(_onboardingSteps));

  @JsonKey(ignore: true)
  @override
  _$$_EnvironmentCopyWith<_$_Environment> get copyWith =>
      __$$_EnvironmentCopyWithImpl<_$_Environment>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_EnvironmentToJson(
      this,
    );
  }
}

abstract class _Environment implements Environment {
  const factory _Environment(
      {required final EnvironmentType type,
      required final List<OnboardingStep> onboardingSteps}) = _$_Environment;

  factory _Environment.fromJson(Map<String, dynamic> json) =
      _$_Environment.fromJson;

  @override
  EnvironmentType get type;
  @override
  List<OnboardingStep> get onboardingSteps;
  @override
  @JsonKey(ignore: true)
  _$$_EnvironmentCopyWith<_$_Environment> get copyWith =>
      throw _privateConstructorUsedError;
}
