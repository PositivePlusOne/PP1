// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Media _$MediaFromJson(Map<String, dynamic> json) {
  return _Media.fromJson(json);
}

/// @nodoc
mixin _$Media {
  String get name => throw _privateConstructorUsedError;
  String get bucketPath => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  List<MediaThumbnail> get thumbnails => throw _privateConstructorUsedError;
  MediaType get type => throw _privateConstructorUsedError;
  int get priority => throw _privateConstructorUsedError;
  dynamic get isSensitive => throw _privateConstructorUsedError;
  dynamic get isPrivate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MediaCopyWith<Media> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MediaCopyWith<$Res> {
  factory $MediaCopyWith(Media value, $Res Function(Media) then) =
      _$MediaCopyWithImpl<$Res, Media>;
  @useResult
  $Res call(
      {String name,
      String bucketPath,
      String url,
      List<MediaThumbnail> thumbnails,
      MediaType type,
      int priority,
      dynamic isSensitive,
      dynamic isPrivate});
}

/// @nodoc
class _$MediaCopyWithImpl<$Res, $Val extends Media>
    implements $MediaCopyWith<$Res> {
  _$MediaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? bucketPath = null,
    Object? url = null,
    Object? thumbnails = null,
    Object? type = null,
    Object? priority = null,
    Object? isSensitive = freezed,
    Object? isPrivate = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      bucketPath: null == bucketPath
          ? _value.bucketPath
          : bucketPath // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnails: null == thumbnails
          ? _value.thumbnails
          : thumbnails // ignore: cast_nullable_to_non_nullable
              as List<MediaThumbnail>,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MediaType,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
      isSensitive: freezed == isSensitive
          ? _value.isSensitive
          : isSensitive // ignore: cast_nullable_to_non_nullable
              as dynamic,
      isPrivate: freezed == isPrivate
          ? _value.isPrivate
          : isPrivate // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_MediaCopyWith<$Res> implements $MediaCopyWith<$Res> {
  factory _$$_MediaCopyWith(_$_Media value, $Res Function(_$_Media) then) =
      __$$_MediaCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String bucketPath,
      String url,
      List<MediaThumbnail> thumbnails,
      MediaType type,
      int priority,
      dynamic isSensitive,
      dynamic isPrivate});
}

