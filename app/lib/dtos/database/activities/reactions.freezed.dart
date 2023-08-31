// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reactions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Reaction _$ReactionFromJson(Map<String, dynamic> json) {
  return _Reaction.fromJson(json);
}

/// @nodoc
mixin _$Reaction {
  @JsonKey(name: 'activity_id')
  String get activityId => throw _privateConstructorUsedError;
  @JsonKey(name: 'reaction_id')
  String get reactionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(fromJson: ReactionType.fromJson, toJson: ReactionType.toJson)
  ReactionType get kind => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReactionCopyWith<Reaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReactionCopyWith<$Res> {
  factory $ReactionCopyWith(Reaction value, $Res Function(Reaction) then) =
      _$ReactionCopyWithImpl<$Res, Reaction>;
  @useResult
  $Res call(
      {@JsonKey(name: 'activity_id') String activityId,
      @JsonKey(name: 'reaction_id') String reactionId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(fromJson: ReactionType.fromJson, toJson: ReactionType.toJson)
      ReactionType kind});

  $ReactionTypeCopyWith<$Res> get kind;
}

/// @nodoc
class _$ReactionCopyWithImpl<$Res, $Val extends Reaction>
    implements $ReactionCopyWith<$Res> {
  _$ReactionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activityId = null,
    Object? reactionId = null,
    Object? userId = null,
    Object? kind = null,
  }) {
    return _then(_value.copyWith(
      activityId: null == activityId
          ? _value.activityId
          : activityId // ignore: cast_nullable_to_non_nullable
              as String,
      reactionId: null == reactionId
          ? _value.reactionId
          : reactionId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as ReactionType,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ReactionTypeCopyWith<$Res> get kind {
    return $ReactionTypeCopyWith<$Res>(_value.kind, (value) {
      return _then(_value.copyWith(kind: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_ReactionCopyWith<$Res> implements $ReactionCopyWith<$Res> {
  factory _$$_ReactionCopyWith(
          _$_Reaction value, $Res Function(_$_Reaction) then) =
      __$$_ReactionCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'activity_id') String activityId,
      @JsonKey(name: 'reaction_id') String reactionId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(fromJson: ReactionType.fromJson, toJson: ReactionType.toJson)
      ReactionType kind});

  @override
  $ReactionTypeCopyWith<$Res> get kind;
}

/// @nodoc
class __$$_ReactionCopyWithImpl<$Res>
    extends _$ReactionCopyWithImpl<$Res, _$_Reaction>
    implements _$$_ReactionCopyWith<$Res> {
  __$$_ReactionCopyWithImpl(
      _$_Reaction _value, $Res Function(_$_Reaction) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activityId = null,
    Object? reactionId = null,
    Object? userId = null,
    Object? kind = null,
  }) {
    return _then(_$_Reaction(
      activityId: null == activityId
          ? _value.activityId
          : activityId // ignore: cast_nullable_to_non_nullable
              as String,
      reactionId: null == reactionId
          ? _value.reactionId
          : reactionId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as ReactionType,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Reaction implements _Reaction {
  const _$_Reaction(
      {@JsonKey(name: 'activity_id') this.activityId = '',
      @JsonKey(name: 'reaction_id') this.reactionId = '',
      @JsonKey(name: 'user_id') this.userId = '',
      @JsonKey(fromJson: ReactionType.fromJson, toJson: ReactionType.toJson)
      this.kind = const ReactionType.unknownReaction()});

  factory _$_Reaction.fromJson(Map<String, dynamic> json) =>
      _$$_ReactionFromJson(json);

  @override
  @JsonKey(name: 'activity_id')
  final String activityId;
  @override
  @JsonKey(name: 'reaction_id')
  final String reactionId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(fromJson: ReactionType.fromJson, toJson: ReactionType.toJson)
  final ReactionType kind;

  @override
  String toString() {
    return 'Reaction(activityId: $activityId, reactionId: $reactionId, userId: $userId, kind: $kind)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Reaction &&
            (identical(other.activityId, activityId) ||
                other.activityId == activityId) &&
            (identical(other.reactionId, reactionId) ||
                other.reactionId == reactionId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.kind, kind) || other.kind == kind));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, activityId, reactionId, userId, kind);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ReactionCopyWith<_$_Reaction> get copyWith =>
      __$$_ReactionCopyWithImpl<_$_Reaction>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ReactionToJson(
      this,
    );
  }
}

abstract class _Reaction implements Reaction {
  const factory _Reaction(
      {@JsonKey(name: 'activity_id') final String activityId,
      @JsonKey(name: 'reaction_id') final String reactionId,
      @JsonKey(name: 'user_id') final String userId,
      @JsonKey(fromJson: ReactionType.fromJson, toJson: ReactionType.toJson)
      final ReactionType kind}) = _$_Reaction;

  factory _Reaction.fromJson(Map<String, dynamic> json) = _$_Reaction.fromJson;

  @override
  @JsonKey(name: 'activity_id')
  String get activityId;
  @override
  @JsonKey(name: 'reaction_id')
  String get reactionId;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(fromJson: ReactionType.fromJson, toJson: ReactionType.toJson)
  ReactionType get kind;
  @override
  @JsonKey(ignore: true)
  _$$_ReactionCopyWith<_$_Reaction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ReactionType {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unknownReaction,
    required TResult Function() like,
    required TResult Function() dislike,
    required TResult Function() comment,
    required TResult Function() bookmark,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unknownReaction,
    TResult? Function()? like,
    TResult? Function()? dislike,
    TResult? Function()? comment,
    TResult? Function()? bookmark,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unknownReaction,
    TResult Function()? like,
    TResult Function()? dislike,
    TResult Function()? comment,
    TResult Function()? bookmark,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ReactionTypeUnknownReaction value)
        unknownReaction,
    required TResult Function(_ReactionTypeLike value) like,
    required TResult Function(_ReactionTypeDislike value) dislike,
    required TResult Function(_ReactionTypeComment value) comment,
    required TResult Function(_ReactionTypeBookmark value) bookmark,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ReactionTypeUnknownReaction value)? unknownReaction,
    TResult? Function(_ReactionTypeLike value)? like,
    TResult? Function(_ReactionTypeDislike value)? dislike,
    TResult? Function(_ReactionTypeComment value)? comment,
    TResult? Function(_ReactionTypeBookmark value)? bookmark,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ReactionTypeUnknownReaction value)? unknownReaction,
    TResult Function(_ReactionTypeLike value)? like,
    TResult Function(_ReactionTypeDislike value)? dislike,
    TResult Function(_ReactionTypeComment value)? comment,
    TResult Function(_ReactionTypeBookmark value)? bookmark,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReactionTypeCopyWith<$Res> {
  factory $ReactionTypeCopyWith(
          ReactionType value, $Res Function(ReactionType) then) =
      _$ReactionTypeCopyWithImpl<$Res, ReactionType>;
}

/// @nodoc
class _$ReactionTypeCopyWithImpl<$Res, $Val extends ReactionType>
    implements $ReactionTypeCopyWith<$Res> {
  _$ReactionTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_ReactionTypeUnknownReactionCopyWith<$Res> {
  factory _$$_ReactionTypeUnknownReactionCopyWith(
          _$_ReactionTypeUnknownReaction value,
          $Res Function(_$_ReactionTypeUnknownReaction) then) =
      __$$_ReactionTypeUnknownReactionCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_ReactionTypeUnknownReactionCopyWithImpl<$Res>
    extends _$ReactionTypeCopyWithImpl<$Res, _$_ReactionTypeUnknownReaction>
    implements _$$_ReactionTypeUnknownReactionCopyWith<$Res> {
  __$$_ReactionTypeUnknownReactionCopyWithImpl(
      _$_ReactionTypeUnknownReaction _value,
      $Res Function(_$_ReactionTypeUnknownReaction) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_ReactionTypeUnknownReaction implements _ReactionTypeUnknownReaction {
  const _$_ReactionTypeUnknownReaction();

  @override
  String toString() {
    return 'ReactionType.unknownReaction()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ReactionTypeUnknownReaction);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unknownReaction,
    required TResult Function() like,
    required TResult Function() dislike,
    required TResult Function() comment,
    required TResult Function() bookmark,
  }) {
    return unknownReaction();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unknownReaction,
    TResult? Function()? like,
    TResult? Function()? dislike,
    TResult? Function()? comment,
    TResult? Function()? bookmark,
  }) {
    return unknownReaction?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unknownReaction,
    TResult Function()? like,
    TResult Function()? dislike,
    TResult Function()? comment,
    TResult Function()? bookmark,
    required TResult orElse(),
  }) {
    if (unknownReaction != null) {
      return unknownReaction();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ReactionTypeUnknownReaction value)
        unknownReaction,
    required TResult Function(_ReactionTypeLike value) like,
    required TResult Function(_ReactionTypeDislike value) dislike,
    required TResult Function(_ReactionTypeComment value) comment,
    required TResult Function(_ReactionTypeBookmark value) bookmark,
  }) {
    return unknownReaction(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ReactionTypeUnknownReaction value)? unknownReaction,
    TResult? Function(_ReactionTypeLike value)? like,
    TResult? Function(_ReactionTypeDislike value)? dislike,
    TResult? Function(_ReactionTypeComment value)? comment,
    TResult? Function(_ReactionTypeBookmark value)? bookmark,
  }) {
    return unknownReaction?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ReactionTypeUnknownReaction value)? unknownReaction,
    TResult Function(_ReactionTypeLike value)? like,
    TResult Function(_ReactionTypeDislike value)? dislike,
    TResult Function(_ReactionTypeComment value)? comment,
    TResult Function(_ReactionTypeBookmark value)? bookmark,
    required TResult orElse(),
  }) {
    if (unknownReaction != null) {
      return unknownReaction(this);
    }
    return orElse();
  }
}

abstract class _ReactionTypeUnknownReaction implements ReactionType {
  const factory _ReactionTypeUnknownReaction() = _$_ReactionTypeUnknownReaction;
}

/// @nodoc
abstract class _$$_ReactionTypeLikeCopyWith<$Res> {
  factory _$$_ReactionTypeLikeCopyWith(
          _$_ReactionTypeLike value, $Res Function(_$_ReactionTypeLike) then) =
      __$$_ReactionTypeLikeCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_ReactionTypeLikeCopyWithImpl<$Res>
    extends _$ReactionTypeCopyWithImpl<$Res, _$_ReactionTypeLike>
    implements _$$_ReactionTypeLikeCopyWith<$Res> {
  __$$_ReactionTypeLikeCopyWithImpl(
      _$_ReactionTypeLike _value, $Res Function(_$_ReactionTypeLike) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_ReactionTypeLike implements _ReactionTypeLike {
  const _$_ReactionTypeLike();

  @override
  String toString() {
    return 'ReactionType.like()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_ReactionTypeLike);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unknownReaction,
    required TResult Function() like,
    required TResult Function() dislike,
    required TResult Function() comment,
    required TResult Function() bookmark,
  }) {
    return like();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unknownReaction,
    TResult? Function()? like,
    TResult? Function()? dislike,
    TResult? Function()? comment,
    TResult? Function()? bookmark,
  }) {
    return like?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unknownReaction,
    TResult Function()? like,
    TResult Function()? dislike,
    TResult Function()? comment,
    TResult Function()? bookmark,
    required TResult orElse(),
  }) {
    if (like != null) {
      return like();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ReactionTypeUnknownReaction value)
        unknownReaction,
    required TResult Function(_ReactionTypeLike value) like,
    required TResult Function(_ReactionTypeDislike value) dislike,
    required TResult Function(_ReactionTypeComment value) comment,
    required TResult Function(_ReactionTypeBookmark value) bookmark,
  }) {
    return like(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ReactionTypeUnknownReaction value)? unknownReaction,
    TResult? Function(_ReactionTypeLike value)? like,
    TResult? Function(_ReactionTypeDislike value)? dislike,
    TResult? Function(_ReactionTypeComment value)? comment,
    TResult? Function(_ReactionTypeBookmark value)? bookmark,
  }) {
    return like?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ReactionTypeUnknownReaction value)? unknownReaction,
    TResult Function(_ReactionTypeLike value)? like,
    TResult Function(_ReactionTypeDislike value)? dislike,
    TResult Function(_ReactionTypeComment value)? comment,
    TResult Function(_ReactionTypeBookmark value)? bookmark,
    required TResult orElse(),
  }) {
    if (like != null) {
      return like(this);
    }
    return orElse();
  }
}

