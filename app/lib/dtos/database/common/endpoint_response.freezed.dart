// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'endpoint_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

EndpointResponse _$EndpointResponseFromJson(Map<String, dynamic> json) {
  return _EndpointResponse.fromJson(json);
}

/// @nodoc
mixin _$EndpointResponse {
  Map<String, Object?> get data => throw _privateConstructorUsedError;
  String? get cursor => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EndpointResponseCopyWith<EndpointResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EndpointResponseCopyWith<$Res> {
  factory $EndpointResponseCopyWith(
          EndpointResponse value, $Res Function(EndpointResponse) then) =
      _$EndpointResponseCopyWithImpl<$Res, EndpointResponse>;
  @useResult
  $Res call({Map<String, Object?> data, String? cursor, int limit});
}

/// @nodoc
class _$EndpointResponseCopyWithImpl<$Res, $Val extends EndpointResponse>
    implements $EndpointResponseCopyWith<$Res> {
  _$EndpointResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? cursor = freezed,
    Object? limit = null,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, Object?>,
      cursor: freezed == cursor
          ? _value.cursor
          : cursor // ignore: cast_nullable_to_non_nullable
              as String?,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EndpointResponseImplCopyWith<$Res>
    implements $EndpointResponseCopyWith<$Res> {
  factory _$$EndpointResponseImplCopyWith(_$EndpointResponseImpl value,
          $Res Function(_$EndpointResponseImpl) then) =
      __$$EndpointResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<String, Object?> data, String? cursor, int limit});
}

/// @nodoc
class __$$EndpointResponseImplCopyWithImpl<$Res>
    extends _$EndpointResponseCopyWithImpl<$Res, _$EndpointResponseImpl>
    implements _$$EndpointResponseImplCopyWith<$Res> {
  __$$EndpointResponseImplCopyWithImpl(_$EndpointResponseImpl _value,
      $Res Function(_$EndpointResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? cursor = freezed,
    Object? limit = null,
  }) {
    return _then(_$EndpointResponseImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, Object?>,
      cursor: freezed == cursor
          ? _value.cursor
          : cursor // ignore: cast_nullable_to_non_nullable
              as String?,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EndpointResponseImpl implements _EndpointResponse {
  const _$EndpointResponseImpl(
      {final Map<String, Object?> data = const {},
      this.cursor,
      this.limit = 10})
      : _data = data;

  factory _$EndpointResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$EndpointResponseImplFromJson(json);

  final Map<String, Object?> _data;
  @override
  @JsonKey()
  Map<String, Object?> get data {
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_data);
  }

  @override
  final String? cursor;
  @override
  @JsonKey()
  final int limit;

  @override
  String toString() {
    return 'EndpointResponse(data: $data, cursor: $cursor, limit: $limit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EndpointResponseImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.cursor, cursor) || other.cursor == cursor) &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_data), cursor, limit);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EndpointResponseImplCopyWith<_$EndpointResponseImpl> get copyWith =>
      __$$EndpointResponseImplCopyWithImpl<_$EndpointResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EndpointResponseImplToJson(
      this,
    );
  }
}

abstract class _EndpointResponse implements EndpointResponse {
  const factory _EndpointResponse(
      {final Map<String, Object?> data,
      final String? cursor,
      final int limit}) = _$EndpointResponseImpl;

  factory _EndpointResponse.fromJson(Map<String, dynamic> json) =
      _$EndpointResponseImpl.fromJson;

  @override
  Map<String, Object?> get data;
  @override
  String? get cursor;
  @override
  int get limit;
  @override
  @JsonKey(ignore: true)
  _$$EndpointResponseImplCopyWith<_$EndpointResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
