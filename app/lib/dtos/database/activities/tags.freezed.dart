// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tags.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Tag _$TagFromJson(Map<String, dynamic> json) {
  return _Tag.fromJson(json);
}

/// @nodoc
mixin _$Tag {
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta => throw _privateConstructorUsedError;
  String get key => throw _privateConstructorUsedError;
  String get fallback => throw _privateConstructorUsedError;
  int get popularity => throw _privateConstructorUsedError;
  bool get promoted => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: TagLocalization.fromJsonLocalizations,
      toJson: TagLocalization.toJsonLocalizations)
  List<TagLocalization> get localizations => throw _privateConstructorUsedError;
  TagTopic? get topic => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TagCopyWith<Tag> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TagCopyWith<$Res> {
  factory $TagCopyWith(Tag value, $Res Function(Tag) then) =
      _$TagCopyWithImpl<$Res, Tag>;
  @useResult
  $Res call(
      {@JsonKey(name: '_fl_meta_') FlMeta? flMeta,
      String key,
      String fallback,
      int popularity,
      bool promoted,
      @JsonKey(
          fromJson: TagLocalization.fromJsonLocalizations,
          toJson: TagLocalization.toJsonLocalizations)
      List<TagLocalization> localizations,
      TagTopic? topic});

  $FlMetaCopyWith<$Res>? get flMeta;
  $TagTopicCopyWith<$Res>? get topic;
}

