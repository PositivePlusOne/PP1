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
  String get bucketPath => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  int get width => throw _privateConstructorUsedError;
  int get height => throw _privateConstructorUsedError;

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
  $Res call({String bucketPath, String url, int width, int height});
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
    Object? bucketPath = null,
    Object? url = null,
    Object? width = null,
    Object? height = null,
  }) {
    return _then(_value.copyWith(
      bucketPath: null == bucketPath
          ? _value.bucketPath
          : bucketPath // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
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
  $Res call({String bucketPath, String url, int width, int height});
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
    Object? bucketPath = null,
    Object? url = null,
    Object? width = null,
    Object? height = null,
  }) {
    return _then(_$_MediaThumbnail(
      bucketPath: null == bucketPath
          ? _value.bucketPath
          : bucketPath // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_MediaThumbnail implements _MediaThumbnail {
  const _$_MediaThumbnail(
      {this.bucketPath = '', this.url = '', this.width = -1, this.height = -1});

  factory _$_MediaThumbnail.fromJson(Map<String, dynamic> json) =>
      _$$_MediaThumbnailFromJson(json);

  @override
  @JsonKey()
  final String bucketPath;
  @override
  @JsonKey()
  final String url;
  @override
  @JsonKey()
  final int width;
  @override
  @JsonKey()
  final int height;

  @override
  String toString() {
    return 'MediaThumbnail(bucketPath: $bucketPath, url: $url, width: $width, height: $height)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MediaThumbnail &&
            (identical(other.bucketPath, bucketPath) ||
                other.bucketPath == bucketPath) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, bucketPath, url, width, height);

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
      {final String bucketPath,
      final String url,
      final int width,
      final int height}) = _$_MediaThumbnail;

  factory _MediaThumbnail.fromJson(Map<String, dynamic> json) =
      _$_MediaThumbnail.fromJson;

  @override
  String get bucketPath;
  @override
  String get url;
  @override
  int get width;
  @override
  int get height;
  @override
  @JsonKey(ignore: true)
  _$$_MediaThumbnailCopyWith<_$_MediaThumbnail> get copyWith =>
      throw _privateConstructorUsedError;
}
