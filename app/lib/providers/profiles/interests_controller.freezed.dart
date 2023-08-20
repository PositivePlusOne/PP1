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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

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
abstract class _$$_InterestsControllerStateCopyWith<$Res>
    implements $InterestsControllerStateCopyWith<$Res> {
  factory _$$_InterestsControllerStateCopyWith(
          _$_InterestsControllerState value,
          $Res Function(_$_InterestsControllerState) then) =
      __$$_InterestsControllerStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<String, String> interests});
}

/// @nodoc
class __$$_InterestsControllerStateCopyWithImpl<$Res>
    extends _$InterestsControllerStateCopyWithImpl<$Res,
        _$_InterestsControllerState>
    implements _$$_InterestsControllerStateCopyWith<$Res> {
  __$$_InterestsControllerStateCopyWithImpl(_$_InterestsControllerState _value,
      $Res Function(_$_InterestsControllerState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? interests = null,
  }) {
    return _then(_$_InterestsControllerState(
      interests: null == interests
          ? _value._interests
          : interests // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ));
  }
}

/// @nodoc

class _$_InterestsControllerState implements _InterestsControllerState {
  const _$_InterestsControllerState(
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
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_InterestsControllerState &&
            const DeepCollectionEquality()
                .equals(other._interests, _interests));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_interests));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_InterestsControllerStateCopyWith<_$_InterestsControllerState>
      get copyWith => __$$_InterestsControllerStateCopyWithImpl<
          _$_InterestsControllerState>(this, _$identity);
}

abstract class _InterestsControllerState implements InterestsControllerState {
  const factory _InterestsControllerState(
      {final Map<String, String> interests}) = _$_InterestsControllerState;

  @override
  Map<String, String> get interests;
  @override
  @JsonKey(ignore: true)
  _$$_InterestsControllerStateCopyWith<_$_InterestsControllerState>
      get copyWith => throw _privateConstructorUsedError;
}