/// @nodoc
class __$$_MediaCopyWithImpl<$Res> extends _$MediaCopyWithImpl<$Res, _$_Media>
    implements _$$_MediaCopyWith<$Res> {
  __$$_MediaCopyWithImpl(_$_Media _value, $Res Function(_$_Media) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? bucketPath = null,
    Object? url = null,
    Object? thumbnails = null,
    Object? type = null,
    Object? priority = null,
    Object? isSensitive = freezed,
    Object? isPrivate = freezed,
  }) {
    return _then(_$_Media(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      bucketPath: null == bucketPath
          ? _value.bucketPath
          : bucketPath // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnails: null == thumbnails
          ? _value._thumbnails
          : thumbnails // ignore: cast_nullable_to_non_nullable
              as List<MediaThumbnail>,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MediaType,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
      isSensitive: freezed == isSensitive ? _value.isSensitive! : isSensitive,
      isPrivate: freezed == isPrivate ? _value.isPrivate! : isPrivate,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Media implements _Media {
  const _$_Media(
      {this.name = '',
      this.bucketPath = '',
      this.url = '',
      final List<MediaThumbnail> thumbnails = const [],
      this.type = MediaType.unknown,
      this.priority = kMediaPriorityDefault,
      this.isSensitive = false,
      this.isPrivate = false})
      : _thumbnails = thumbnails;

  factory _$_Media.fromJson(Map<String, dynamic> json) =>
      _$$_MediaFromJson(json);

  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String bucketPath;
  @override
  @JsonKey()
  final String url;
  final List<MediaThumbnail> _thumbnails;
  @override
  @JsonKey()
  List<MediaThumbnail> get thumbnails {
    if (_thumbnails is EqualUnmodifiableListView) return _thumbnails;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_thumbnails);
  }

  @override
  @JsonKey()
  final MediaType type;
  @override
  @JsonKey()
  final int priority;
  @override
  @JsonKey()
  final dynamic isSensitive;
  @override
  @JsonKey()
  final dynamic isPrivate;

  @override
  String toString() {
    return 'Media(name: $name, bucketPath: $bucketPath, url: $url, thumbnails: $thumbnails, type: $type, priority: $priority, isSensitive: $isSensitive, isPrivate: $isPrivate)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Media &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.bucketPath, bucketPath) ||
                other.bucketPath == bucketPath) &&
            (identical(other.url, url) || other.url == url) &&
            const DeepCollectionEquality()
                .equals(other._thumbnails, _thumbnails) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            const DeepCollectionEquality()
                .equals(other.isSensitive, isSensitive) &&
            const DeepCollectionEquality().equals(other.isPrivate, isPrivate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      name,
      bucketPath,
      url,
      const DeepCollectionEquality().hash(_thumbnails),
      type,
      priority,
      const DeepCollectionEquality().hash(isSensitive),
      const DeepCollectionEquality().hash(isPrivate));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MediaCopyWith<_$_Media> get copyWith =>
      __$$_MediaCopyWithImpl<_$_Media>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MediaToJson(
      this,
    );
  }
}

abstract class _Media implements Media {
  const factory _Media(
      {final String name,
      final String bucketPath,
      final String url,
      final List<MediaThumbnail> thumbnails,
      final MediaType type,
      final int priority,
      final dynamic isSensitive,
      final dynamic isPrivate}) = _$_Media;

  factory _Media.fromJson(Map<String, dynamic> json) = _$_Media.fromJson;

  @override
  String get name;
  @override
  String get bucketPath;
  @override
  String get url;
  @override
  List<MediaThumbnail> get thumbnails;
  @override
  MediaType get type;
  @override
  int get priority;
  @override
  dynamic get isSensitive;
  @override
  dynamic get isPrivate;
  @override
  @JsonKey(ignore: true)
  _$$_MediaCopyWith<_$_Media> get copyWith =>
      throw _privateConstructorUsedError;
}

MediaThumbnail _$MediaThumbnailFromJson(Map<String, dynamic> json) {
  return _MediaThumbnail.fromJson(json);
}

/// @nodoc
mixin _$MediaThumbnail {
  @JsonKey(fromJson: ThumbnailType.fromJson, toJson: ThumbnailType.toJson)
  ThumbnailType get type => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MediaThumbnailCopyWith<MediaThumbnail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MediaThumbnailCopyWith<$Res> {
  factory $MediaThumbnailCopyWith(
          MediaThumbnail value, $Res Function(MediaThumbnail) then) =
      _$MediaThumbnailCopyWithImpl<$Res, MediaThumbnail>;
  @useResult
  $Res call(
      {@JsonKey(fromJson: ThumbnailType.fromJson, toJson: ThumbnailType.toJson)
      ThumbnailType type,
      String url});

  $ThumbnailTypeCopyWith<$Res> get type;
}

/// @nodoc
class _$MediaThumbnailCopyWithImpl<$Res, $Val extends MediaThumbnail>
    implements $MediaThumbnailCopyWith<$Res> {
  _$MediaThumbnailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? url = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ThumbnailType,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ThumbnailTypeCopyWith<$Res> get type {
    return $ThumbnailTypeCopyWith<$Res>(_value.type, (value) {
      return _then(_value.copyWith(type: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_MediaThumbnailCopyWith<$Res>
    implements $MediaThumbnailCopyWith<$Res> {
  factory _$$_MediaThumbnailCopyWith(
          _$_MediaThumbnail value, $Res Function(_$_MediaThumbnail) then) =
      __$$_MediaThumbnailCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(fromJson: ThumbnailType.fromJson, toJson: ThumbnailType.toJson)
      ThumbnailType type,
      String url});

  @override
  $ThumbnailTypeCopyWith<$Res> get type;
}

/// @nodoc
class __$$_MediaThumbnailCopyWithImpl<$Res>
    extends _$MediaThumbnailCopyWithImpl<$Res, _$_MediaThumbnail>
    implements _$$_MediaThumbnailCopyWith<$Res> {
  __$$_MediaThumbnailCopyWithImpl(
      _$_MediaThumbnail _value, $Res Function(_$_MediaThumbnail) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? url = null,
  }) {
    return _then(_$_MediaThumbnail(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ThumbnailType,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_MediaThumbnail implements _MediaThumbnail {
  const _$_MediaThumbnail(
      {@JsonKey(fromJson: ThumbnailType.fromJson, toJson: ThumbnailType.toJson)
      this.type = const ThumbnailType.none(),
      this.url = ''});

  factory _$_MediaThumbnail.fromJson(Map<String, dynamic> json) =>
      _$$_MediaThumbnailFromJson(json);

  @override
  @JsonKey(fromJson: ThumbnailType.fromJson, toJson: ThumbnailType.toJson)
  final ThumbnailType type;
  @override
  @JsonKey()
  final String url;

  @override
  String toString() {
    return 'MediaThumbnail(type: $type, url: $url)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MediaThumbnail &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, type, url);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MediaThumbnailCopyWith<_$_MediaThumbnail> get copyWith =>
      __$$_MediaThumbnailCopyWithImpl<_$_MediaThumbnail>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MediaThumbnailToJson(
      this,
    );
  }
}

abstract class _MediaThumbnail implements MediaThumbnail {
  const factory _MediaThumbnail(
      {@JsonKey(fromJson: ThumbnailType.fromJson, toJson: ThumbnailType.toJson)
      final ThumbnailType type,
      final String url}) = _$_MediaThumbnail;

  factory _MediaThumbnail.fromJson(Map<String, dynamic> json) =
      _$_MediaThumbnail.fromJson;

  @override
  @JsonKey(fromJson: ThumbnailType.fromJson, toJson: ThumbnailType.toJson)
  ThumbnailType get type;
  @override
  String get url;
  @override
  @JsonKey(ignore: true)
  _$$_MediaThumbnailCopyWith<_$_MediaThumbnail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ThumbnailType {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() none,
    required TResult Function() small,
    required TResult Function() medium,
    required TResult Function() large,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? none,
    TResult? Function()? small,
    TResult? Function()? medium,
    TResult? Function()? large,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? none,
    TResult Function()? small,
    TResult Function()? medium,
    TResult Function()? large,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ThumbnailTypeNone value) none,
    required TResult Function(_ThumbnailTypeSmall value) small,
    required TResult Function(_ThumbnailTypeMedium value) medium,
    required TResult Function(_ThumbnailTypeLarge value) large,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ThumbnailTypeNone value)? none,
    TResult? Function(_ThumbnailTypeSmall value)? small,
    TResult? Function(_ThumbnailTypeMedium value)? medium,
    TResult? Function(_ThumbnailTypeLarge value)? large,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ThumbnailTypeNone value)? none,
    TResult Function(_ThumbnailTypeSmall value)? small,
    TResult Function(_ThumbnailTypeMedium value)? medium,
    TResult Function(_ThumbnailTypeLarge value)? large,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ThumbnailTypeCopyWith<$Res> {
  factory $ThumbnailTypeCopyWith(
          ThumbnailType value, $Res Function(ThumbnailType) then) =
      _$ThumbnailTypeCopyWithImpl<$Res, ThumbnailType>;
}

/// @nodoc
class _$ThumbnailTypeCopyWithImpl<$Res, $Val extends ThumbnailType>
    implements $ThumbnailTypeCopyWith<$Res> {
  _$ThumbnailTypeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_ThumbnailTypeNoneCopyWith<$Res> {
  factory _$$_ThumbnailTypeNoneCopyWith(_$_ThumbnailTypeNone value,
          $Res Function(_$_ThumbnailTypeNone) then) =
      __$$_ThumbnailTypeNoneCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_ThumbnailTypeNoneCopyWithImpl<$Res>
    extends _$ThumbnailTypeCopyWithImpl<$Res, _$_ThumbnailTypeNone>
    implements _$$_ThumbnailTypeNoneCopyWith<$Res> {
  __$$_ThumbnailTypeNoneCopyWithImpl(
      _$_ThumbnailTypeNone _value, $Res Function(_$_ThumbnailTypeNone) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_ThumbnailTypeNone implements _ThumbnailTypeNone {
  const _$_ThumbnailTypeNone();

  @override
  String toString() {
    return 'ThumbnailType.none()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_ThumbnailTypeNone);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() none,
    required TResult Function() small,
    required TResult Function() medium,
    required TResult Function() large,
  }) {
    return none();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? none,
    TResult? Function()? small,
    TResult? Function()? medium,
    TResult? Function()? large,
  }) {
    return none?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? none,
    TResult Function()? small,
    TResult Function()? medium,
    TResult Function()? large,
    required TResult orElse(),
  }) {
    if (none != null) {
      return none();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ThumbnailTypeNone value) none,
    required TResult Function(_ThumbnailTypeSmall value) small,
    required TResult Function(_ThumbnailTypeMedium value) medium,
    required TResult Function(_ThumbnailTypeLarge value) large,
  }) {
    return none(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ThumbnailTypeNone value)? none,
    TResult? Function(_ThumbnailTypeSmall value)? small,
    TResult? Function(_ThumbnailTypeMedium value)? medium,
    TResult? Function(_ThumbnailTypeLarge value)? large,
  }) {
    return none?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ThumbnailTypeNone value)? none,
    TResult Function(_ThumbnailTypeSmall value)? small,
    TResult Function(_ThumbnailTypeMedium value)? medium,
    TResult Function(_ThumbnailTypeLarge value)? large,
    required TResult orElse(),
  }) {
    if (none != null) {
      return none(this);
    }
    return orElse();
  }
}

abstract class _ThumbnailTypeNone implements ThumbnailType {
  const factory _ThumbnailTypeNone() = _$_ThumbnailTypeNone;
}

/// @nodoc
abstract class _$$_ThumbnailTypeSmallCopyWith<$Res> {
  factory _$$_ThumbnailTypeSmallCopyWith(_$_ThumbnailTypeSmall value,
          $Res Function(_$_ThumbnailTypeSmall) then) =
      __$$_ThumbnailTypeSmallCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_ThumbnailTypeSmallCopyWithImpl<$Res>
    extends _$ThumbnailTypeCopyWithImpl<$Res, _$_ThumbnailTypeSmall>
    implements _$$_ThumbnailTypeSmallCopyWith<$Res> {
  __$$_ThumbnailTypeSmallCopyWithImpl(
      _$_ThumbnailTypeSmall _value, $Res Function(_$_ThumbnailTypeSmall) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_ThumbnailTypeSmall implements _ThumbnailTypeSmall {
  const _$_ThumbnailTypeSmall();

  @override
  String toString() {
    return 'ThumbnailType.small()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_ThumbnailTypeSmall);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() none,
    required TResult Function() small,
    required TResult Function() medium,
    required TResult Function() large,
  }) {
    return small();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? none,
    TResult? Function()? small,
    TResult? Function()? medium,
    TResult? Function()? large,
  }) {
    return small?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? none,
    TResult Function()? small,
    TResult Function()? medium,
    TResult Function()? large,
    required TResult orElse(),
  }) {
    if (small != null) {
      return small();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ThumbnailTypeNone value) none,
    required TResult Function(_ThumbnailTypeSmall value) small,
    required TResult Function(_ThumbnailTypeMedium value) medium,
    required TResult Function(_ThumbnailTypeLarge value) large,
  }) {
    return small(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ThumbnailTypeNone value)? none,
    TResult? Function(_ThumbnailTypeSmall value)? small,
    TResult? Function(_ThumbnailTypeMedium value)? medium,
    TResult? Function(_ThumbnailTypeLarge value)? large,
  }) {
    return small?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ThumbnailTypeNone value)? none,
    TResult Function(_ThumbnailTypeSmall value)? small,
    TResult Function(_ThumbnailTypeMedium value)? medium,
    TResult Function(_ThumbnailTypeLarge value)? large,
    required TResult orElse(),
  }) {
    if (small != null) {
      return small(this);
    }
    return orElse();
  }
}

abstract class _ThumbnailTypeSmall implements ThumbnailType {
  const factory _ThumbnailTypeSmall() = _$_ThumbnailTypeSmall;
}

/// @nodoc
abstract class _$$_ThumbnailTypeMediumCopyWith<$Res> {
  factory _$$_ThumbnailTypeMediumCopyWith(_$_ThumbnailTypeMedium value,
          $Res Function(_$_ThumbnailTypeMedium) then) =
      __$$_ThumbnailTypeMediumCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_ThumbnailTypeMediumCopyWithImpl<$Res>
    extends _$ThumbnailTypeCopyWithImpl<$Res, _$_ThumbnailTypeMedium>
    implements _$$_ThumbnailTypeMediumCopyWith<$Res> {
  __$$_ThumbnailTypeMediumCopyWithImpl(_$_ThumbnailTypeMedium _value,
      $Res Function(_$_ThumbnailTypeMedium) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_ThumbnailTypeMedium implements _ThumbnailTypeMedium {
  const _$_ThumbnailTypeMedium();

  @override
  String toString() {
    return 'ThumbnailType.medium()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_ThumbnailTypeMedium);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() none,
    required TResult Function() small,
    required TResult Function() medium,
    required TResult Function() large,
  }) {
    return medium();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? none,
    TResult? Function()? small,
    TResult? Function()? medium,
    TResult? Function()? large,
  }) {
    return medium?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? none,
    TResult Function()? small,
    TResult Function()? medium,
    TResult Function()? large,
    required TResult orElse(),
  }) {
    if (medium != null) {
      return medium();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ThumbnailTypeNone value) none,
    required TResult Function(_ThumbnailTypeSmall value) small,
    required TResult Function(_ThumbnailTypeMedium value) medium,
    required TResult Function(_ThumbnailTypeLarge value) large,
  }) {
    return medium(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ThumbnailTypeNone value)? none,
    TResult? Function(_ThumbnailTypeSmall value)? small,
    TResult? Function(_ThumbnailTypeMedium value)? medium,
    TResult? Function(_ThumbnailTypeLarge value)? large,
  }) {
    return medium?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ThumbnailTypeNone value)? none,
    TResult Function(_ThumbnailTypeSmall value)? small,
    TResult Function(_ThumbnailTypeMedium value)? medium,
    TResult Function(_ThumbnailTypeLarge value)? large,
    required TResult orElse(),
  }) {
    if (medium != null) {
      return medium(this);
    }
    return orElse();
  }
}