abstract class _ReactionTypeLike implements ReactionType {
  const factory _ReactionTypeLike() = _$_ReactionTypeLike;
}

/// @nodoc
abstract class _$$_ReactionTypeDislikeCopyWith<$Res> {
  factory _$$_ReactionTypeDislikeCopyWith(_$_ReactionTypeDislike value,
          $Res Function(_$_ReactionTypeDislike) then) =
      __$$_ReactionTypeDislikeCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_ReactionTypeDislikeCopyWithImpl<$Res>
    extends _$ReactionTypeCopyWithImpl<$Res, _$_ReactionTypeDislike>
    implements _$$_ReactionTypeDislikeCopyWith<$Res> {
  __$$_ReactionTypeDislikeCopyWithImpl(_$_ReactionTypeDislike _value,
      $Res Function(_$_ReactionTypeDislike) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_ReactionTypeDislike implements _ReactionTypeDislike {
  const _$_ReactionTypeDislike();

  @override
  String toString() {
    return 'ReactionType.dislike()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_ReactionTypeDislike);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unknownReaction,
    required TResult Function() like,
    required TResult Function() dislike,
    required TResult Function() comment,
    required TResult Function() bookmark,
  }) {
    return dislike();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unknownReaction,
    TResult? Function()? like,
    TResult? Function()? dislike,
    TResult? Function()? comment,
    TResult? Function()? bookmark,
  }) {
    return dislike?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unknownReaction,
    TResult Function()? like,
    TResult Function()? dislike,
    TResult Function()? comment,
    TResult Function()? bookmark,
    required TResult orElse(),
  }) {
    if (dislike != null) {
      return dislike();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ReactionTypeUnknownReaction value)
        unknownReaction,
    required TResult Function(_ReactionTypeLike value) like,
    required TResult Function(_ReactionTypeDislike value) dislike,
    required TResult Function(_ReactionTypeComment value) comment,
    required TResult Function(_ReactionTypeBookmark value) bookmark,
  }) {
    return dislike(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ReactionTypeUnknownReaction value)? unknownReaction,
    TResult? Function(_ReactionTypeLike value)? like,
    TResult? Function(_ReactionTypeDislike value)? dislike,
    TResult? Function(_ReactionTypeComment value)? comment,
    TResult? Function(_ReactionTypeBookmark value)? bookmark,
  }) {
    return dislike?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ReactionTypeUnknownReaction value)? unknownReaction,
    TResult Function(_ReactionTypeLike value)? like,
    TResult Function(_ReactionTypeDislike value)? dislike,
    TResult Function(_ReactionTypeComment value)? comment,
    TResult Function(_ReactionTypeBookmark value)? bookmark,
    required TResult orElse(),
  }) {
    if (dislike != null) {
      return dislike(this);
    }
    return orElse();
  }
}

