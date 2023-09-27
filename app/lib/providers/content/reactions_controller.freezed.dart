// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reactions_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ReactionsControllerState {
  HashMap<String, HashMap<String, Reaction>> get activityReactions =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ReactionsControllerStateCopyWith<ReactionsControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReactionsControllerStateCopyWith<$Res> {
  factory $ReactionsControllerStateCopyWith(ReactionsControllerState value,
          $Res Function(ReactionsControllerState) then) =
      _$ReactionsControllerStateCopyWithImpl<$Res, ReactionsControllerState>;
  @useResult
  $Res call({HashMap<String, HashMap<String, Reaction>> activityReactions});
}

/// @nodoc
class _$ReactionsControllerStateCopyWithImpl<$Res,
        $Val extends ReactionsControllerState>
    implements $ReactionsControllerStateCopyWith<$Res> {
  _$ReactionsControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activityReactions = null,
  }) {
    return _then(_value.copyWith(
      activityReactions: null == activityReactions
          ? _value.activityReactions
          : activityReactions // ignore: cast_nullable_to_non_nullable
              as HashMap<String, HashMap<String, Reaction>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ReactionsControllerStateCopyWith<$Res>
    implements $ReactionsControllerStateCopyWith<$Res> {
  factory _$$_ReactionsControllerStateCopyWith(
          _$_ReactionsControllerState value,
          $Res Function(_$_ReactionsControllerState) then) =
      __$$_ReactionsControllerStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({HashMap<String, HashMap<String, Reaction>> activityReactions});
}

/// @nodoc
class __$$_ReactionsControllerStateCopyWithImpl<$Res>
    extends _$ReactionsControllerStateCopyWithImpl<$Res,
        _$_ReactionsControllerState>
    implements _$$_ReactionsControllerStateCopyWith<$Res> {
  __$$_ReactionsControllerStateCopyWithImpl(_$_ReactionsControllerState _value,
      $Res Function(_$_ReactionsControllerState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activityReactions = null,
  }) {
    return _then(_$_ReactionsControllerState(
      activityReactions: null == activityReactions
          ? _value.activityReactions
          : activityReactions // ignore: cast_nullable_to_non_nullable
              as HashMap<String, HashMap<String, Reaction>>,
    ));
  }
}

/// @nodoc

class _$_ReactionsControllerState implements _ReactionsControllerState {
  const _$_ReactionsControllerState({required this.activityReactions});

  @override
  final HashMap<String, HashMap<String, Reaction>> activityReactions;

  @override
  String toString() {
    return 'ReactionsControllerState(activityReactions: $activityReactions)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ReactionsControllerState &&
            const DeepCollectionEquality()
                .equals(other.activityReactions, activityReactions));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(activityReactions));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ReactionsControllerStateCopyWith<_$_ReactionsControllerState>
      get copyWith => __$$_ReactionsControllerStateCopyWithImpl<
          _$_ReactionsControllerState>(this, _$identity);
}

abstract class _ReactionsControllerState implements ReactionsControllerState {
  const factory _ReactionsControllerState(
      {required final HashMap<String, HashMap<String, Reaction>>
          activityReactions}) = _$_ReactionsControllerState;

  @override
  HashMap<String, HashMap<String, Reaction>> get activityReactions;
  @override
  @JsonKey(ignore: true)
  _$$_ReactionsControllerStateCopyWith<_$_ReactionsControllerState>
      get copyWith => throw _privateConstructorUsedError;
}
