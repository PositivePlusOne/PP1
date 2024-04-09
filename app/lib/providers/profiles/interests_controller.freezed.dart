// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'interests_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$InterestsControllerState {
  Map<String, String> get interests => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $InterestsControllerStateCopyWith<InterestsControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InterestsControllerStateCopyWith<$Res> {
  factory $InterestsControllerStateCopyWith(InterestsControllerState value,
          $Res Function(InterestsControllerState) then) =
      _$InterestsControllerStateCopyWithImpl<$Res, InterestsControllerState>;
  @useResult
  $Res call({Map<String, String> interests});
}

/// @nodoc
class _$InterestsControllerStateCopyWithImpl<$Res,
        $Val extends InterestsControllerState>
    implements $InterestsControllerStateCopyWith<$Res> {
  _$InterestsControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? interests = null,
  }) {
    return _then(_value.copyWith(
      interests: null == interests
          ? _value.interests
          : interests // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$InterestsControllerStateImplCopyWith<$Res>
    implements $InterestsControllerStateCopyWith<$Res> {
  factory _$$InterestsControllerStateImplCopyWith(
          _$InterestsControllerStateImpl value,
          $Res Function(_$InterestsControllerStateImpl) then) =
      __$$InterestsControllerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<String, String> interests});
}

/// @nodoc
class __$$InterestsControllerStateImplCopyWithImpl<$Res>
    extends _$InterestsControllerStateCopyWithImpl<$Res,
        _$InterestsControllerStateImpl>
    implements _$$InterestsControllerStateImplCopyWith<$Res> {
  __$$InterestsControllerStateImplCopyWithImpl(
      _$InterestsControllerStateImpl _value,
      $Res Function(_$InterestsControllerStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? interests = null,
  }) {
    return _then(_$InterestsControllerStateImpl(
      interests: null == interests
          ? _value._interests
          : interests // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ));
  }
}

/// @nodoc

class _$InterestsControllerStateImpl implements _InterestsControllerState {
  const _$InterestsControllerStateImpl(
      {final Map<String, String> interests = const {}})
      : _interests = interests;

  final Map<String, String> _interests;
  @override
  @JsonKey()
  Map<String, String> get interests {
    if (_interests is EqualUnmodifiableMapView) return _interests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_interests);
  }

  @override
  String toString() {
    return 'InterestsControllerState(interests: $interests)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InterestsControllerStateImpl &&
            const DeepCollectionEquality()
                .equals(other._interests, _interests));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_interests));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InterestsControllerStateImplCopyWith<_$InterestsControllerStateImpl>
      get copyWith => __$$InterestsControllerStateImplCopyWithImpl<
          _$InterestsControllerStateImpl>(this, _$identity);
}

abstract class _InterestsControllerState implements InterestsControllerState {
  const factory _InterestsControllerState(
      {final Map<String, String> interests}) = _$InterestsControllerStateImpl;

  @override
  Map<String, String> get interests;
  @override
  @JsonKey(ignore: true)
  _$$InterestsControllerStateImplCopyWith<_$InterestsControllerStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
