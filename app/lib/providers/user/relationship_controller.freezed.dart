// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'relationship_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$RelationshipControllerState {
  Set<Relationship> get currentUserRelationships =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RelationshipControllerStateCopyWith<RelationshipControllerState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RelationshipControllerStateCopyWith<$Res> {
  factory $RelationshipControllerStateCopyWith(
          RelationshipControllerState value,
          $Res Function(RelationshipControllerState) then) =
      _$RelationshipControllerStateCopyWithImpl<$Res,
          RelationshipControllerState>;
  @useResult
  $Res call({Set<Relationship> currentUserRelationships});
}

/// @nodoc
class _$RelationshipControllerStateCopyWithImpl<$Res,
        $Val extends RelationshipControllerState>
    implements $RelationshipControllerStateCopyWith<$Res> {
  _$RelationshipControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentUserRelationships = null,
  }) {
    return _then(_value.copyWith(
      currentUserRelationships: null == currentUserRelationships
          ? _value.currentUserRelationships
          : currentUserRelationships // ignore: cast_nullable_to_non_nullable
              as Set<Relationship>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_RelationshipControllerStateCopyWith<$Res>
    implements $RelationshipControllerStateCopyWith<$Res> {
  factory _$$_RelationshipControllerStateCopyWith(
          _$_RelationshipControllerState value,
          $Res Function(_$_RelationshipControllerState) then) =
      __$$_RelationshipControllerStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Set<Relationship> currentUserRelationships});
}

/// @nodoc
class __$$_RelationshipControllerStateCopyWithImpl<$Res>
    extends _$RelationshipControllerStateCopyWithImpl<$Res,
        _$_RelationshipControllerState>
    implements _$$_RelationshipControllerStateCopyWith<$Res> {
  __$$_RelationshipControllerStateCopyWithImpl(
      _$_RelationshipControllerState _value,
      $Res Function(_$_RelationshipControllerState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentUserRelationships = null,
  }) {
    return _then(_$_RelationshipControllerState(
      currentUserRelationships: null == currentUserRelationships
          ? _value._currentUserRelationships
          : currentUserRelationships // ignore: cast_nullable_to_non_nullable
              as Set<Relationship>,
    ));
  }
}

/// @nodoc

class _$_RelationshipControllerState implements _RelationshipControllerState {
  const _$_RelationshipControllerState(
      {final Set<Relationship> currentUserRelationships = const {}})
      : _currentUserRelationships = currentUserRelationships;

  final Set<Relationship> _currentUserRelationships;
  @override
  @JsonKey()
  Set<Relationship> get currentUserRelationships {
    if (_currentUserRelationships is EqualUnmodifiableSetView)
      return _currentUserRelationships;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_currentUserRelationships);
  }

  @override
  String toString() {
    return 'RelationshipControllerState(currentUserRelationships: $currentUserRelationships)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_RelationshipControllerState &&
            const DeepCollectionEquality().equals(
                other._currentUserRelationships, _currentUserRelationships));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_currentUserRelationships));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_RelationshipControllerStateCopyWith<_$_RelationshipControllerState>
      get copyWith => __$$_RelationshipControllerStateCopyWithImpl<
          _$_RelationshipControllerState>(this, _$identity);
}

abstract class _RelationshipControllerState
    implements RelationshipControllerState {
  const factory _RelationshipControllerState(
          {final Set<Relationship> currentUserRelationships}) =
      _$_RelationshipControllerState;

  @override
  Set<Relationship> get currentUserRelationships;
  @override
  @JsonKey(ignore: true)
  _$$_RelationshipControllerStateCopyWith<_$_RelationshipControllerState>
      get copyWith => throw _privateConstructorUsedError;
}
