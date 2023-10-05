// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mentions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Mention _$MentionFromJson(Map<String, dynamic> json) {
  return _Mention.fromJson(json);
}

/// @nodoc
mixin _$Mention {
  int get startIndex => throw _privateConstructorUsedError;
  int get endIndex => throw _privateConstructorUsedError;
  String get foreignKey => throw _privateConstructorUsedError;
  String get schema => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MentionCopyWith<Mention> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MentionCopyWith<$Res> {
  factory $MentionCopyWith(Mention value, $Res Function(Mention) then) =
      _$MentionCopyWithImpl<$Res, Mention>;
  @useResult
  $Res call({int startIndex, int endIndex, String foreignKey, String schema});
}

/// @nodoc
class _$MentionCopyWithImpl<$Res, $Val extends Mention>
    implements $MentionCopyWith<$Res> {
  _$MentionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startIndex = null,
    Object? endIndex = null,
    Object? foreignKey = null,
    Object? schema = null,
  }) {
    return _then(_value.copyWith(
      startIndex: null == startIndex
          ? _value.startIndex
          : startIndex // ignore: cast_nullable_to_non_nullable
              as int,
      endIndex: null == endIndex
          ? _value.endIndex
          : endIndex // ignore: cast_nullable_to_non_nullable
              as int,
      foreignKey: null == foreignKey
          ? _value.foreignKey
          : foreignKey // ignore: cast_nullable_to_non_nullable
              as String,
      schema: null == schema
          ? _value.schema
          : schema // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MentionImplCopyWith<$Res> implements $MentionCopyWith<$Res> {
  factory _$$MentionImplCopyWith(
          _$MentionImpl value, $Res Function(_$MentionImpl) then) =
      __$$MentionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int startIndex, int endIndex, String foreignKey, String schema});
}

/// @nodoc
class __$$MentionImplCopyWithImpl<$Res>
    extends _$MentionCopyWithImpl<$Res, _$MentionImpl>
    implements _$$MentionImplCopyWith<$Res> {
  __$$MentionImplCopyWithImpl(
      _$MentionImpl _value, $Res Function(_$MentionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startIndex = null,
    Object? endIndex = null,
    Object? foreignKey = null,
    Object? schema = null,
  }) {
    return _then(_$MentionImpl(
      startIndex: null == startIndex
          ? _value.startIndex
          : startIndex // ignore: cast_nullable_to_non_nullable
              as int,
      endIndex: null == endIndex
          ? _value.endIndex
          : endIndex // ignore: cast_nullable_to_non_nullable
              as int,
      foreignKey: null == foreignKey
          ? _value.foreignKey
          : foreignKey // ignore: cast_nullable_to_non_nullable
              as String,
      schema: null == schema
          ? _value.schema
          : schema // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MentionImpl implements _Mention {
  const _$MentionImpl(
      {this.startIndex = -1,
      this.endIndex = -1,
      this.foreignKey = '',
      this.schema = ''});

  factory _$MentionImpl.fromJson(Map<String, dynamic> json) =>
      _$$MentionImplFromJson(json);

  @override
  @JsonKey()
  final int startIndex;
  @override
  @JsonKey()
  final int endIndex;
  @override
  @JsonKey()
  final String foreignKey;
  @override
  @JsonKey()
  final String schema;

  @override
  String toString() {
    return 'Mention(startIndex: $startIndex, endIndex: $endIndex, foreignKey: $foreignKey, schema: $schema)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MentionImpl &&
            (identical(other.startIndex, startIndex) ||
                other.startIndex == startIndex) &&
            (identical(other.endIndex, endIndex) ||
                other.endIndex == endIndex) &&
            (identical(other.foreignKey, foreignKey) ||
                other.foreignKey == foreignKey) &&
            (identical(other.schema, schema) || other.schema == schema));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, startIndex, endIndex, foreignKey, schema);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MentionImplCopyWith<_$MentionImpl> get copyWith =>
      __$$MentionImplCopyWithImpl<_$MentionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MentionImplToJson(
      this,
    );
  }
}

abstract class _Mention implements Mention {
  const factory _Mention(
      {final int startIndex,
      final int endIndex,
      final String foreignKey,
      final String schema}) = _$MentionImpl;

  factory _Mention.fromJson(Map<String, dynamic> json) = _$MentionImpl.fromJson;

  @override
  int get startIndex;
  @override
  int get endIndex;
  @override
  String get foreignKey;
  @override
  String get schema;
  @override
  @JsonKey(ignore: true)
  _$$MentionImplCopyWith<_$MentionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
