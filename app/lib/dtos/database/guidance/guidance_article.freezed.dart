// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'guidance_article.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

GuidanceArticle _$GuidanceArticleFromJson(Map<String, dynamic> json) {
  return _GuidanceArticle.fromJson(json);
}

/// @nodoc
mixin _$GuidanceArticle {
  @JsonKey(name: 'id')
  String get documentId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  String get locale => throw _privateConstructorUsedError;
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GuidanceArticleCopyWith<GuidanceArticle> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GuidanceArticleCopyWith<$Res> {
  factory $GuidanceArticleCopyWith(
          GuidanceArticle value, $Res Function(GuidanceArticle) then) =
      _$GuidanceArticleCopyWithImpl<$Res, GuidanceArticle>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String documentId,
      String title,
      String body,
      String locale,
      @JsonKey(name: '_fl_meta_') FlMeta? flMeta});

  $FlMetaCopyWith<$Res>? get flMeta;
}

/// @nodoc
class _$GuidanceArticleCopyWithImpl<$Res, $Val extends GuidanceArticle>
    implements $GuidanceArticleCopyWith<$Res> {
  _$GuidanceArticleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? documentId = null,
    Object? title = null,
    Object? body = null,
    Object? locale = null,
    Object? flMeta = freezed,
  }) {
    return _then(_value.copyWith(
      documentId: null == documentId
          ? _value.documentId
          : documentId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      locale: null == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String,
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
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
}

/// @nodoc
abstract class _$$GuidanceArticleImplCopyWith<$Res>
    implements $GuidanceArticleCopyWith<$Res> {
  factory _$$GuidanceArticleImplCopyWith(_$GuidanceArticleImpl value,
          $Res Function(_$GuidanceArticleImpl) then) =
      __$$GuidanceArticleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String documentId,
      String title,
      String body,
      String locale,
      @JsonKey(name: '_fl_meta_') FlMeta? flMeta});

  @override
  $FlMetaCopyWith<$Res>? get flMeta;
}

/// @nodoc
class __$$GuidanceArticleImplCopyWithImpl<$Res>
    extends _$GuidanceArticleCopyWithImpl<$Res, _$GuidanceArticleImpl>
    implements _$$GuidanceArticleImplCopyWith<$Res> {
  __$$GuidanceArticleImplCopyWithImpl(
      _$GuidanceArticleImpl _value, $Res Function(_$GuidanceArticleImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? documentId = null,
    Object? title = null,
    Object? body = null,
    Object? locale = null,
    Object? flMeta = freezed,
  }) {
    return _then(_$GuidanceArticleImpl(
      documentId: null == documentId
          ? _value.documentId
          : documentId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      locale: null == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String,
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GuidanceArticleImpl implements _GuidanceArticle {
  const _$GuidanceArticleImpl(
      {@JsonKey(name: 'id') required this.documentId,
      this.title = '',
      this.body = '',
      this.locale = 'en',
      @JsonKey(name: '_fl_meta_') this.flMeta});

  factory _$GuidanceArticleImpl.fromJson(Map<String, dynamic> json) =>
      _$$GuidanceArticleImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String documentId;
  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String body;
  @override
  @JsonKey()
  final String locale;
  @override
  @JsonKey(name: '_fl_meta_')
  final FlMeta? flMeta;

  @override
  String toString() {
    return 'GuidanceArticle(documentId: $documentId, title: $title, body: $body, locale: $locale, flMeta: $flMeta)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GuidanceArticleImpl &&
            (identical(other.documentId, documentId) ||
                other.documentId == documentId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.flMeta, flMeta) || other.flMeta == flMeta));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, documentId, title, body, locale, flMeta);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GuidanceArticleImplCopyWith<_$GuidanceArticleImpl> get copyWith =>
      __$$GuidanceArticleImplCopyWithImpl<_$GuidanceArticleImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GuidanceArticleImplToJson(
      this,
    );
  }
}

abstract class _GuidanceArticle implements GuidanceArticle {
  const factory _GuidanceArticle(
          {@JsonKey(name: 'id') required final String documentId,
          final String title,
          final String body,
          final String locale,
          @JsonKey(name: '_fl_meta_') final FlMeta? flMeta}) =
      _$GuidanceArticleImpl;

  factory _GuidanceArticle.fromJson(Map<String, dynamic> json) =
      _$GuidanceArticleImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  String get documentId;
  @override
  String get title;
  @override
  String get body;
  @override
  String get locale;
  @override
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta;
  @override
  @JsonKey(ignore: true)
  _$$GuidanceArticleImplCopyWith<_$GuidanceArticleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
