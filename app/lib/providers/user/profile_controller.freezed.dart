// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ProfileControllerState {
  UserProfile? get userProfile => throw _privateConstructorUsedError;
  Set<String> get followers => throw _privateConstructorUsedError;
  Set<String> get connections => throw _privateConstructorUsedError;
  Set<String> get blockedUsers => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ProfileControllerStateCopyWith<ProfileControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileControllerStateCopyWith<$Res> {
  factory $ProfileControllerStateCopyWith(ProfileControllerState value,
          $Res Function(ProfileControllerState) then) =
      _$ProfileControllerStateCopyWithImpl<$Res, ProfileControllerState>;
  @useResult
  $Res call(
      {UserProfile? userProfile,
      Set<String> followers,
      Set<String> connections,
      Set<String> blockedUsers});

  $UserProfileCopyWith<$Res>? get userProfile;
}

/// @nodoc
class _$ProfileControllerStateCopyWithImpl<$Res,
        $Val extends ProfileControllerState>
    implements $ProfileControllerStateCopyWith<$Res> {
  _$ProfileControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userProfile = freezed,
    Object? followers = null,
    Object? connections = null,
    Object? blockedUsers = null,
  }) {
    return _then(_value.copyWith(
      userProfile: freezed == userProfile
          ? _value.userProfile
          : userProfile // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
      followers: null == followers
          ? _value.followers
          : followers // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      connections: null == connections
          ? _value.connections
          : connections // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      blockedUsers: null == blockedUsers
          ? _value.blockedUsers
          : blockedUsers // ignore: cast_nullable_to_non_nullable
              as Set<String>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $UserProfileCopyWith<$Res>? get userProfile {
    if (_value.userProfile == null) {
      return null;
    }

    return $UserProfileCopyWith<$Res>(_value.userProfile!, (value) {
      return _then(_value.copyWith(userProfile: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_ProfileControllerStateCopyWith<$Res>
    implements $ProfileControllerStateCopyWith<$Res> {
  factory _$$_ProfileControllerStateCopyWith(_$_ProfileControllerState value,
          $Res Function(_$_ProfileControllerState) then) =
      __$$_ProfileControllerStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {UserProfile? userProfile,
      Set<String> followers,
      Set<String> connections,
      Set<String> blockedUsers});

  @override
  $UserProfileCopyWith<$Res>? get userProfile;
}

/// @nodoc
class __$$_ProfileControllerStateCopyWithImpl<$Res>
    extends _$ProfileControllerStateCopyWithImpl<$Res,
        _$_ProfileControllerState>
    implements _$$_ProfileControllerStateCopyWith<$Res> {
  __$$_ProfileControllerStateCopyWithImpl(_$_ProfileControllerState _value,
      $Res Function(_$_ProfileControllerState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userProfile = freezed,
    Object? followers = null,
    Object? connections = null,
    Object? blockedUsers = null,
  }) {
    return _then(_$_ProfileControllerState(
      userProfile: freezed == userProfile
          ? _value.userProfile
          : userProfile // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
      followers: null == followers
          ? _value._followers
          : followers // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      connections: null == connections
          ? _value._connections
          : connections // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      blockedUsers: null == blockedUsers
          ? _value._blockedUsers
          : blockedUsers // ignore: cast_nullable_to_non_nullable
              as Set<String>,
    ));
  }
}

/// @nodoc

class _$_ProfileControllerState implements _ProfileControllerState {
  const _$_ProfileControllerState(
      {this.userProfile,
      final Set<String> followers = const {},
      final Set<String> connections = const {},
      final Set<String> blockedUsers = const {}})
      : _followers = followers,
        _connections = connections,
        _blockedUsers = blockedUsers;

  @override
  final UserProfile? userProfile;
  final Set<String> _followers;
  @override
  @JsonKey()
  Set<String> get followers {
    if (_followers is EqualUnmodifiableSetView) return _followers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_followers);
  }

  final Set<String> _connections;
  @override
  @JsonKey()
  Set<String> get connections {
    if (_connections is EqualUnmodifiableSetView) return _connections;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_connections);
  }

  final Set<String> _blockedUsers;
  @override
  @JsonKey()
  Set<String> get blockedUsers {
    if (_blockedUsers is EqualUnmodifiableSetView) return _blockedUsers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_blockedUsers);
  }

  @override
  String toString() {
    return 'ProfileControllerState(userProfile: $userProfile, followers: $followers, connections: $connections, blockedUsers: $blockedUsers)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ProfileControllerState &&
            (identical(other.userProfile, userProfile) ||
                other.userProfile == userProfile) &&
            const DeepCollectionEquality()
                .equals(other._followers, _followers) &&
            const DeepCollectionEquality()
                .equals(other._connections, _connections) &&
            const DeepCollectionEquality()
                .equals(other._blockedUsers, _blockedUsers));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      userProfile,
      const DeepCollectionEquality().hash(_followers),
      const DeepCollectionEquality().hash(_connections),
      const DeepCollectionEquality().hash(_blockedUsers));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ProfileControllerStateCopyWith<_$_ProfileControllerState> get copyWith =>
      __$$_ProfileControllerStateCopyWithImpl<_$_ProfileControllerState>(
          this, _$identity);
}

abstract class _ProfileControllerState implements ProfileControllerState {
  const factory _ProfileControllerState(
      {final UserProfile? userProfile,
      final Set<String> followers,
      final Set<String> connections,
      final Set<String> blockedUsers}) = _$_ProfileControllerState;

  @override
  UserProfile? get userProfile;
  @override
  Set<String> get followers;
  @override
  Set<String> get connections;
  @override
  Set<String> get blockedUsers;
  @override
  @JsonKey(ignore: true)
  _$$_ProfileControllerStateCopyWith<_$_ProfileControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}
