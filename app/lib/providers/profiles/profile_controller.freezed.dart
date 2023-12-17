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
  Map<String, String> get displayNameToId => throw _privateConstructorUsedError;

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
      {Profile? currentProfile,
      Set<String> availableProfileIds,
      Map<String, String> displayNameToId});

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
    Object? displayNameToId = null,
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
      displayNameToId: null == displayNameToId
          ? _value.displayNameToId
          : displayNameToId // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
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
abstract class _$$ProfileControllerStateImplCopyWith<$Res>
    implements $ProfileControllerStateCopyWith<$Res> {
  factory _$$ProfileControllerStateImplCopyWith(
          _$ProfileControllerStateImpl value,
          $Res Function(_$ProfileControllerStateImpl) then) =
      __$$ProfileControllerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Profile? currentProfile,
      Set<String> availableProfileIds,
      Map<String, String> displayNameToId});

  @override
  $ProfileCopyWith<$Res>? get currentProfile;
}

/// @nodoc
class __$$ProfileControllerStateImplCopyWithImpl<$Res>
    extends _$ProfileControllerStateCopyWithImpl<$Res,
        _$ProfileControllerStateImpl>
    implements _$$ProfileControllerStateImplCopyWith<$Res> {
  __$$ProfileControllerStateImplCopyWithImpl(
      _$ProfileControllerStateImpl _value,
      $Res Function(_$ProfileControllerStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentProfile = freezed,
    Object? availableProfileIds = null,
    Object? displayNameToId = null,
  }) {
    return _then(_$ProfileControllerStateImpl(
      currentProfile: freezed == currentProfile
          ? _value.currentProfile
          : currentProfile // ignore: cast_nullable_to_non_nullable
              as Profile?,
      availableProfileIds: null == availableProfileIds
          ? _value._availableProfileIds
          : availableProfileIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      displayNameToId: null == displayNameToId
          ? _value._displayNameToId
          : displayNameToId // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
    ));
  }
}

/// @nodoc

class _$ProfileControllerStateImpl implements _ProfileControllerState {
  const _$ProfileControllerStateImpl(
      {this.currentProfile,
      final Set<String> availableProfileIds = const {},
      final Map<String, String> displayNameToId = const {}})
      : _availableProfileIds = availableProfileIds,
        _displayNameToId = displayNameToId;

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

  final Map<String, String> _displayNameToId;
  @override
  @JsonKey()
  Map<String, String> get displayNameToId {
    if (_displayNameToId is EqualUnmodifiableMapView) return _displayNameToId;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_displayNameToId);
  }

  @override
  String toString() {
    return 'ProfileControllerState(currentProfile: $currentProfile, availableProfileIds: $availableProfileIds, displayNameToId: $displayNameToId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProfileControllerStateImpl &&
            (identical(other.currentProfile, currentProfile) ||
                other.currentProfile == currentProfile) &&
            const DeepCollectionEquality()
                .equals(other._availableProfileIds, _availableProfileIds) &&
            const DeepCollectionEquality()
                .equals(other._displayNameToId, _displayNameToId));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentProfile,
      const DeepCollectionEquality().hash(_availableProfileIds),
      const DeepCollectionEquality().hash(_displayNameToId));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProfileControllerStateImplCopyWith<_$ProfileControllerStateImpl>
      get copyWith => __$$ProfileControllerStateImplCopyWithImpl<
          _$ProfileControllerStateImpl>(this, _$identity);
}

abstract class _ProfileControllerState implements ProfileControllerState {
  const factory _ProfileControllerState(
          {final Profile? currentProfile,
          final Set<String> availableProfileIds,
          final Map<String, String> displayNameToId}) =
      _$ProfileControllerStateImpl;

  @override
  Profile? get currentProfile;
  @override
  Set<String> get availableProfileIds;
  @override
  Map<String, String> get displayNameToId;
  @override
  @JsonKey(ignore: true)
  _$$ProfileControllerStateImplCopyWith<_$ProfileControllerStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
