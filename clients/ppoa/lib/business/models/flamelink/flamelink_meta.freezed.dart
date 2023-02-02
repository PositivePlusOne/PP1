// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flamelink_meta.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FlamelinkMeta _$FlamelinkMetaFromJson(Map<String, dynamic> json) {
  return _FlamelinkMeta.fromJson(json);
}

/// @nodoc
mixin _$FlamelinkMeta {
  String get createdBy => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: firestoreTimestampFromJson, toJson: firestoreTimestampToJson)
  Timestamp get timestamp => throw _privateConstructorUsedError;
  @JsonKey(name: 'docId')
  String get documentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'fl_id')
  String get flamelinkId => throw _privateConstructorUsedError;
  @JsonKey(name: 'env')
  String get environment => throw _privateConstructorUsedError;
  String get lastModifiedBy => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: firestoreTimestampFromJson, toJson: firestoreTimestampToJson)
  Timestamp get lastModifiedDate => throw _privateConstructorUsedError;
  String get schema => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'schemaRef',
      toJson: firestoreDocRefToJson,
      fromJson: firestoreDocRefFromJson)
  DocumentReference<Object?> get schemaReference =>
      throw _privateConstructorUsedError;
  String get schemaType => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FlamelinkMetaCopyWith<FlamelinkMeta> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FlamelinkMetaCopyWith<$Res> {
  factory $FlamelinkMetaCopyWith(
          FlamelinkMeta value, $Res Function(FlamelinkMeta) then) =
      _$FlamelinkMetaCopyWithImpl<$Res, FlamelinkMeta>;
  @useResult
  $Res call(
      {String createdBy,
      @JsonKey(fromJson: firestoreTimestampFromJson, toJson: firestoreTimestampToJson)
          Timestamp timestamp,
      @JsonKey(name: 'docId')
          String documentId,
      @JsonKey(name: 'fl_id')
          String flamelinkId,
      @JsonKey(name: 'env')
          String environment,
      String lastModifiedBy,
      @JsonKey(fromJson: firestoreTimestampFromJson, toJson: firestoreTimestampToJson)
          Timestamp lastModifiedDate,
      String schema,
      @JsonKey(name: 'schemaRef', toJson: firestoreDocRefToJson, fromJson: firestoreDocRefFromJson)
          DocumentReference<Object?> schemaReference,
      String schemaType,
      String status});
}

/// @nodoc
class _$FlamelinkMetaCopyWithImpl<$Res, $Val extends FlamelinkMeta>
    implements $FlamelinkMetaCopyWith<$Res> {
  _$FlamelinkMetaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdBy = null,
    Object? timestamp = null,
    Object? documentId = null,
    Object? flamelinkId = null,
    Object? environment = null,
    Object? lastModifiedBy = null,
    Object? lastModifiedDate = null,
    Object? schema = null,
    Object? schemaReference = null,
    Object? schemaType = null,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as Timestamp,
      documentId: null == documentId
          ? _value.documentId
          : documentId // ignore: cast_nullable_to_non_nullable
              as String,
      flamelinkId: null == flamelinkId
          ? _value.flamelinkId
          : flamelinkId // ignore: cast_nullable_to_non_nullable
              as String,
      environment: null == environment
          ? _value.environment
          : environment // ignore: cast_nullable_to_non_nullable
              as String,
      lastModifiedBy: null == lastModifiedBy
          ? _value.lastModifiedBy
          : lastModifiedBy // ignore: cast_nullable_to_non_nullable
              as String,
      lastModifiedDate: null == lastModifiedDate
          ? _value.lastModifiedDate
          : lastModifiedDate // ignore: cast_nullable_to_non_nullable
              as Timestamp,
      schema: null == schema
          ? _value.schema
          : schema // ignore: cast_nullable_to_non_nullable
              as String,
      schemaReference: null == schemaReference
          ? _value.schemaReference
          : schemaReference // ignore: cast_nullable_to_non_nullable
              as DocumentReference<Object?>,
      schemaType: null == schemaType
          ? _value.schemaType
          : schemaType // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_FlamelinkMetaCopyWith<$Res>
    implements $FlamelinkMetaCopyWith<$Res> {
  factory _$$_FlamelinkMetaCopyWith(
          _$_FlamelinkMeta value, $Res Function(_$_FlamelinkMeta) then) =
      __$$_FlamelinkMetaCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String createdBy,
      @JsonKey(fromJson: firestoreTimestampFromJson, toJson: firestoreTimestampToJson)
          Timestamp timestamp,
      @JsonKey(name: 'docId')
          String documentId,
      @JsonKey(name: 'fl_id')
          String flamelinkId,
      @JsonKey(name: 'env')
          String environment,
      String lastModifiedBy,
      @JsonKey(fromJson: firestoreTimestampFromJson, toJson: firestoreTimestampToJson)
          Timestamp lastModifiedDate,
      String schema,
      @JsonKey(name: 'schemaRef', toJson: firestoreDocRefToJson, fromJson: firestoreDocRefFromJson)
          DocumentReference<Object?> schemaReference,
      String schemaType,
      String status});
}