abstract class _ReactionTypeDislike implements ReactionType {
  const factory _ReactionTypeDislike() = _$_ReactionTypeDislike;
}

/// @nodoc
abstract class _$$_ReactionTypeCommentCopyWith<$Res> {
  factory _$$_ReactionTypeCommentCopyWith(_$_ReactionTypeComment value,
          $Res Function(_$_ReactionTypeComment) then) =
      __$$_ReactionTypeCommentCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_ReactionTypeCommentCopyWithImpl<$Res>
    extends _$ReactionTypeCopyWithImpl<$Res, _$_ReactionTypeComment>
    implements _$$_ReactionTypeCommentCopyWith<$Res> {
  __$$_ReactionTypeCommentCopyWithImpl(_$_ReactionTypeComment _value,
      $Res Function(_$_ReactionTypeComment) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_ReactionTypeComment implements _ReactionTypeComment {
  const _$_ReactionTypeComment();

  @override
  String toString() {
    return 'ReactionType.comment()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_ReactionTypeComment);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unknownReaction,
    required TResult Function() like,
    required TResult Function() dislike,
    required TResult Function() comment,
    required TResult Function() bookmark,
  }) {
    return comment();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unknownReaction,
    TResult? Function()? like,
    TResult? Function()? dislike,
    TResult? Function()? comment,
    TResult? Function()? bookmark,
  }) {
    return comment?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unknownReaction,
    TResult Function()? like,
    TResult Function()? dislike,
    TResult Function()? comment,
    TResult Function()? bookmark,
    required TResult orElse(),
  }) {
    if (comment != null) {
      return comment();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ReactionTypeUnknownReaction value)
        unknownReaction,
    required TResult Function(_ReactionTypeLike value) like,
    required TResult Function(_ReactionTypeDislike value) dislike,
    required TResult Function(_ReactionTypeComment value) comment,
    required TResult Function(_ReactionTypeBookmark value) bookmark,
  }) {
    return comment(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ReactionTypeUnknownReaction value)? unknownReaction,
    TResult? Function(_ReactionTypeLike value)? like,
    TResult? Function(_ReactionTypeDislike value)? dislike,
    TResult? Function(_ReactionTypeComment value)? comment,
    TResult? Function(_ReactionTypeBookmark value)? bookmark,
  }) {
    return comment?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ReactionTypeUnknownReaction value)? unknownReaction,
    TResult Function(_ReactionTypeLike value)? like,
    TResult Function(_ReactionTypeDislike value)? dislike,
    TResult Function(_ReactionTypeComment value)? comment,
    TResult Function(_ReactionTypeBookmark value)? bookmark,
    required TResult orElse(),
  }) {
    if (comment != null) {
      return comment(this);
    }
    return orElse();
  }
}

