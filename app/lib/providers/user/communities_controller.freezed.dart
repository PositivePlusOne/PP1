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
  String get currentUserId => throw _privateConstructorUsedError;
  String get currentProfileId => throw _privateConstructorUsedError;
  CommunityType get selectedCommunityType => throw _privateConstructorUsedError;
  String get searchQuery => throw _privateConstructorUsedError;
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
      {String currentUserId,
      String currentProfileId,
      CommunityType selectedCommunityType,
      String searchQuery,
      bool isBusy});
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
    Object? currentUserId = null,
    Object? currentProfileId = null,
    Object? selectedCommunityType = null,
    Object? searchQuery = null,
    Object? isBusy = null,
  }) {
    return _then(_value.copyWith(
      currentUserId: null == currentUserId
          ? _value.currentUserId
          : currentUserId // ignore: cast_nullable_to_non_nullable
              as String,
      currentProfileId: null == currentProfileId
          ? _value.currentProfileId
          : currentProfileId // ignore: cast_nullable_to_non_nullable
              as String,
      selectedCommunityType: null == selectedCommunityType
          ? _value.selectedCommunityType
          : selectedCommunityType // ignore: cast_nullable_to_non_nullable
              as CommunityType,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
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
      {String currentUserId,
      String currentProfileId,
      CommunityType selectedCommunityType,
      String searchQuery,
      bool isBusy});
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
    Object? currentUserId = null,
    Object? currentProfileId = null,
    Object? selectedCommunityType = null,
    Object? searchQuery = null,
    Object? isBusy = null,
  }) {
    return _then(_$CommunitiesControllerStateImpl(
      currentUserId: null == currentUserId
          ? _value.currentUserId
          : currentUserId // ignore: cast_nullable_to_non_nullable
              as String,
      currentProfileId: null == currentProfileId
          ? _value.currentProfileId
          : currentProfileId // ignore: cast_nullable_to_non_nullable
              as String,
      selectedCommunityType: null == selectedCommunityType
          ? _value.selectedCommunityType
          : selectedCommunityType // ignore: cast_nullable_to_non_nullable
              as CommunityType,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
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
      {required this.currentUserId,
      required this.currentProfileId,
      required this.selectedCommunityType,
      this.searchQuery = '',
      this.isBusy = false});

  @override
  final String currentUserId;
  @override
  final String currentProfileId;
  @override
  final CommunityType selectedCommunityType;
  @override
  @JsonKey()
  final String searchQuery;
  @override
  @JsonKey()
  final bool isBusy;

  @override
  String toString() {
    return 'CommunitiesControllerState(currentUserId: $currentUserId, currentProfileId: $currentProfileId, selectedCommunityType: $selectedCommunityType, searchQuery: $searchQuery, isBusy: $isBusy)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CommunitiesControllerStateImpl &&
            (identical(other.currentUserId, currentUserId) ||
                other.currentUserId == currentUserId) &&
            (identical(other.currentProfileId, currentProfileId) ||
                other.currentProfileId == currentProfileId) &&
            (identical(other.selectedCommunityType, selectedCommunityType) ||
                other.selectedCommunityType == selectedCommunityType) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentUserId, currentProfileId,
      selectedCommunityType, searchQuery, isBusy);

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
      {required final String currentUserId,
      required final String currentProfileId,
      required final CommunityType selectedCommunityType,
      final String searchQuery,
      final bool isBusy}) = _$CommunitiesControllerStateImpl;

  @override
  String get currentUserId;
  @override
  String get currentProfileId;
  @override
  CommunityType get selectedCommunityType;
  @override
  String get searchQuery;
  @override
  bool get isBusy;
  @override
  @JsonKey(ignore: true)
  _$$CommunitiesControllerStateImplCopyWith<_$CommunitiesControllerStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
