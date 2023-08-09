// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bookmark.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Bookmark _$BookmarkFromJson(Map<String, dynamic> json) {
  return _Bookmark.fromJson(json);
}

/// @nodoc
mixin _$Bookmark {
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta => throw _privateConstructorUsedError;
  @JsonKey(fromJson: firestoreDocRefFromJson, toJson: firestoreDocRefToJson)
  DocumentReference<Object?>? get profile => throw _privateConstructorUsedError;
  @JsonKey(fromJson: firestoreDocRefFromJson, toJson: firestoreDocRefToJson)
  DocumentReference<Object?>? get activity =>
      throw _privateConstructorUsedError;
  @JsonKey(fromJson: BookmarkType.fromJson, toJson: BookmarkType.toJson)
  BookmarkType get type => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BookmarkCopyWith<Bookmark> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookmarkCopyWith<$Res> {
  factory $BookmarkCopyWith(Bookmark value, $Res Function(Bookmark) then) =
      _$BookmarkCopyWithImpl<$Res, Bookmark>;
  @useResult
  $Res call(
      {@JsonKey(name: '_fl_meta_') FlMeta? flMeta,
      @JsonKey(fromJson: firestoreDocRefFromJson, toJson: firestoreDocRefToJson)
      DocumentReference<Object?>? profile,
      @JsonKey(fromJson: firestoreDocRefFromJson, toJson: firestoreDocRefToJson)
      DocumentReference<Object?>? activity,
      @JsonKey(fromJson: BookmarkType.fromJson, toJson: BookmarkType.toJson)
      BookmarkType type});

  $FlMetaCopyWith<$Res>? get flMeta;
  $BookmarkTypeCopyWith<$Res> get type;
}

/// @nodoc
class _$BookmarkCopyWithImpl<$Res, $Val extends Bookmark>
    implements $BookmarkCopyWith<$Res> {
  _$BookmarkCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flMeta = freezed,
    Object? profile = freezed,
    Object? activity = freezed,
    Object? type = null,
  }) {
    return _then(_value.copyWith(
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as DocumentReference<Object?>?,
      activity: freezed == activity
          ? _value.activity
          : activity // ignore: cast_nullable_to_non_nullable
              as DocumentReference<Object?>?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BookmarkType,
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
  $BookmarkTypeCopyWith<$Res> get type {
    return $BookmarkTypeCopyWith<$Res>(_value.type, (value) {
      return _then(_value.copyWith(type: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_BookmarkCopyWith<$Res> implements $BookmarkCopyWith<$Res> {
  factory _$$_BookmarkCopyWith(
          _$_Bookmark value, $Res Function(_$_Bookmark) then) =
      __$$_BookmarkCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_fl_meta_') FlMeta? flMeta,
      @JsonKey(fromJson: firestoreDocRefFromJson, toJson: firestoreDocRefToJson)
      DocumentReference<Object?>? profile,
      @JsonKey(fromJson: firestoreDocRefFromJson, toJson: firestoreDocRefToJson)
      DocumentReference<Object?>? activity,
      @JsonKey(fromJson: BookmarkType.fromJson, toJson: BookmarkType.toJson)
      BookmarkType type});

  @override
  $FlMetaCopyWith<$Res>? get flMeta;
  @override
  $BookmarkTypeCopyWith<$Res> get type;
}

/// @nodoc
class __$$_BookmarkCopyWithImpl<$Res>
    extends _$BookmarkCopyWithImpl<$Res, _$_Bookmark>
    implements _$$_BookmarkCopyWith<$Res> {
  __$$_BookmarkCopyWithImpl(
      _$_Bookmark _value, $Res Function(_$_Bookmark) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flMeta = freezed,
    Object? profile = freezed,
    Object? activity = freezed,
    Object? type = null,
  }) {
    return _then(_$_Bookmark(
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
      profile: freezed == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as DocumentReference<Object?>?,
      activity: freezed == activity
          ? _value.activity
          : activity // ignore: cast_nullable_to_non_nullable
              as DocumentReference<Object?>?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as BookmarkType,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Bookmark implements _Bookmark {
  const _$_Bookmark(
      {@JsonKey(name: '_fl_meta_') this.flMeta,
      @JsonKey(fromJson: firestoreDocRefFromJson, toJson: firestoreDocRefToJson)
      this.profile = null,
      @JsonKey(fromJson: firestoreDocRefFromJson, toJson: firestoreDocRefToJson)
      this.activity = null,
      @JsonKey(fromJson: BookmarkType.fromJson, toJson: BookmarkType.toJson)
      this.type = const BookmarkType.post()});

  factory _$_Bookmark.fromJson(Map<String, dynamic> json) =>
      _$$_BookmarkFromJson(json);

  @override
  @JsonKey(name: '_fl_meta_')
  final FlMeta? flMeta;
  @override
  @JsonKey(fromJson: firestoreDocRefFromJson, toJson: firestoreDocRefToJson)
  final DocumentReference<Object?>? profile;
  @override
  @JsonKey(fromJson: firestoreDocRefFromJson, toJson: firestoreDocRefToJson)
  final DocumentReference<Object?>? activity;
  @override
  @JsonKey(fromJson: BookmarkType.fromJson, toJson: BookmarkType.toJson)
  final BookmarkType type;

  @override
  String toString() {
    return 'Bookmark(flMeta: $flMeta, profile: $profile, activity: $activity, type: $type)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Bookmark &&
            (identical(other.flMeta, flMeta) || other.flMeta == flMeta) &&
            (identical(other.profile, profile) || other.profile == profile) &&
            (identical(other.activity, activity) ||
                other.activity == activity) &&
            (identical(other.type, type) || other.type == type));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, flMeta, profile, activity, type);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_BookmarkCopyWith<_$_Bookmark> get copyWith =>
      __$$_BookmarkCopyWithImpl<_$_Bookmark>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_BookmarkToJson(
      this,
    );
  }
}

abstract class _Bookmark implements Bookmark {
  const factory _Bookmark(
      {@JsonKey(name: '_fl_meta_') final FlMeta? flMeta,
      @JsonKey(fromJson: firestoreDocRefFromJson, toJson: firestoreDocRefToJson)
      final DocumentReference<Object?>? profile,
      @JsonKey(fromJson: firestoreDocRefFromJson, toJson: firestoreDocRefToJson)
      final DocumentReference<Object?>? activity,
      @JsonKey(fromJson: BookmarkType.fromJson, toJson: BookmarkType.toJson)
      final BookmarkType type}) = _$_Bookmark;

  factory _Bookmark.fromJson(Map<String, dynamic> json) = _$_Bookmark.fromJson;

  @override
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta;
  @override
  @JsonKey(fromJson: firestoreDocRefFromJson, toJson: firestoreDocRefToJson)
  DocumentReference<Object?>? get profile;
  @override
  @JsonKey(fromJson: firestoreDocRefFromJson, toJson: firestoreDocRefToJson)
  DocumentReference<Object?>? get activity;
  @override
  @JsonKey(fromJson: BookmarkType.fromJson, toJson: BookmarkType.toJson)
  BookmarkType get type;
  @override
  @JsonKey(ignore: true)
  _$$_BookmarkCopyWith<_$_Bookmark> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$BookmarkType {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() post,
    required TResult Function() event,
    required TResult Function() clip,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? post,
    TResult? Function()? event,
    TResult? Function()? clip,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? post,
    TResult Function()? event,
    TResult Function()? clip,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_BookmarkTypePost value) post,
    required TResult Function(_BookmarkTypeEvent value) event,
    required TResult Function(_BookmarkTypeClip value) clip,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_BookmarkTypePost value)? post,
    TResult? Function(_BookmarkTypeEvent value)? event,
    TResult? Function(_BookmarkTypeClip value)? clip,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_BookmarkTypePost value)? post,
    TResult Function(_BookmarkTypeEvent value)? event,
    TResult Function(_BookmarkTypeClip value)? clip,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookmarkTypeCopyWith<$Res> {
  factory $BookmarkTypeCopyWith(
          BookmarkType value, $Res Function(BookmarkType) then) =
      _$BookmarkTypeCopyWithImpl<$Res, BookmarkType>;
}

/// @nodoc
class _$BookmarkTypeCopyWithImpl<$Res, $Val extends BookmarkType>
    implements $BookmarkTypeCopyWith<$Res> {
  _$BookmarkTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_BookmarkTypePostCopyWith<$Res> {
  factory _$$_BookmarkTypePostCopyWith(
          _$_BookmarkTypePost value, $Res Function(_$_BookmarkTypePost) then) =
      __$$_BookmarkTypePostCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_BookmarkTypePostCopyWithImpl<$Res>
    extends _$BookmarkTypeCopyWithImpl<$Res, _$_BookmarkTypePost>
    implements _$$_BookmarkTypePostCopyWith<$Res> {
  __$$_BookmarkTypePostCopyWithImpl(
      _$_BookmarkTypePost _value, $Res Function(_$_BookmarkTypePost) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_BookmarkTypePost implements _BookmarkTypePost {
  const _$_BookmarkTypePost();

  @override
  String toString() {
    return 'BookmarkType.post()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_BookmarkTypePost);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() post,
    required TResult Function() event,
    required TResult Function() clip,
  }) {
    return post();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? post,
    TResult? Function()? event,
    TResult? Function()? clip,
  }) {
    return post?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? post,
    TResult Function()? event,
    TResult Function()? clip,
    required TResult orElse(),
  }) {
    if (post != null) {
      return post();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_BookmarkTypePost value) post,
    required TResult Function(_BookmarkTypeEvent value) event,
    required TResult Function(_BookmarkTypeClip value) clip,
  }) {
    return post(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_BookmarkTypePost value)? post,
    TResult? Function(_BookmarkTypeEvent value)? event,
    TResult? Function(_BookmarkTypeClip value)? clip,
  }) {
    return post?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_BookmarkTypePost value)? post,
    TResult Function(_BookmarkTypeEvent value)? event,
    TResult Function(_BookmarkTypeClip value)? clip,
    required TResult orElse(),
  }) {
    if (post != null) {
      return post(this);
    }
    return orElse();
  }
}

abstract class _BookmarkTypePost implements BookmarkType {
  const factory _BookmarkTypePost() = _$_BookmarkTypePost;
}

/// @nodoc
abstract class _$$_BookmarkTypeEventCopyWith<$Res> {
  factory _$$_BookmarkTypeEventCopyWith(_$_BookmarkTypeEvent value,
          $Res Function(_$_BookmarkTypeEvent) then) =
      __$$_BookmarkTypeEventCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_BookmarkTypeEventCopyWithImpl<$Res>
    extends _$BookmarkTypeCopyWithImpl<$Res, _$_BookmarkTypeEvent>
    implements _$$_BookmarkTypeEventCopyWith<$Res> {
  __$$_BookmarkTypeEventCopyWithImpl(
      _$_BookmarkTypeEvent _value, $Res Function(_$_BookmarkTypeEvent) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_BookmarkTypeEvent implements _BookmarkTypeEvent {
  const _$_BookmarkTypeEvent();

  @override
  String toString() {
    return 'BookmarkType.event()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_BookmarkTypeEvent);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() post,
    required TResult Function() event,
    required TResult Function() clip,
  }) {
    return event();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? post,
    TResult? Function()? event,
    TResult? Function()? clip,
  }) {
    return event?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? post,
    TResult Function()? event,
    TResult Function()? clip,
    required TResult orElse(),
  }) {
    if (event != null) {
      return event();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_BookmarkTypePost value) post,
    required TResult Function(_BookmarkTypeEvent value) event,
    required TResult Function(_BookmarkTypeClip value) clip,
  }) {
    return event(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_BookmarkTypePost value)? post,
    TResult? Function(_BookmarkTypeEvent value)? event,
    TResult? Function(_BookmarkTypeClip value)? clip,
  }) {
    return event?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_BookmarkTypePost value)? post,
    TResult Function(_BookmarkTypeEvent value)? event,
    TResult Function(_BookmarkTypeClip value)? clip,
    required TResult orElse(),
  }) {
    if (event != null) {
      return event(this);
    }
    return orElse();
  }
}