abstract class _ReactionTypeComment implements ReactionType {
  const factory _ReactionTypeComment() = _$_ReactionTypeComment;
}

/// @nodoc
abstract class _$$_ReactionTypeBookmarkCopyWith<$Res> {
  factory _$$_ReactionTypeBookmarkCopyWith(_$_ReactionTypeBookmark value,
          $Res Function(_$_ReactionTypeBookmark) then) =
      __$$_ReactionTypeBookmarkCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_ReactionTypeBookmarkCopyWithImpl<$Res>
    extends _$ReactionTypeCopyWithImpl<$Res, _$_ReactionTypeBookmark>
    implements _$$_ReactionTypeBookmarkCopyWith<$Res> {
  __$$_ReactionTypeBookmarkCopyWithImpl(_$_ReactionTypeBookmark _value,
      $Res Function(_$_ReactionTypeBookmark) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_ReactionTypeBookmark implements _ReactionTypeBookmark {
  const _$_ReactionTypeBookmark();

  @override
  String toString() {
    return 'ReactionType.bookmark()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_ReactionTypeBookmark);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() unknownReaction,
    required TResult Function() like,
    required TResult Function() dislike,
    required TResult Function() comment,
    required TResult Function() bookmark,
  }) {
    return bookmark();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unknownReaction,
    TResult? Function()? like,
    TResult? Function()? dislike,
    TResult? Function()? comment,
    TResult? Function()? bookmark,
  }) {
    return bookmark?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unknownReaction,
    TResult Function()? like,
    TResult Function()? dislike,
    TResult Function()? comment,
    TResult Function()? bookmark,
    required TResult orElse(),
  }) {
    if (bookmark != null) {
      return bookmark();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ReactionTypeUnknownReaction value)
        unknownReaction,
    required TResult Function(_ReactionTypeLike value) like,
    required TResult Function(_ReactionTypeDislike value) dislike,
    required TResult Function(_ReactionTypeComment value) comment,
    required TResult Function(_ReactionTypeBookmark value) bookmark,
  }) {
    return bookmark(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ReactionTypeUnknownReaction value)? unknownReaction,
    TResult? Function(_ReactionTypeLike value)? like,
    TResult? Function(_ReactionTypeDislike value)? dislike,
    TResult? Function(_ReactionTypeComment value)? comment,
    TResult? Function(_ReactionTypeBookmark value)? bookmark,
  }) {
    return bookmark?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ReactionTypeUnknownReaction value)? unknownReaction,
    TResult Function(_ReactionTypeLike value)? like,
    TResult Function(_ReactionTypeDislike value)? dislike,
    TResult Function(_ReactionTypeComment value)? comment,
    TResult Function(_ReactionTypeBookmark value)? bookmark,
    required TResult orElse(),
  }) {
    if (bookmark != null) {
      return bookmark(this);
    }
    return orElse();
  }
}

