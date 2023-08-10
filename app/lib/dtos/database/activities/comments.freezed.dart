// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comments.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return _Comment.fromJson(json);
}

/// @nodoc
mixin _$Comment {
  String get content => throw _privateConstructorUsedError;
  String get reactionId => throw _privateConstructorUsedError;
  String get activityId => throw _privateConstructorUsedError;
  String get senderId => throw _privateConstructorUsedError;
  @JsonKey(fromJson: Mention.fromJsonList, toJson: Mention.toJsonList)
  List<Mention> get mentions => throw _privateConstructorUsedError;
  @JsonKey(fromJson: Media.fromJsonList, toJson: Media.toJsonList)
  List<Media> get media => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CommentCopyWith<Comment> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CommentCopyWith<$Res> {
  factory $CommentCopyWith(Comment value, $Res Function(Comment) then) =
      _$CommentCopyWithImpl<$Res, Comment>;
  @useResult
  $Res call(
      {String content,
      String reactionId,
      String activityId,
      String senderId,
      @JsonKey(fromJson: Mention.fromJsonList, toJson: Mention.toJsonList)
      List<Mention> mentions,
      @JsonKey(fromJson: Media.fromJsonList, toJson: Media.toJsonList)
      List<Media> media});
}

/// @nodoc
class _$CommentCopyWithImpl<$Res, $Val extends Comment>
    implements $CommentCopyWith<$Res> {
  _$CommentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? reactionId = null,
    Object? activityId = null,
    Object? senderId = null,
    Object? mentions = null,
    Object? media = null,
  }) {
    return _then(_value.copyWith(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      reactionId: null == reactionId
          ? _value.reactionId
          : reactionId // ignore: cast_nullable_to_non_nullable
              as String,
      activityId: null == activityId
          ? _value.activityId
          : activityId // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      mentions: null == mentions
          ? _value.mentions
          : mentions // ignore: cast_nullable_to_non_nullable
              as List<Mention>,
      media: null == media
          ? _value.media
          : media // ignore: cast_nullable_to_non_nullable
              as List<Media>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_CommentCopyWith<$Res> implements $CommentCopyWith<$Res> {
  factory _$$_CommentCopyWith(
          _$_Comment value, $Res Function(_$_Comment) then) =
      __$$_CommentCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String content,
      String reactionId,
      String activityId,
      String senderId,
      @JsonKey(fromJson: Mention.fromJsonList, toJson: Mention.toJsonList)
      List<Mention> mentions,
      @JsonKey(fromJson: Media.fromJsonList, toJson: Media.toJsonList)
      List<Media> media});
}

/// @nodoc
class __$$_CommentCopyWithImpl<$Res>
    extends _$CommentCopyWithImpl<$Res, _$_Comment>
    implements _$$_CommentCopyWith<$Res> {
  __$$_CommentCopyWithImpl(_$_Comment _value, $Res Function(_$_Comment) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? reactionId = null,
    Object? activityId = null,
    Object? senderId = null,
    Object? mentions = null,
    Object? media = null,
  }) {
    return _then(_$_Comment(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      reactionId: null == reactionId
          ? _value.reactionId
          : reactionId // ignore: cast_nullable_to_non_nullable
              as String,
      activityId: null == activityId
          ? _value.activityId
          : activityId // ignore: cast_nullable_to_non_nullable
              as String,
      senderId: null == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String,
      mentions: null == mentions
          ? _value._mentions
          : mentions // ignore: cast_nullable_to_non_nullable
              as List<Mention>,
      media: null == media
          ? _value._media
          : media // ignore: cast_nullable_to_non_nullable
              as List<Media>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Comment implements _Comment {
  const _$_Comment(
      {this.content = '',
      this.reactionId = '',
      this.activityId = '',
      this.senderId = '',
      @JsonKey(fromJson: Mention.fromJsonList, toJson: Mention.toJsonList)
      final List<Mention> mentions = const [],
      @JsonKey(fromJson: Media.fromJsonList, toJson: Media.toJsonList)
      final List<Media> media = const []})
      : _mentions = mentions,
        _media = media;

  factory _$_Comment.fromJson(Map<String, dynamic> json) =>
      _$$_CommentFromJson(json);

  @override
  @JsonKey()
  final String content;
  @override
  @JsonKey()
  final String reactionId;
  @override
  @JsonKey()
  final String activityId;
  @override
  @JsonKey()
  final String senderId;
  final List<Mention> _mentions;
  @override
  @JsonKey(fromJson: Mention.fromJsonList, toJson: Mention.toJsonList)
  List<Mention> get mentions {
    if (_mentions is EqualUnmodifiableListView) return _mentions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mentions);
  }

  final List<Media> _media;
  @override
  @JsonKey(fromJson: Media.fromJsonList, toJson: Media.toJsonList)
  List<Media> get media {
    if (_media is EqualUnmodifiableListView) return _media;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_media);
  }

  @override
  String toString() {
    return 'Comment(content: $content, reactionId: $reactionId, activityId: $activityId, senderId: $senderId, mentions: $mentions, media: $media)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Comment &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.reactionId, reactionId) ||
                other.reactionId == reactionId) &&
            (identical(other.activityId, activityId) ||
                other.activityId == activityId) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            const DeepCollectionEquality().equals(other._mentions, _mentions) &&
            const DeepCollectionEquality().equals(other._media, _media));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      content,
      reactionId,
      activityId,
      senderId,
      const DeepCollectionEquality().hash(_mentions),
      const DeepCollectionEquality().hash(_media));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CommentCopyWith<_$_Comment> get copyWith =>
      __$$_CommentCopyWithImpl<_$_Comment>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CommentToJson(
      this,
    );
  }
}

abstract class _Comment implements Comment {
  const factory _Comment(
      {final String content,
      final String reactionId,
      final String activityId,
      final String senderId,
      @JsonKey(fromJson: Mention.fromJsonList, toJson: Mention.toJsonList)
      final List<Mention> mentions,
      @JsonKey(fromJson: Media.fromJsonList, toJson: Media.toJsonList)
      final List<Media> media}) = _$_Comment;

  factory _Comment.fromJson(Map<String, dynamic> json) = _$_Comment.fromJson;

  @override
  String get content;
  @override
  String get reactionId;
  @override
  String get activityId;
  @override
  String get senderId;
  @override
  @JsonKey(fromJson: Mention.fromJsonList, toJson: Mention.toJsonList)
  List<Mention> get mentions;
  @override
  @JsonKey(fromJson: Media.fromJsonList, toJson: Media.toJsonList)
  List<Media> get media;
  @override
  @JsonKey(ignore: true)
  _$$_CommentCopyWith<_$_Comment> get copyWith =>
      throw _privateConstructorUsedError;
}
