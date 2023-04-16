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
  Set<String> get following => throw _privateConstructorUsedError;
  Set<String> get connections => throw _privateConstructorUsedError;
  Set<String> get pendingConnectionRequests =>
      throw _privateConstructorUsedError;
  Set<String> get blockedRelationships => throw _privateConstructorUsedError;
  Set<String> get mutedRelationships => throw _privateConstructorUsedError;
  Set<String> get hiddenRelationships => throw _privateConstructorUsedError;

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
  $Res call(
      {Set<String> following,
      Set<String> connections,
      Set<String> pendingConnectionRequests,
      Set<String> blockedRelationships,
      Set<String> mutedRelationships,
      Set<String> hiddenRelationships});
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
    Object? following = null,
    Object? connections = null,
    Object? pendingConnectionRequests = null,
    Object? blockedRelationships = null,
    Object? mutedRelationships = null,
    Object? hiddenRelationships = null,
  }) {
    return _then(_value.copyWith(
      following: null == following
          ? _value.following
          : following // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      connections: null == connections
          ? _value.connections
          : connections // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      pendingConnectionRequests: null == pendingConnectionRequests
          ? _value.pendingConnectionRequests
          : pendingConnectionRequests // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      blockedRelationships: null == blockedRelationships
          ? _value.blockedRelationships
          : blockedRelationships // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      mutedRelationships: null == mutedRelationships
          ? _value.mutedRelationships
          : mutedRelationships // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      hiddenRelationships: null == hiddenRelationships
          ? _value.hiddenRelationships
          : hiddenRelationships // ignore: cast_nullable_to_non_nullable
              as Set<String>,
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
  $Res call(
      {Set<String> following,
      Set<String> connections,
      Set<String> pendingConnectionRequests,
      Set<String> blockedRelationships,
      Set<String> mutedRelationships,
      Set<String> hiddenRelationships});
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
    Object? following = null,
    Object? connections = null,
    Object? pendingConnectionRequests = null,
    Object? blockedRelationships = null,
    Object? mutedRelationships = null,
    Object? hiddenRelationships = null,
  }) {
    return _then(_$_RelationshipControllerState(
      following: null == following
          ? _value._following
          : following // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      connections: null == connections
          ? _value._connections
          : connections // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      pendingConnectionRequests: null == pendingConnectionRequests
          ? _value._pendingConnectionRequests
          : pendingConnectionRequests // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      blockedRelationships: null == blockedRelationships
          ? _value._blockedRelationships
          : blockedRelationships // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      mutedRelationships: null == mutedRelationships
          ? _value._mutedRelationships
          : mutedRelationships // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      hiddenRelationships: null == hiddenRelationships
          ? _value._hiddenRelationships
          : hiddenRelationships // ignore: cast_nullable_to_non_nullable
              as Set<String>,
    ));
  }
}

/// @nodoc

class _$_RelationshipControllerState implements _RelationshipControllerState {
  const _$_RelationshipControllerState(
      {final Set<String> following = const {},
      final Set<String> connections = const {},
      final Set<String> pendingConnectionRequests = const {},
      final Set<String> blockedRelationships = const {},
      final Set<String> mutedRelationships = const {},
      final Set<String> hiddenRelationships = const {}})
      : _following = following,
        _connections = connections,
        _pendingConnectionRequests = pendingConnectionRequests,
        _blockedRelationships = blockedRelationships,
        _mutedRelationships = mutedRelationships,
        _hiddenRelationships = hiddenRelationships;

  final Set<String> _following;
  @override
  @JsonKey()
  Set<String> get following {
    if (_following is EqualUnmodifiableSetView) return _following;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_following);
  }

  final Set<String> _connections;
  @override
  @JsonKey()
  Set<String> get connections {
    if (_connections is EqualUnmodifiableSetView) return _connections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_connections);
  }

  final Set<String> _pendingConnectionRequests;
  @override
  @JsonKey()
  Set<String> get pendingConnectionRequests {
    if (_pendingConnectionRequests is EqualUnmodifiableSetView)
      return _pendingConnectionRequests;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_pendingConnectionRequests);
  }

  final Set<String> _blockedRelationships;
  @override
  @JsonKey()
  Set<String> get blockedRelationships {
    if (_blockedRelationships is EqualUnmodifiableSetView)
      return _blockedRelationships;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_blockedRelationships);
  }

  final Set<String> _mutedRelationships;
  @override
  @JsonKey()
  Set<String> get mutedRelationships {
    if (_mutedRelationships is EqualUnmodifiableSetView)
      return _mutedRelationships;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_mutedRelationships);
  }

  final Set<String> _hiddenRelationships;
  @override
  @JsonKey()
  Set<String> get hiddenRelationships {
    if (_hiddenRelationships is EqualUnmodifiableSetView)
      return _hiddenRelationships;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_hiddenRelationships);
  }

  @override
  String toString() {
    return 'RelationshipControllerState(following: $following, connections: $connections, pendingConnectionRequests: $pendingConnectionRequests, blockedRelationships: $blockedRelationships, mutedRelationships: $mutedRelationships, hiddenRelationships: $hiddenRelationships)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_RelationshipControllerState &&
            const DeepCollectionEquality()
                .equals(other._following, _following) &&
            const DeepCollectionEquality()
                .equals(other._connections, _connections) &&
            const DeepCollectionEquality().equals(
                other._pendingConnectionRequests, _pendingConnectionRequests) &&
            const DeepCollectionEquality()
                .equals(other._blockedRelationships, _blockedRelationships) &&
            const DeepCollectionEquality()
                .equals(other._mutedRelationships, _mutedRelationships) &&
            const DeepCollectionEquality()
                .equals(other._hiddenRelationships, _hiddenRelationships));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_following),
      const DeepCollectionEquality().hash(_connections),
      const DeepCollectionEquality().hash(_pendingConnectionRequests),
      const DeepCollectionEquality().hash(_blockedRelationships),
      const DeepCollectionEquality().hash(_mutedRelationships),
      const DeepCollectionEquality().hash(_hiddenRelationships));

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
      {final Set<String> following,
      final Set<String> connections,
      final Set<String> pendingConnectionRequests,
      final Set<String> blockedRelationships,
      final Set<String> mutedRelationships,
      final Set<String> hiddenRelationships}) = _$_RelationshipControllerState;

  @override
  Set<String> get following;
  @override
  Set<String> get connections;
  @override
  Set<String> get pendingConnectionRequests;
  @override
  Set<String> get blockedRelationships;
  @override
  Set<String> get mutedRelationships;
  @override
  Set<String> get hiddenRelationships;
  @override
  @JsonKey(ignore: true)
  _$$_RelationshipControllerStateCopyWith<_$_RelationshipControllerState>
      get copyWith => throw _privateConstructorUsedError;
}