abstract class _ReactionTypeBookmark implements ReactionType {
  const factory _ReactionTypeBookmark() = _$_ReactionTypeBookmark;
}

ReactionStatistics _$ReactionStatisticsFromJson(Map<String, dynamic> json) {
  return _ReactionStatistics.fromJson(json);
}

/// @nodoc
mixin _$ReactionStatistics {
  @JsonKey(name: 'feed')
  String get feed => throw _privateConstructorUsedError;
  @JsonKey(name: 'counts')
  Map<String, int> get counts => throw _privateConstructorUsedError;
  @JsonKey(name: 'unique_user_reactions')
  Map<String, bool> get uniqueUserReactions =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'activity_id')
  String get activityId => throw _privateConstructorUsedError;
  @JsonKey(name: 'reaction_id')
  String get reactionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReactionStatisticsCopyWith<ReactionStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReactionStatisticsCopyWith<$Res> {
  factory $ReactionStatisticsCopyWith(
          ReactionStatistics value, $Res Function(ReactionStatistics) then) =
      _$ReactionStatisticsCopyWithImpl<$Res, ReactionStatistics>;
  @useResult
  $Res call(
      {@JsonKey(name: 'feed') String feed,
      @JsonKey(name: 'counts') Map<String, int> counts,
      @JsonKey(name: 'unique_user_reactions')
      Map<String, bool> uniqueUserReactions,
      @JsonKey(name: 'activity_id') String activityId,
      @JsonKey(name: 'reaction_id') String reactionId,
      @JsonKey(name: 'user_id') String userId});
}

