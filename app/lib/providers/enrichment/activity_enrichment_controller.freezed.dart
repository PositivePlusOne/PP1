// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_enrichment_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ActivityEnrichmentControllerState {
  String? get currentProfileId => throw _privateConstructorUsedError;
  Map<String, List<String>> get activityEnrichmentTags =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ActivityEnrichmentControllerStateCopyWith<ActivityEnrichmentControllerState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityEnrichmentControllerStateCopyWith<$Res> {
  factory $ActivityEnrichmentControllerStateCopyWith(
          ActivityEnrichmentControllerState value,
          $Res Function(ActivityEnrichmentControllerState) then) =
      _$ActivityEnrichmentControllerStateCopyWithImpl<$Res,
          ActivityEnrichmentControllerState>;
  @useResult
  $Res call(
      {String? currentProfileId,
      Map<String, List<String>> activityEnrichmentTags});
}

/// @nodoc
class _$ActivityEnrichmentControllerStateCopyWithImpl<$Res,
        $Val extends ActivityEnrichmentControllerState>
    implements $ActivityEnrichmentControllerStateCopyWith<$Res> {
  _$ActivityEnrichmentControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentProfileId = freezed,
    Object? activityEnrichmentTags = null,
  }) {
    return _then(_value.copyWith(
      currentProfileId: freezed == currentProfileId
          ? _value.currentProfileId
          : currentProfileId // ignore: cast_nullable_to_non_nullable
              as String?,
      activityEnrichmentTags: null == activityEnrichmentTags
          ? _value.activityEnrichmentTags
          : activityEnrichmentTags // ignore: cast_nullable_to_non_nullable
              as Map<String, List<String>>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActivityEnrichmentControllerStateImplCopyWith<$Res>
    implements $ActivityEnrichmentControllerStateCopyWith<$Res> {
  factory _$$ActivityEnrichmentControllerStateImplCopyWith(
          _$ActivityEnrichmentControllerStateImpl value,
          $Res Function(_$ActivityEnrichmentControllerStateImpl) then) =
      __$$ActivityEnrichmentControllerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? currentProfileId,
      Map<String, List<String>> activityEnrichmentTags});
}

/// @nodoc
class __$$ActivityEnrichmentControllerStateImplCopyWithImpl<$Res>
    extends _$ActivityEnrichmentControllerStateCopyWithImpl<$Res,
        _$ActivityEnrichmentControllerStateImpl>
    implements _$$ActivityEnrichmentControllerStateImplCopyWith<$Res> {
  __$$ActivityEnrichmentControllerStateImplCopyWithImpl(
      _$ActivityEnrichmentControllerStateImpl _value,
      $Res Function(_$ActivityEnrichmentControllerStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentProfileId = freezed,
    Object? activityEnrichmentTags = null,
  }) {
    return _then(_$ActivityEnrichmentControllerStateImpl(
      currentProfileId: freezed == currentProfileId
          ? _value.currentProfileId
          : currentProfileId // ignore: cast_nullable_to_non_nullable
              as String?,
      activityEnrichmentTags: null == activityEnrichmentTags
          ? _value._activityEnrichmentTags
          : activityEnrichmentTags // ignore: cast_nullable_to_non_nullable
              as Map<String, List<String>>,
    ));
  }
}

/// @nodoc

class _$ActivityEnrichmentControllerStateImpl
    implements _ActivityEnrichmentControllerState {
  const _$ActivityEnrichmentControllerStateImpl(
      {required this.currentProfileId,
      final Map<String, List<String>> activityEnrichmentTags = const {}})
      : _activityEnrichmentTags = activityEnrichmentTags;

  @override
  final String? currentProfileId;
  final Map<String, List<String>> _activityEnrichmentTags;
  @override
  @JsonKey()
  Map<String, List<String>> get activityEnrichmentTags {
    if (_activityEnrichmentTags is EqualUnmodifiableMapView)
      return _activityEnrichmentTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_activityEnrichmentTags);
  }

  @override
  String toString() {
    return 'ActivityEnrichmentControllerState(currentProfileId: $currentProfileId, activityEnrichmentTags: $activityEnrichmentTags)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityEnrichmentControllerStateImpl &&
            (identical(other.currentProfileId, currentProfileId) ||
                other.currentProfileId == currentProfileId) &&
            const DeepCollectionEquality().equals(
                other._activityEnrichmentTags, _activityEnrichmentTags));
  }

  @override
  int get hashCode => Object.hash(runtimeType, currentProfileId,
      const DeepCollectionEquality().hash(_activityEnrichmentTags));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityEnrichmentControllerStateImplCopyWith<
          _$ActivityEnrichmentControllerStateImpl>
      get copyWith => __$$ActivityEnrichmentControllerStateImplCopyWithImpl<
          _$ActivityEnrichmentControllerStateImpl>(this, _$identity);
}

