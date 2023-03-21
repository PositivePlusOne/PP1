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
  bool get isBusy => throw _privateConstructorUsedError;
  UserProfile? get userProfile => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;

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
  $Res call({bool isBusy, UserProfile? userProfile, String userId});

  $UserProfileCopyWith<$Res>? get userProfile;
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
    Object? isBusy = null,
    Object? userProfile = freezed,
    Object? userId = null,
  }) {
    return _then(_value.copyWith(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      userProfile: freezed == userProfile
          ? _value.userProfile
          : userProfile // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
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
abstract class _$$_ProfileViewModelStateCopyWith<$Res>
    implements $ProfileViewModelStateCopyWith<$Res> {
  factory _$$_ProfileViewModelStateCopyWith(_$_ProfileViewModelState value,
          $Res Function(_$_ProfileViewModelState) then) =
      __$$_ProfileViewModelStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isBusy, UserProfile? userProfile, String userId});

  @override
  $UserProfileCopyWith<$Res>? get userProfile;
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
    Object? isBusy = null,
    Object? userProfile = freezed,
    Object? userId = null,
  }) {
    return _then(_$_ProfileViewModelState(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      userProfile: freezed == userProfile
          ? _value.userProfile
          : userProfile // ignore: cast_nullable_to_non_nullable
              as UserProfile?,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_ProfileViewModelState implements _ProfileViewModelState {
  const _$_ProfileViewModelState(
      {this.isBusy = false, this.userProfile, required this.userId});

  @override
  @JsonKey()
  final bool isBusy;
  @override
  final UserProfile? userProfile;
  @override
  final String userId;

  @override
  String toString() {
    return 'ProfileViewModelState(isBusy: $isBusy, userProfile: $userProfile, userId: $userId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ProfileViewModelState &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy) &&
            (identical(other.userProfile, userProfile) ||
                other.userProfile == userProfile) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isBusy, userProfile, userId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ProfileViewModelStateCopyWith<_$_ProfileViewModelState> get copyWith =>
      __$$_ProfileViewModelStateCopyWithImpl<_$_ProfileViewModelState>(
          this, _$identity);
}

abstract class _ProfileViewModelState implements ProfileViewModelState {
  const factory _ProfileViewModelState(
      {final bool isBusy,
      final UserProfile? userProfile,
      required final String userId}) = _$_ProfileViewModelState;

  @override
  bool get isBusy;
  @override
  UserProfile? get userProfile;
  @override
  String get userId;
  @override
  @JsonKey(ignore: true)
  _$$_ProfileViewModelStateCopyWith<_$_ProfileViewModelState> get copyWith =>
      throw _privateConstructorUsedError;
}