/// @nodoc
class _$ReactionStatisticsCopyWithImpl<$Res, $Val extends ReactionStatistics>
    implements $ReactionStatisticsCopyWith<$Res> {
  _$ReactionStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? feed = null,
    Object? counts = null,
    Object? uniqueUserReactions = null,
    Object? activityId = null,
    Object? reactionId = null,
    Object? userId = null,
  }) {
    return _then(_value.copyWith(
      feed: null == feed
          ? _value.feed
          : feed // ignore: cast_nullable_to_non_nullable
              as String,
      counts: null == counts
          ? _value.counts
          : counts // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      uniqueUserReactions: null == uniqueUserReactions
          ? _value.uniqueUserReactions
          : uniqueUserReactions // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
      activityId: null == activityId
          ? _value.activityId
          : activityId // ignore: cast_nullable_to_non_nullable
              as String,
      reactionId: null == reactionId
          ? _value.reactionId
          : reactionId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ReactionStatisticsCopyWith<$Res>
    implements $ReactionStatisticsCopyWith<$Res> {
  factory _$$_ReactionStatisticsCopyWith(_$_ReactionStatistics value,
          $Res Function(_$_ReactionStatistics) then) =
      __$$_ReactionStatisticsCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'feed') String feed,
      @JsonKey(name: 'counts') Map<String, int> counts,
      @JsonKey(name: 'unique_user_reactions')
      Map<String, bool> uniqueUserReactions,
      @JsonKey(name: 'activity_id') String activityId,
      @JsonKey(name: 'reaction_id') String reactionId,
      @JsonKey(name: 'user_id') String userId});
}

