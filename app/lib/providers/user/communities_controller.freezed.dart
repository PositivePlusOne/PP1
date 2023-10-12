// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'communities_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$CommunitiesControllerState {
  User? get currentUser => throw _privateConstructorUsedError;
  Profile? get currentProfile => throw _privateConstructorUsedError;
  CommunityType get selectedCommunityType => throw _privateConstructorUsedError;
  bool get isBusy => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CommunitiesControllerStateCopyWith<CommunitiesControllerState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommunitiesControllerStateCopyWith<$Res> {
  factory $CommunitiesControllerStateCopyWith(CommunitiesControllerState value,
          $Res Function(CommunitiesControllerState) then) =
      _$CommunitiesControllerStateCopyWithImpl<$Res,
          CommunitiesControllerState>;
  @useResult
  $Res call(
      {User? currentUser,
      Profile? currentProfile,
      CommunityType selectedCommunityType,
      bool isBusy});

  $ProfileCopyWith<$Res>? get currentProfile;
}

/// @nodoc
class _$CommunitiesControllerStateCopyWithImpl<$Res,
        $Val extends CommunitiesControllerState>
    implements $CommunitiesControllerStateCopyWith<$Res> {
  _$CommunitiesControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentUser = freezed,
    Object? currentProfile = freezed,
    Object? selectedCommunityType = null,
    Object? isBusy = null,
  }) {
    return _then(_value.copyWith(
      currentUser: freezed == currentUser
          ? _value.currentUser
          : currentUser // ignore: cast_nullable_to_non_nullable
              as User?,
      currentProfile: freezed == currentProfile
          ? _value.currentProfile
          : currentProfile // ignore: cast_nullable_to_non_nullable
              as Profile?,
      selectedCommunityType: null == selectedCommunityType
          ? _value.selectedCommunityType
          : selectedCommunityType // ignore: cast_nullable_to_non_nullable
              as CommunityType,
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
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
abstract class _$$CommunitiesControllerStateImplCopyWith<$Res>
    implements $CommunitiesControllerStateCopyWith<$Res> {
  factory _$$CommunitiesControllerStateImplCopyWith(
          _$CommunitiesControllerStateImpl value,
          $Res Function(_$CommunitiesControllerStateImpl) then) =
      __$$CommunitiesControllerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {User? currentUser,
      Profile? currentProfile,
      CommunityType selectedCommunityType,
      bool isBusy});

  @override
  $ProfileCopyWith<$Res>? get currentProfile;
}

/// @nodoc
class __$$CommunitiesControllerStateImplCopyWithImpl<$Res>
    extends _$CommunitiesControllerStateCopyWithImpl<$Res,
        _$CommunitiesControllerStateImpl>
    implements _$$CommunitiesControllerStateImplCopyWith<$Res> {
  __$$CommunitiesControllerStateImplCopyWithImpl(
      _$CommunitiesControllerStateImpl _value,
      $Res Function(_$CommunitiesControllerStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentUser = freezed,
    Object? currentProfile = freezed,
    Object? selectedCommunityType = null,
    Object? isBusy = null,
  }) {
    return _then(_$CommunitiesControllerStateImpl(
      currentUser: freezed == currentUser
          ? _value.currentUser
          : currentUser // ignore: cast_nullable_to_non_nullable
              as User?,
      currentProfile: freezed == currentProfile
          ? _value.currentProfile
          : currentProfile // ignore: cast_nullable_to_non_nullable
              as Profile?,
      selectedCommunityType: null == selectedCommunityType
          ? _value.selectedCommunityType
          : selectedCommunityType // ignore: cast_nullable_to_non_nullable
              as CommunityType,
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$CommunitiesControllerStateImpl implements _CommunitiesControllerState {
  const _$CommunitiesControllerStateImpl(
      {required this.currentUser,
      required this.currentProfile,
      required this.selectedCommunityType,
      this.isBusy = false});

  @override
  final User? currentUser;
  @override
  final Profile? currentProfile;
  @override
  final CommunityType selectedCommunityType;
  @override
  @JsonKey()
  final bool isBusy;

  @override
  String toString() {
    return 'CommunitiesControllerState(currentUser: $currentUser, currentProfile: $currentProfile, selectedCommunityType: $selectedCommunityType, isBusy: $isBusy)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommunitiesControllerStateImpl &&
            (identical(other.currentUser, currentUser) ||
                other.currentUser == currentUser) &&
            (identical(other.currentProfile, currentProfile) ||
                other.currentProfile == currentProfile) &&
            (identical(other.selectedCommunityType, selectedCommunityType) ||
                other.selectedCommunityType == selectedCommunityType) &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, currentUser, currentProfile, selectedCommunityType, isBusy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CommunitiesControllerStateImplCopyWith<_$CommunitiesControllerStateImpl>
      get copyWith => __$$CommunitiesControllerStateImplCopyWithImpl<
          _$CommunitiesControllerStateImpl>(this, _$identity);
}

abstract class _CommunitiesControllerState
    implements CommunitiesControllerState {
  const factory _CommunitiesControllerState(
      {required final User? currentUser,
      required final Profile? currentProfile,
      required final CommunityType selectedCommunityType,
      final bool isBusy}) = _$CommunitiesControllerStateImpl;

  @override
  User? get currentUser;
  @override
  Profile? get currentProfile;
  @override
  CommunityType get selectedCommunityType;
  @override
  bool get isBusy;
  @override
  @JsonKey(ignore: true)
  _$$CommunitiesControllerStateImplCopyWith<_$CommunitiesControllerStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
