// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fl_meta.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FlMeta _$FlMetaFromJson(Map<String, dynamic> json) {
  return _FlMeta.fromJson(json);
}

/// @nodoc
mixin _$FlMeta {
  String? get createdBy => throw _privateConstructorUsedError;
  @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown)
  String? get createdDate => throw _privateConstructorUsedError;
  String? get ownedBy => throw _privateConstructorUsedError;
  @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown)
  String? get ownedAsOfDate => throw _privateConstructorUsedError;
  String get directoryEntryId => throw _privateConstructorUsedError;
  String? get lastModifiedBy => throw _privateConstructorUsedError;
  @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown)
  String? get lastModifiedDate => throw _privateConstructorUsedError;
  int get lastFetchMillis => throw _privateConstructorUsedError;
  bool get isPartial => throw _privateConstructorUsedError;
  String? get docId => throw _privateConstructorUsedError;
  @JsonKey(name: 'fl_id')
  String? get id => throw _privateConstructorUsedError;
  String? get env => throw _privateConstructorUsedError;
  String? get locale => throw _privateConstructorUsedError;
  String? get schema => throw _privateConstructorUsedError;
  String? get schemaRefId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FlMetaCopyWith<FlMeta> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FlMetaCopyWith<$Res> {
  factory $FlMetaCopyWith(FlMeta value, $Res Function(FlMeta) then) =
      _$FlMetaCopyWithImpl<$Res, FlMeta>;
  @useResult
  $Res call(
      {String? createdBy,
      @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown)
      String? createdDate,
      String? ownedBy,
      @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown)
      String? ownedAsOfDate,
      String directoryEntryId,
      String? lastModifiedBy,
      @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown)
      String? lastModifiedDate,
      int lastFetchMillis,
      bool isPartial,
      String? docId,
      @JsonKey(name: 'fl_id') String? id,
      String? env,
      String? locale,
      String? schema,
      String? schemaRefId});
}

/// @nodoc
class _$FlMetaCopyWithImpl<$Res, $Val extends FlMeta>
    implements $FlMetaCopyWith<$Res> {
  _$FlMetaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdBy = freezed,
    Object? createdDate = freezed,
    Object? ownedBy = freezed,
    Object? ownedAsOfDate = freezed,
    Object? directoryEntryId = null,
    Object? lastModifiedBy = freezed,
    Object? lastModifiedDate = freezed,
    Object? lastFetchMillis = null,
    Object? isPartial = null,
    Object? docId = freezed,
    Object? id = freezed,
    Object? env = freezed,
    Object? locale = freezed,
    Object? schema = freezed,
    Object? schemaRefId = freezed,
  }) {
    return _then(_value.copyWith(
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdDate: freezed == createdDate
          ? _value.createdDate
          : createdDate // ignore: cast_nullable_to_non_nullable
              as String?,
      ownedBy: freezed == ownedBy
          ? _value.ownedBy
          : ownedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      ownedAsOfDate: freezed == ownedAsOfDate
          ? _value.ownedAsOfDate
          : ownedAsOfDate // ignore: cast_nullable_to_non_nullable
              as String?,
      directoryEntryId: null == directoryEntryId
          ? _value.directoryEntryId
          : directoryEntryId // ignore: cast_nullable_to_non_nullable
              as String,
      lastModifiedBy: freezed == lastModifiedBy
          ? _value.lastModifiedBy
          : lastModifiedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      lastModifiedDate: freezed == lastModifiedDate
          ? _value.lastModifiedDate
          : lastModifiedDate // ignore: cast_nullable_to_non_nullable
              as String?,
      lastFetchMillis: null == lastFetchMillis
          ? _value.lastFetchMillis
          : lastFetchMillis // ignore: cast_nullable_to_non_nullable
              as int,
      isPartial: null == isPartial
          ? _value.isPartial
          : isPartial // ignore: cast_nullable_to_non_nullable
              as bool,
      docId: freezed == docId
          ? _value.docId
          : docId // ignore: cast_nullable_to_non_nullable
              as String?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      env: freezed == env
          ? _value.env
          : env // ignore: cast_nullable_to_non_nullable
              as String?,
      locale: freezed == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String?,
      schema: freezed == schema
          ? _value.schema
          : schema // ignore: cast_nullable_to_non_nullable
              as String?,
      schemaRefId: freezed == schemaRefId
          ? _value.schemaRefId
          : schemaRefId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FlMetaImplCopyWith<$Res> implements $FlMetaCopyWith<$Res> {
  factory _$$FlMetaImplCopyWith(
          _$FlMetaImpl value, $Res Function(_$FlMetaImpl) then) =
      __$$FlMetaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? createdBy,
      @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown)
      String? createdDate,
      String? ownedBy,
      @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown)
      String? ownedAsOfDate,
      String directoryEntryId,
      String? lastModifiedBy,
      @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown)
      String? lastModifiedDate,
      int lastFetchMillis,
      bool isPartial,
      String? docId,
      @JsonKey(name: 'fl_id') String? id,
      String? env,
      String? locale,
      String? schema,
      String? schemaRefId});
}

