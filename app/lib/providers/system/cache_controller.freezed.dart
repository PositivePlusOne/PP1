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