/// @nodoc
class __$$_FlamelinkMetaCopyWithImpl<$Res>
    extends _$FlamelinkMetaCopyWithImpl<$Res, _$_FlamelinkMeta>
    implements _$$_FlamelinkMetaCopyWith<$Res> {
  __$$_FlamelinkMetaCopyWithImpl(
      _$_FlamelinkMeta _value, $Res Function(_$_FlamelinkMeta) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdBy = null,
    Object? timestamp = null,
    Object? documentId = null,
    Object? flamelinkId = null,
    Object? environment = null,
    Object? lastModifiedBy = null,
    Object? lastModifiedDate = null,
    Object? schema = null,
    Object? schemaReference = null,
    Object? schemaType = null,
    Object? status = null,
  }) {
    return _then(_$_FlamelinkMeta(
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as Timestamp,
      documentId: null == documentId
          ? _value.documentId
          : documentId // ignore: cast_nullable_to_non_nullable
              as String,
      flamelinkId: null == flamelinkId
          ? _value.flamelinkId
          : flamelinkId // ignore: cast_nullable_to_non_nullable
              as String,
      environment: null == environment
          ? _value.environment
          : environment // ignore: cast_nullable_to_non_nullable
              as String,
      lastModifiedBy: null == lastModifiedBy
          ? _value.lastModifiedBy
          : lastModifiedBy // ignore: cast_nullable_to_non_nullable
              as String,
      lastModifiedDate: null == lastModifiedDate
          ? _value.lastModifiedDate
          : lastModifiedDate // ignore: cast_nullable_to_non_nullable
              as Timestamp,
      schema: null == schema
          ? _value.schema
          : schema // ignore: cast_nullable_to_non_nullable
              as String,
      schemaReference: null == schemaReference
          ? _value.schemaReference
          : schemaReference // ignore: cast_nullable_to_non_nullable
              as DocumentReference<Object?>,
      schemaType: null == schemaType
          ? _value.schemaType
          : schemaType // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$_FlamelinkMeta implements _FlamelinkMeta {
  const _$_FlamelinkMeta(
      {required this.createdBy,
      @JsonKey(fromJson: firestoreTimestampFromJson, toJson: firestoreTimestampToJson)
          required this.timestamp,
      @JsonKey(name: 'docId')
          required this.documentId,
      @JsonKey(name: 'fl_id')
          required this.flamelinkId,
      @JsonKey(name: 'env')
          required this.environment,
      required this.lastModifiedBy,
      @JsonKey(fromJson: firestoreTimestampFromJson, toJson: firestoreTimestampToJson)
          required this.lastModifiedDate,
      required this.schema,
      @JsonKey(name: 'schemaRef', toJson: firestoreDocRefToJson, fromJson: firestoreDocRefFromJson)
          required this.schemaReference,
      required this.schemaType,
      required this.status});

  factory _$_FlamelinkMeta.fromJson(Map<String, dynamic> json) =>
      _$$_FlamelinkMetaFromJson(json);

  @override
  final String createdBy;
  @override
  @JsonKey(
      fromJson: firestoreTimestampFromJson, toJson: firestoreTimestampToJson)
  final Timestamp timestamp;
  @override
  @JsonKey(name: 'docId')
  final String documentId;
  @override
  @JsonKey(name: 'fl_id')
  final String flamelinkId;
  @override
  @JsonKey(name: 'env')
  final String environment;
  @override
  final String lastModifiedBy;
  @override
  @JsonKey(
      fromJson: firestoreTimestampFromJson, toJson: firestoreTimestampToJson)
  final Timestamp lastModifiedDate;
  @override
  final String schema;
  @override
  @JsonKey(
      name: 'schemaRef',
      toJson: firestoreDocRefToJson,
      fromJson: firestoreDocRefFromJson)
  final DocumentReference<Object?> schemaReference;
  @override
  final String schemaType;
  @override
  final String status;

  @override
  String toString() {
    return 'FlamelinkMeta(createdBy: $createdBy, timestamp: $timestamp, documentId: $documentId, flamelinkId: $flamelinkId, environment: $environment, lastModifiedBy: $lastModifiedBy, lastModifiedDate: $lastModifiedDate, schema: $schema, schemaReference: $schemaReference, schemaType: $schemaType, status: $status)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FlamelinkMeta &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.documentId, documentId) ||
                other.documentId == documentId) &&
            (identical(other.flamelinkId, flamelinkId) ||
                other.flamelinkId == flamelinkId) &&
            (identical(other.environment, environment) ||
                other.environment == environment) &&
            (identical(other.lastModifiedBy, lastModifiedBy) ||
                other.lastModifiedBy == lastModifiedBy) &&
            (identical(other.lastModifiedDate, lastModifiedDate) ||
                other.lastModifiedDate == lastModifiedDate) &&
            (identical(other.schema, schema) || other.schema == schema) &&
            (identical(other.schemaReference, schemaReference) ||
                other.schemaReference == schemaReference) &&
            (identical(other.schemaType, schemaType) ||
                other.schemaType == schemaType) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      createdBy,
      timestamp,
      documentId,
      flamelinkId,
      environment,
      lastModifiedBy,
      lastModifiedDate,
      schema,
      schemaReference,
      schemaType,
      status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FlamelinkMetaCopyWith<_$_FlamelinkMeta> get copyWith =>
      __$$_FlamelinkMetaCopyWithImpl<_$_FlamelinkMeta>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FlamelinkMetaToJson(
      this,
    );
  }
}

abstract class _FlamelinkMeta implements FlamelinkMeta {
  const factory _FlamelinkMeta(
      {required final String createdBy,
      @JsonKey(fromJson: firestoreTimestampFromJson, toJson: firestoreTimestampToJson)
          required final Timestamp timestamp,
      @JsonKey(name: 'docId')
          required final String documentId,
      @JsonKey(name: 'fl_id')
          required final String flamelinkId,
      @JsonKey(name: 'env')
          required final String environment,
      required final String lastModifiedBy,
      @JsonKey(fromJson: firestoreTimestampFromJson, toJson: firestoreTimestampToJson)
          required final Timestamp lastModifiedDate,
      required final String schema,
      @JsonKey(name: 'schemaRef', toJson: firestoreDocRefToJson, fromJson: firestoreDocRefFromJson)
          required final DocumentReference<Object?> schemaReference,
      required final String schemaType,
      required final String status}) = _$_FlamelinkMeta;

  factory _FlamelinkMeta.fromJson(Map<String, dynamic> json) =
      _$_FlamelinkMeta.fromJson;

  @override
  String get createdBy;
  @override
  @JsonKey(
      fromJson: firestoreTimestampFromJson, toJson: firestoreTimestampToJson)
  Timestamp get timestamp;
  @override
  @JsonKey(name: 'docId')
  String get documentId;
  @override
  @JsonKey(name: 'fl_id')
  String get flamelinkId;
  @override
  @JsonKey(name: 'env')
  String get environment;
  @override
  String get lastModifiedBy;
  @override
  @JsonKey(
      fromJson: firestoreTimestampFromJson, toJson: firestoreTimestampToJson)
  Timestamp get lastModifiedDate;
  @override
  String get schema;
  @override
  @JsonKey(
      name: 'schemaRef',
      toJson: firestoreDocRefToJson,
      fromJson: firestoreDocRefFromJson)
  DocumentReference<Object?> get schemaReference;
  @override
  String get schemaType;
  @override
  String get status;
  @override
  @JsonKey(ignore: true)
  _$$_FlamelinkMetaCopyWith<_$_FlamelinkMeta> get copyWith =>
      throw _privateConstructorUsedError;
}