/// @nodoc
class __$$FlMetaImplCopyWithImpl<$Res>
    extends _$FlMetaCopyWithImpl<$Res, _$FlMetaImpl>
    implements _$$FlMetaImplCopyWith<$Res> {
  __$$FlMetaImplCopyWithImpl(
      _$FlMetaImpl _value, $Res Function(_$FlMetaImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdBy = freezed,
    Object? createdDate = freezed,
    Object? ownedBy = freezed,
    Object? ownedAsOfDate = freezed,
    Object? directoryEntryId = null,
    Object? lastModifiedBy = freezed,
    Object? lastModifiedDate = freezed,
    Object? lastFetchMillis = null,
    Object? isPartial = null,
    Object? docId = freezed,
    Object? id = freezed,
    Object? env = freezed,
    Object? locale = freezed,
    Object? schema = freezed,
    Object? schemaRefId = freezed,
  }) {
    return _then(_$FlMetaImpl(
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      createdDate: freezed == createdDate
          ? _value.createdDate
          : createdDate // ignore: cast_nullable_to_non_nullable
              as String?,
      ownedBy: freezed == ownedBy
          ? _value.ownedBy
          : ownedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      ownedAsOfDate: freezed == ownedAsOfDate
          ? _value.ownedAsOfDate
          : ownedAsOfDate // ignore: cast_nullable_to_non_nullable
              as String?,
      directoryEntryId: null == directoryEntryId
          ? _value.directoryEntryId
          : directoryEntryId // ignore: cast_nullable_to_non_nullable
              as String,
      lastModifiedBy: freezed == lastModifiedBy
          ? _value.lastModifiedBy
          : lastModifiedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      lastModifiedDate: freezed == lastModifiedDate
          ? _value.lastModifiedDate
          : lastModifiedDate // ignore: cast_nullable_to_non_nullable
              as String?,
      lastFetchMillis: null == lastFetchMillis
          ? _value.lastFetchMillis
          : lastFetchMillis // ignore: cast_nullable_to_non_nullable
              as int,
      isPartial: null == isPartial
          ? _value.isPartial
          : isPartial // ignore: cast_nullable_to_non_nullable
              as bool,
      docId: freezed == docId
          ? _value.docId
          : docId // ignore: cast_nullable_to_non_nullable
              as String?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      env: freezed == env
          ? _value.env
          : env // ignore: cast_nullable_to_non_nullable
              as String?,
      locale: freezed == locale
          ? _value.locale
          : locale // ignore: cast_nullable_to_non_nullable
              as String?,
      schema: freezed == schema
          ? _value.schema
          : schema // ignore: cast_nullable_to_non_nullable
              as String?,
      schemaRefId: freezed == schemaRefId
          ? _value.schemaRefId
          : schemaRefId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FlMetaImpl implements _FlMeta {
  const _$FlMetaImpl(
      {this.createdBy,
      @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown)
      this.createdDate,
      this.ownedBy,
      @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown)
      this.ownedAsOfDate,
      this.directoryEntryId = '',
      this.lastModifiedBy,
      @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown)
      this.lastModifiedDate,
      this.lastFetchMillis = -1,
      this.isPartial = false,
      this.docId,
      @JsonKey(name: 'fl_id') this.id,
      this.env = '',
      this.locale = 'en',
      this.schema = '',
      this.schemaRefId});

  factory _$FlMetaImpl.fromJson(Map<String, dynamic> json) =>
      _$$FlMetaImplFromJson(json);

  @override
  final String? createdBy;
  @override
  @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown)
  final String? createdDate;
  @override
  final String? ownedBy;
  @override
  @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown)
  final String? ownedAsOfDate;
  @override
  @JsonKey()
  final String directoryEntryId;
  @override
  final String? lastModifiedBy;
  @override
  @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown)
  final String? lastModifiedDate;
  @override
  @JsonKey()
  final int lastFetchMillis;
  @override
  @JsonKey()
  final bool isPartial;
  @override
  final String? docId;
  @override
  @JsonKey(name: 'fl_id')
  final String? id;
  @override
  @JsonKey()
  final String? env;
  @override
  @JsonKey()
  final String? locale;
  @override
  @JsonKey()
  final String? schema;
  @override
  final String? schemaRefId;

  @override
  String toString() {
    return 'FlMeta(createdBy: $createdBy, createdDate: $createdDate, ownedBy: $ownedBy, ownedAsOfDate: $ownedAsOfDate, directoryEntryId: $directoryEntryId, lastModifiedBy: $lastModifiedBy, lastModifiedDate: $lastModifiedDate, lastFetchMillis: $lastFetchMillis, isPartial: $isPartial, docId: $docId, id: $id, env: $env, locale: $locale, schema: $schema, schemaRefId: $schemaRefId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FlMetaImpl &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdDate, createdDate) ||
                other.createdDate == createdDate) &&
            (identical(other.ownedBy, ownedBy) || other.ownedBy == ownedBy) &&
            (identical(other.ownedAsOfDate, ownedAsOfDate) ||
                other.ownedAsOfDate == ownedAsOfDate) &&
            (identical(other.directoryEntryId, directoryEntryId) ||
                other.directoryEntryId == directoryEntryId) &&
            (identical(other.lastModifiedBy, lastModifiedBy) ||
                other.lastModifiedBy == lastModifiedBy) &&
            (identical(other.lastModifiedDate, lastModifiedDate) ||
                other.lastModifiedDate == lastModifiedDate) &&
            (identical(other.lastFetchMillis, lastFetchMillis) ||
                other.lastFetchMillis == lastFetchMillis) &&
            (identical(other.isPartial, isPartial) ||
                other.isPartial == isPartial) &&
            (identical(other.docId, docId) || other.docId == docId) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.env, env) || other.env == env) &&
            (identical(other.locale, locale) || other.locale == locale) &&
            (identical(other.schema, schema) || other.schema == schema) &&
            (identical(other.schemaRefId, schemaRefId) ||
                other.schemaRefId == schemaRefId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      createdBy,
      createdDate,
      ownedBy,
      ownedAsOfDate,
      directoryEntryId,
      lastModifiedBy,
      lastModifiedDate,
      lastFetchMillis,
      isPartial,
      docId,
      id,
      env,
      locale,
      schema,
      schemaRefId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FlMetaImplCopyWith<_$FlMetaImpl> get copyWith =>
      __$$FlMetaImplCopyWithImpl<_$FlMetaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FlMetaImplToJson(
      this,
    );
  }
}

