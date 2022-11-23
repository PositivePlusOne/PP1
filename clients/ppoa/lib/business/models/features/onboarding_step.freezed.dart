// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'onboarding_step.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

OnboardingStep _$OnboardingStepFromJson(Map<String, dynamic> json) {
  return _OnboardingStep.fromJson(json);
}

/// @nodoc
mixin _$OnboardingStep {
  OnboardingStepType get type => throw _privateConstructorUsedError;
  String get key => throw _privateConstructorUsedError;
  String get markdown => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OnboardingStepCopyWith<OnboardingStep> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnboardingStepCopyWith<$Res> {
  factory $OnboardingStepCopyWith(
          OnboardingStep value, $Res Function(OnboardingStep) then) =
      _$OnboardingStepCopyWithImpl<$Res>;
  $Res call({OnboardingStepType type, String key, String markdown});
}

/// @nodoc
class _$OnboardingStepCopyWithImpl<$Res>
    implements $OnboardingStepCopyWith<$Res> {
  _$OnboardingStepCopyWithImpl(this._value, this._then);

  final OnboardingStep _value;
  // ignore: unused_field
  final $Res Function(OnboardingStep) _then;

  @override
  $Res call({
    Object? type = freezed,
    Object? key = freezed,
    Object? markdown = freezed,
  }) {
    return _then(_value.copyWith(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as OnboardingStepType,
      key: key == freezed
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      markdown: markdown == freezed
          ? _value.markdown
          : markdown // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_OnboardingStepCopyWith<$Res>
    implements $OnboardingStepCopyWith<$Res> {
  factory _$$_OnboardingStepCopyWith(
          _$_OnboardingStep value, $Res Function(_$_OnboardingStep) then) =
      __$$_OnboardingStepCopyWithImpl<$Res>;
  @override
  $Res call({OnboardingStepType type, String key, String markdown});
}

/// @nodoc
class __$$_OnboardingStepCopyWithImpl<$Res>
    extends _$OnboardingStepCopyWithImpl<$Res>
    implements _$$_OnboardingStepCopyWith<$Res> {
  __$$_OnboardingStepCopyWithImpl(
      _$_OnboardingStep _value, $Res Function(_$_OnboardingStep) _then)
      : super(_value, (v) => _then(v as _$_OnboardingStep));

  @override
  _$_OnboardingStep get _value => super._value as _$_OnboardingStep;

  @override
  $Res call({
    Object? type = freezed,
    Object? key = freezed,
    Object? markdown = freezed,
  }) {
    return _then(_$_OnboardingStep(
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as OnboardingStepType,
      key: key == freezed
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      markdown: markdown == freezed
          ? _value.markdown
          : markdown // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$_OnboardingStep implements _OnboardingStep {
  const _$_OnboardingStep(
      {required this.type, required this.key, required this.markdown});

  factory _$_OnboardingStep.fromJson(Map<String, dynamic> json) =>
      _$$_OnboardingStepFromJson(json);

  @override
  final OnboardingStepType type;
  @override
  final String key;
  @override
  final String markdown;

  @override
  String toString() {
    return 'OnboardingStep(type: $type, key: $key, markdown: $markdown)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_OnboardingStep &&
            const DeepCollectionEquality().equals(other.type, type) &&
            const DeepCollectionEquality().equals(other.key, key) &&
            const DeepCollectionEquality().equals(other.markdown, markdown));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(type),
      const DeepCollectionEquality().hash(key),
      const DeepCollectionEquality().hash(markdown));

  @JsonKey(ignore: true)
  @override
  _$$_OnboardingStepCopyWith<_$_OnboardingStep> get copyWith =>
      __$$_OnboardingStepCopyWithImpl<_$_OnboardingStep>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_OnboardingStepToJson(
      this,
    );
  }
}

abstract class _OnboardingStep implements OnboardingStep {
  const factory _OnboardingStep(
      {required final OnboardingStepType type,
      required final String key,
      required final String markdown}) = _$_OnboardingStep;

  factory _OnboardingStep.fromJson(Map<String, dynamic> json) =
      _$_OnboardingStep.fromJson;

  @override
  OnboardingStepType get type;
  @override
  String get key;
  @override
  String get markdown;
  @override
  @JsonKey(ignore: true)
  _$$_OnboardingStepCopyWith<_$_OnboardingStep> get copyWith =>
      throw _privateConstructorUsedError;
}
