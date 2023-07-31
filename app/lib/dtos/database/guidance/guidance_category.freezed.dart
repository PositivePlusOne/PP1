// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'guidance_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

GuidanceCategory _$GuidanceCategoryFromJson(Map<String, dynamic> json) {
  return _GuidanceCategory.fromJson(json);
}

/// @nodoc
mixin _$GuidanceCategory {
  @JsonKey(name: 'id')
  String get documentId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  String get locale => throw _privateConstructorUsedError;
  @JsonKey(fromJson: firestoreDocRefFromJson, toJson: firestoreDocRefToJson)
  DocumentReference<Object?>? get parent => throw _privateConstructorUsedError;
  int get priority => throw _privateConstructorUsedError;
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GuidanceCategoryCopyWith<GuidanceCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GuidanceCategoryCopyWith<$Res> {
  factory $GuidanceCategoryCopyWith(
          GuidanceCategory value, $Res Function(GuidanceCategory) then) =
      _$GuidanceCategoryCopyWithImpl<$Res, GuidanceCategory>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String documentId,
      String title,
      String body,
      String locale,
      @JsonKey(fromJson: firestoreDocRefFromJson, toJson: firestoreDocRefToJson)
      DocumentReference<Object?>? parent,
      int priority,
      @JsonKey(name: '_fl_meta_') FlMeta? flMeta});

  $FlMetaCopyWith<$Res>? get flMeta;
}

/// @nodoc
class _$GuidanceCategoryCopyWithImpl<$Res, $Val extends GuidanceCategory>
    implements $GuidanceCategoryCopyWith<$Res> {
  _$GuidanceCategoryCopyWithImpl(this._value, this._then);

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
    Object? parent = freezed,
    Object? priority = null,
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
      parent: freezed == parent
          ? _value.parent
          : parent // ignore: cast_nullable_to_non_nullable
              as DocumentReference<Object?>?,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
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
abstract class _$$_GuidanceCategoryCopyWith<$Res>
    implements $GuidanceCategoryCopyWith<$Res> {
  factory _$$_GuidanceCategoryCopyWith(
          _$_GuidanceCategory value, $Res Function(_$_GuidanceCategory) then) =
      __$$_GuidanceCategoryCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String documentId,
      String title,
      String body,
      String locale,
      @JsonKey(fromJson: firestoreDocRefFromJson, toJson: firestoreDocRefToJson)
      DocumentReference<Object?>? parent,
      int priority,
      @JsonKey(name: '_fl_meta_') FlMeta? flMeta});

  @override
  $FlMetaCopyWith<$Res>? get flMeta;
}

/// @nodoc
class __$$_GuidanceCategoryCopyWithImpl<$Res>
    extends _$GuidanceCategoryCopyWithImpl<$Res, _$_GuidanceCategory>
    implements _$$_GuidanceCategoryCopyWith<$Res> {
  __$$_GuidanceCategoryCopyWithImpl(
      _$_GuidanceCategory _value, $Res Function(_$_GuidanceCategory) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? documentId = null,
    Object? title = null,
    Object? body = null,
    Object? locale = null,
    Object? parent = freezed,
    Object? priority = null,
    Object? flMeta = freezed,
  }) {
    return _then(_$_GuidanceCategory(
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
      parent: freezed == parent
          ? _value.parent
          : parent // ignore: cast_nullable_to_non_nullable
              as DocumentReference<Object?>?,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_GuidanceCategory implements _GuidanceCategory {
  const _$_GuidanceCategory(
      {@JsonKey(name: 'id') required this.documentId,
      this.title = '',
      this.body = '',
      this.locale = 'en',
      @JsonKey(fromJson: firestoreDocRefFromJson, toJson: firestoreDocRefToJson)
      this.parent = null,
      this.priority = 0,
      @JsonKey(name: '_fl_meta_') this.flMeta});

  factory _$_GuidanceCategory.fromJson(Map<String, dynamic> json) =>
      _$$_GuidanceCategoryFromJson(json);

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
  @JsonKey(fromJson: firestoreDocRefFromJson, toJson: firestoreDocRefToJson)
  final DocumentReference<Object?>? parent;
  @override
  @JsonKey()
  final int priority;
  @override
  @JsonKey(name: '_fl_meta_')
  final FlMeta? flMeta;

  @override
  String toString() {
    return 'GuidanceCategory(documentId: $documentId, title: $title, body: $body, locale: $locale, parent: $parent, priority: $priority, flMeta: $flMeta)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GuidanceCategory &&
            (identical(other.documentId, documentId) ||
                other.documentId == documentId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.parent, parent) || other.parent == parent) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.flMeta, flMeta) || other.flMeta == flMeta));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, documentId, title, body, locale, parent, priority, flMeta);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GuidanceCategoryCopyWith<_$_GuidanceCategory> get copyWith =>
      __$$_GuidanceCategoryCopyWithImpl<_$_GuidanceCategory>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_GuidanceCategoryToJson(
      this,
    );
  }
}

abstract class _GuidanceCategory implements GuidanceCategory {
  const factory _GuidanceCategory(
      {@JsonKey(name: 'id') required final String documentId,
      final String title,
      final String body,
      final String locale,
      @JsonKey(fromJson: firestoreDocRefFromJson, toJson: firestoreDocRefToJson)
      final DocumentReference<Object?>? parent,
      final int priority,
      @JsonKey(name: '_fl_meta_') final FlMeta? flMeta}) = _$_GuidanceCategory;

  factory _GuidanceCategory.fromJson(Map<String, dynamic> json) =
      _$_GuidanceCategory.fromJson;

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
  @JsonKey(fromJson: firestoreDocRefFromJson, toJson: firestoreDocRefToJson)
  DocumentReference<Object?>? get parent;
  @override
  int get priority;
  @override
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta;
  @override
  @JsonKey(ignore: true)
  _$$_GuidanceCategoryCopyWith<_$_GuidanceCategory> get copyWith =>
      throw _privateConstructorUsedError;
}