/// @nodoc
class _$TagCopyWithImpl<$Res, $Val extends Tag> implements $TagCopyWith<$Res> {
  _$TagCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flMeta = freezed,
    Object? key = null,
    Object? fallback = null,
    Object? popularity = null,
    Object? promoted = null,
    Object? localizations = null,
    Object? topic = freezed,
  }) {
    return _then(_value.copyWith(
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      fallback: null == fallback
          ? _value.fallback
          : fallback // ignore: cast_nullable_to_non_nullable
              as String,
      popularity: null == popularity
          ? _value.popularity
          : popularity // ignore: cast_nullable_to_non_nullable
              as int,
      promoted: null == promoted
          ? _value.promoted
          : promoted // ignore: cast_nullable_to_non_nullable
              as bool,
      localizations: null == localizations
          ? _value.localizations
          : localizations // ignore: cast_nullable_to_non_nullable
              as List<TagLocalization>,
      topic: freezed == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as TagTopic?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $FlMetaCopyWith<$Res>? get flMeta {
    if (_value.flMeta == null) {
      return null;
    }

    return $FlMetaCopyWith<$Res>(_value.flMeta!, (value) {
      return _then(_value.copyWith(flMeta: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $TagTopicCopyWith<$Res>? get topic {
    if (_value.topic == null) {
      return null;
    }

    return $TagTopicCopyWith<$Res>(_value.topic!, (value) {
      return _then(_value.copyWith(topic: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TagImplCopyWith<$Res> implements $TagCopyWith<$Res> {
  factory _$$TagImplCopyWith(_$TagImpl value, $Res Function(_$TagImpl) then) =
      __$$TagImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_fl_meta_') FlMeta? flMeta,
      String key,
      String fallback,
      int popularity,
      bool promoted,
      @JsonKey(
          fromJson: TagLocalization.fromJsonLocalizations,
          toJson: TagLocalization.toJsonLocalizations)
      List<TagLocalization> localizations,
      TagTopic? topic});

  @override
  $FlMetaCopyWith<$Res>? get flMeta;
  @override
  $TagTopicCopyWith<$Res>? get topic;
}

/// @nodoc
class __$$TagImplCopyWithImpl<$Res> extends _$TagCopyWithImpl<$Res, _$TagImpl>
    implements _$$TagImplCopyWith<$Res> {
  __$$TagImplCopyWithImpl(_$TagImpl _value, $Res Function(_$TagImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flMeta = freezed,
    Object? key = null,
    Object? fallback = null,
    Object? popularity = null,
    Object? promoted = null,
    Object? localizations = null,
    Object? topic = freezed,
  }) {
    return _then(_$TagImpl(
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      fallback: null == fallback
          ? _value.fallback
          : fallback // ignore: cast_nullable_to_non_nullable
              as String,
      popularity: null == popularity
          ? _value.popularity
          : popularity // ignore: cast_nullable_to_non_nullable
              as int,
      promoted: null == promoted
          ? _value.promoted
          : promoted // ignore: cast_nullable_to_non_nullable
              as bool,
      localizations: null == localizations
          ? _value._localizations
          : localizations // ignore: cast_nullable_to_non_nullable
              as List<TagLocalization>,
      topic: freezed == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as TagTopic?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TagImpl implements _Tag {
  const _$TagImpl(
      {@JsonKey(name: '_fl_meta_') this.flMeta,
      this.key = '',
      this.fallback = '',
      this.popularity = -1,
      this.promoted = false,
      @JsonKey(
          fromJson: TagLocalization.fromJsonLocalizations,
          toJson: TagLocalization.toJsonLocalizations)
      final List<TagLocalization> localizations = const [],
      this.topic})
      : _localizations = localizations;

  factory _$TagImpl.fromJson(Map<String, dynamic> json) =>
      _$$TagImplFromJson(json);

  @override
  @JsonKey(name: '_fl_meta_')
  final FlMeta? flMeta;
  @override
  @JsonKey()
  final String key;
  @override
  @JsonKey()
  final String fallback;
  @override
  @JsonKey()
  final int popularity;
  @override
  @JsonKey()
  final bool promoted;
  final List<TagLocalization> _localizations;
  @override
  @JsonKey(
      fromJson: TagLocalization.fromJsonLocalizations,
      toJson: TagLocalization.toJsonLocalizations)
  List<TagLocalization> get localizations {
    if (_localizations is EqualUnmodifiableListView) return _localizations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_localizations);
  }

  @override
  final TagTopic? topic;

  @override
  String toString() {
    return 'Tag(flMeta: $flMeta, key: $key, fallback: $fallback, popularity: $popularity, promoted: $promoted, localizations: $localizations, topic: $topic)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TagImpl &&
            (identical(other.flMeta, flMeta) || other.flMeta == flMeta) &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.fallback, fallback) ||
                other.fallback == fallback) &&
            (identical(other.popularity, popularity) ||
                other.popularity == popularity) &&
            (identical(other.promoted, promoted) ||
                other.promoted == promoted) &&
            const DeepCollectionEquality()
                .equals(other._localizations, _localizations) &&
            (identical(other.topic, topic) || other.topic == topic));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      flMeta,
      key,
      fallback,
      popularity,
      promoted,
      const DeepCollectionEquality().hash(_localizations),
      topic);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TagImplCopyWith<_$TagImpl> get copyWith =>
      __$$TagImplCopyWithImpl<_$TagImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TagImplToJson(
      this,
    );
  }
}

abstract class _Tag implements Tag {
  const factory _Tag(
      {@JsonKey(name: '_fl_meta_') final FlMeta? flMeta,
      final String key,
      final String fallback,
      final int popularity,
      final bool promoted,
      @JsonKey(
          fromJson: TagLocalization.fromJsonLocalizations,
          toJson: TagLocalization.toJsonLocalizations)
      final List<TagLocalization> localizations,
      final TagTopic? topic}) = _$TagImpl;

  factory _Tag.fromJson(Map<String, dynamic> json) = _$TagImpl.fromJson;

  @override
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta;
  @override
  String get key;
  @override
  String get fallback;
  @override
  int get popularity;
  @override
  bool get promoted;
  @override
  @JsonKey(
      fromJson: TagLocalization.fromJsonLocalizations,
      toJson: TagLocalization.toJsonLocalizations)
  List<TagLocalization> get localizations;
  @override
  TagTopic? get topic;
  @override
  @JsonKey(ignore: true)
  _$$TagImplCopyWith<_$TagImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TagLocalization _$TagLocalizationFromJson(Map<String, dynamic> json) {
  return _TagLocalization.fromJson(json);
}

/// @nodoc
mixin _$TagLocalization {
  String get locale => throw _privateConstructorUsedError;
  String get value => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TagLocalizationCopyWith<TagLocalization> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TagLocalizationCopyWith<$Res> {
  factory $TagLocalizationCopyWith(
          TagLocalization value, $Res Function(TagLocalization) then) =
      _$TagLocalizationCopyWithImpl<$Res, TagLocalization>;
  @useResult
  $Res call({String locale, String value});
}

/// @nodoc
class _$TagLocalizationCopyWithImpl<$Res, $Val extends TagLocalization>
    implements $TagLocalizationCopyWith<$Res> {
  _$TagLocalizationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locale = null,
    Object? value = null,
  }) {
    return _then(_value.copyWith(
      locale: null == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TagLocalizationImplCopyWith<$Res>
    implements $TagLocalizationCopyWith<$Res> {
  factory _$$TagLocalizationImplCopyWith(_$TagLocalizationImpl value,
          $Res Function(_$TagLocalizationImpl) then) =
      __$$TagLocalizationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String locale, String value});
}

/// @nodoc
class __$$TagLocalizationImplCopyWithImpl<$Res>
    extends _$TagLocalizationCopyWithImpl<$Res, _$TagLocalizationImpl>
    implements _$$TagLocalizationImplCopyWith<$Res> {
  __$$TagLocalizationImplCopyWithImpl(
      _$TagLocalizationImpl _value, $Res Function(_$TagLocalizationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? locale = null,
    Object? value = null,
  }) {
    return _then(_$TagLocalizationImpl(
      locale: null == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TagLocalizationImpl implements _TagLocalization {
  const _$TagLocalizationImpl({this.locale = '', this.value = ''});

  factory _$TagLocalizationImpl.fromJson(Map<String, dynamic> json) =>
      _$$TagLocalizationImplFromJson(json);

  @override
  @JsonKey()
  final String locale;
  @override
  @JsonKey()
  final String value;

  @override
  String toString() {
    return 'TagLocalization(locale: $locale, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TagLocalizationImpl &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, locale, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TagLocalizationImplCopyWith<_$TagLocalizationImpl> get copyWith =>
      __$$TagLocalizationImplCopyWithImpl<_$TagLocalizationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TagLocalizationImplToJson(
      this,
    );
  }
}

abstract class _TagLocalization implements TagLocalization {
  const factory _TagLocalization({final String locale, final String value}) =
      _$TagLocalizationImpl;

  factory _TagLocalization.fromJson(Map<String, dynamic> json) =
      _$TagLocalizationImpl.fromJson;

  @override
  String get locale;
  @override
  String get value;
  @override
  @JsonKey(ignore: true)
  _$$TagLocalizationImplCopyWith<_$TagLocalizationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TagTopic _$TagTopicFromJson(Map<String, dynamic> json) {
  return _TagTopic.fromJson(json);
}

/// @nodoc
mixin _$TagTopic {
  String get fallback => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: TagLocalization.fromJsonLocalizations,
      toJson: TagLocalization.toJsonLocalizations)
  List<TagLocalization> get localizations => throw _privateConstructorUsedError;
  bool get isEnabled => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TagTopicCopyWith<TagTopic> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TagTopicCopyWith<$Res> {
  factory $TagTopicCopyWith(TagTopic value, $Res Function(TagTopic) then) =
      _$TagTopicCopyWithImpl<$Res, TagTopic>;
  @useResult
  $Res call(
      {String fallback,
      @JsonKey(
          fromJson: TagLocalization.fromJsonLocalizations,
          toJson: TagLocalization.toJsonLocalizations)
      List<TagLocalization> localizations,
      bool isEnabled});
}

/// @nodoc
class _$TagTopicCopyWithImpl<$Res, $Val extends TagTopic>
    implements $TagTopicCopyWith<$Res> {
  _$TagTopicCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fallback = null,
    Object? localizations = null,
    Object? isEnabled = null,
  }) {
    return _then(_value.copyWith(
      fallback: null == fallback
          ? _value.fallback
          : fallback // ignore: cast_nullable_to_non_nullable
              as String,
      localizations: null == localizations
          ? _value.localizations
          : localizations // ignore: cast_nullable_to_non_nullable
              as List<TagLocalization>,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TagTopicImplCopyWith<$Res>
    implements $TagTopicCopyWith<$Res> {
  factory _$$TagTopicImplCopyWith(
          _$TagTopicImpl value, $Res Function(_$TagTopicImpl) then) =
      __$$TagTopicImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String fallback,
      @JsonKey(
          fromJson: TagLocalization.fromJsonLocalizations,
          toJson: TagLocalization.toJsonLocalizations)
      List<TagLocalization> localizations,
      bool isEnabled});
}

/// @nodoc
class __$$TagTopicImplCopyWithImpl<$Res>
    extends _$TagTopicCopyWithImpl<$Res, _$TagTopicImpl>
    implements _$$TagTopicImplCopyWith<$Res> {
  __$$TagTopicImplCopyWithImpl(
      _$TagTopicImpl _value, $Res Function(_$TagTopicImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fallback = null,
    Object? localizations = null,
    Object? isEnabled = null,
  }) {
    return _then(_$TagTopicImpl(
      fallback: null == fallback
          ? _value.fallback
          : fallback // ignore: cast_nullable_to_non_nullable
              as String,
      localizations: null == localizations
          ? _value._localizations
          : localizations // ignore: cast_nullable_to_non_nullable
              as List<TagLocalization>,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TagTopicImpl implements _TagTopic {
  const _$TagTopicImpl(
      {this.fallback = '',
      @JsonKey(
          fromJson: TagLocalization.fromJsonLocalizations,
          toJson: TagLocalization.toJsonLocalizations)
      final List<TagLocalization> localizations = const [],
      this.isEnabled = false})
      : _localizations = localizations;

  factory _$TagTopicImpl.fromJson(Map<String, dynamic> json) =>
      _$$TagTopicImplFromJson(json);

  @override
  @JsonKey()
  final String fallback;
  final List<TagLocalization> _localizations;
  @override
  @JsonKey(
      fromJson: TagLocalization.fromJsonLocalizations,
      toJson: TagLocalization.toJsonLocalizations)
  List<TagLocalization> get localizations {
    if (_localizations is EqualUnmodifiableListView) return _localizations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_localizations);
  }

  @override
  @JsonKey()
  final bool isEnabled;

  @override
  String toString() {
    return 'TagTopic(fallback: $fallback, localizations: $localizations, isEnabled: $isEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TagTopicImpl &&
            (identical(other.fallback, fallback) ||
                other.fallback == fallback) &&
            const DeepCollectionEquality()
                .equals(other._localizations, _localizations) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, fallback,
      const DeepCollectionEquality().hash(_localizations), isEnabled);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TagTopicImplCopyWith<_$TagTopicImpl> get copyWith =>
      __$$TagTopicImplCopyWithImpl<_$TagTopicImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TagTopicImplToJson(
      this,
    );
  }
}

abstract class _TagTopic implements TagTopic {
  const factory _TagTopic(
      {final String fallback,
      @JsonKey(
          fromJson: TagLocalization.fromJsonLocalizations,
          toJson: TagLocalization.toJsonLocalizations)
      final List<TagLocalization> localizations,
      final bool isEnabled}) = _$TagTopicImpl;

  factory _TagTopic.fromJson(Map<String, dynamic> json) =
      _$TagTopicImpl.fromJson;

  @override
  String get fallback;
  @override
  @JsonKey(
      fromJson: TagLocalization.fromJsonLocalizations,
      toJson: TagLocalization.toJsonLocalizations)
  List<TagLocalization> get localizations;
  @override
  bool get isEnabled;
  @override
  @JsonKey(ignore: true)
  _$$TagTopicImplCopyWith<_$TagTopicImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
