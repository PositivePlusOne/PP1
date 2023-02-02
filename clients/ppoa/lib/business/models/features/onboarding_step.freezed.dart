// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

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
  String get title => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  List<PageDecoration> get decorations => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OnboardingStepCopyWith<OnboardingStep> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnboardingStepCopyWith<$Res> {
  factory $OnboardingStepCopyWith(
          OnboardingStep value, $Res Function(OnboardingStep) then) =
      _$OnboardingStepCopyWithImpl<$Res, OnboardingStep>;
  @useResult
  $Res call(
      {OnboardingStepType type,
      String title,
      String body,
      List<PageDecoration> decorations});
}

/// @nodoc
class _$OnboardingStepCopyWithImpl<$Res, $Val extends OnboardingStep>
    implements $OnboardingStepCopyWith<$Res> {
  _$OnboardingStepCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? title = null,
    Object? body = null,
    Object? decorations = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as OnboardingStepType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      decorations: null == decorations
          ? _value.decorations
          : decorations // ignore: cast_nullable_to_non_nullable
              as List<PageDecoration>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_OnboardingStepCopyWith<$Res>
    implements $OnboardingStepCopyWith<$Res> {
  factory _$$_OnboardingStepCopyWith(
          _$_OnboardingStep value, $Res Function(_$_OnboardingStep) then) =
      __$$_OnboardingStepCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {OnboardingStepType type,
      String title,
      String body,
      List<PageDecoration> decorations});
}

/// @nodoc
class __$$_OnboardingStepCopyWithImpl<$Res>
    extends _$OnboardingStepCopyWithImpl<$Res, _$_OnboardingStep>
    implements _$$_OnboardingStepCopyWith<$Res> {
  __$$_OnboardingStepCopyWithImpl(
      _$_OnboardingStep _value, $Res Function(_$_OnboardingStep) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? title = null,
    Object? body = null,
    Object? decorations = null,
  }) {
    return _then(_$_OnboardingStep(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as OnboardingStepType,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      decorations: null == decorations
          ? _value._decorations
          : decorations // ignore: cast_nullable_to_non_nullable
              as List<PageDecoration>,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$_OnboardingStep implements _OnboardingStep {
  const _$_OnboardingStep(
      {required this.type,
      this.title = '',
      this.body = '',
      final List<PageDecoration> decorations = const <PageDecoration>[]})
      : _decorations = decorations;

  factory _$_OnboardingStep.fromJson(Map<String, dynamic> json) =>
      _$$_OnboardingStepFromJson(json);

  @override
  final OnboardingStepType type;
  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String body;
  final List<PageDecoration> _decorations;
  @override
  @JsonKey()
  List<PageDecoration> get decorations {
    if (_decorations is EqualUnmodifiableListView) return _decorations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_decorations);
  }

  @override
  String toString() {
    return 'OnboardingStep(type: $type, title: $title, body: $body, decorations: $decorations)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_OnboardingStep &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            const DeepCollectionEquality()
                .equals(other._decorations, _decorations));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, type, title, body,
      const DeepCollectionEquality().hash(_decorations));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
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
      final String title,
      final String body,
      final List<PageDecoration> decorations}) = _$_OnboardingStep;

  factory _OnboardingStep.fromJson(Map<String, dynamic> json) =
      _$_OnboardingStep.fromJson;

  @override
  OnboardingStepType get type;
  @override
  String get title;
  @override
  String get body;
  @override
  List<PageDecoration> get decorations;
  @override
  @JsonKey(ignore: true)
  _$$_OnboardingStepCopyWith<_$_OnboardingStep> get copyWith =>
      throw _privateConstructorUsedError;
}
