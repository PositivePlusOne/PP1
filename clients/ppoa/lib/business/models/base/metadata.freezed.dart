// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Metadata _$MetadataFromJson(Map<String, dynamic> json) {
  return _Metadata.fromJson(json);
}

/// @nodoc
mixin _$Metadata {
  String get description => throw _privateConstructorUsedError;
  String get mimeType => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MetadataCopyWith<Metadata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MetadataCopyWith<$Res> {
  factory $MetadataCopyWith(Metadata value, $Res Function(Metadata) then) =
      _$MetadataCopyWithImpl<$Res, Metadata>;
  @useResult
  $Res call({String description, String mimeType, List<String> tags});
}

/// @nodoc
class _$MetadataCopyWithImpl<$Res, $Val extends Metadata>
    implements $MetadataCopyWith<$Res> {
  _$MetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = null,
    Object? mimeType = null,
    Object? tags = null,
  }) {
    return _then(_value.copyWith(
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_MetadataCopyWith<$Res> implements $MetadataCopyWith<$Res> {
  factory _$$_MetadataCopyWith(
          _$_Metadata value, $Res Function(_$_Metadata) then) =
      __$$_MetadataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String description, String mimeType, List<String> tags});
}

/// @nodoc
class __$$_MetadataCopyWithImpl<$Res>
    extends _$MetadataCopyWithImpl<$Res, _$_Metadata>
    implements _$$_MetadataCopyWith<$Res> {
  __$$_MetadataCopyWithImpl(
      _$_Metadata _value, $Res Function(_$_Metadata) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = null,
    Object? mimeType = null,
    Object? tags = null,
  }) {
    return _then(_$_Metadata(
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      mimeType: null == mimeType
          ? _value.mimeType
          : mimeType // ignore: cast_nullable_to_non_nullable
              as String,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$_Metadata implements _Metadata {
  const _$_Metadata(
      {required this.description,
      required this.mimeType = '',
      required final List<String> tags = const <String>[]})
      : _tags = tags;

  factory _$_Metadata.fromJson(Map<String, dynamic> json) =>
      _$$_MetadataFromJson(json);

  @override
  final String description;
  @override
  @JsonKey()
  final String mimeType;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  String toString() {
    return 'Metadata(description: $description, mimeType: $mimeType, tags: $tags)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Metadata &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.mimeType, mimeType) ||
                other.mimeType == mimeType) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, description, mimeType,
      const DeepCollectionEquality().hash(_tags));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MetadataCopyWith<_$_Metadata> get copyWith =>
      __$$_MetadataCopyWithImpl<_$_Metadata>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MetadataToJson(
      this,
    );
  }
}

abstract class _Metadata implements Metadata {
  const factory _Metadata(
      {required final String description,
      required final String mimeType,
      required final List<String> tags}) = _$_Metadata;

  factory _Metadata.fromJson(Map<String, dynamic> json) = _$_Metadata.fromJson;

  @override
  String get description;
  @override
  String get mimeType;
  @override
  List<String> get tags;
  @override
  @JsonKey(ignore: true)
  _$$_MetadataCopyWith<_$_Metadata> get copyWith =>
      throw _privateConstructorUsedError;
}
