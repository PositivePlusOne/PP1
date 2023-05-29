// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ProfileViewModelState {
  Profile? get profile => throw _privateConstructorUsedError;
  Relationship? get relationship => throw _privateConstructorUsedError;
  bool get isBusy => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ProfileViewModelStateCopyWith<ProfileViewModelState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProfileViewModelStateCopyWith<$Res> {
  factory $ProfileViewModelStateCopyWith(ProfileViewModelState value,
          $Res Function(ProfileViewModelState) then) =
      _$ProfileViewModelStateCopyWithImpl<$Res, ProfileViewModelState>;
  @useResult
  $Res call({Profile? profile, Relationship? relationship, bool isBusy});

  $ProfileCopyWith<$Res>? get profile;
  $RelationshipCopyWith<$Res>? get relationship;
}

/// @nodoc
class _$ProfileViewModelStateCopyWithImpl<$Res,
        $Val extends ProfileViewModelState>
    implements $ProfileViewModelStateCopyWith<$Res> {
  _$ProfileViewModelStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profile = freezed,
    Object? relationship = freezed,
    Object? isBusy = null,
  }) {
    return _then(_value.copyWith(
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as Profile?,
      relationship: freezed == relationship
          ? _value.relationship
          : relationship // ignore: cast_nullable_to_non_nullable
              as Relationship?,
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ProfileCopyWith<$Res>? get profile {
    if (_value.profile == null) {
      return null;
    }

    return $ProfileCopyWith<$Res>(_value.profile!, (value) {
      return _then(_value.copyWith(profile: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $RelationshipCopyWith<$Res>? get relationship {
    if (_value.relationship == null) {
      return null;
    }

    return $RelationshipCopyWith<$Res>(_value.relationship!, (value) {
      return _then(_value.copyWith(relationship: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_ProfileViewModelStateCopyWith<$Res>
    implements $ProfileViewModelStateCopyWith<$Res> {
  factory _$$_ProfileViewModelStateCopyWith(_$_ProfileViewModelState value,
          $Res Function(_$_ProfileViewModelState) then) =
      __$$_ProfileViewModelStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Profile? profile, Relationship? relationship, bool isBusy});

  @override
  $ProfileCopyWith<$Res>? get profile;
  @override
  $RelationshipCopyWith<$Res>? get relationship;
}

/// @nodoc
class __$$_ProfileViewModelStateCopyWithImpl<$Res>
    extends _$ProfileViewModelStateCopyWithImpl<$Res, _$_ProfileViewModelState>
    implements _$$_ProfileViewModelStateCopyWith<$Res> {
  __$$_ProfileViewModelStateCopyWithImpl(_$_ProfileViewModelState _value,
      $Res Function(_$_ProfileViewModelState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profile = freezed,
    Object? relationship = freezed,
    Object? isBusy = null,
  }) {
    return _then(_$_ProfileViewModelState(
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as Profile?,
      relationship: freezed == relationship
          ? _value.relationship
          : relationship // ignore: cast_nullable_to_non_nullable
              as Relationship?,
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_ProfileViewModelState implements _ProfileViewModelState {
  const _$_ProfileViewModelState(
      {this.profile, this.relationship, this.isBusy = false});

  @override
  final Profile? profile;
  @override
  final Relationship? relationship;
  @override
  @JsonKey()
  final bool isBusy;

  @override
  String toString() {
    return 'ProfileViewModelState(profile: $profile, relationship: $relationship, isBusy: $isBusy)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ProfileViewModelState &&
            (identical(other.profile, profile) || other.profile == profile) &&
            (identical(other.relationship, relationship) ||
                other.relationship == relationship) &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy));
  }

  @override
  int get hashCode => Object.hash(runtimeType, profile, relationship, isBusy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ProfileViewModelStateCopyWith<_$_ProfileViewModelState> get copyWith =>
      __$$_ProfileViewModelStateCopyWithImpl<_$_ProfileViewModelState>(
          this, _$identity);
}

abstract class _ProfileViewModelState implements ProfileViewModelState {
  const factory _ProfileViewModelState(
      {final Profile? profile,
      final Relationship? relationship,
      final bool isBusy}) = _$_ProfileViewModelState;

  @override
  Profile? get profile;
  @override
  Relationship? get relationship;
  @override
  bool get isBusy;
  @override
  @JsonKey(ignore: true)
  _$$_ProfileViewModelStateCopyWith<_$_ProfileViewModelState> get copyWith =>
      throw _privateConstructorUsedError;
}
