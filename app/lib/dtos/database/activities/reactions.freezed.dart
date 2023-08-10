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
  String get activityId => throw _privateConstructorUsedError;
  String get reactionId => throw _privateConstructorUsedError;
  String get senderId => throw _privateConstructorUsedError;
  @JsonKey(fromJson: ReactionType.fromJson, toJson: ReactionType.toJson)
  ReactionType get reactionType => throw _privateConstructorUsedError;

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
      {String activityId,
      String reactionId,
      String senderId,
      @JsonKey(fromJson: ReactionType.fromJson, toJson: ReactionType.toJson)
      ReactionType reactionType});

  $ReactionTypeCopyWith<$Res> get reactionType;
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
    Object? senderId = null,
    Object? reactionType = null,
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
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      reactionType: null == reactionType
          ? _value.reactionType
          : reactionType // ignore: cast_nullable_to_non_nullable
              as ReactionType,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ReactionTypeCopyWith<$Res> get reactionType {
    return $ReactionTypeCopyWith<$Res>(_value.reactionType, (value) {
      return _then(_value.copyWith(reactionType: value) as $Val);
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
      {String activityId,
      String reactionId,
      String senderId,
      @JsonKey(fromJson: ReactionType.fromJson, toJson: ReactionType.toJson)
      ReactionType reactionType});

  @override
  $ReactionTypeCopyWith<$Res> get reactionType;
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
    Object? senderId = null,
    Object? reactionType = null,
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
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      reactionType: null == reactionType
          ? _value.reactionType
          : reactionType // ignore: cast_nullable_to_non_nullable
              as ReactionType,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Reaction implements _Reaction {
  const _$_Reaction(
      {this.activityId = '',
      this.reactionId = '',
      this.senderId = '',
      @JsonKey(fromJson: ReactionType.fromJson, toJson: ReactionType.toJson)
      this.reactionType = const ReactionType.unknownReaction()});

  factory _$_Reaction.fromJson(Map<String, dynamic> json) =>
      _$$_ReactionFromJson(json);

  @override
  @JsonKey()
  final String activityId;
  @override
  @JsonKey()
  final String reactionId;
  @override
  @JsonKey()
  final String senderId;
  @override
  @JsonKey(fromJson: ReactionType.fromJson, toJson: ReactionType.toJson)
  final ReactionType reactionType;

  @override
  String toString() {
    return 'Reaction(activityId: $activityId, reactionId: $reactionId, senderId: $senderId, reactionType: $reactionType)';
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
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.reactionType, reactionType) ||
                other.reactionType == reactionType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, activityId, reactionId, senderId, reactionType);

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
      {final String activityId,
      final String reactionId,
      final String senderId,
      @JsonKey(fromJson: ReactionType.fromJson, toJson: ReactionType.toJson)
      final ReactionType reactionType}) = _$_Reaction;

  factory _Reaction.fromJson(Map<String, dynamic> json) = _$_Reaction.fromJson;

  @override
  String get activityId;
  @override
  String get reactionId;
  @override
  String get senderId;
  @override
  @JsonKey(fromJson: ReactionType.fromJson, toJson: ReactionType.toJson)
  ReactionType get reactionType;
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
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unknownReaction,
    TResult? Function()? like,
    TResult? Function()? dislike,
    TResult? Function()? comment,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unknownReaction,
    TResult Function()? like,
    TResult Function()? dislike,
    TResult Function()? comment,
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
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ReactionTypeUnknownReaction value)? unknownReaction,
    TResult? Function(_ReactionTypeLike value)? like,
    TResult? Function(_ReactionTypeDislike value)? dislike,
    TResult? Function(_ReactionTypeComment value)? comment,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ReactionTypeUnknownReaction value)? unknownReaction,
    TResult Function(_ReactionTypeLike value)? like,
    TResult Function(_ReactionTypeDislike value)? dislike,
    TResult Function(_ReactionTypeComment value)? comment,
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