/// @nodoc
class __$$_ReactionStatisticsCopyWithImpl<$Res>
    extends _$ReactionStatisticsCopyWithImpl<$Res, _$_ReactionStatistics>
    implements _$$_ReactionStatisticsCopyWith<$Res> {
  __$$_ReactionStatisticsCopyWithImpl(
      _$_ReactionStatistics _value, $Res Function(_$_ReactionStatistics) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? feed = null,
    Object? counts = null,
    Object? uniqueUserReactions = null,
    Object? activityId = null,
    Object? reactionId = null,
    Object? userId = null,
  }) {
    return _then(_$_ReactionStatistics(
      feed: null == feed
          ? _value.feed
          : feed // ignore: cast_nullable_to_non_nullable
              as String,
      counts: null == counts
          ? _value._counts
          : counts // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      uniqueUserReactions: null == uniqueUserReactions
          ? _value._uniqueUserReactions
          : uniqueUserReactions // ignore: cast_nullable_to_non_nullable
              as Map<String, bool>,
      activityId: null == activityId
          ? _value.activityId
          : activityId // ignore: cast_nullable_to_non_nullable
              as String,
      reactionId: null == reactionId
          ? _value.reactionId
          : reactionId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ReactionStatistics implements _ReactionStatistics {
  const _$_ReactionStatistics(
      {@JsonKey(name: 'feed') this.feed = '',
      @JsonKey(name: 'counts') final Map<String, int> counts = const {},
      @JsonKey(name: 'unique_user_reactions')
      final Map<String, bool> uniqueUserReactions = const {},
      @JsonKey(name: 'activity_id') this.activityId = '',
      @JsonKey(name: 'reaction_id') this.reactionId = '',
      @JsonKey(name: 'user_id') this.userId = ''})
      : _counts = counts,
        _uniqueUserReactions = uniqueUserReactions;

  factory _$_ReactionStatistics.fromJson(Map<String, dynamic> json) =>
      _$$_ReactionStatisticsFromJson(json);

  @override
  @JsonKey(name: 'feed')
  final String feed;
  final Map<String, int> _counts;
  @override
  @JsonKey(name: 'counts')
  Map<String, int> get counts {
    if (_counts is EqualUnmodifiableMapView) return _counts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_counts);
  }

  final Map<String, bool> _uniqueUserReactions;
  @override
  @JsonKey(name: 'unique_user_reactions')
  Map<String, bool> get uniqueUserReactions {
    if (_uniqueUserReactions is EqualUnmodifiableMapView)
      return _uniqueUserReactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_uniqueUserReactions);
  }

  @override
  @JsonKey(name: 'activity_id')
  final String activityId;
  @override
  @JsonKey(name: 'reaction_id')
  final String reactionId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;

  @override
  String toString() {
    return 'ReactionStatistics(feed: $feed, counts: $counts, uniqueUserReactions: $uniqueUserReactions, activityId: $activityId, reactionId: $reactionId, userId: $userId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ReactionStatistics &&
            (identical(other.feed, feed) || other.feed == feed) &&
            const DeepCollectionEquality().equals(other._counts, _counts) &&
            const DeepCollectionEquality()
                .equals(other._uniqueUserReactions, _uniqueUserReactions) &&
            (identical(other.activityId, activityId) ||
                other.activityId == activityId) &&
            (identical(other.reactionId, reactionId) ||
                other.reactionId == reactionId) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      feed,
      const DeepCollectionEquality().hash(_counts),
      const DeepCollectionEquality().hash(_uniqueUserReactions),
      activityId,
      reactionId,
      userId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ReactionStatisticsCopyWith<_$_ReactionStatistics> get copyWith =>
      __$$_ReactionStatisticsCopyWithImpl<_$_ReactionStatistics>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ReactionStatisticsToJson(
      this,
    );
  }
}

abstract class _ReactionStatistics implements ReactionStatistics {
  const factory _ReactionStatistics(
      {@JsonKey(name: 'feed') final String feed,
      @JsonKey(name: 'counts') final Map<String, int> counts,
      @JsonKey(name: 'unique_user_reactions')
      final Map<String, bool> uniqueUserReactions,
      @JsonKey(name: 'activity_id') final String activityId,
      @JsonKey(name: 'reaction_id') final String reactionId,
      @JsonKey(name: 'user_id') final String userId}) = _$_ReactionStatistics;

  factory _ReactionStatistics.fromJson(Map<String, dynamic> json) =
      _$_ReactionStatistics.fromJson;

  @override
  @JsonKey(name: 'feed')
  String get feed;
  @override
  @JsonKey(name: 'counts')
  Map<String, int> get counts;
  @override
  @JsonKey(name: 'unique_user_reactions')
  Map<String, bool> get uniqueUserReactions;
  @override
  @JsonKey(name: 'activity_id')
  String get activityId;
  @override
  @JsonKey(name: 'reaction_id')
  String get reactionId;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(ignore: true)
  _$$_ReactionStatisticsCopyWith<_$_ReactionStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}