abstract class _BookmarkTypeEvent implements BookmarkType {
  const factory _BookmarkTypeEvent() = _$_BookmarkTypeEvent;
}

/// @nodoc
abstract class _$$_BookmarkTypeClipCopyWith<$Res> {
  factory _$$_BookmarkTypeClipCopyWith(
          _$_BookmarkTypeClip value, $Res Function(_$_BookmarkTypeClip) then) =
      __$$_BookmarkTypeClipCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_BookmarkTypeClipCopyWithImpl<$Res>
    extends _$BookmarkTypeCopyWithImpl<$Res, _$_BookmarkTypeClip>
    implements _$$_BookmarkTypeClipCopyWith<$Res> {
  __$$_BookmarkTypeClipCopyWithImpl(
      _$_BookmarkTypeClip _value, $Res Function(_$_BookmarkTypeClip) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_BookmarkTypeClip implements _BookmarkTypeClip {
  const _$_BookmarkTypeClip();

  @override
  String toString() {
    return 'BookmarkType.clip()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_BookmarkTypeClip);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() post,
    required TResult Function() event,
    required TResult Function() clip,
  }) {
    return clip();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? post,
    TResult? Function()? event,
    TResult? Function()? clip,
  }) {
    return clip?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? post,
    TResult Function()? event,
    TResult Function()? clip,
    required TResult orElse(),
  }) {
    if (clip != null) {
      return clip();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_BookmarkTypePost value) post,
    required TResult Function(_BookmarkTypeEvent value) event,
    required TResult Function(_BookmarkTypeClip value) clip,
  }) {
    return clip(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_BookmarkTypePost value)? post,
    TResult? Function(_BookmarkTypeEvent value)? event,
    TResult? Function(_BookmarkTypeClip value)? clip,
  }) {
    return clip?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_BookmarkTypePost value)? post,
    TResult Function(_BookmarkTypeEvent value)? event,
    TResult Function(_BookmarkTypeClip value)? clip,
    required TResult orElse(),
  }) {
    if (clip != null) {
      return clip(this);
    }
    return orElse();
  }
}

abstract class _BookmarkTypeClip implements BookmarkType {
  const factory _BookmarkTypeClip() = _$_BookmarkTypeClip;
}
