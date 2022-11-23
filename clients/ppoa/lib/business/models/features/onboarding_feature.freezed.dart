// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'onboarding_feature.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

OnboardingFeature _$OnboardingFeatureFromJson(Map<String, dynamic> json) {
  return _OnboardingFeature.fromJson(json);
}

/// @nodoc
mixin _$OnboardingFeature {
  String get key => throw _privateConstructorUsedError;
  String get locale => throw _privateConstructorUsedError;
  String get localizedMarkdown => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OnboardingFeatureCopyWith<OnboardingFeature> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnboardingFeatureCopyWith<$Res> {
  factory $OnboardingFeatureCopyWith(
          OnboardingFeature value, $Res Function(OnboardingFeature) then) =
      _$OnboardingFeatureCopyWithImpl<$Res>;
  $Res call({String key, String locale, String localizedMarkdown});
}

/// @nodoc
class _$OnboardingFeatureCopyWithImpl<$Res>
    implements $OnboardingFeatureCopyWith<$Res> {
  _$OnboardingFeatureCopyWithImpl(this._value, this._then);

  final OnboardingFeature _value;
  // ignore: unused_field
  final $Res Function(OnboardingFeature) _then;

  @override
  $Res call({
    Object? key = freezed,
    Object? locale = freezed,
    Object? localizedMarkdown = freezed,
  }) {
    return _then(_value.copyWith(
      key: key == freezed
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      locale: locale == freezed
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String,
      localizedMarkdown: localizedMarkdown == freezed
          ? _value.localizedMarkdown
          : localizedMarkdown // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_OnboardingFeatureCopyWith<$Res>
    implements $OnboardingFeatureCopyWith<$Res> {
  factory _$$_OnboardingFeatureCopyWith(_$_OnboardingFeature value,
          $Res Function(_$_OnboardingFeature) then) =
      __$$_OnboardingFeatureCopyWithImpl<$Res>;
  @override
  $Res call({String key, String locale, String localizedMarkdown});
}

/// @nodoc
class __$$_OnboardingFeatureCopyWithImpl<$Res>
    extends _$OnboardingFeatureCopyWithImpl<$Res>
    implements _$$_OnboardingFeatureCopyWith<$Res> {
  __$$_OnboardingFeatureCopyWithImpl(
      _$_OnboardingFeature _value, $Res Function(_$_OnboardingFeature) _then)
      : super(_value, (v) => _then(v as _$_OnboardingFeature));

  @override
  _$_OnboardingFeature get _value => super._value as _$_OnboardingFeature;

  @override
  $Res call({
    Object? key = freezed,
    Object? locale = freezed,
    Object? localizedMarkdown = freezed,
  }) {
    return _then(_$_OnboardingFeature(
      key: key == freezed
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      locale: locale == freezed
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String,
      localizedMarkdown: localizedMarkdown == freezed
          ? _value.localizedMarkdown
          : localizedMarkdown // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$_OnboardingFeature implements _OnboardingFeature {
  const _$_OnboardingFeature(
      {required this.key,
      required this.locale,
      required this.localizedMarkdown});

  factory _$_OnboardingFeature.fromJson(Map<String, dynamic> json) =>
      _$$_OnboardingFeatureFromJson(json);

  @override
  final String key;
  @override
  final String locale;
  @override
  final String localizedMarkdown;

  @override
  String toString() {
    return 'OnboardingFeature(key: $key, locale: $locale, localizedMarkdown: $localizedMarkdown)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_OnboardingFeature &&
            const DeepCollectionEquality().equals(other.key, key) &&
            const DeepCollectionEquality().equals(other.locale, locale) &&
            const DeepCollectionEquality()
                .equals(other.localizedMarkdown, localizedMarkdown));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(key),
      const DeepCollectionEquality().hash(locale),
      const DeepCollectionEquality().hash(localizedMarkdown));

  @JsonKey(ignore: true)
  @override
  _$$_OnboardingFeatureCopyWith<_$_OnboardingFeature> get copyWith =>
      __$$_OnboardingFeatureCopyWithImpl<_$_OnboardingFeature>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_OnboardingFeatureToJson(
      this,
    );
  }
}

abstract class _OnboardingFeature implements OnboardingFeature {
  const factory _OnboardingFeature(
      {required final String key,
      required final String locale,
      required final String localizedMarkdown}) = _$_OnboardingFeature;

  factory _OnboardingFeature.fromJson(Map<String, dynamic> json) =
      _$_OnboardingFeature.fromJson;

  @override
  String get key;
  @override
  String get locale;
  @override
  String get localizedMarkdown;
  @override
  @JsonKey(ignore: true)
  _$$_OnboardingFeatureCopyWith<_$_OnboardingFeature> get copyWith =>
      throw _privateConstructorUsedError;
}
