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
  Set<String> get followerProfileIds => throw _privateConstructorUsedError;
  String get followerPaginationCursor => throw _privateConstructorUsedError;
  bool get hasMoreFollowers => throw _privateConstructorUsedError;
  Set<String> get followingProfileIds => throw _privateConstructorUsedError;
  String get followingPaginationCursor => throw _privateConstructorUsedError;
  bool get hasMoreFollowing => throw _privateConstructorUsedError;
  Set<String> get blockedProfileIds => throw _privateConstructorUsedError;
  String get blockedPaginationCursor => throw _privateConstructorUsedError;
  bool get hasMoreBlocked => throw _privateConstructorUsedError;
  Set<String> get connectedProfileIds => throw _privateConstructorUsedError;
  String get connectedPaginationCursor => throw _privateConstructorUsedError;
  bool get hasMoreConnected => throw _privateConstructorUsedError;
  Set<String> get managedProfileIds => throw _privateConstructorUsedError;
  String get managedPaginationCursor => throw _privateConstructorUsedError;
  bool get hasMoreManaged => throw _privateConstructorUsedError;

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
      bool isBusy,
      Set<String> followerProfileIds,
      String followerPaginationCursor,
      bool hasMoreFollowers,
      Set<String> followingProfileIds,
      String followingPaginationCursor,
      bool hasMoreFollowing,
      Set<String> blockedProfileIds,
      String blockedPaginationCursor,
      bool hasMoreBlocked,
      Set<String> connectedProfileIds,
      String connectedPaginationCursor,
      bool hasMoreConnected,
      Set<String> managedProfileIds,
      String managedPaginationCursor,
      bool hasMoreManaged});

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
    Object? followerProfileIds = null,
    Object? followerPaginationCursor = null,
    Object? hasMoreFollowers = null,
    Object? followingProfileIds = null,
    Object? followingPaginationCursor = null,
    Object? hasMoreFollowing = null,
    Object? blockedProfileIds = null,
    Object? blockedPaginationCursor = null,
    Object? hasMoreBlocked = null,
    Object? connectedProfileIds = null,
    Object? connectedPaginationCursor = null,
    Object? hasMoreConnected = null,
    Object? managedProfileIds = null,
    Object? managedPaginationCursor = null,
    Object? hasMoreManaged = null,
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
      followerProfileIds: null == followerProfileIds
          ? _value.followerProfileIds
          : followerProfileIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      followerPaginationCursor: null == followerPaginationCursor
          ? _value.followerPaginationCursor
          : followerPaginationCursor // ignore: cast_nullable_to_non_nullable
              as String,
      hasMoreFollowers: null == hasMoreFollowers
          ? _value.hasMoreFollowers
          : hasMoreFollowers // ignore: cast_nullable_to_non_nullable
              as bool,
      followingProfileIds: null == followingProfileIds
          ? _value.followingProfileIds
          : followingProfileIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      followingPaginationCursor: null == followingPaginationCursor
          ? _value.followingPaginationCursor
          : followingPaginationCursor // ignore: cast_nullable_to_non_nullable
              as String,
      hasMoreFollowing: null == hasMoreFollowing
          ? _value.hasMoreFollowing
          : hasMoreFollowing // ignore: cast_nullable_to_non_nullable
              as bool,
      blockedProfileIds: null == blockedProfileIds
          ? _value.blockedProfileIds
          : blockedProfileIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      blockedPaginationCursor: null == blockedPaginationCursor
          ? _value.blockedPaginationCursor
          : blockedPaginationCursor // ignore: cast_nullable_to_non_nullable
              as String,
      hasMoreBlocked: null == hasMoreBlocked
          ? _value.hasMoreBlocked
          : hasMoreBlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      connectedProfileIds: null == connectedProfileIds
          ? _value.connectedProfileIds
          : connectedProfileIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      connectedPaginationCursor: null == connectedPaginationCursor
          ? _value.connectedPaginationCursor
          : connectedPaginationCursor // ignore: cast_nullable_to_non_nullable
              as String,
      hasMoreConnected: null == hasMoreConnected
          ? _value.hasMoreConnected
          : hasMoreConnected // ignore: cast_nullable_to_non_nullable
              as bool,
      managedProfileIds: null == managedProfileIds
          ? _value.managedProfileIds
          : managedProfileIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      managedPaginationCursor: null == managedPaginationCursor
          ? _value.managedPaginationCursor
          : managedPaginationCursor // ignore: cast_nullable_to_non_nullable
              as String,
      hasMoreManaged: null == hasMoreManaged
          ? _value.hasMoreManaged
          : hasMoreManaged // ignore: cast_nullable_to_non_nullable
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
      bool isBusy,
      Set<String> followerProfileIds,
      String followerPaginationCursor,
      bool hasMoreFollowers,
      Set<String> followingProfileIds,
      String followingPaginationCursor,
      bool hasMoreFollowing,
      Set<String> blockedProfileIds,
      String blockedPaginationCursor,
      bool hasMoreBlocked,
      Set<String> connectedProfileIds,
      String connectedPaginationCursor,
      bool hasMoreConnected,
      Set<String> managedProfileIds,
      String managedPaginationCursor,
      bool hasMoreManaged});

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
    Object? followerProfileIds = null,
    Object? followerPaginationCursor = null,
    Object? hasMoreFollowers = null,
    Object? followingProfileIds = null,
    Object? followingPaginationCursor = null,
    Object? hasMoreFollowing = null,
    Object? blockedProfileIds = null,
    Object? blockedPaginationCursor = null,
    Object? hasMoreBlocked = null,
    Object? connectedProfileIds = null,
    Object? connectedPaginationCursor = null,
    Object? hasMoreConnected = null,
    Object? managedProfileIds = null,
    Object? managedPaginationCursor = null,
    Object? hasMoreManaged = null,
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
      followerProfileIds: null == followerProfileIds
          ? _value._followerProfileIds
          : followerProfileIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      followerPaginationCursor: null == followerPaginationCursor
          ? _value.followerPaginationCursor
          : followerPaginationCursor // ignore: cast_nullable_to_non_nullable
              as String,
      hasMoreFollowers: null == hasMoreFollowers
          ? _value.hasMoreFollowers
          : hasMoreFollowers // ignore: cast_nullable_to_non_nullable
              as bool,
      followingProfileIds: null == followingProfileIds
          ? _value._followingProfileIds
          : followingProfileIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      followingPaginationCursor: null == followingPaginationCursor
          ? _value.followingPaginationCursor
          : followingPaginationCursor // ignore: cast_nullable_to_non_nullable
              as String,
      hasMoreFollowing: null == hasMoreFollowing
          ? _value.hasMoreFollowing
          : hasMoreFollowing // ignore: cast_nullable_to_non_nullable
              as bool,
      blockedProfileIds: null == blockedProfileIds
          ? _value._blockedProfileIds
          : blockedProfileIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      blockedPaginationCursor: null == blockedPaginationCursor
          ? _value.blockedPaginationCursor
          : blockedPaginationCursor // ignore: cast_nullable_to_non_nullable
              as String,
      hasMoreBlocked: null == hasMoreBlocked
          ? _value.hasMoreBlocked
          : hasMoreBlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      connectedProfileIds: null == connectedProfileIds
          ? _value._connectedProfileIds
          : connectedProfileIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      connectedPaginationCursor: null == connectedPaginationCursor
          ? _value.connectedPaginationCursor
          : connectedPaginationCursor // ignore: cast_nullable_to_non_nullable
              as String,
      hasMoreConnected: null == hasMoreConnected
          ? _value.hasMoreConnected
          : hasMoreConnected // ignore: cast_nullable_to_non_nullable
              as bool,
      managedProfileIds: null == managedProfileIds
          ? _value._managedProfileIds
          : managedProfileIds // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      managedPaginationCursor: null == managedPaginationCursor
          ? _value.managedPaginationCursor
          : managedPaginationCursor // ignore: cast_nullable_to_non_nullable
              as String,
      hasMoreManaged: null == hasMoreManaged
          ? _value.hasMoreManaged
          : hasMoreManaged // ignore: cast_nullable_to_non_nullable
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
      this.isBusy = false,
      final Set<String> followerProfileIds = const {},
      this.followerPaginationCursor = '',
      this.hasMoreFollowers = true,
      final Set<String> followingProfileIds = const {},
      this.followingPaginationCursor = '',
      this.hasMoreFollowing = true,
      final Set<String> blockedProfileIds = const {},
      this.blockedPaginationCursor = '',
      this.hasMoreBlocked = true,
      final Set<String> connectedProfileIds = const {},
      this.connectedPaginationCursor = '',
      this.hasMoreConnected = true,
      final Set<String> managedProfileIds = const {},
      this.managedPaginationCursor = '',
      this.hasMoreManaged = true})
      : _followerProfileIds = followerProfileIds,
        _followingProfileIds = followingProfileIds,
        _blockedProfileIds = blockedProfileIds,
        _connectedProfileIds = connectedProfileIds,
        _managedProfileIds = managedProfileIds;

  @override
  final User? currentUser;
  @override
  final Profile? currentProfile;
  @override
  final CommunityType selectedCommunityType;
  @override
  @JsonKey()
  final bool isBusy;
  final Set<String> _followerProfileIds;
  @override
  @JsonKey()
  Set<String> get followerProfileIds {
    if (_followerProfileIds is EqualUnmodifiableSetView)
      return _followerProfileIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_followerProfileIds);
  }

  @override
  @JsonKey()
  final String followerPaginationCursor;
  @override
  @JsonKey()
  final bool hasMoreFollowers;
  final Set<String> _followingProfileIds;
  @override
  @JsonKey()
  Set<String> get followingProfileIds {
    if (_followingProfileIds is EqualUnmodifiableSetView)
      return _followingProfileIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_followingProfileIds);
  }

  @override
  @JsonKey()
  final String followingPaginationCursor;
  @override
  @JsonKey()
  final bool hasMoreFollowing;
  final Set<String> _blockedProfileIds;
  @override
  @JsonKey()
  Set<String> get blockedProfileIds {
    if (_blockedProfileIds is EqualUnmodifiableSetView)
      return _blockedProfileIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_blockedProfileIds);
  }

  @override
  @JsonKey()
  final String blockedPaginationCursor;
  @override
  @JsonKey()
  final bool hasMoreBlocked;
  final Set<String> _connectedProfileIds;
  @override
  @JsonKey()
  Set<String> get connectedProfileIds {
    if (_connectedProfileIds is EqualUnmodifiableSetView)
      return _connectedProfileIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_connectedProfileIds);
  }

  @override
  @JsonKey()
  final String connectedPaginationCursor;
  @override
  @JsonKey()
  final bool hasMoreConnected;
  final Set<String> _managedProfileIds;
  @override
  @JsonKey()
  Set<String> get managedProfileIds {
    if (_managedProfileIds is EqualUnmodifiableSetView)
      return _managedProfileIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_managedProfileIds);
  }

  @override
  @JsonKey()
  final String managedPaginationCursor;
  @override
  @JsonKey()
  final bool hasMoreManaged;

  @override
  String toString() {
    return 'CommunitiesControllerState(currentUser: $currentUser, currentProfile: $currentProfile, selectedCommunityType: $selectedCommunityType, isBusy: $isBusy, followerProfileIds: $followerProfileIds, followerPaginationCursor: $followerPaginationCursor, hasMoreFollowers: $hasMoreFollowers, followingProfileIds: $followingProfileIds, followingPaginationCursor: $followingPaginationCursor, hasMoreFollowing: $hasMoreFollowing, blockedProfileIds: $blockedProfileIds, blockedPaginationCursor: $blockedPaginationCursor, hasMoreBlocked: $hasMoreBlocked, connectedProfileIds: $connectedProfileIds, connectedPaginationCursor: $connectedPaginationCursor, hasMoreConnected: $hasMoreConnected, managedProfileIds: $managedProfileIds, managedPaginationCursor: $managedPaginationCursor, hasMoreManaged: $hasMoreManaged)';
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
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy) &&
            const DeepCollectionEquality()
                .equals(other._followerProfileIds, _followerProfileIds) &&
            (identical(
                    other.followerPaginationCursor, followerPaginationCursor) ||
                other.followerPaginationCursor == followerPaginationCursor) &&
            (identical(other.hasMoreFollowers, hasMoreFollowers) ||
                other.hasMoreFollowers == hasMoreFollowers) &&
            const DeepCollectionEquality()
                .equals(other._followingProfileIds, _followingProfileIds) &&
            (identical(other.followingPaginationCursor,
                    followingPaginationCursor) ||
                other.followingPaginationCursor == followingPaginationCursor) &&
            (identical(other.hasMoreFollowing, hasMoreFollowing) ||
                other.hasMoreFollowing == hasMoreFollowing) &&
            const DeepCollectionEquality()
                .equals(other._blockedProfileIds, _blockedProfileIds) &&
            (identical(other.blockedPaginationCursor, blockedPaginationCursor) ||
                other.blockedPaginationCursor == blockedPaginationCursor) &&
            (identical(other.hasMoreBlocked, hasMoreBlocked) ||
                other.hasMoreBlocked == hasMoreBlocked) &&
            const DeepCollectionEquality()
                .equals(other._connectedProfileIds, _connectedProfileIds) &&
            (identical(other.connectedPaginationCursor,
                    connectedPaginationCursor) ||
                other.connectedPaginationCursor == connectedPaginationCursor) &&
            (identical(other.hasMoreConnected, hasMoreConnected) ||
                other.hasMoreConnected == hasMoreConnected) &&
            const DeepCollectionEquality()
                .equals(other._managedProfileIds, _managedProfileIds) &&
            (identical(other.managedPaginationCursor, managedPaginationCursor) ||
                other.managedPaginationCursor == managedPaginationCursor) &&
            (identical(other.hasMoreManaged, hasMoreManaged) ||
                other.hasMoreManaged == hasMoreManaged));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        currentUser,
        currentProfile,
        selectedCommunityType,
        isBusy,
        const DeepCollectionEquality().hash(_followerProfileIds),
        followerPaginationCursor,
        hasMoreFollowers,
        const DeepCollectionEquality().hash(_followingProfileIds),
        followingPaginationCursor,
        hasMoreFollowing,
        const DeepCollectionEquality().hash(_blockedProfileIds),
        blockedPaginationCursor,
        hasMoreBlocked,
        const DeepCollectionEquality().hash(_connectedProfileIds),
        connectedPaginationCursor,
        hasMoreConnected,
        const DeepCollectionEquality().hash(_managedProfileIds),
        managedPaginationCursor,
        hasMoreManaged
      ]);

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
      final bool isBusy,
      final Set<String> followerProfileIds,
      final String followerPaginationCursor,
      final bool hasMoreFollowers,
      final Set<String> followingProfileIds,
      final String followingPaginationCursor,
      final bool hasMoreFollowing,
      final Set<String> blockedProfileIds,
      final String blockedPaginationCursor,
      final bool hasMoreBlocked,
      final Set<String> connectedProfileIds,
      final String connectedPaginationCursor,
      final bool hasMoreConnected,
      final Set<String> managedProfileIds,
      final String managedPaginationCursor,
      final bool hasMoreManaged}) = _$CommunitiesControllerStateImpl;

  @override
  User? get currentUser;
  @override
  Profile? get currentProfile;
  @override
  CommunityType get selectedCommunityType;
  @override
  bool get isBusy;
  @override
  Set<String> get followerProfileIds;
  @override
  String get followerPaginationCursor;
  @override
  bool get hasMoreFollowers;
  @override
  Set<String> get followingProfileIds;
  @override
  String get followingPaginationCursor;
  @override
  bool get hasMoreFollowing;
  @override
  Set<String> get blockedProfileIds;
  @override
  String get blockedPaginationCursor;
  @override
  bool get hasMoreBlocked;
  @override
  Set<String> get connectedProfileIds;
  @override
  String get connectedPaginationCursor;
  @override
  bool get hasMoreConnected;
  @override
  Set<String> get managedProfileIds;
  @override
  String get managedPaginationCursor;
  @override
  bool get hasMoreManaged;
  @override
  @JsonKey(ignore: true)
  _$$CommunitiesControllerStateImplCopyWith<_$CommunitiesControllerStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
