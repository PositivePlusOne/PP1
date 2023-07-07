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
  Profile? get currentProfile => throw _privateConstructorUsedError;
  Set<String> get availableProfileIds => throw _privateConstructorUsedError;

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
  $Res call({Profile? currentProfile, Set<String> availableProfileIds});

  $ProfileCopyWith<$Res>? get currentProfile;
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
    Object? currentProfile = freezed,
    Object? availableProfileIds = null,
  }) {
    return _then(_value.copyWith(
      currentProfile: freezed == currentProfile
          ? _value.currentProfile
          : currentProfile // ignore: cast_nullable_to_non_nullable
              as Profile?,
      availableProfileIds: null == availableProfileIds
          ? _value.availableProfileIds
          : availableProfileIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ProfileCopyWith<$Res>? get currentProfile {
    if (_value.currentProfile == null) {
      return null;
    }

    return $ProfileCopyWith<$Res>(_value.currentProfile!, (value) {
      return _then(_value.copyWith(currentProfile: value) as $Val);
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
  $Res call({Profile? currentProfile, Set<String> availableProfileIds});

  @override
  $ProfileCopyWith<$Res>? get currentProfile;
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
    Object? currentProfile = freezed,
    Object? availableProfileIds = null,
  }) {
    return _then(_$_ProfileControllerState(
      currentProfile: freezed == currentProfile
          ? _value.currentProfile
          : currentProfile // ignore: cast_nullable_to_non_nullable
              as Profile?,
      availableProfileIds: null == availableProfileIds
          ? _value._availableProfileIds
          : availableProfileIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
    ));
  }
}

/// @nodoc

class _$_ProfileControllerState implements _ProfileControllerState {
  const _$_ProfileControllerState(
      {this.currentProfile, final Set<String> availableProfileIds = const {}})
      : _availableProfileIds = availableProfileIds;

  @override
  final Profile? currentProfile;
  final Set<String> _availableProfileIds;
  @override
  @JsonKey()
  Set<String> get availableProfileIds {
    if (_availableProfileIds is EqualUnmodifiableSetView)
      return _availableProfileIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_availableProfileIds);
  }

  @override
  String toString() {
    return 'ProfileControllerState(currentProfile: $currentProfile, availableProfileIds: $availableProfileIds)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ProfileControllerState &&
            (identical(other.currentProfile, currentProfile) ||
                other.currentProfile == currentProfile) &&
            const DeepCollectionEquality()
                .equals(other._availableProfileIds, _availableProfileIds));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentProfile,
      const DeepCollectionEquality().hash(_availableProfileIds));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ProfileControllerStateCopyWith<_$_ProfileControllerState> get copyWith =>
      __$$_ProfileControllerStateCopyWithImpl<_$_ProfileControllerState>(
          this, _$identity);
}

abstract class _ProfileControllerState implements ProfileControllerState {
  const factory _ProfileControllerState(
      {final Profile? currentProfile,
      final Set<String> availableProfileIds}) = _$_ProfileControllerState;

  @override
  Profile? get currentProfile;
  @override
  Set<String> get availableProfileIds;
  @override
  @JsonKey(ignore: true)
  _$$_ProfileControllerStateCopyWith<_$_ProfileControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}