abstract class _ActivityEnrichmentControllerState
    implements ActivityEnrichmentControllerState {
  const factory _ActivityEnrichmentControllerState(
          {required final String? currentProfileId,
          final Map<String, List<String>> activityEnrichmentTags}) =
      _$ActivityEnrichmentControllerStateImpl;

  @override
  String? get currentProfileId;
  @override
  Map<String, List<String>> get activityEnrichmentTags;
  @override
  @JsonKey(ignore: true)
  _$$ActivityEnrichmentControllerStateImplCopyWith<
          _$ActivityEnrichmentControllerStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ActivityEnrichmentTagAction {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() openPost,
    required TResult Function() viewPostExtended,
    required TResult Function() commentPost,
    required TResult Function() likePost,
    required TResult Function() bookmarkPost,
    required TResult Function() sharePost,
    required TResult Function() followPublisher,
    required TResult Function() connectPublisher,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? openPost,
    TResult? Function()? viewPostExtended,
    TResult? Function()? commentPost,
    TResult? Function()? likePost,
    TResult? Function()? bookmarkPost,
    TResult? Function()? sharePost,
    TResult? Function()? followPublisher,
    TResult? Function()? connectPublisher,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? openPost,
    TResult Function()? viewPostExtended,
    TResult Function()? commentPost,
    TResult Function()? likePost,
    TResult Function()? bookmarkPost,
    TResult Function()? sharePost,
    TResult Function()? followPublisher,
    TResult Function()? connectPublisher,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ActivityEnrichmentTagActionOpenPost value)
        openPost,
    required TResult Function(
            _ActivityEnrichmentTagActionViewPostExtended value)
        viewPostExtended,
    required TResult Function(_ActivityEnrichmentTagActionCommentPost value)
        commentPost,
    required TResult Function(_ActivityEnrichmentTagActionLikePost value)
        likePost,
    required TResult Function(_ActivityEnrichmentTagActionBookmarkPost value)
        bookmarkPost,
    required TResult Function(_ActivityEnrichmentTagActionSharePost value)
        sharePost,
    required TResult Function(_ActivityEnrichmentTagActionFollowPublisher value)
        followPublisher,
    required TResult Function(
            _ActivityEnrichmentTagActionConnectPublisher value)
        connectPublisher,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ActivityEnrichmentTagActionOpenPost value)? openPost,
    TResult? Function(_ActivityEnrichmentTagActionViewPostExtended value)?
        viewPostExtended,
    TResult? Function(_ActivityEnrichmentTagActionCommentPost value)?
        commentPost,
    TResult? Function(_ActivityEnrichmentTagActionLikePost value)? likePost,
    TResult? Function(_ActivityEnrichmentTagActionBookmarkPost value)?
        bookmarkPost,
    TResult? Function(_ActivityEnrichmentTagActionSharePost value)? sharePost,
    TResult? Function(_ActivityEnrichmentTagActionFollowPublisher value)?
        followPublisher,
    TResult? Function(_ActivityEnrichmentTagActionConnectPublisher value)?
        connectPublisher,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ActivityEnrichmentTagActionOpenPost value)? openPost,
    TResult Function(_ActivityEnrichmentTagActionViewPostExtended value)?
        viewPostExtended,
    TResult Function(_ActivityEnrichmentTagActionCommentPost value)?
        commentPost,
    TResult Function(_ActivityEnrichmentTagActionLikePost value)? likePost,
    TResult Function(_ActivityEnrichmentTagActionBookmarkPost value)?
        bookmarkPost,
    TResult Function(_ActivityEnrichmentTagActionSharePost value)? sharePost,
    TResult Function(_ActivityEnrichmentTagActionFollowPublisher value)?
        followPublisher,
    TResult Function(_ActivityEnrichmentTagActionConnectPublisher value)?
        connectPublisher,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityEnrichmentTagActionCopyWith<$Res> {
  factory $ActivityEnrichmentTagActionCopyWith(
          ActivityEnrichmentTagAction value,
          $Res Function(ActivityEnrichmentTagAction) then) =
      _$ActivityEnrichmentTagActionCopyWithImpl<$Res,
          ActivityEnrichmentTagAction>;
}

/// @nodoc
class _$ActivityEnrichmentTagActionCopyWithImpl<$Res,
        $Val extends ActivityEnrichmentTagAction>
    implements $ActivityEnrichmentTagActionCopyWith<$Res> {
  _$ActivityEnrichmentTagActionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$ActivityEnrichmentTagActionOpenPostImplCopyWith<$Res> {
  factory _$$ActivityEnrichmentTagActionOpenPostImplCopyWith(
          _$ActivityEnrichmentTagActionOpenPostImpl value,
          $Res Function(_$ActivityEnrichmentTagActionOpenPostImpl) then) =
      __$$ActivityEnrichmentTagActionOpenPostImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ActivityEnrichmentTagActionOpenPostImplCopyWithImpl<$Res>
    extends _$ActivityEnrichmentTagActionCopyWithImpl<$Res,
        _$ActivityEnrichmentTagActionOpenPostImpl>
    implements _$$ActivityEnrichmentTagActionOpenPostImplCopyWith<$Res> {
  __$$ActivityEnrichmentTagActionOpenPostImplCopyWithImpl(
      _$ActivityEnrichmentTagActionOpenPostImpl _value,
      $Res Function(_$ActivityEnrichmentTagActionOpenPostImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ActivityEnrichmentTagActionOpenPostImpl
    implements _ActivityEnrichmentTagActionOpenPost {
  const _$ActivityEnrichmentTagActionOpenPostImpl();

  @override
  String toString() {
    return 'ActivityEnrichmentTagAction.openPost()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityEnrichmentTagActionOpenPostImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() openPost,
    required TResult Function() viewPostExtended,
    required TResult Function() commentPost,
    required TResult Function() likePost,
    required TResult Function() bookmarkPost,
    required TResult Function() sharePost,
    required TResult Function() followPublisher,
    required TResult Function() connectPublisher,
  }) {
    return openPost();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? openPost,
    TResult? Function()? viewPostExtended,
    TResult? Function()? commentPost,
    TResult? Function()? likePost,
    TResult? Function()? bookmarkPost,
    TResult? Function()? sharePost,
    TResult? Function()? followPublisher,
    TResult? Function()? connectPublisher,
  }) {
    return openPost?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? openPost,
    TResult Function()? viewPostExtended,
    TResult Function()? commentPost,
    TResult Function()? likePost,
    TResult Function()? bookmarkPost,
    TResult Function()? sharePost,
    TResult Function()? followPublisher,
    TResult Function()? connectPublisher,
    required TResult orElse(),
  }) {
    if (openPost != null) {
      return openPost();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ActivityEnrichmentTagActionOpenPost value)
        openPost,
    required TResult Function(
            _ActivityEnrichmentTagActionViewPostExtended value)
        viewPostExtended,
    required TResult Function(_ActivityEnrichmentTagActionCommentPost value)
        commentPost,
    required TResult Function(_ActivityEnrichmentTagActionLikePost value)
        likePost,
    required TResult Function(_ActivityEnrichmentTagActionBookmarkPost value)
        bookmarkPost,
    required TResult Function(_ActivityEnrichmentTagActionSharePost value)
        sharePost,
    required TResult Function(_ActivityEnrichmentTagActionFollowPublisher value)
        followPublisher,
    required TResult Function(
            _ActivityEnrichmentTagActionConnectPublisher value)
        connectPublisher,
  }) {
    return openPost(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ActivityEnrichmentTagActionOpenPost value)? openPost,
    TResult? Function(_ActivityEnrichmentTagActionViewPostExtended value)?
        viewPostExtended,
    TResult? Function(_ActivityEnrichmentTagActionCommentPost value)?
        commentPost,
    TResult? Function(_ActivityEnrichmentTagActionLikePost value)? likePost,
    TResult? Function(_ActivityEnrichmentTagActionBookmarkPost value)?
        bookmarkPost,
    TResult? Function(_ActivityEnrichmentTagActionSharePost value)? sharePost,
    TResult? Function(_ActivityEnrichmentTagActionFollowPublisher value)?
        followPublisher,
    TResult? Function(_ActivityEnrichmentTagActionConnectPublisher value)?
        connectPublisher,
  }) {
    return openPost?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ActivityEnrichmentTagActionOpenPost value)? openPost,
    TResult Function(_ActivityEnrichmentTagActionViewPostExtended value)?
        viewPostExtended,
    TResult Function(_ActivityEnrichmentTagActionCommentPost value)?
        commentPost,
    TResult Function(_ActivityEnrichmentTagActionLikePost value)? likePost,
    TResult Function(_ActivityEnrichmentTagActionBookmarkPost value)?
        bookmarkPost,
    TResult Function(_ActivityEnrichmentTagActionSharePost value)? sharePost,
    TResult Function(_ActivityEnrichmentTagActionFollowPublisher value)?
        followPublisher,
    TResult Function(_ActivityEnrichmentTagActionConnectPublisher value)?
        connectPublisher,
    required TResult orElse(),
  }) {
    if (openPost != null) {
      return openPost(this);
    }
    return orElse();
  }
}