abstract class _FlMeta implements FlMeta {
  const factory _FlMeta(
      {final String? createdBy,
      @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown)
      final String? createdDate,
      final String? ownedBy,
      @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown)
      final String? ownedAsOfDate,
      final String directoryEntryId,
      final String? lastModifiedBy,
      @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown)
      final String? lastModifiedDate,
      final int lastFetchMillis,
      final bool isPartial,
      final String? docId,
      @JsonKey(name: 'fl_id') final String? id,
      final String? env,
      final String? locale,
      final String? schema,
      final String? schemaRefId}) = _$FlMetaImpl;

  factory _FlMeta.fromJson(Map<String, dynamic> json) = _$FlMetaImpl.fromJson;

  @override
  String? get createdBy;
  @override
  @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown)
  String? get createdDate;
  @override
  String? get ownedBy;
  @override
  @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown)
  String? get ownedAsOfDate;
  @override
  String get directoryEntryId;
  @override
  String? get lastModifiedBy;
  @override
  @JsonKey(fromJson: dateFromUnknown, toJson: dateToUnknown)
  String? get lastModifiedDate;
  @override
  int get lastFetchMillis;
  @override
  bool get isPartial;
  @override
  String? get docId;
  @override
  @JsonKey(name: 'fl_id')
  String? get id;
  @override
  String? get env;
  @override
  String? get locale;
  @override
  String? get schema;
  @override
  String? get schemaRefId;
  @override
  @JsonKey(ignore: true)
  _$$FlMetaImplCopyWith<_$FlMetaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