abstract class _ThumbnailTypeMedium implements ThumbnailType {
  const factory _ThumbnailTypeMedium() = _$_ThumbnailTypeMedium;
}

/// @nodoc
abstract class _$$_ThumbnailTypeLargeCopyWith<$Res> {
  factory _$$_ThumbnailTypeLargeCopyWith(_$_ThumbnailTypeLarge value,
          $Res Function(_$_ThumbnailTypeLarge) then) =
      __$$_ThumbnailTypeLargeCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_ThumbnailTypeLargeCopyWithImpl<$Res>
    extends _$ThumbnailTypeCopyWithImpl<$Res, _$_ThumbnailTypeLarge>
    implements _$$_ThumbnailTypeLargeCopyWith<$Res> {
  __$$_ThumbnailTypeLargeCopyWithImpl(
      _$_ThumbnailTypeLarge _value, $Res Function(_$_ThumbnailTypeLarge) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_ThumbnailTypeLarge implements _ThumbnailTypeLarge {
  const _$_ThumbnailTypeLarge();

  @override
  String toString() {
    return 'ThumbnailType.large()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$_ThumbnailTypeLarge);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() none,
    required TResult Function() small,
    required TResult Function() medium,
    required TResult Function() large,
  }) {
    return large();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? none,
    TResult? Function()? small,
    TResult? Function()? medium,
    TResult? Function()? large,
  }) {
    return large?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? none,
    TResult Function()? small,
    TResult Function()? medium,
    TResult Function()? large,
    required TResult orElse(),
  }) {
    if (large != null) {
      return large();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_ThumbnailTypeNone value) none,
    required TResult Function(_ThumbnailTypeSmall value) small,
    required TResult Function(_ThumbnailTypeMedium value) medium,
    required TResult Function(_ThumbnailTypeLarge value) large,
  }) {
    return large(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_ThumbnailTypeNone value)? none,
    TResult? Function(_ThumbnailTypeSmall value)? small,
    TResult? Function(_ThumbnailTypeMedium value)? medium,
    TResult? Function(_ThumbnailTypeLarge value)? large,
  }) {
    return large?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_ThumbnailTypeNone value)? none,
    TResult Function(_ThumbnailTypeSmall value)? small,
    TResult Function(_ThumbnailTypeMedium value)? medium,
    TResult Function(_ThumbnailTypeLarge value)? large,
    required TResult orElse(),
  }) {
    if (large != null) {
      return large(this);
    }
    return orElse();
  }
}

abstract class _ThumbnailTypeLarge implements ThumbnailType {
  const factory _ThumbnailTypeLarge() = _$_ThumbnailTypeLarge;
}
