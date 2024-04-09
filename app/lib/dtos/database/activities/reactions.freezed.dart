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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Reaction _$ReactionFromJson(Map<String, dynamic> json) {
  return _Reaction.fromJson(json);
}

/// @nodoc
mixin _$Reaction {
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta => throw _privateConstructorUsedError;
  @JsonKey(name: 'activity_id')
  String get activityId => throw _privateConstructorUsedError;
  @JsonKey(name: 'reaction_id')
  String get reactionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'entry_id')
  String get entryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(fromJson: ReactionType.fromJson, toJson: ReactionType.toJson)
  ReactionType get kind => throw _privateConstructorUsedError;
  @JsonKey(name: 'text')
  String get text => throw _privateConstructorUsedError;
  @JsonKey(name: 'tags')
  List<String> get tags => throw _privateConstructorUsedError;
  @JsonKey(fromJson: Mention.fromJsonList, toJson: Mention.toJsonList)
  List<Mention> get mentions => throw _privateConstructorUsedError;

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
      {@JsonKey(name: '_fl_meta_') FlMeta? flMeta,
      @JsonKey(name: 'activity_id') String activityId,
      @JsonKey(name: 'reaction_id') String reactionId,
      @JsonKey(name: 'entry_id') String entryId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(fromJson: ReactionType.fromJson, toJson: ReactionType.toJson)
      ReactionType kind,
      @JsonKey(name: 'text') String text,
      @JsonKey(name: 'tags') List<String> tags,
      @JsonKey(fromJson: Mention.fromJsonList, toJson: Mention.toJsonList)
      List<Mention> mentions});

  $FlMetaCopyWith<$Res>? get flMeta;
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
    Object? flMeta = freezed,
    Object? activityId = null,
    Object? reactionId = null,
    Object? entryId = null,
    Object? userId = null,
    Object? kind = null,
    Object? text = null,
    Object? tags = null,
    Object? mentions = null,
  }) {
    return _then(_value.copyWith(
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
      activityId: null == activityId
          ? _value.activityId
          : activityId // ignore: cast_nullable_to_non_nullable
              as String,
      reactionId: null == reactionId
          ? _value.reactionId
          : reactionId // ignore: cast_nullable_to_non_nullable
              as String,
      entryId: null == entryId
          ? _value.entryId
          : entryId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as ReactionType,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      mentions: null == mentions
          ? _value.mentions
          : mentions // ignore: cast_nullable_to_non_nullable
              as List<Mention>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $FlMetaCopyWith<$Res>? get flMeta {
    if (_value.flMeta == null) {
      return null;
    }

    return $FlMetaCopyWith<$Res>(_value.flMeta!, (value) {
      return _then(_value.copyWith(flMeta: value) as $Val);
    });
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
abstract class _$$ReactionImplCopyWith<$Res>
    implements $ReactionCopyWith<$Res> {
  factory _$$ReactionImplCopyWith(
          _$ReactionImpl value, $Res Function(_$ReactionImpl) then) =
      __$$ReactionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_fl_meta_') FlMeta? flMeta,
      @JsonKey(name: 'activity_id') String activityId,
      @JsonKey(name: 'reaction_id') String reactionId,
      @JsonKey(name: 'entry_id') String entryId,
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(fromJson: ReactionType.fromJson, toJson: ReactionType.toJson)
      ReactionType kind,
      @JsonKey(name: 'text') String text,
      @JsonKey(name: 'tags') List<String> tags,
      @JsonKey(fromJson: Mention.fromJsonList, toJson: Mention.toJsonList)
      List<Mention> mentions});

  @override
  $FlMetaCopyWith<$Res>? get flMeta;
  @override
  $ReactionTypeCopyWith<$Res> get kind;
}

/// @nodoc
class __$$ReactionImplCopyWithImpl<$Res>
    extends _$ReactionCopyWithImpl<$Res, _$ReactionImpl>
    implements _$$ReactionImplCopyWith<$Res> {
  __$$ReactionImplCopyWithImpl(
      _$ReactionImpl _value, $Res Function(_$ReactionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flMeta = freezed,
    Object? activityId = null,
    Object? reactionId = null,
    Object? entryId = null,
    Object? userId = null,
    Object? kind = null,
    Object? text = null,
    Object? tags = null,
    Object? mentions = null,
  }) {
    return _then(_$ReactionImpl(
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
      activityId: null == activityId
          ? _value.activityId
          : activityId // ignore: cast_nullable_to_non_nullable
              as String,
      reactionId: null == reactionId
          ? _value.reactionId
          : reactionId // ignore: cast_nullable_to_non_nullable
              as String,
      entryId: null == entryId
          ? _value.entryId
          : entryId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      kind: null == kind
          ? _value.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as ReactionType,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      mentions: null == mentions
          ? _value._mentions
          : mentions // ignore: cast_nullable_to_non_nullable
              as List<Mention>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReactionImpl implements _Reaction {
  const _$ReactionImpl(
      {@JsonKey(name: '_fl_meta_') this.flMeta,
      @JsonKey(name: 'activity_id') this.activityId = '',
      @JsonKey(name: 'reaction_id') this.reactionId = '',
      @JsonKey(name: 'entry_id') this.entryId = '',
      @JsonKey(name: 'user_id') this.userId = '',
      @JsonKey(fromJson: ReactionType.fromJson, toJson: ReactionType.toJson)
      this.kind = const ReactionType.unknownReaction(),
      @JsonKey(name: 'text') this.text = '',
      @JsonKey(name: 'tags') final List<String> tags = const [],
      @JsonKey(fromJson: Mention.fromJsonList, toJson: Mention.toJsonList)
      final List<Mention> mentions = const []})
      : _tags = tags,
        _mentions = mentions;

  factory _$ReactionImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReactionImplFromJson(json);

  @override
  @JsonKey(name: '_fl_meta_')
  final FlMeta? flMeta;
  @override
  @JsonKey(name: 'activity_id')
  final String activityId;
  @override
  @JsonKey(name: 'reaction_id')
  final String reactionId;
  @override
  @JsonKey(name: 'entry_id')
  final String entryId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(fromJson: ReactionType.fromJson, toJson: ReactionType.toJson)
  final ReactionType kind;
  @override
  @JsonKey(name: 'text')
  final String text;
  final List<String> _tags;
  @override
  @JsonKey(name: 'tags')
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  final List<Mention> _mentions;
  @override
  @JsonKey(fromJson: Mention.fromJsonList, toJson: Mention.toJsonList)
  List<Mention> get mentions {
    if (_mentions is EqualUnmodifiableListView) return _mentions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mentions);
  }

  @override
  String toString() {
    return 'Reaction(flMeta: $flMeta, activityId: $activityId, reactionId: $reactionId, entryId: $entryId, userId: $userId, kind: $kind, text: $text, tags: $tags, mentions: $mentions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReactionImpl &&
            (identical(other.flMeta, flMeta) || other.flMeta == flMeta) &&
            (identical(other.activityId, activityId) ||
                other.activityId == activityId) &&
            (identical(other.reactionId, reactionId) ||
                other.reactionId == reactionId) &&
            (identical(other.entryId, entryId) || other.entryId == entryId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.text, text) || other.text == text) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality().equals(other._mentions, _mentions));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      flMeta,
      activityId,
      reactionId,
      entryId,
      userId,
      kind,
      text,
      const DeepCollectionEquality().hash(_tags),
      const DeepCollectionEquality().hash(_mentions));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReactionImplCopyWith<_$ReactionImpl> get copyWith =>
      __$$ReactionImplCopyWithImpl<_$ReactionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReactionImplToJson(
      this,
    );
  }
}

abstract class _Reaction implements Reaction {
  const factory _Reaction(
      {@JsonKey(name: '_fl_meta_') final FlMeta? flMeta,
      @JsonKey(name: 'activity_id') final String activityId,
      @JsonKey(name: 'reaction_id') final String reactionId,
      @JsonKey(name: 'entry_id') final String entryId,
      @JsonKey(name: 'user_id') final String userId,
      @JsonKey(fromJson: ReactionType.fromJson, toJson: ReactionType.toJson)
      final ReactionType kind,
      @JsonKey(name: 'text') final String text,
      @JsonKey(name: 'tags') final List<String> tags,
      @JsonKey(fromJson: Mention.fromJsonList, toJson: Mention.toJsonList)
      final List<Mention> mentions}) = _$ReactionImpl;

  factory _Reaction.fromJson(Map<String, dynamic> json) =
      _$ReactionImpl.fromJson;

  @override
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta;
  @override
  @JsonKey(name: 'activity_id')
  String get activityId;
  @override
  @JsonKey(name: 'reaction_id')
  String get reactionId;
  @override
  @JsonKey(name: 'entry_id')
  String get entryId;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(fromJson: ReactionType.fromJson, toJson: ReactionType.toJson)
  ReactionType get kind;
  @override
  @JsonKey(name: 'text')
  String get text;
  @override
  @JsonKey(name: 'tags')
  List<String> get tags;
  @override
  @JsonKey(fromJson: Mention.fromJsonList, toJson: Mention.toJsonList)
  List<Mention> get mentions;
  @override
  @JsonKey(ignore: true)
  _$$ReactionImplCopyWith<_$ReactionImpl> get copyWith =>
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
    required TResult Function() share,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unknownReaction,
    TResult? Function()? like,
    TResult? Function()? dislike,
    TResult? Function()? comment,
    TResult? Function()? bookmark,
    TResult? Function()? share,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unknownReaction,
    TResult Function()? like,
    TResult Function()? dislike,
    TResult Function()? comment,
    TResult Function()? bookmark,
    TResult Function()? share,
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
    required TResult Function(_ReactionTypeShare value) share,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ReactionTypeUnknownReaction value)? unknownReaction,
    TResult? Function(_ReactionTypeLike value)? like,
    TResult? Function(_ReactionTypeDislike value)? dislike,
    TResult? Function(_ReactionTypeComment value)? comment,
    TResult? Function(_ReactionTypeBookmark value)? bookmark,
    TResult? Function(_ReactionTypeShare value)? share,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ReactionTypeUnknownReaction value)? unknownReaction,
    TResult Function(_ReactionTypeLike value)? like,
    TResult Function(_ReactionTypeDislike value)? dislike,
    TResult Function(_ReactionTypeComment value)? comment,
    TResult Function(_ReactionTypeBookmark value)? bookmark,
    TResult Function(_ReactionTypeShare value)? share,
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
abstract class _$$ReactionTypeUnknownReactionImplCopyWith<$Res> {
  factory _$$ReactionTypeUnknownReactionImplCopyWith(
          _$ReactionTypeUnknownReactionImpl value,
          $Res Function(_$ReactionTypeUnknownReactionImpl) then) =
      __$$ReactionTypeUnknownReactionImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ReactionTypeUnknownReactionImplCopyWithImpl<$Res>
    extends _$ReactionTypeCopyWithImpl<$Res, _$ReactionTypeUnknownReactionImpl>
    implements _$$ReactionTypeUnknownReactionImplCopyWith<$Res> {
  __$$ReactionTypeUnknownReactionImplCopyWithImpl(
      _$ReactionTypeUnknownReactionImpl _value,
      $Res Function(_$ReactionTypeUnknownReactionImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ReactionTypeUnknownReactionImpl
    implements _ReactionTypeUnknownReaction {
  const _$ReactionTypeUnknownReactionImpl();

  @override
  String toString() {
    return 'ReactionType.unknownReaction()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReactionTypeUnknownReactionImpl);
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
    required TResult Function() share,
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
    TResult? Function()? share,
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
    TResult Function()? share,
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
    required TResult Function(_ReactionTypeShare value) share,
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
    TResult? Function(_ReactionTypeShare value)? share,
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
    TResult Function(_ReactionTypeShare value)? share,
    required TResult orElse(),
  }) {
    if (unknownReaction != null) {
      return unknownReaction(this);
    }
    return orElse();
  }
}

abstract class _ReactionTypeUnknownReaction implements ReactionType {
  const factory _ReactionTypeUnknownReaction() =
      _$ReactionTypeUnknownReactionImpl;
}

/// @nodoc
abstract class _$$ReactionTypeLikeImplCopyWith<$Res> {
  factory _$$ReactionTypeLikeImplCopyWith(_$ReactionTypeLikeImpl value,
          $Res Function(_$ReactionTypeLikeImpl) then) =
      __$$ReactionTypeLikeImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ReactionTypeLikeImplCopyWithImpl<$Res>
    extends _$ReactionTypeCopyWithImpl<$Res, _$ReactionTypeLikeImpl>
    implements _$$ReactionTypeLikeImplCopyWith<$Res> {
  __$$ReactionTypeLikeImplCopyWithImpl(_$ReactionTypeLikeImpl _value,
      $Res Function(_$ReactionTypeLikeImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ReactionTypeLikeImpl implements _ReactionTypeLike {
  const _$ReactionTypeLikeImpl();

  @override
  String toString() {
    return 'ReactionType.like()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ReactionTypeLikeImpl);
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
    required TResult Function() share,
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
    TResult? Function()? share,
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
    TResult Function()? share,
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
    required TResult Function(_ReactionTypeShare value) share,
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
    TResult? Function(_ReactionTypeShare value)? share,
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
    TResult Function(_ReactionTypeShare value)? share,
    required TResult orElse(),
  }) {
    if (like != null) {
      return like(this);
    }
    return orElse();
  }
}

abstract class _ReactionTypeLike implements ReactionType {
  const factory _ReactionTypeLike() = _$ReactionTypeLikeImpl;
}

/// @nodoc
abstract class _$$ReactionTypeDislikeImplCopyWith<$Res> {
  factory _$$ReactionTypeDislikeImplCopyWith(_$ReactionTypeDislikeImpl value,
          $Res Function(_$ReactionTypeDislikeImpl) then) =
      __$$ReactionTypeDislikeImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ReactionTypeDislikeImplCopyWithImpl<$Res>
    extends _$ReactionTypeCopyWithImpl<$Res, _$ReactionTypeDislikeImpl>
    implements _$$ReactionTypeDislikeImplCopyWith<$Res> {
  __$$ReactionTypeDislikeImplCopyWithImpl(_$ReactionTypeDislikeImpl _value,
      $Res Function(_$ReactionTypeDislikeImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ReactionTypeDislikeImpl implements _ReactionTypeDislike {
  const _$ReactionTypeDislikeImpl();

  @override
  String toString() {
    return 'ReactionType.dislike()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReactionTypeDislikeImpl);
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
    required TResult Function() share,
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
    TResult? Function()? share,
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
    TResult Function()? share,
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
    required TResult Function(_ReactionTypeShare value) share,
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
    TResult? Function(_ReactionTypeShare value)? share,
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
    TResult Function(_ReactionTypeShare value)? share,
    required TResult orElse(),
  }) {
    if (dislike != null) {
      return dislike(this);
    }
    return orElse();
  }
}

abstract class _ReactionTypeDislike implements ReactionType {
  const factory _ReactionTypeDislike() = _$ReactionTypeDislikeImpl;
}

/// @nodoc
abstract class _$$ReactionTypeCommentImplCopyWith<$Res> {
  factory _$$ReactionTypeCommentImplCopyWith(_$ReactionTypeCommentImpl value,
          $Res Function(_$ReactionTypeCommentImpl) then) =
      __$$ReactionTypeCommentImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ReactionTypeCommentImplCopyWithImpl<$Res>
    extends _$ReactionTypeCopyWithImpl<$Res, _$ReactionTypeCommentImpl>
    implements _$$ReactionTypeCommentImplCopyWith<$Res> {
  __$$ReactionTypeCommentImplCopyWithImpl(_$ReactionTypeCommentImpl _value,
      $Res Function(_$ReactionTypeCommentImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ReactionTypeCommentImpl implements _ReactionTypeComment {
  const _$ReactionTypeCommentImpl();

  @override
  String toString() {
    return 'ReactionType.comment()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReactionTypeCommentImpl);
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
    required TResult Function() share,
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
    TResult? Function()? share,
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
    TResult Function()? share,
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
    required TResult Function(_ReactionTypeShare value) share,
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
    TResult? Function(_ReactionTypeShare value)? share,
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
    TResult Function(_ReactionTypeShare value)? share,
    required TResult orElse(),
  }) {
    if (comment != null) {
      return comment(this);
    }
    return orElse();
  }
}

abstract class _ReactionTypeComment implements ReactionType {
  const factory _ReactionTypeComment() = _$ReactionTypeCommentImpl;
}

/// @nodoc
abstract class _$$ReactionTypeBookmarkImplCopyWith<$Res> {
  factory _$$ReactionTypeBookmarkImplCopyWith(_$ReactionTypeBookmarkImpl value,
          $Res Function(_$ReactionTypeBookmarkImpl) then) =
      __$$ReactionTypeBookmarkImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ReactionTypeBookmarkImplCopyWithImpl<$Res>
    extends _$ReactionTypeCopyWithImpl<$Res, _$ReactionTypeBookmarkImpl>
    implements _$$ReactionTypeBookmarkImplCopyWith<$Res> {
  __$$ReactionTypeBookmarkImplCopyWithImpl(_$ReactionTypeBookmarkImpl _value,
      $Res Function(_$ReactionTypeBookmarkImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ReactionTypeBookmarkImpl implements _ReactionTypeBookmark {
  const _$ReactionTypeBookmarkImpl();

  @override
  String toString() {
    return 'ReactionType.bookmark()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReactionTypeBookmarkImpl);
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
    required TResult Function() share,
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
    TResult? Function()? share,
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
    TResult Function()? share,
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
    required TResult Function(_ReactionTypeShare value) share,
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
    TResult? Function(_ReactionTypeShare value)? share,
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
    TResult Function(_ReactionTypeShare value)? share,
    required TResult orElse(),
  }) {
    if (bookmark != null) {
      return bookmark(this);
    }
    return orElse();
  }
}

abstract class _ReactionTypeBookmark implements ReactionType {
  const factory _ReactionTypeBookmark() = _$ReactionTypeBookmarkImpl;
}

/// @nodoc
abstract class _$$ReactionTypeShareImplCopyWith<$Res> {
  factory _$$ReactionTypeShareImplCopyWith(_$ReactionTypeShareImpl value,
          $Res Function(_$ReactionTypeShareImpl) then) =
      __$$ReactionTypeShareImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ReactionTypeShareImplCopyWithImpl<$Res>
    extends _$ReactionTypeCopyWithImpl<$Res, _$ReactionTypeShareImpl>
    implements _$$ReactionTypeShareImplCopyWith<$Res> {
  __$$ReactionTypeShareImplCopyWithImpl(_$ReactionTypeShareImpl _value,
      $Res Function(_$ReactionTypeShareImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$ReactionTypeShareImpl implements _ReactionTypeShare {
  const _$ReactionTypeShareImpl();

  @override
  String toString() {
    return 'ReactionType.share()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ReactionTypeShareImpl);
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
    required TResult Function() share,
  }) {
    return share();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? unknownReaction,
    TResult? Function()? like,
    TResult? Function()? dislike,
    TResult? Function()? comment,
    TResult? Function()? bookmark,
    TResult? Function()? share,
  }) {
    return share?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? unknownReaction,
    TResult Function()? like,
    TResult Function()? dislike,
    TResult Function()? comment,
    TResult Function()? bookmark,
    TResult Function()? share,
    required TResult orElse(),
  }) {
    if (share != null) {
      return share();
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
    required TResult Function(_ReactionTypeShare value) share,
  }) {
    return share(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ReactionTypeUnknownReaction value)? unknownReaction,
    TResult? Function(_ReactionTypeLike value)? like,
    TResult? Function(_ReactionTypeDislike value)? dislike,
    TResult? Function(_ReactionTypeComment value)? comment,
    TResult? Function(_ReactionTypeBookmark value)? bookmark,
    TResult? Function(_ReactionTypeShare value)? share,
  }) {
    return share?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ReactionTypeUnknownReaction value)? unknownReaction,
    TResult Function(_ReactionTypeLike value)? like,
    TResult Function(_ReactionTypeDislike value)? dislike,
    TResult Function(_ReactionTypeComment value)? comment,
    TResult Function(_ReactionTypeBookmark value)? bookmark,
    TResult Function(_ReactionTypeShare value)? share,
    required TResult orElse(),
  }) {
    if (share != null) {
      return share(this);
    }
    return orElse();
  }
}

abstract class _ReactionTypeShare implements ReactionType {
  const factory _ReactionTypeShare() = _$ReactionTypeShareImpl;
}

ReactionStatistics _$ReactionStatisticsFromJson(Map<String, dynamic> json) {
  return _ReactionStatistics.fromJson(json);
}

/// @nodoc
mixin _$ReactionStatistics {
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta => throw _privateConstructorUsedError;
  @JsonKey(name: 'counts')
  Map<String, int> get counts => throw _privateConstructorUsedError;
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
      {@JsonKey(name: '_fl_meta_') FlMeta? flMeta,
      @JsonKey(name: 'counts') Map<String, int> counts,
      @JsonKey(name: 'activity_id') String activityId,
      @JsonKey(name: 'reaction_id') String reactionId,
      @JsonKey(name: 'user_id') String userId});

  $FlMetaCopyWith<$Res>? get flMeta;
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
    Object? flMeta = freezed,
    Object? counts = null,
    Object? activityId = null,
    Object? reactionId = null,
    Object? userId = null,
  }) {
    return _then(_value.copyWith(
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
      counts: null == counts
          ? _value.counts
          : counts // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
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

  @override
  @pragma('vm:prefer-inline')
  $FlMetaCopyWith<$Res>? get flMeta {
    if (_value.flMeta == null) {
      return null;
    }

    return $FlMetaCopyWith<$Res>(_value.flMeta!, (value) {
      return _then(_value.copyWith(flMeta: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ReactionStatisticsImplCopyWith<$Res>
    implements $ReactionStatisticsCopyWith<$Res> {
  factory _$$ReactionStatisticsImplCopyWith(_$ReactionStatisticsImpl value,
          $Res Function(_$ReactionStatisticsImpl) then) =
      __$$ReactionStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_fl_meta_') FlMeta? flMeta,
      @JsonKey(name: 'counts') Map<String, int> counts,
      @JsonKey(name: 'activity_id') String activityId,
      @JsonKey(name: 'reaction_id') String reactionId,
      @JsonKey(name: 'user_id') String userId});

  @override
  $FlMetaCopyWith<$Res>? get flMeta;
}

/// @nodoc
class __$$ReactionStatisticsImplCopyWithImpl<$Res>
    extends _$ReactionStatisticsCopyWithImpl<$Res, _$ReactionStatisticsImpl>
    implements _$$ReactionStatisticsImplCopyWith<$Res> {
  __$$ReactionStatisticsImplCopyWithImpl(_$ReactionStatisticsImpl _value,
      $Res Function(_$ReactionStatisticsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flMeta = freezed,
    Object? counts = null,
    Object? activityId = null,
    Object? reactionId = null,
    Object? userId = null,
  }) {
    return _then(_$ReactionStatisticsImpl(
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
      counts: null == counts
          ? _value._counts
          : counts // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
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
class _$ReactionStatisticsImpl implements _ReactionStatistics {
  const _$ReactionStatisticsImpl(
      {@JsonKey(name: '_fl_meta_') this.flMeta,
      @JsonKey(name: 'counts') final Map<String, int> counts = const {},
      @JsonKey(name: 'activity_id') this.activityId = '',
      @JsonKey(name: 'reaction_id') this.reactionId = '',
      @JsonKey(name: 'user_id') this.userId = ''})
      : _counts = counts;

  factory _$ReactionStatisticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReactionStatisticsImplFromJson(json);

  @override
  @JsonKey(name: '_fl_meta_')
  final FlMeta? flMeta;
  final Map<String, int> _counts;
  @override
  @JsonKey(name: 'counts')
  Map<String, int> get counts {
    if (_counts is EqualUnmodifiableMapView) return _counts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_counts);
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
    return 'ReactionStatistics(flMeta: $flMeta, counts: $counts, activityId: $activityId, reactionId: $reactionId, userId: $userId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReactionStatisticsImpl &&
            (identical(other.flMeta, flMeta) || other.flMeta == flMeta) &&
            const DeepCollectionEquality().equals(other._counts, _counts) &&
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
      flMeta,
      const DeepCollectionEquality().hash(_counts),
      activityId,
      reactionId,
      userId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReactionStatisticsImplCopyWith<_$ReactionStatisticsImpl> get copyWith =>
      __$$ReactionStatisticsImplCopyWithImpl<_$ReactionStatisticsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReactionStatisticsImplToJson(
      this,
    );
  }
}

abstract class _ReactionStatistics implements ReactionStatistics {
  const factory _ReactionStatistics(
          {@JsonKey(name: '_fl_meta_') final FlMeta? flMeta,
          @JsonKey(name: 'counts') final Map<String, int> counts,
          @JsonKey(name: 'activity_id') final String activityId,
          @JsonKey(name: 'reaction_id') final String reactionId,
          @JsonKey(name: 'user_id') final String userId}) =
      _$ReactionStatisticsImpl;

  factory _ReactionStatistics.fromJson(Map<String, dynamic> json) =
      _$ReactionStatisticsImpl.fromJson;

  @override
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta;
  @override
  @JsonKey(name: 'counts')
  Map<String, int> get counts;
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
  _$$ReactionStatisticsImplCopyWith<_$ReactionStatisticsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TargetFeed _$TargetFeedFromJson(Map<String, dynamic> json) {
  return _TargetFeed.fromJson(json);
}

/// @nodoc
mixin _$TargetFeed {
  String get targetSlug => throw _privateConstructorUsedError;
  String get targetUserId => throw _privateConstructorUsedError;
  bool get shouldPersonalize => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TargetFeedCopyWith<TargetFeed> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TargetFeedCopyWith<$Res> {
  factory $TargetFeedCopyWith(
          TargetFeed value, $Res Function(TargetFeed) then) =
      _$TargetFeedCopyWithImpl<$Res, TargetFeed>;
  @useResult
  $Res call({String targetSlug, String targetUserId, bool shouldPersonalize});
}

/// @nodoc
class _$TargetFeedCopyWithImpl<$Res, $Val extends TargetFeed>
    implements $TargetFeedCopyWith<$Res> {
  _$TargetFeedCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetSlug = null,
    Object? targetUserId = null,
    Object? shouldPersonalize = null,
  }) {
    return _then(_value.copyWith(
      targetSlug: null == targetSlug
          ? _value.targetSlug
          : targetSlug // ignore: cast_nullable_to_non_nullable
              as String,
      targetUserId: null == targetUserId
          ? _value.targetUserId
          : targetUserId // ignore: cast_nullable_to_non_nullable
              as String,
      shouldPersonalize: null == shouldPersonalize
          ? _value.shouldPersonalize
          : shouldPersonalize // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TargetFeedImplCopyWith<$Res>
    implements $TargetFeedCopyWith<$Res> {
  factory _$$TargetFeedImplCopyWith(
          _$TargetFeedImpl value, $Res Function(_$TargetFeedImpl) then) =
      __$$TargetFeedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String targetSlug, String targetUserId, bool shouldPersonalize});
}

/// @nodoc
class __$$TargetFeedImplCopyWithImpl<$Res>
    extends _$TargetFeedCopyWithImpl<$Res, _$TargetFeedImpl>
    implements _$$TargetFeedImplCopyWith<$Res> {
  __$$TargetFeedImplCopyWithImpl(
      _$TargetFeedImpl _value, $Res Function(_$TargetFeedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetSlug = null,
    Object? targetUserId = null,
    Object? shouldPersonalize = null,
  }) {
    return _then(_$TargetFeedImpl(
      targetSlug: null == targetSlug
          ? _value.targetSlug
          : targetSlug // ignore: cast_nullable_to_non_nullable
              as String,
      targetUserId: null == targetUserId
          ? _value.targetUserId
          : targetUserId // ignore: cast_nullable_to_non_nullable
              as String,
      shouldPersonalize: null == shouldPersonalize
          ? _value.shouldPersonalize
          : shouldPersonalize // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TargetFeedImpl implements _TargetFeed {
  const _$TargetFeedImpl(
      {this.targetSlug = '',
      this.targetUserId = '',
      this.shouldPersonalize = false});

  factory _$TargetFeedImpl.fromJson(Map<String, dynamic> json) =>
      _$$TargetFeedImplFromJson(json);

  @override
  @JsonKey()
  final String targetSlug;
  @override
  @JsonKey()
  final String targetUserId;
  @override
  @JsonKey()
  final bool shouldPersonalize;

  @override
  String toString() {
    return 'TargetFeed(targetSlug: $targetSlug, targetUserId: $targetUserId, shouldPersonalize: $shouldPersonalize)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TargetFeedImpl &&
            (identical(other.targetSlug, targetSlug) ||
                other.targetSlug == targetSlug) &&
            (identical(other.targetUserId, targetUserId) ||
                other.targetUserId == targetUserId) &&
            (identical(other.shouldPersonalize, shouldPersonalize) ||
                other.shouldPersonalize == shouldPersonalize));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, targetSlug, targetUserId, shouldPersonalize);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TargetFeedImplCopyWith<_$TargetFeedImpl> get copyWith =>
      __$$TargetFeedImplCopyWithImpl<_$TargetFeedImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TargetFeedImplToJson(
      this,
    );
  }
}

abstract class _TargetFeed implements TargetFeed {
  const factory _TargetFeed(
      {final String targetSlug,
      final String targetUserId,
      final bool shouldPersonalize}) = _$TargetFeedImpl;

  factory _TargetFeed.fromJson(Map<String, dynamic> json) =
      _$TargetFeedImpl.fromJson;

  @override
  String get targetSlug;
  @override
  String get targetUserId;
  @override
  bool get shouldPersonalize;
  @override
  @JsonKey(ignore: true)
  _$$TargetFeedImplCopyWith<_$TargetFeedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
