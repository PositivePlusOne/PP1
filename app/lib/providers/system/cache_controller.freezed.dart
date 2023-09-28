// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cache_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CacheRecord _$CacheRecordFromJson(Map<String, dynamic> json) {
  return _CacheRecord.fromJson(json);
}

/// @nodoc
mixin _$CacheRecord {
  String get key => throw _privateConstructorUsedError;
  Object get value => throw _privateConstructorUsedError;
  FlMeta get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CacheRecordCopyWith<CacheRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CacheRecordCopyWith<$Res> {
  factory $CacheRecordCopyWith(
          CacheRecord value, $Res Function(CacheRecord) then) =
      _$CacheRecordCopyWithImpl<$Res, CacheRecord>;
  @useResult
  $Res call({String key, Object value, FlMeta metadata});

  $FlMetaCopyWith<$Res> get metadata;
}

/// @nodoc
class _$CacheRecordCopyWithImpl<$Res, $Val extends CacheRecord>
    implements $CacheRecordCopyWith<$Res> {
  _$CacheRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? value = null,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value ? _value.value : value,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as FlMeta,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $FlMetaCopyWith<$Res> get metadata {
    return $FlMetaCopyWith<$Res>(_value.metadata, (value) {
      return _then(_value.copyWith(metadata: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_CacheRecordCopyWith<$Res>
    implements $CacheRecordCopyWith<$Res> {
  factory _$$_CacheRecordCopyWith(
          _$_CacheRecord value, $Res Function(_$_CacheRecord) then) =
      __$$_CacheRecordCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String key, Object value, FlMeta metadata});

  @override
  $FlMetaCopyWith<$Res> get metadata;
}

/// @nodoc
class __$$_CacheRecordCopyWithImpl<$Res>
    extends _$CacheRecordCopyWithImpl<$Res, _$_CacheRecord>
    implements _$$_CacheRecordCopyWith<$Res> {
  __$$_CacheRecordCopyWithImpl(
      _$_CacheRecord _value, $Res Function(_$_CacheRecord) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? value = null,
    Object? metadata = null,
  }) {
    return _then(_$_CacheRecord(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value ? _value.value : value,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as FlMeta,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CacheRecord implements _CacheRecord {
  const _$_CacheRecord(
      {required this.key, required this.value, required this.metadata});

  factory _$_CacheRecord.fromJson(Map<String, dynamic> json) =>
      _$$_CacheRecordFromJson(json);

  @override
  final String key;
  @override
  final Object value;
  @override
  final FlMeta metadata;

  @override
  String toString() {
    return 'CacheRecord(key: $key, value: $value, metadata: $metadata)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CacheRecord &&
            (identical(other.key, key) || other.key == key) &&
            const DeepCollectionEquality().equals(other.value, value) &&
            (identical(other.metadata, metadata) ||
                other.metadata == metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, key, const DeepCollectionEquality().hash(value), metadata);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CacheRecordCopyWith<_$_CacheRecord> get copyWith =>
      __$$_CacheRecordCopyWithImpl<_$_CacheRecord>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CacheRecordToJson(
      this,
    );
  }
}

abstract class _CacheRecord implements CacheRecord {
  const factory _CacheRecord(
      {required final String key,
      required final Object value,
      required final FlMeta metadata}) = _$_CacheRecord;

  factory _CacheRecord.fromJson(Map<String, dynamic> json) =
      _$_CacheRecord.fromJson;

  @override
  String get key;
  @override
  Object get value;
  @override
  FlMeta get metadata;
  @override
  @JsonKey(ignore: true)
  _$$_CacheRecordCopyWith<_$_CacheRecord> get copyWith =>
      throw _privateConstructorUsedError;
}
