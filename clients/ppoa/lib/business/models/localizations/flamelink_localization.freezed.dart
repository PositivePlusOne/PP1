// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'flamelink_localization.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FlamelinkLocalization _$FlamelinkLocalizationFromJson(
    Map<String, dynamic> json) {
  return _FlamelinkLocalization.fromJson(json);
}

/// @nodoc
mixin _$FlamelinkLocalization {
  @JsonKey(name: 'metadata')
  Metadata get metadata => throw _privateConstructorUsedError;
  String get key => throw _privateConstructorUsedError;
  String get locale => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FlamelinkLocalizationCopyWith<FlamelinkLocalization> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FlamelinkLocalizationCopyWith<$Res> {
  factory $FlamelinkLocalizationCopyWith(FlamelinkLocalization value,
          $Res Function(FlamelinkLocalization) then) =
      _$FlamelinkLocalizationCopyWithImpl<$Res>;
  $Res call(
      {@JsonKey(name: 'metadata') Metadata metadata,
      String key,
      String locale,
      String text});

  $MetadataCopyWith<$Res> get metadata;
}

/// @nodoc
class _$FlamelinkLocalizationCopyWithImpl<$Res>
    implements $FlamelinkLocalizationCopyWith<$Res> {
  _$FlamelinkLocalizationCopyWithImpl(this._value, this._then);

  final FlamelinkLocalization _value;
  // ignore: unused_field
  final $Res Function(FlamelinkLocalization) _then;

  @override
  $Res call({
    Object? metadata = freezed,
    Object? key = freezed,
    Object? locale = freezed,
    Object? text = freezed,
  }) {
    return _then(_value.copyWith(
      metadata: metadata == freezed
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Metadata,
      key: key == freezed
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      locale: locale == freezed
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String,
      text: text == freezed
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  @override
  $MetadataCopyWith<$Res> get metadata {
    return $MetadataCopyWith<$Res>(_value.metadata, (value) {
      return _then(_value.copyWith(metadata: value));
    });
  }
}

/// @nodoc
abstract class _$$_FlamelinkLocalizationCopyWith<$Res>
    implements $FlamelinkLocalizationCopyWith<$Res> {
  factory _$$_FlamelinkLocalizationCopyWith(_$_FlamelinkLocalization value,
          $Res Function(_$_FlamelinkLocalization) then) =
      __$$_FlamelinkLocalizationCopyWithImpl<$Res>;
  @override
  $Res call(
      {@JsonKey(name: 'metadata') Metadata metadata,
      String key,
      String locale,
      String text});

  @override
  $MetadataCopyWith<$Res> get metadata;
}

/// @nodoc
class __$$_FlamelinkLocalizationCopyWithImpl<$Res>
    extends _$FlamelinkLocalizationCopyWithImpl<$Res>
    implements _$$_FlamelinkLocalizationCopyWith<$Res> {
  __$$_FlamelinkLocalizationCopyWithImpl(_$_FlamelinkLocalization _value,
      $Res Function(_$_FlamelinkLocalization) _then)
      : super(_value, (v) => _then(v as _$_FlamelinkLocalization));

  @override
  _$_FlamelinkLocalization get _value =>
      super._value as _$_FlamelinkLocalization;

  @override
  $Res call({
    Object? metadata = freezed,
    Object? key = freezed,
    Object? locale = freezed,
    Object? text = freezed,
  }) {
    return _then(_$_FlamelinkLocalization(
      metadata: metadata == freezed
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Metadata,
      key: key == freezed
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      locale: locale == freezed
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String,
      text: text == freezed
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$_FlamelinkLocalization implements _FlamelinkLocalization {
  const _$_FlamelinkLocalization(
      {@JsonKey(name: 'metadata') required this.metadata,
      required this.key,
      required this.locale,
      required this.text});

  factory _$_FlamelinkLocalization.fromJson(Map<String, dynamic> json) =>
      _$$_FlamelinkLocalizationFromJson(json);

  @override
  @JsonKey(name: 'metadata')
  final Metadata metadata;
  @override
  final String key;
  @override
  final String locale;
  @override
  final String text;

  @override
  String toString() {
    return 'FlamelinkLocalization(metadata: $metadata, key: $key, locale: $locale, text: $text)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FlamelinkLocalization &&
            const DeepCollectionEquality().equals(other.metadata, metadata) &&
            const DeepCollectionEquality().equals(other.key, key) &&
            const DeepCollectionEquality().equals(other.locale, locale) &&
            const DeepCollectionEquality().equals(other.text, text));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(metadata),
      const DeepCollectionEquality().hash(key),
      const DeepCollectionEquality().hash(locale),
      const DeepCollectionEquality().hash(text));

  @JsonKey(ignore: true)
  @override
  _$$_FlamelinkLocalizationCopyWith<_$_FlamelinkLocalization> get copyWith =>
      __$$_FlamelinkLocalizationCopyWithImpl<_$_FlamelinkLocalization>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FlamelinkLocalizationToJson(
      this,
    );
  }
}

abstract class _FlamelinkLocalization implements FlamelinkLocalization {
  const factory _FlamelinkLocalization(
      {@JsonKey(name: 'metadata') required final Metadata metadata,
      required final String key,
      required final String locale,
      required final String text}) = _$_FlamelinkLocalization;

  factory _FlamelinkLocalization.fromJson(Map<String, dynamic> json) =
      _$_FlamelinkLocalization.fromJson;

  @override
  @JsonKey(name: 'metadata')
  Metadata get metadata;
  @override
  String get key;
  @override
  String get locale;
  @override
  String get text;
  @override
  @JsonKey(ignore: true)
  _$$_FlamelinkLocalizationCopyWith<_$_FlamelinkLocalization> get copyWith =>
      throw _privateConstructorUsedError;
}