abstract class _ActivityEnrichmentTagActionOpenPost
    implements ActivityEnrichmentTagAction {
  const factory _ActivityEnrichmentTagActionOpenPost() =
      _$ActivityEnrichmentTagActionOpenPostImpl;
}

/// @nodoc
abstract class _$$ActivityEnrichmentTagActionViewPostExtendedImplCopyWith<
    $Res> {
  factory _$$ActivityEnrichmentTagActionViewPostExtendedImplCopyWith(
          _$ActivityEnrichmentTagActionViewPostExtendedImpl value,
          $Res Function(_$ActivityEnrichmentTagActionViewPostExtendedImpl)
              then) =
      __$$ActivityEnrichmentTagActionViewPostExtendedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ActivityEnrichmentTagActionViewPostExtendedImplCopyWithImpl<$Res>
    extends _$ActivityEnrichmentTagActionCopyWithImpl<$Res,
        _$ActivityEnrichmentTagActionViewPostExtendedImpl>
    implements
        _$$ActivityEnrichmentTagActionViewPostExtendedImplCopyWith<$Res> {
  __$$ActivityEnrichmentTagActionViewPostExtendedImplCopyWithImpl(
      _$ActivityEnrichmentTagActionViewPostExtendedImpl _value,
      $Res Function(_$ActivityEnrichmentTagActionViewPostExtendedImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ActivityEnrichmentTagActionViewPostExtendedImpl
    implements _ActivityEnrichmentTagActionViewPostExtended {
  const _$ActivityEnrichmentTagActionViewPostExtendedImpl();

  @override
  String toString() {
    return 'ActivityEnrichmentTagAction.viewPostExtended()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityEnrichmentTagActionViewPostExtendedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() openPost,
    required TResult Function() viewPostExtended,
    required TResult Function() commentPost,
    required TResult Function() likePost,
    required TResult Function() bookmarkPost,
    required TResult Function() sharePost,
    required TResult Function() followPublisher,
    required TResult Function() connectPublisher,
  }) {
    return viewPostExtended();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? openPost,
    TResult? Function()? viewPostExtended,
    TResult? Function()? commentPost,
    TResult? Function()? likePost,
    TResult? Function()? bookmarkPost,
    TResult? Function()? sharePost,
    TResult? Function()? followPublisher,
    TResult? Function()? connectPublisher,
  }) {
    return viewPostExtended?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? openPost,
    TResult Function()? viewPostExtended,
    TResult Function()? commentPost,
    TResult Function()? likePost,
    TResult Function()? bookmarkPost,
    TResult Function()? sharePost,
    TResult Function()? followPublisher,
    TResult Function()? connectPublisher,
    required TResult orElse(),
  }) {
    if (viewPostExtended != null) {
      return viewPostExtended();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ActivityEnrichmentTagActionOpenPost value)
        openPost,
    required TResult Function(
            _ActivityEnrichmentTagActionViewPostExtended value)
        viewPostExtended,
    required TResult Function(_ActivityEnrichmentTagActionCommentPost value)
        commentPost,
    required TResult Function(_ActivityEnrichmentTagActionLikePost value)
        likePost,
    required TResult Function(_ActivityEnrichmentTagActionBookmarkPost value)
        bookmarkPost,
    required TResult Function(_ActivityEnrichmentTagActionSharePost value)
        sharePost,
    required TResult Function(_ActivityEnrichmentTagActionFollowPublisher value)
        followPublisher,
    required TResult Function(
            _ActivityEnrichmentTagActionConnectPublisher value)
        connectPublisher,
  }) {
    return viewPostExtended(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ActivityEnrichmentTagActionOpenPost value)? openPost,
    TResult? Function(_ActivityEnrichmentTagActionViewPostExtended value)?
        viewPostExtended,
    TResult? Function(_ActivityEnrichmentTagActionCommentPost value)?
        commentPost,
    TResult? Function(_ActivityEnrichmentTagActionLikePost value)? likePost,
    TResult? Function(_ActivityEnrichmentTagActionBookmarkPost value)?
        bookmarkPost,
    TResult? Function(_ActivityEnrichmentTagActionSharePost value)? sharePost,
    TResult? Function(_ActivityEnrichmentTagActionFollowPublisher value)?
        followPublisher,
    TResult? Function(_ActivityEnrichmentTagActionConnectPublisher value)?
        connectPublisher,
  }) {
    return viewPostExtended?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ActivityEnrichmentTagActionOpenPost value)? openPost,
    TResult Function(_ActivityEnrichmentTagActionViewPostExtended value)?
        viewPostExtended,
    TResult Function(_ActivityEnrichmentTagActionCommentPost value)?
        commentPost,
    TResult Function(_ActivityEnrichmentTagActionLikePost value)? likePost,
    TResult Function(_ActivityEnrichmentTagActionBookmarkPost value)?
        bookmarkPost,
    TResult Function(_ActivityEnrichmentTagActionSharePost value)? sharePost,
    TResult Function(_ActivityEnrichmentTagActionFollowPublisher value)?
        followPublisher,
    TResult Function(_ActivityEnrichmentTagActionConnectPublisher value)?
        connectPublisher,
    required TResult orElse(),
  }) {
    if (viewPostExtended != null) {
      return viewPostExtended(this);
    }
    return orElse();
  }
}

