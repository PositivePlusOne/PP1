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
  String get folder => throw _privateConstructorUsedError;
  MediaType get type => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  int get priority => throw _privateConstructorUsedError;

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
      {String name, String folder, MediaType type, String url, int priority});
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
    Object? folder = null,
    Object? type = null,
    Object? url = null,
    Object? priority = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      folder: null == folder
          ? _value.folder
          : folder // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MediaType,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
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
      {String name, String folder, MediaType type, String url, int priority});
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
    Object? folder = null,
    Object? type = null,
    Object? url = null,
    Object? priority = null,
  }) {
    return _then(_$_Media(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      folder: null == folder
          ? _value.folder
          : folder // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MediaType,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Media implements _Media {
  const _$_Media(
      {this.name = '',
      this.folder = '',
      this.type = MediaType.unknown,
      this.url = '',
      this.priority = kMediaPriorityDefault});

  factory _$_Media.fromJson(Map<String, dynamic> json) =>
      _$$_MediaFromJson(json);

  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String folder;
  @override
  @JsonKey()
  final MediaType type;
  @override
  @JsonKey()
  final String url;
  @override
  @JsonKey()
  final int priority;

  @override
  String toString() {
    return 'Media(name: $name, folder: $folder, type: $type, url: $url, priority: $priority)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Media &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.folder, folder) || other.folder == folder) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.priority, priority) ||
                other.priority == priority));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, name, folder, type, url, priority);

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
      final String folder,
      final MediaType type,
      final String url,
      final int priority}) = _$_Media;

  factory _Media.fromJson(Map<String, dynamic> json) = _$_Media.fromJson;

  @override
  String get name;
  @override
  String get folder;
  @override
  MediaType get type;
  @override
  String get url;
  @override
  int get priority;
  @override
  @JsonKey(ignore: true)
  _$$_MediaCopyWith<_$_Media> get copyWith =>
      throw _privateConstructorUsedError;
}
