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
  Profile? get userProfile => throw _privateConstructorUsedError;
  List<Profile> get organisationProfiles => throw _privateConstructorUsedError;

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
  $Res call({Profile? userProfile, List<Profile> organisationProfiles});

  $ProfileCopyWith<$Res>? get userProfile;
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
    Object? organisationProfiles = null,
  }) {
    return _then(_value.copyWith(
      userProfile: freezed == userProfile
          ? _value.userProfile
          : userProfile // ignore: cast_nullable_to_non_nullable
              as Profile?,
      organisationProfiles: null == organisationProfiles
          ? _value.organisationProfiles
          : organisationProfiles // ignore: cast_nullable_to_non_nullable
              as List<Profile>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ProfileCopyWith<$Res>? get userProfile {
    if (_value.userProfile == null) {
      return null;
    }

    return $ProfileCopyWith<$Res>(_value.userProfile!, (value) {
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
  $Res call({Profile? userProfile, List<Profile> organisationProfiles});

  @override
  $ProfileCopyWith<$Res>? get userProfile;
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
    Object? organisationProfiles = null,
  }) {
    return _then(_$_ProfileControllerState(
      userProfile: freezed == userProfile
          ? _value.userProfile
          : userProfile // ignore: cast_nullable_to_non_nullable
              as Profile?,
      organisationProfiles: null == organisationProfiles
          ? _value._organisationProfiles
          : organisationProfiles // ignore: cast_nullable_to_non_nullable
              as List<Profile>,
    ));
  }
}

/// @nodoc

class _$_ProfileControllerState implements _ProfileControllerState {
  const _$_ProfileControllerState(
      {this.userProfile, required final List<Profile> organisationProfiles})
      : _organisationProfiles = organisationProfiles;

  @override
  final Profile? userProfile;
  final List<Profile> _organisationProfiles;
  @override
  List<Profile> get organisationProfiles {
    if (_organisationProfiles is EqualUnmodifiableListView)
      return _organisationProfiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_organisationProfiles);
  }

  @override
  String toString() {
    return 'ProfileControllerState(userProfile: $userProfile, organisationProfiles: $organisationProfiles)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ProfileControllerState &&
            (identical(other.userProfile, userProfile) ||
                other.userProfile == userProfile) &&
            const DeepCollectionEquality()
                .equals(other._organisationProfiles, _organisationProfiles));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userProfile,
      const DeepCollectionEquality().hash(_organisationProfiles));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ProfileControllerStateCopyWith<_$_ProfileControllerState> get copyWith =>
      __$$_ProfileControllerStateCopyWithImpl<_$_ProfileControllerState>(
          this, _$identity);
}

abstract class _ProfileControllerState implements ProfileControllerState {
  const factory _ProfileControllerState(
          {final Profile? userProfile,
          required final List<Profile> organisationProfiles}) =
      _$_ProfileControllerState;

  @override
  Profile? get userProfile;
  @override
  List<Profile> get organisationProfiles;
  @override
  @JsonKey(ignore: true)
  _$$_ProfileControllerStateCopyWith<_$_ProfileControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}