abstract class _ActivityEnrichmentTagActionViewPostExtended
    implements ActivityEnrichmentTagAction {
  const factory _ActivityEnrichmentTagActionViewPostExtended() =
      _$ActivityEnrichmentTagActionViewPostExtendedImpl;
}

/// @nodoc
abstract class _$$ActivityEnrichmentTagActionCommentPostImplCopyWith<$Res> {
  factory _$$ActivityEnrichmentTagActionCommentPostImplCopyWith(
          _$ActivityEnrichmentTagActionCommentPostImpl value,
          $Res Function(_$ActivityEnrichmentTagActionCommentPostImpl) then) =
      __$$ActivityEnrichmentTagActionCommentPostImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ActivityEnrichmentTagActionCommentPostImplCopyWithImpl<$Res>
    extends _$ActivityEnrichmentTagActionCopyWithImpl<$Res,
        _$ActivityEnrichmentTagActionCommentPostImpl>
    implements _$$ActivityEnrichmentTagActionCommentPostImplCopyWith<$Res> {
  __$$ActivityEnrichmentTagActionCommentPostImplCopyWithImpl(
      _$ActivityEnrichmentTagActionCommentPostImpl _value,
      $Res Function(_$ActivityEnrichmentTagActionCommentPostImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ActivityEnrichmentTagActionCommentPostImpl
    implements _ActivityEnrichmentTagActionCommentPost {
  const _$ActivityEnrichmentTagActionCommentPostImpl();

  @override
  String toString() {
    return 'ActivityEnrichmentTagAction.commentPost()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityEnrichmentTagActionCommentPostImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() openPost,
    required TResult Function() viewPostExtended,
    required TResult Function() commentPost,
    required TResult Function() likePost,
    required TResult Function() bookmarkPost,
    required TResult Function() sharePost,
    required TResult Function() followPublisher,
    required TResult Function() connectPublisher,
  }) {
    return commentPost();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? openPost,
    TResult? Function()? viewPostExtended,
    TResult? Function()? commentPost,
    TResult? Function()? likePost,
    TResult? Function()? bookmarkPost,
    TResult? Function()? sharePost,
    TResult? Function()? followPublisher,
    TResult? Function()? connectPublisher,
  }) {
    return commentPost?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? openPost,
    TResult Function()? viewPostExtended,
    TResult Function()? commentPost,
    TResult Function()? likePost,
    TResult Function()? bookmarkPost,
    TResult Function()? sharePost,
    TResult Function()? followPublisher,
    TResult Function()? connectPublisher,
    required TResult orElse(),
  }) {
    if (commentPost != null) {
      return commentPost();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ActivityEnrichmentTagActionOpenPost value)
        openPost,
    required TResult Function(
            _ActivityEnrichmentTagActionViewPostExtended value)
        viewPostExtended,
    required TResult Function(_ActivityEnrichmentTagActionCommentPost value)
        commentPost,
    required TResult Function(_ActivityEnrichmentTagActionLikePost value)
        likePost,
    required TResult Function(_ActivityEnrichmentTagActionBookmarkPost value)
        bookmarkPost,
    required TResult Function(_ActivityEnrichmentTagActionSharePost value)
        sharePost,
    required TResult Function(_ActivityEnrichmentTagActionFollowPublisher value)
        followPublisher,
    required TResult Function(
            _ActivityEnrichmentTagActionConnectPublisher value)
        connectPublisher,
  }) {
    return commentPost(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ActivityEnrichmentTagActionOpenPost value)? openPost,
    TResult? Function(_ActivityEnrichmentTagActionViewPostExtended value)?
        viewPostExtended,
    TResult? Function(_ActivityEnrichmentTagActionCommentPost value)?
        commentPost,
    TResult? Function(_ActivityEnrichmentTagActionLikePost value)? likePost,
    TResult? Function(_ActivityEnrichmentTagActionBookmarkPost value)?
        bookmarkPost,
    TResult? Function(_ActivityEnrichmentTagActionSharePost value)? sharePost,
    TResult? Function(_ActivityEnrichmentTagActionFollowPublisher value)?
        followPublisher,
    TResult? Function(_ActivityEnrichmentTagActionConnectPublisher value)?
        connectPublisher,
  }) {
    return commentPost?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ActivityEnrichmentTagActionOpenPost value)? openPost,
    TResult Function(_ActivityEnrichmentTagActionViewPostExtended value)?
        viewPostExtended,
    TResult Function(_ActivityEnrichmentTagActionCommentPost value)?
        commentPost,
    TResult Function(_ActivityEnrichmentTagActionLikePost value)? likePost,
    TResult Function(_ActivityEnrichmentTagActionBookmarkPost value)?
        bookmarkPost,
    TResult Function(_ActivityEnrichmentTagActionSharePost value)? sharePost,
    TResult Function(_ActivityEnrichmentTagActionFollowPublisher value)?
        followPublisher,
    TResult Function(_ActivityEnrichmentTagActionConnectPublisher value)?
        connectPublisher,
    required TResult orElse(),
  }) {
    if (commentPost != null) {
      return commentPost(this);
    }
    return orElse();
  }
}

abstract class _ActivityEnrichmentTagActionCommentPost
    implements ActivityEnrichmentTagAction {
  const factory _ActivityEnrichmentTagActionCommentPost() =
      _$ActivityEnrichmentTagActionCommentPostImpl;
}

