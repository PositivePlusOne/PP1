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
  String get createdBy => throw _privateConstructorUsedError;
  String get lastAccessedBy => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get lastUpdatedAt => throw _privateConstructorUsedError;

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
  $Res call(
      {String key,
      Object value,
      String createdBy,
      String lastAccessedBy,
      DateTime createdAt,
      DateTime lastUpdatedAt});
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
    Object? createdBy = null,
    Object? lastAccessedBy = null,
    Object? createdAt = null,
    Object? lastUpdatedAt = null,
  }) {
    return _then(_value.copyWith(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value ? _value.value : value,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      lastAccessedBy: null == lastAccessedBy
          ? _value.lastAccessedBy
          : lastAccessedBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastUpdatedAt: null == lastUpdatedAt
          ? _value.lastUpdatedAt
          : lastUpdatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
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
  $Res call(
      {String key,
      Object value,
      String createdBy,
      String lastAccessedBy,
      DateTime createdAt,
      DateTime lastUpdatedAt});
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
    Object? createdBy = null,
    Object? lastAccessedBy = null,
    Object? createdAt = null,
    Object? lastUpdatedAt = null,
  }) {
    return _then(_$_CacheRecord(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value ? _value.value : value,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      lastAccessedBy: null == lastAccessedBy
          ? _value.lastAccessedBy
          : lastAccessedBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastUpdatedAt: null == lastUpdatedAt
          ? _value.lastUpdatedAt
          : lastUpdatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CacheRecord implements _CacheRecord {
  const _$_CacheRecord(
      {required this.key,
      required this.value,
      required this.createdBy,
      required this.lastAccessedBy,
      required this.createdAt,
      required this.lastUpdatedAt});

  factory _$_CacheRecord.fromJson(Map<String, dynamic> json) =>
      _$$_CacheRecordFromJson(json);

  @override
  final String key;
  @override
  final Object value;
  @override
  final String createdBy;
  @override
  final String lastAccessedBy;
  @override
  final DateTime createdAt;
  @override
  final DateTime lastUpdatedAt;

  @override
  String toString() {
    return 'CacheRecord(key: $key, value: $value, createdBy: $createdBy, lastAccessedBy: $lastAccessedBy, createdAt: $createdAt, lastUpdatedAt: $lastUpdatedAt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CacheRecord &&
            (identical(other.key, key) || other.key == key) &&
            const DeepCollectionEquality().equals(other.value, value) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.lastAccessedBy, lastAccessedBy) ||
                other.lastAccessedBy == lastAccessedBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastUpdatedAt, lastUpdatedAt) ||
                other.lastUpdatedAt == lastUpdatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      key,
      const DeepCollectionEquality().hash(value),
      createdBy,
      lastAccessedBy,
      createdAt,
      lastUpdatedAt);

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
      required final String createdBy,
      required final String lastAccessedBy,
      required final DateTime createdAt,
      required final DateTime lastUpdatedAt}) = _$_CacheRecord;

  factory _CacheRecord.fromJson(Map<String, dynamic> json) =
      _$_CacheRecord.fromJson;

  @override
  String get key;
  @override
  Object get value;
  @override
  String get createdBy;
  @override
  String get lastAccessedBy;
  @override
  DateTime get createdAt;
  @override
  DateTime get lastUpdatedAt;
  @override
  @JsonKey(ignore: true)
  _$$_CacheRecordCopyWith<_$_CacheRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CacheControllerState {
  Map<String, CacheRecord> get cacheData => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CacheControllerStateCopyWith<CacheControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CacheControllerStateCopyWith<$Res> {
  factory $CacheControllerStateCopyWith(CacheControllerState value,
          $Res Function(CacheControllerState) then) =
      _$CacheControllerStateCopyWithImpl<$Res, CacheControllerState>;
  @useResult
  $Res call({Map<String, CacheRecord> cacheData});
}

/// @nodoc
class _$CacheControllerStateCopyWithImpl<$Res,
        $Val extends CacheControllerState>
    implements $CacheControllerStateCopyWith<$Res> {
  _$CacheControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cacheData = null,
  }) {
    return _then(_value.copyWith(
      cacheData: null == cacheData
          ? _value.cacheData
          : cacheData // ignore: cast_nullable_to_non_nullable
              as Map<String, CacheRecord>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_CacheControllerStateCopyWith<$Res>
    implements $CacheControllerStateCopyWith<$Res> {
  factory _$$_CacheControllerStateCopyWith(_$_CacheControllerState value,
          $Res Function(_$_CacheControllerState) then) =
      __$$_CacheControllerStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<String, CacheRecord> cacheData});
}

/// @nodoc
class __$$_CacheControllerStateCopyWithImpl<$Res>
    extends _$CacheControllerStateCopyWithImpl<$Res, _$_CacheControllerState>
    implements _$$_CacheControllerStateCopyWith<$Res> {
  __$$_CacheControllerStateCopyWithImpl(_$_CacheControllerState _value,
      $Res Function(_$_CacheControllerState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cacheData = null,
  }) {
    return _then(_$_CacheControllerState(
      cacheData: null == cacheData
          ? _value._cacheData
          : cacheData // ignore: cast_nullable_to_non_nullable
              as Map<String, CacheRecord>,
    ));
  }
}

/// @nodoc

class _$_CacheControllerState implements _CacheControllerState {
  const _$_CacheControllerState(
      {required final Map<String, CacheRecord> cacheData})
      : _cacheData = cacheData;

  final Map<String, CacheRecord> _cacheData;
  @override
  Map<String, CacheRecord> get cacheData {
    if (_cacheData is EqualUnmodifiableMapView) return _cacheData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_cacheData);
  }

  @override
  String toString() {
    return 'CacheControllerState(cacheData: $cacheData)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CacheControllerState &&
            const DeepCollectionEquality()
                .equals(other._cacheData, _cacheData));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_cacheData));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CacheControllerStateCopyWith<_$_CacheControllerState> get copyWith =>
      __$$_CacheControllerStateCopyWithImpl<_$_CacheControllerState>(
          this, _$identity);
}

abstract class _CacheControllerState implements CacheControllerState {
  const factory _CacheControllerState(
          {required final Map<String, CacheRecord> cacheData}) =
      _$_CacheControllerState;

  @override
  Map<String, CacheRecord> get cacheData;
  @override
  @JsonKey(ignore: true)
  _$$_CacheControllerStateCopyWith<_$_CacheControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}
