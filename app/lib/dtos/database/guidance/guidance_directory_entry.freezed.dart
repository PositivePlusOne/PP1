// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'guidance_directory_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

GuidanceDirectoryEntry _$GuidanceDirectoryEntryFromJson(
    Map<String, dynamic> json) {
  return _GuidanceDirectoryEntry.fromJson(json);
}

/// @nodoc
mixin _$GuidanceDirectoryEntry {
  @JsonKey(name: 'id')
  String get documentId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get blurb => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  String get logoUrl => throw _privateConstructorUsedError;
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GuidanceDirectoryEntryCopyWith<GuidanceDirectoryEntry> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GuidanceDirectoryEntryCopyWith<$Res> {
  factory $GuidanceDirectoryEntryCopyWith(GuidanceDirectoryEntry value,
          $Res Function(GuidanceDirectoryEntry) then) =
      _$GuidanceDirectoryEntryCopyWithImpl<$Res, GuidanceDirectoryEntry>;
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String documentId,
      String title,
      String blurb,
      String body,
      String logoUrl,
      @JsonKey(name: '_fl_meta_') FlMeta? flMeta});

  $FlMetaCopyWith<$Res>? get flMeta;
}

/// @nodoc
class _$GuidanceDirectoryEntryCopyWithImpl<$Res,
        $Val extends GuidanceDirectoryEntry>
    implements $GuidanceDirectoryEntryCopyWith<$Res> {
  _$GuidanceDirectoryEntryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? documentId = null,
    Object? title = null,
    Object? blurb = null,
    Object? body = null,
    Object? logoUrl = null,
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
      blurb: null == blurb
          ? _value.blurb
          : blurb // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      logoUrl: null == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
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
abstract class _$$_GuidanceDirectoryEntryCopyWith<$Res>
    implements $GuidanceDirectoryEntryCopyWith<$Res> {
  factory _$$_GuidanceDirectoryEntryCopyWith(_$_GuidanceDirectoryEntry value,
          $Res Function(_$_GuidanceDirectoryEntry) then) =
      __$$_GuidanceDirectoryEntryCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'id') String documentId,
      String title,
      String blurb,
      String body,
      String logoUrl,
      @JsonKey(name: '_fl_meta_') FlMeta? flMeta});

  @override
  $FlMetaCopyWith<$Res>? get flMeta;
}

/// @nodoc
class __$$_GuidanceDirectoryEntryCopyWithImpl<$Res>
    extends _$GuidanceDirectoryEntryCopyWithImpl<$Res,
        _$_GuidanceDirectoryEntry>
    implements _$$_GuidanceDirectoryEntryCopyWith<$Res> {
  __$$_GuidanceDirectoryEntryCopyWithImpl(_$_GuidanceDirectoryEntry _value,
      $Res Function(_$_GuidanceDirectoryEntry) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? documentId = null,
    Object? title = null,
    Object? blurb = null,
    Object? body = null,
    Object? logoUrl = null,
    Object? flMeta = freezed,
  }) {
    return _then(_$_GuidanceDirectoryEntry(
      documentId: null == documentId
          ? _value.documentId
          : documentId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      blurb: null == blurb
          ? _value.blurb
          : blurb // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      logoUrl: null == logoUrl
          ? _value.logoUrl
          : logoUrl // ignore: cast_nullable_to_non_nullable
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
class _$_GuidanceDirectoryEntry implements _GuidanceDirectoryEntry {
  const _$_GuidanceDirectoryEntry(
      {@JsonKey(name: 'id') required this.documentId,
      this.title = '',
      this.blurb = '',
      this.body = '',
      this.logoUrl = '',
      @JsonKey(name: '_fl_meta_') this.flMeta});

  factory _$_GuidanceDirectoryEntry.fromJson(Map<String, dynamic> json) =>
      _$$_GuidanceDirectoryEntryFromJson(json);

  @override
  @JsonKey(name: 'id')
  final String documentId;
  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String blurb;
  @override
  @JsonKey()
  final String body;
  @override
  @JsonKey()
  final String logoUrl;
  @override
  @JsonKey(name: '_fl_meta_')
  final FlMeta? flMeta;

  @override
  String toString() {
    return 'GuidanceDirectoryEntry(documentId: $documentId, title: $title, blurb: $blurb, body: $body, logoUrl: $logoUrl, flMeta: $flMeta)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GuidanceDirectoryEntry &&
            (identical(other.documentId, documentId) ||
                other.documentId == documentId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.blurb, blurb) || other.blurb == blurb) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl) &&
            (identical(other.flMeta, flMeta) || other.flMeta == flMeta));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, documentId, title, blurb, body, logoUrl, flMeta);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GuidanceDirectoryEntryCopyWith<_$_GuidanceDirectoryEntry> get copyWith =>
      __$$_GuidanceDirectoryEntryCopyWithImpl<_$_GuidanceDirectoryEntry>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_GuidanceDirectoryEntryToJson(
      this,
    );
  }
}

abstract class _GuidanceDirectoryEntry implements GuidanceDirectoryEntry {
  const factory _GuidanceDirectoryEntry(
          {@JsonKey(name: 'id') required final String documentId,
          final String title,
          final String blurb,
          final String body,
          final String logoUrl,
          @JsonKey(name: '_fl_meta_') final FlMeta? flMeta}) =
      _$_GuidanceDirectoryEntry;

  factory _GuidanceDirectoryEntry.fromJson(Map<String, dynamic> json) =
      _$_GuidanceDirectoryEntry.fromJson;

  @override
  @JsonKey(name: 'id')
  String get documentId;
  @override
  String get title;
  @override
  String get blurb;
  @override
  String get body;
  @override
  String get logoUrl;
  @override
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta;
  @override
  @JsonKey(ignore: true)
  _$$_GuidanceDirectoryEntryCopyWith<_$_GuidanceDirectoryEntry> get copyWith =>
      throw _privateConstructorUsedError;
}