/// @nodoc
abstract class _$$ActivityEnrichmentTagActionLikePostImplCopyWith<$Res> {
  factory _$$ActivityEnrichmentTagActionLikePostImplCopyWith(
          _$ActivityEnrichmentTagActionLikePostImpl value,
          $Res Function(_$ActivityEnrichmentTagActionLikePostImpl) then) =
      __$$ActivityEnrichmentTagActionLikePostImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ActivityEnrichmentTagActionLikePostImplCopyWithImpl<$Res>
    extends _$ActivityEnrichmentTagActionCopyWithImpl<$Res,
        _$ActivityEnrichmentTagActionLikePostImpl>
    implements _$$ActivityEnrichmentTagActionLikePostImplCopyWith<$Res> {
  __$$ActivityEnrichmentTagActionLikePostImplCopyWithImpl(
      _$ActivityEnrichmentTagActionLikePostImpl _value,
      $Res Function(_$ActivityEnrichmentTagActionLikePostImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ActivityEnrichmentTagActionLikePostImpl
    implements _ActivityEnrichmentTagActionLikePost {
  const _$ActivityEnrichmentTagActionLikePostImpl();

  @override
  String toString() {
    return 'ActivityEnrichmentTagAction.likePost()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityEnrichmentTagActionLikePostImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() openPost,
    required TResult Function() viewPostExtended,
    required TResult Function() commentPost,
    required TResult Function() likePost,
    required TResult Function() bookmarkPost,
    required TResult Function() sharePost,
    required TResult Function() followPublisher,
    required TResult Function() connectPublisher,
  }) {
    return likePost();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? openPost,
    TResult? Function()? viewPostExtended,
    TResult? Function()? commentPost,
    TResult? Function()? likePost,
    TResult? Function()? bookmarkPost,
    TResult? Function()? sharePost,
    TResult? Function()? followPublisher,
    TResult? Function()? connectPublisher,
  }) {
    return likePost?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? openPost,
    TResult Function()? viewPostExtended,
    TResult Function()? commentPost,
    TResult Function()? likePost,
    TResult Function()? bookmarkPost,
    TResult Function()? sharePost,
    TResult Function()? followPublisher,
    TResult Function()? connectPublisher,
    required TResult orElse(),
  }) {
    if (likePost != null) {
      return likePost();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ActivityEnrichmentTagActionOpenPost value)
        openPost,
    required TResult Function(
            _ActivityEnrichmentTagActionViewPostExtended value)
        viewPostExtended,
    required TResult Function(_ActivityEnrichmentTagActionCommentPost value)
        commentPost,
    required TResult Function(_ActivityEnrichmentTagActionLikePost value)
        likePost,
    required TResult Function(_ActivityEnrichmentTagActionBookmarkPost value)
        bookmarkPost,
    required TResult Function(_ActivityEnrichmentTagActionSharePost value)
        sharePost,
    required TResult Function(_ActivityEnrichmentTagActionFollowPublisher value)
        followPublisher,
    required TResult Function(
            _ActivityEnrichmentTagActionConnectPublisher value)
        connectPublisher,
  }) {
    return likePost(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ActivityEnrichmentTagActionOpenPost value)? openPost,
    TResult? Function(_ActivityEnrichmentTagActionViewPostExtended value)?
        viewPostExtended,
    TResult? Function(_ActivityEnrichmentTagActionCommentPost value)?
        commentPost,
    TResult? Function(_ActivityEnrichmentTagActionLikePost value)? likePost,
    TResult? Function(_ActivityEnrichmentTagActionBookmarkPost value)?
        bookmarkPost,
    TResult? Function(_ActivityEnrichmentTagActionSharePost value)? sharePost,
    TResult? Function(_ActivityEnrichmentTagActionFollowPublisher value)?
        followPublisher,
    TResult? Function(_ActivityEnrichmentTagActionConnectPublisher value)?
        connectPublisher,
  }) {
    return likePost?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ActivityEnrichmentTagActionOpenPost value)? openPost,
    TResult Function(_ActivityEnrichmentTagActionViewPostExtended value)?
        viewPostExtended,
    TResult Function(_ActivityEnrichmentTagActionCommentPost value)?
        commentPost,
    TResult Function(_ActivityEnrichmentTagActionLikePost value)? likePost,
    TResult Function(_ActivityEnrichmentTagActionBookmarkPost value)?
        bookmarkPost,
    TResult Function(_ActivityEnrichmentTagActionSharePost value)? sharePost,
    TResult Function(_ActivityEnrichmentTagActionFollowPublisher value)?
        followPublisher,
    TResult Function(_ActivityEnrichmentTagActionConnectPublisher value)?
        connectPublisher,
    required TResult orElse(),
  }) {
    if (likePost != null) {
      return likePost(this);
    }
    return orElse();
  }
}

abstract class _ActivityEnrichmentTagActionLikePost
    implements ActivityEnrichmentTagAction {
  const factory _ActivityEnrichmentTagActionLikePost() =
      _$ActivityEnrichmentTagActionLikePostImpl;
}

