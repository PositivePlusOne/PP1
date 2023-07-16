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
abstract class _$$_EndpointResponseCopyWith<$Res>
    implements $EndpointResponseCopyWith<$Res> {
  factory _$$_EndpointResponseCopyWith(
          _$_EndpointResponse value, $Res Function(_$_EndpointResponse) then) =
      __$$_EndpointResponseCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<String, Object?> data, String? cursor, int limit});
}

/// @nodoc
class __$$_EndpointResponseCopyWithImpl<$Res>
    extends _$EndpointResponseCopyWithImpl<$Res, _$_EndpointResponse>
    implements _$$_EndpointResponseCopyWith<$Res> {
  __$$_EndpointResponseCopyWithImpl(
      _$_EndpointResponse _value, $Res Function(_$_EndpointResponse) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? cursor = freezed,
    Object? limit = null,
  }) {
    return _then(_$_EndpointResponse(
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
class _$_EndpointResponse implements _EndpointResponse {
  const _$_EndpointResponse(
      {final Map<String, Object?> data = const [],
      this.cursor,
      this.limit = 10})
      : _data = data;

  factory _$_EndpointResponse.fromJson(Map<String, dynamic> json) =>
      _$$_EndpointResponseFromJson(json);

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
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_EndpointResponse &&
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
  _$$_EndpointResponseCopyWith<_$_EndpointResponse> get copyWith =>
      __$$_EndpointResponseCopyWithImpl<_$_EndpointResponse>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_EndpointResponseToJson(
      this,
    );
  }
}

abstract class _EndpointResponse implements EndpointResponse {
  const factory _EndpointResponse(
      {final Map<String, Object?> data,
      final String? cursor,
      final int limit}) = _$_EndpointResponse;

  factory _EndpointResponse.fromJson(Map<String, dynamic> json) =
      _$_EndpointResponse.fromJson;

  @override
  Map<String, Object?> get data;
  @override
  String? get cursor;
  @override
  int get limit;
  @override
  @JsonKey(ignore: true)
  _$$_EndpointResponseCopyWith<_$_EndpointResponse> get copyWith =>
      throw _privateConstructorUsedError;
}
