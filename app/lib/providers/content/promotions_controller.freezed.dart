// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'promotions_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PromotionsControllerState {
  String get cursor => throw _privateConstructorUsedError;
  List<String> get promotionIds => throw _privateConstructorUsedError;
  bool get isExhausted => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PromotionsControllerStateCopyWith<PromotionsControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PromotionsControllerStateCopyWith<$Res> {
  factory $PromotionsControllerStateCopyWith(PromotionsControllerState value,
          $Res Function(PromotionsControllerState) then) =
      _$PromotionsControllerStateCopyWithImpl<$Res, PromotionsControllerState>;
  @useResult
  $Res call({String cursor, List<String> promotionIds, bool isExhausted});
}

/// @nodoc
class _$PromotionsControllerStateCopyWithImpl<$Res,
        $Val extends PromotionsControllerState>
    implements $PromotionsControllerStateCopyWith<$Res> {
  _$PromotionsControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cursor = null,
    Object? promotionIds = null,
    Object? isExhausted = null,
  }) {
    return _then(_value.copyWith(
      cursor: null == cursor
          ? _value.cursor
          : cursor // ignore: cast_nullable_to_non_nullable
              as String,
      promotionIds: null == promotionIds
          ? _value.promotionIds
          : promotionIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isExhausted: null == isExhausted
          ? _value.isExhausted
          : isExhausted // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PromotionsControllerStateImplCopyWith<$Res>
    implements $PromotionsControllerStateCopyWith<$Res> {
  factory _$$PromotionsControllerStateImplCopyWith(
          _$PromotionsControllerStateImpl value,
          $Res Function(_$PromotionsControllerStateImpl) then) =
      __$$PromotionsControllerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String cursor, List<String> promotionIds, bool isExhausted});
}

/// @nodoc
class __$$PromotionsControllerStateImplCopyWithImpl<$Res>
    extends _$PromotionsControllerStateCopyWithImpl<$Res,
        _$PromotionsControllerStateImpl>
    implements _$$PromotionsControllerStateImplCopyWith<$Res> {
  __$$PromotionsControllerStateImplCopyWithImpl(
      _$PromotionsControllerStateImpl _value,
      $Res Function(_$PromotionsControllerStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cursor = null,
    Object? promotionIds = null,
    Object? isExhausted = null,
  }) {
    return _then(_$PromotionsControllerStateImpl(
      cursor: null == cursor
          ? _value.cursor
          : cursor // ignore: cast_nullable_to_non_nullable
              as String,
      promotionIds: null == promotionIds
          ? _value._promotionIds
          : promotionIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isExhausted: null == isExhausted
          ? _value.isExhausted
          : isExhausted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$PromotionsControllerStateImpl implements _PromotionsControllerState {
  const _$PromotionsControllerStateImpl(
      {this.cursor = '',
      final List<String> promotionIds = const [],
      this.isExhausted = false})
      : _promotionIds = promotionIds;

  @override
  @JsonKey()
  final String cursor;
  final List<String> _promotionIds;
  @override
  @JsonKey()
  List<String> get promotionIds {
    if (_promotionIds is EqualUnmodifiableListView) return _promotionIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_promotionIds);
  }

  @override
  @JsonKey()
  final bool isExhausted;

  @override
  String toString() {
    return 'PromotionsControllerState(cursor: $cursor, promotionIds: $promotionIds, isExhausted: $isExhausted)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PromotionsControllerStateImpl &&
            (identical(other.cursor, cursor) || other.cursor == cursor) &&
            const DeepCollectionEquality()
                .equals(other._promotionIds, _promotionIds) &&
            (identical(other.isExhausted, isExhausted) ||
                other.isExhausted == isExhausted));
  }

  @override
  int get hashCode => Object.hash(runtimeType, cursor,
      const DeepCollectionEquality().hash(_promotionIds), isExhausted);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PromotionsControllerStateImplCopyWith<_$PromotionsControllerStateImpl>
      get copyWith => __$$PromotionsControllerStateImplCopyWithImpl<
          _$PromotionsControllerStateImpl>(this, _$identity);
}

abstract class _PromotionsControllerState implements PromotionsControllerState {
  const factory _PromotionsControllerState(
      {final String cursor,
      final List<String> promotionIds,
      final bool isExhausted}) = _$PromotionsControllerStateImpl;

  @override
  String get cursor;
  @override
  List<String> get promotionIds;
  @override
  bool get isExhausted;
  @override
  @JsonKey(ignore: true)
  _$$PromotionsControllerStateImplCopyWith<_$PromotionsControllerStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