/// @nodoc
abstract class _$$ActivityEnrichmentTagActionBookmarkPostImplCopyWith<$Res> {
  factory _$$ActivityEnrichmentTagActionBookmarkPostImplCopyWith(
          _$ActivityEnrichmentTagActionBookmarkPostImpl value,
          $Res Function(_$ActivityEnrichmentTagActionBookmarkPostImpl) then) =
      __$$ActivityEnrichmentTagActionBookmarkPostImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ActivityEnrichmentTagActionBookmarkPostImplCopyWithImpl<$Res>
    extends _$ActivityEnrichmentTagActionCopyWithImpl<$Res,
        _$ActivityEnrichmentTagActionBookmarkPostImpl>
    implements _$$ActivityEnrichmentTagActionBookmarkPostImplCopyWith<$Res> {
  __$$ActivityEnrichmentTagActionBookmarkPostImplCopyWithImpl(
      _$ActivityEnrichmentTagActionBookmarkPostImpl _value,
      $Res Function(_$ActivityEnrichmentTagActionBookmarkPostImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ActivityEnrichmentTagActionBookmarkPostImpl
    implements _ActivityEnrichmentTagActionBookmarkPost {
  const _$ActivityEnrichmentTagActionBookmarkPostImpl();

  @override
  String toString() {
    return 'ActivityEnrichmentTagAction.bookmarkPost()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityEnrichmentTagActionBookmarkPostImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() openPost,
    required TResult Function() viewPostExtended,
    required TResult Function() commentPost,
    required TResult Function() likePost,
    required TResult Function() bookmarkPost,
    required TResult Function() sharePost,
    required TResult Function() followPublisher,
    required TResult Function() connectPublisher,
  }) {
    return bookmarkPost();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? openPost,
    TResult? Function()? viewPostExtended,
    TResult? Function()? commentPost,
    TResult? Function()? likePost,
    TResult? Function()? bookmarkPost,
    TResult? Function()? sharePost,
    TResult? Function()? followPublisher,
    TResult? Function()? connectPublisher,
  }) {
    return bookmarkPost?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? openPost,
    TResult Function()? viewPostExtended,
    TResult Function()? commentPost,
    TResult Function()? likePost,
    TResult Function()? bookmarkPost,
    TResult Function()? sharePost,
    TResult Function()? followPublisher,
    TResult Function()? connectPublisher,
    required TResult orElse(),
  }) {
    if (bookmarkPost != null) {
      return bookmarkPost();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ActivityEnrichmentTagActionOpenPost value)
        openPost,
    required TResult Function(
            _ActivityEnrichmentTagActionViewPostExtended value)
        viewPostExtended,
    required TResult Function(_ActivityEnrichmentTagActionCommentPost value)
        commentPost,
    required TResult Function(_ActivityEnrichmentTagActionLikePost value)
        likePost,
    required TResult Function(_ActivityEnrichmentTagActionBookmarkPost value)
        bookmarkPost,
    required TResult Function(_ActivityEnrichmentTagActionSharePost value)
        sharePost,
    required TResult Function(_ActivityEnrichmentTagActionFollowPublisher value)
        followPublisher,
    required TResult Function(
            _ActivityEnrichmentTagActionConnectPublisher value)
        connectPublisher,
  }) {
    return bookmarkPost(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ActivityEnrichmentTagActionOpenPost value)? openPost,
    TResult? Function(_ActivityEnrichmentTagActionViewPostExtended value)?
        viewPostExtended,
    TResult? Function(_ActivityEnrichmentTagActionCommentPost value)?
        commentPost,
    TResult? Function(_ActivityEnrichmentTagActionLikePost value)? likePost,
    TResult? Function(_ActivityEnrichmentTagActionBookmarkPost value)?
        bookmarkPost,
    TResult? Function(_ActivityEnrichmentTagActionSharePost value)? sharePost,
    TResult? Function(_ActivityEnrichmentTagActionFollowPublisher value)?
        followPublisher,
    TResult? Function(_ActivityEnrichmentTagActionConnectPublisher value)?
        connectPublisher,
  }) {
    return bookmarkPost?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ActivityEnrichmentTagActionOpenPost value)? openPost,
    TResult Function(_ActivityEnrichmentTagActionViewPostExtended value)?
        viewPostExtended,
    TResult Function(_ActivityEnrichmentTagActionCommentPost value)?
        commentPost,
    TResult Function(_ActivityEnrichmentTagActionLikePost value)? likePost,
    TResult Function(_ActivityEnrichmentTagActionBookmarkPost value)?
        bookmarkPost,
    TResult Function(_ActivityEnrichmentTagActionSharePost value)? sharePost,
    TResult Function(_ActivityEnrichmentTagActionFollowPublisher value)?
        followPublisher,
    TResult Function(_ActivityEnrichmentTagActionConnectPublisher value)?
        connectPublisher,
    required TResult orElse(),
  }) {
    if (bookmarkPost != null) {
      return bookmarkPost(this);
    }
    return orElse();
  }
}

abstract class _ActivityEnrichmentTagActionBookmarkPost
    implements ActivityEnrichmentTagAction {
  const factory _ActivityEnrichmentTagActionBookmarkPost() =
      _$ActivityEnrichmentTagActionBookmarkPostImpl;
}

/// @nodoc
abstract class _$$ActivityEnrichmentTagActionSharePostImplCopyWith<$Res> {
  factory _$$ActivityEnrichmentTagActionSharePostImplCopyWith(
          _$ActivityEnrichmentTagActionSharePostImpl value,
          $Res Function(_$ActivityEnrichmentTagActionSharePostImpl) then) =
      __$$ActivityEnrichmentTagActionSharePostImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ActivityEnrichmentTagActionSharePostImplCopyWithImpl<$Res>
    extends _$ActivityEnrichmentTagActionCopyWithImpl<$Res,
        _$ActivityEnrichmentTagActionSharePostImpl>
    implements _$$ActivityEnrichmentTagActionSharePostImplCopyWith<$Res> {
  __$$ActivityEnrichmentTagActionSharePostImplCopyWithImpl(
      _$ActivityEnrichmentTagActionSharePostImpl _value,
      $Res Function(_$ActivityEnrichmentTagActionSharePostImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ActivityEnrichmentTagActionSharePostImpl
    implements _ActivityEnrichmentTagActionSharePost {
  const _$ActivityEnrichmentTagActionSharePostImpl();

  @override
  String toString() {
    return 'ActivityEnrichmentTagAction.sharePost()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityEnrichmentTagActionSharePostImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() openPost,
    required TResult Function() viewPostExtended,
    required TResult Function() commentPost,
    required TResult Function() likePost,
    required TResult Function() bookmarkPost,
    required TResult Function() sharePost,
    required TResult Function() followPublisher,
    required TResult Function() connectPublisher,
  }) {
    return sharePost();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? openPost,
    TResult? Function()? viewPostExtended,
    TResult? Function()? commentPost,
    TResult? Function()? likePost,
    TResult? Function()? bookmarkPost,
    TResult? Function()? sharePost,
    TResult? Function()? followPublisher,
    TResult? Function()? connectPublisher,
  }) {
    return sharePost?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? openPost,
    TResult Function()? viewPostExtended,
    TResult Function()? commentPost,
    TResult Function()? likePost,
    TResult Function()? bookmarkPost,
    TResult Function()? sharePost,
    TResult Function()? followPublisher,
    TResult Function()? connectPublisher,
    required TResult orElse(),
  }) {
    if (sharePost != null) {
      return sharePost();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ActivityEnrichmentTagActionOpenPost value)
        openPost,
    required TResult Function(
            _ActivityEnrichmentTagActionViewPostExtended value)
        viewPostExtended,
    required TResult Function(_ActivityEnrichmentTagActionCommentPost value)
        commentPost,
    required TResult Function(_ActivityEnrichmentTagActionLikePost value)
        likePost,
    required TResult Function(_ActivityEnrichmentTagActionBookmarkPost value)
        bookmarkPost,
    required TResult Function(_ActivityEnrichmentTagActionSharePost value)
        sharePost,
    required TResult Function(_ActivityEnrichmentTagActionFollowPublisher value)
        followPublisher,
    required TResult Function(
            _ActivityEnrichmentTagActionConnectPublisher value)
        connectPublisher,
  }) {
    return sharePost(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ActivityEnrichmentTagActionOpenPost value)? openPost,
    TResult? Function(_ActivityEnrichmentTagActionViewPostExtended value)?
        viewPostExtended,
    TResult? Function(_ActivityEnrichmentTagActionCommentPost value)?
        commentPost,
    TResult? Function(_ActivityEnrichmentTagActionLikePost value)? likePost,
    TResult? Function(_ActivityEnrichmentTagActionBookmarkPost value)?
        bookmarkPost,
    TResult? Function(_ActivityEnrichmentTagActionSharePost value)? sharePost,
    TResult? Function(_ActivityEnrichmentTagActionFollowPublisher value)?
        followPublisher,
    TResult? Function(_ActivityEnrichmentTagActionConnectPublisher value)?
        connectPublisher,
  }) {
    return sharePost?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ActivityEnrichmentTagActionOpenPost value)? openPost,
    TResult Function(_ActivityEnrichmentTagActionViewPostExtended value)?
        viewPostExtended,
    TResult Function(_ActivityEnrichmentTagActionCommentPost value)?
        commentPost,
    TResult Function(_ActivityEnrichmentTagActionLikePost value)? likePost,
    TResult Function(_ActivityEnrichmentTagActionBookmarkPost value)?
        bookmarkPost,
    TResult Function(_ActivityEnrichmentTagActionSharePost value)? sharePost,
    TResult Function(_ActivityEnrichmentTagActionFollowPublisher value)?
        followPublisher,
    TResult Function(_ActivityEnrichmentTagActionConnectPublisher value)?
        connectPublisher,
    required TResult orElse(),
  }) {
    if (sharePost != null) {
      return sharePost(this);
    }
    return orElse();
  }
}

