// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fl_file.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FlFile _$FlFileFromJson(Map<String, dynamic> json) {
  return _FlFile.fromJson(json);
}

/// @nodoc
mixin _$FlFile {
  String get contentType => throw _privateConstructorUsedError;
  String get file => throw _privateConstructorUsedError;
  String get folderId => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta => throw _privateConstructorUsedError;
  @JsonKey(name: 'sizes')
  List<FlFileSize>? get sizes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FlFileCopyWith<FlFile> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FlFileCopyWith<$Res> {
  factory $FlFileCopyWith(FlFile value, $Res Function(FlFile) then) =
      _$FlFileCopyWithImpl<$Res, FlFile>;
  @useResult
  $Res call(
      {String contentType,
      String file,
      String folderId,
      String id,
      String type,
      @JsonKey(name: '_fl_meta_') FlMeta? flMeta,
      @JsonKey(name: 'sizes') List<FlFileSize>? sizes});

  $FlMetaCopyWith<$Res>? get flMeta;
}

/// @nodoc
class _$FlFileCopyWithImpl<$Res, $Val extends FlFile>
    implements $FlFileCopyWith<$Res> {
  _$FlFileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contentType = null,
    Object? file = null,
    Object? folderId = null,
    Object? id = null,
    Object? type = null,
    Object? flMeta = freezed,
    Object? sizes = freezed,
  }) {
    return _then(_value.copyWith(
      contentType: null == contentType
          ? _value.contentType
          : contentType // ignore: cast_nullable_to_non_nullable
              as String,
      file: null == file
          ? _value.file
          : file // ignore: cast_nullable_to_non_nullable
              as String,
      folderId: null == folderId
          ? _value.folderId
          : folderId // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
      sizes: freezed == sizes
          ? _value.sizes
          : sizes // ignore: cast_nullable_to_non_nullable
              as List<FlFileSize>?,
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
abstract class _$$_FlFileCopyWith<$Res> implements $FlFileCopyWith<$Res> {
  factory _$$_FlFileCopyWith(_$_FlFile value, $Res Function(_$_FlFile) then) =
      __$$_FlFileCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String contentType,
      String file,
      String folderId,
      String id,
      String type,
      @JsonKey(name: '_fl_meta_') FlMeta? flMeta,
      @JsonKey(name: 'sizes') List<FlFileSize>? sizes});

  @override
  $FlMetaCopyWith<$Res>? get flMeta;
}

/// @nodoc
class __$$_FlFileCopyWithImpl<$Res>
    extends _$FlFileCopyWithImpl<$Res, _$_FlFile>
    implements _$$_FlFileCopyWith<$Res> {
  __$$_FlFileCopyWithImpl(_$_FlFile _value, $Res Function(_$_FlFile) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contentType = null,
    Object? file = null,
    Object? folderId = null,
    Object? id = null,
    Object? type = null,
    Object? flMeta = freezed,
    Object? sizes = freezed,
  }) {
    return _then(_$_FlFile(
      contentType: null == contentType
          ? _value.contentType
          : contentType // ignore: cast_nullable_to_non_nullable
              as String,
      file: null == file
          ? _value.file
          : file // ignore: cast_nullable_to_non_nullable
              as String,
      folderId: null == folderId
          ? _value.folderId
          : folderId // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
      sizes: freezed == sizes
          ? _value._sizes
          : sizes // ignore: cast_nullable_to_non_nullable
              as List<FlFileSize>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FlFile implements _FlFile {
  const _$_FlFile(
      {this.contentType = 'application/octet-stream',
      this.file = '',
      this.folderId = '',
      this.id = '',
      this.type = '',
      @JsonKey(name: '_fl_meta_') this.flMeta,
      @JsonKey(name: 'sizes') final List<FlFileSize>? sizes})
      : _sizes = sizes;

  factory _$_FlFile.fromJson(Map<String, dynamic> json) =>
      _$$_FlFileFromJson(json);

  @override
  @JsonKey()
  final String contentType;
  @override
  @JsonKey()
  final String file;
  @override
  @JsonKey()
  final String folderId;
  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String type;
  @override
  @JsonKey(name: '_fl_meta_')
  final FlMeta? flMeta;
  final List<FlFileSize>? _sizes;
  @override
  @JsonKey(name: 'sizes')
  List<FlFileSize>? get sizes {
    final value = _sizes;
    if (value == null) return null;
    if (_sizes is EqualUnmodifiableListView) return _sizes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'FlFile(contentType: $contentType, file: $file, folderId: $folderId, id: $id, type: $type, flMeta: $flMeta, sizes: $sizes)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FlFile &&
            (identical(other.contentType, contentType) ||
                other.contentType == contentType) &&
            (identical(other.file, file) || other.file == file) &&
            (identical(other.folderId, folderId) ||
                other.folderId == folderId) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.flMeta, flMeta) || other.flMeta == flMeta) &&
            const DeepCollectionEquality().equals(other._sizes, _sizes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, contentType, file, folderId, id,
      type, flMeta, const DeepCollectionEquality().hash(_sizes));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FlFileCopyWith<_$_FlFile> get copyWith =>
      __$$_FlFileCopyWithImpl<_$_FlFile>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FlFileToJson(
      this,
    );
  }
}

abstract class _FlFile implements FlFile {
  const factory _FlFile(
      {final String contentType,
      final String file,
      final String folderId,
      final String id,
      final String type,
      @JsonKey(name: '_fl_meta_') final FlMeta? flMeta,
      @JsonKey(name: 'sizes') final List<FlFileSize>? sizes}) = _$_FlFile;

  factory _FlFile.fromJson(Map<String, dynamic> json) = _$_FlFile.fromJson;

  @override
  String get contentType;
  @override
  String get file;
  @override
  String get folderId;
  @override
  String get id;
  @override
  String get type;
  @override
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta;
  @override
  @JsonKey(name: 'sizes')
  List<FlFileSize>? get sizes;
  @override
  @JsonKey(ignore: true)
  _$$_FlFileCopyWith<_$_FlFile> get copyWith =>
      throw _privateConstructorUsedError;
}

FlFileSize _$FlFileSizeFromJson(Map<String, dynamic> json) {
  return _FlFileSize.fromJson(json);
}

/// @nodoc
mixin _$FlFileSize {
  String get path => throw _privateConstructorUsedError;
  double get quality => throw _privateConstructorUsedError;
  int get height => throw _privateConstructorUsedError;
  int get width => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FlFileSizeCopyWith<FlFileSize> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FlFileSizeCopyWith<$Res> {
  factory $FlFileSizeCopyWith(
          FlFileSize value, $Res Function(FlFileSize) then) =
      _$FlFileSizeCopyWithImpl<$Res, FlFileSize>;
  @useResult
  $Res call({String path, double quality, int height, int width});
}

/// @nodoc
class _$FlFileSizeCopyWithImpl<$Res, $Val extends FlFileSize>
    implements $FlFileSizeCopyWith<$Res> {
  _$FlFileSizeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? quality = null,
    Object? height = null,
    Object? width = null,
  }) {
    return _then(_value.copyWith(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      quality: null == quality
          ? _value.quality
          : quality // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_FlFileSizeCopyWith<$Res>
    implements $FlFileSizeCopyWith<$Res> {
  factory _$$_FlFileSizeCopyWith(
          _$_FlFileSize value, $Res Function(_$_FlFileSize) then) =
      __$$_FlFileSizeCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String path, double quality, int height, int width});
}

/// @nodoc
class __$$_FlFileSizeCopyWithImpl<$Res>
    extends _$FlFileSizeCopyWithImpl<$Res, _$_FlFileSize>
    implements _$$_FlFileSizeCopyWith<$Res> {
  __$$_FlFileSizeCopyWithImpl(
      _$_FlFileSize _value, $Res Function(_$_FlFileSize) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? path = null,
    Object? quality = null,
    Object? height = null,
    Object? width = null,
  }) {
    return _then(_$_FlFileSize(
      path: null == path
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      quality: null == quality
          ? _value.quality
          : quality // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FlFileSize implements _FlFileSize {
  const _$_FlFileSize(
      {this.path = '', this.quality = 0.0, this.height = 0, this.width = 0});

  factory _$_FlFileSize.fromJson(Map<String, dynamic> json) =>
      _$$_FlFileSizeFromJson(json);

  @override
  @JsonKey()
  final String path;
  @override
  @JsonKey()
  final double quality;
  @override
  @JsonKey()
  final int height;
  @override
  @JsonKey()
  final int width;

  @override
  String toString() {
    return 'FlFileSize(path: $path, quality: $quality, height: $height, width: $width)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FlFileSize &&
            (identical(other.path, path) || other.path == path) &&
            (identical(other.quality, quality) || other.quality == quality) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.width, width) || other.width == width));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, path, quality, height, width);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FlFileSizeCopyWith<_$_FlFileSize> get copyWith =>
      __$$_FlFileSizeCopyWithImpl<_$_FlFileSize>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FlFileSizeToJson(
      this,
    );
  }
}

abstract class _FlFileSize implements FlFileSize {
  const factory _FlFileSize(
      {final String path,
      final double quality,
      final int height,
      final int width}) = _$_FlFileSize;

  factory _FlFileSize.fromJson(Map<String, dynamic> json) =
      _$_FlFileSize.fromJson;

  @override
  String get path;
  @override
  double get quality;
  @override
  int get height;
  @override
  int get width;
  @override
  @JsonKey(ignore: true)
  _$$_FlFileSizeCopyWith<_$_FlFileSize> get copyWith =>
      throw _privateConstructorUsedError;
}