abstract class _ActivityEnrichmentTagActionSharePost
    implements ActivityEnrichmentTagAction {
  const factory _ActivityEnrichmentTagActionSharePost() =
      _$ActivityEnrichmentTagActionSharePostImpl;
}

/// @nodoc
abstract class _$$ActivityEnrichmentTagActionFollowPublisherImplCopyWith<$Res> {
  factory _$$ActivityEnrichmentTagActionFollowPublisherImplCopyWith(
          _$ActivityEnrichmentTagActionFollowPublisherImpl value,
          $Res Function(_$ActivityEnrichmentTagActionFollowPublisherImpl)
              then) =
      __$$ActivityEnrichmentTagActionFollowPublisherImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ActivityEnrichmentTagActionFollowPublisherImplCopyWithImpl<$Res>
    extends _$ActivityEnrichmentTagActionCopyWithImpl<$Res,
        _$ActivityEnrichmentTagActionFollowPublisherImpl>
    implements _$$ActivityEnrichmentTagActionFollowPublisherImplCopyWith<$Res> {
  __$$ActivityEnrichmentTagActionFollowPublisherImplCopyWithImpl(
      _$ActivityEnrichmentTagActionFollowPublisherImpl _value,
      $Res Function(_$ActivityEnrichmentTagActionFollowPublisherImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ActivityEnrichmentTagActionFollowPublisherImpl
    implements _ActivityEnrichmentTagActionFollowPublisher {
  const _$ActivityEnrichmentTagActionFollowPublisherImpl();

  @override
  String toString() {
    return 'ActivityEnrichmentTagAction.followPublisher()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityEnrichmentTagActionFollowPublisherImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() openPost,
    required TResult Function() viewPostExtended,
    required TResult Function() commentPost,
    required TResult Function() likePost,
    required TResult Function() bookmarkPost,
    required TResult Function() sharePost,
    required TResult Function() followPublisher,
    required TResult Function() connectPublisher,
  }) {
    return followPublisher();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? openPost,
    TResult? Function()? viewPostExtended,
    TResult? Function()? commentPost,
    TResult? Function()? likePost,
    TResult? Function()? bookmarkPost,
    TResult? Function()? sharePost,
    TResult? Function()? followPublisher,
    TResult? Function()? connectPublisher,
  }) {
    return followPublisher?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? openPost,
    TResult Function()? viewPostExtended,
    TResult Function()? commentPost,
    TResult Function()? likePost,
    TResult Function()? bookmarkPost,
    TResult Function()? sharePost,
    TResult Function()? followPublisher,
    TResult Function()? connectPublisher,
    required TResult orElse(),
  }) {
    if (followPublisher != null) {
      return followPublisher();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ActivityEnrichmentTagActionOpenPost value)
        openPost,
    required TResult Function(
            _ActivityEnrichmentTagActionViewPostExtended value)
        viewPostExtended,
    required TResult Function(_ActivityEnrichmentTagActionCommentPost value)
        commentPost,
    required TResult Function(_ActivityEnrichmentTagActionLikePost value)
        likePost,
    required TResult Function(_ActivityEnrichmentTagActionBookmarkPost value)
        bookmarkPost,
    required TResult Function(_ActivityEnrichmentTagActionSharePost value)
        sharePost,
    required TResult Function(_ActivityEnrichmentTagActionFollowPublisher value)
        followPublisher,
    required TResult Function(
            _ActivityEnrichmentTagActionConnectPublisher value)
        connectPublisher,
  }) {
    return followPublisher(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ActivityEnrichmentTagActionOpenPost value)? openPost,
    TResult? Function(_ActivityEnrichmentTagActionViewPostExtended value)?
        viewPostExtended,
    TResult? Function(_ActivityEnrichmentTagActionCommentPost value)?
        commentPost,
    TResult? Function(_ActivityEnrichmentTagActionLikePost value)? likePost,
    TResult? Function(_ActivityEnrichmentTagActionBookmarkPost value)?
        bookmarkPost,
    TResult? Function(_ActivityEnrichmentTagActionSharePost value)? sharePost,
    TResult? Function(_ActivityEnrichmentTagActionFollowPublisher value)?
        followPublisher,
    TResult? Function(_ActivityEnrichmentTagActionConnectPublisher value)?
        connectPublisher,
  }) {
    return followPublisher?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ActivityEnrichmentTagActionOpenPost value)? openPost,
    TResult Function(_ActivityEnrichmentTagActionViewPostExtended value)?
        viewPostExtended,
    TResult Function(_ActivityEnrichmentTagActionCommentPost value)?
        commentPost,
    TResult Function(_ActivityEnrichmentTagActionLikePost value)? likePost,
    TResult Function(_ActivityEnrichmentTagActionBookmarkPost value)?
        bookmarkPost,
    TResult Function(_ActivityEnrichmentTagActionSharePost value)? sharePost,
    TResult Function(_ActivityEnrichmentTagActionFollowPublisher value)?
        followPublisher,
    TResult Function(_ActivityEnrichmentTagActionConnectPublisher value)?
        connectPublisher,
    required TResult orElse(),
  }) {
    if (followPublisher != null) {
      return followPublisher(this);
    }
    return orElse();
  }
}

abstract class _ActivityEnrichmentTagActionFollowPublisher
    implements ActivityEnrichmentTagAction {
  const factory _ActivityEnrichmentTagActionFollowPublisher() =
      _$ActivityEnrichmentTagActionFollowPublisherImpl;
}

/// @nodoc
abstract class _$$ActivityEnrichmentTagActionConnectPublisherImplCopyWith<
    $Res> {
  factory _$$ActivityEnrichmentTagActionConnectPublisherImplCopyWith(
          _$ActivityEnrichmentTagActionConnectPublisherImpl value,
          $Res Function(_$ActivityEnrichmentTagActionConnectPublisherImpl)
              then) =
      __$$ActivityEnrichmentTagActionConnectPublisherImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ActivityEnrichmentTagActionConnectPublisherImplCopyWithImpl<$Res>
    extends _$ActivityEnrichmentTagActionCopyWithImpl<$Res,
        _$ActivityEnrichmentTagActionConnectPublisherImpl>
    implements
        _$$ActivityEnrichmentTagActionConnectPublisherImplCopyWith<$Res> {
  __$$ActivityEnrichmentTagActionConnectPublisherImplCopyWithImpl(
      _$ActivityEnrichmentTagActionConnectPublisherImpl _value,
      $Res Function(_$ActivityEnrichmentTagActionConnectPublisherImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ActivityEnrichmentTagActionConnectPublisherImpl
    implements _ActivityEnrichmentTagActionConnectPublisher {
  const _$ActivityEnrichmentTagActionConnectPublisherImpl();

  @override
  String toString() {
    return 'ActivityEnrichmentTagAction.connectPublisher()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityEnrichmentTagActionConnectPublisherImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() openPost,
    required TResult Function() viewPostExtended,
    required TResult Function() commentPost,
    required TResult Function() likePost,
    required TResult Function() bookmarkPost,
    required TResult Function() sharePost,
    required TResult Function() followPublisher,
    required TResult Function() connectPublisher,
  }) {
    return connectPublisher();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? openPost,
    TResult? Function()? viewPostExtended,
    TResult? Function()? commentPost,
    TResult? Function()? likePost,
    TResult? Function()? bookmarkPost,
    TResult? Function()? sharePost,
    TResult? Function()? followPublisher,
    TResult? Function()? connectPublisher,
  }) {
    return connectPublisher?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? openPost,
    TResult Function()? viewPostExtended,
    TResult Function()? commentPost,
    TResult Function()? likePost,
    TResult Function()? bookmarkPost,
    TResult Function()? sharePost,
    TResult Function()? followPublisher,
    TResult Function()? connectPublisher,
    required TResult orElse(),
  }) {
    if (connectPublisher != null) {
      return connectPublisher();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ActivityEnrichmentTagActionOpenPost value)
        openPost,
    required TResult Function(
            _ActivityEnrichmentTagActionViewPostExtended value)
        viewPostExtended,
    required TResult Function(_ActivityEnrichmentTagActionCommentPost value)
        commentPost,
    required TResult Function(_ActivityEnrichmentTagActionLikePost value)
        likePost,
    required TResult Function(_ActivityEnrichmentTagActionBookmarkPost value)
        bookmarkPost,
    required TResult Function(_ActivityEnrichmentTagActionSharePost value)
        sharePost,
    required TResult Function(_ActivityEnrichmentTagActionFollowPublisher value)
        followPublisher,
    required TResult Function(
            _ActivityEnrichmentTagActionConnectPublisher value)
        connectPublisher,
  }) {
    return connectPublisher(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ActivityEnrichmentTagActionOpenPost value)? openPost,
    TResult? Function(_ActivityEnrichmentTagActionViewPostExtended value)?
        viewPostExtended,
    TResult? Function(_ActivityEnrichmentTagActionCommentPost value)?
        commentPost,
    TResult? Function(_ActivityEnrichmentTagActionLikePost value)? likePost,
    TResult? Function(_ActivityEnrichmentTagActionBookmarkPost value)?
        bookmarkPost,
    TResult? Function(_ActivityEnrichmentTagActionSharePost value)? sharePost,
    TResult? Function(_ActivityEnrichmentTagActionFollowPublisher value)?
        followPublisher,
    TResult? Function(_ActivityEnrichmentTagActionConnectPublisher value)?
        connectPublisher,
  }) {
    return connectPublisher?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ActivityEnrichmentTagActionOpenPost value)? openPost,
    TResult Function(_ActivityEnrichmentTagActionViewPostExtended value)?
        viewPostExtended,
    TResult Function(_ActivityEnrichmentTagActionCommentPost value)?
        commentPost,
    TResult Function(_ActivityEnrichmentTagActionLikePost value)? likePost,
    TResult Function(_ActivityEnrichmentTagActionBookmarkPost value)?
        bookmarkPost,
    TResult Function(_ActivityEnrichmentTagActionSharePost value)? sharePost,
    TResult Function(_ActivityEnrichmentTagActionFollowPublisher value)?
        followPublisher,
    TResult Function(_ActivityEnrichmentTagActionConnectPublisher value)?
        connectPublisher,
    required TResult orElse(),
  }) {
    if (connectPublisher != null) {
      return connectPublisher(this);
    }
    return orElse();
  }
}

abstract class _ActivityEnrichmentTagActionConnectPublisher
    implements ActivityEnrichmentTagAction {
  const factory _ActivityEnrichmentTagActionConnectPublisher() =
      _$ActivityEnrichmentTagActionConnectPublisherImpl;
}
