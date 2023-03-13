// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_feedback.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserFeedback _$UserFeedbackFromJson(Map<String, dynamic> json) {
  return _UserFeedback.fromJson(json);
}

/// @nodoc
mixin _$UserFeedback {
  String get content => throw _privateConstructorUsedError;
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserFeedbackCopyWith<UserFeedback> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserFeedbackCopyWith<$Res> {
  factory $UserFeedbackCopyWith(
          UserFeedback value, $Res Function(UserFeedback) then) =
      _$UserFeedbackCopyWithImpl<$Res, UserFeedback>;
  @useResult
  $Res call({String content, @JsonKey(name: '_fl_meta_') FlMeta? flMeta});

  $FlMetaCopyWith<$Res>? get flMeta;
}

/// @nodoc
class _$UserFeedbackCopyWithImpl<$Res, $Val extends UserFeedback>
    implements $UserFeedbackCopyWith<$Res> {
  _$UserFeedbackCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? flMeta = freezed,
  }) {
    return _then(_value.copyWith(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
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
abstract class _$$_UserFeedbackCopyWith<$Res>
    implements $UserFeedbackCopyWith<$Res> {
  factory _$$_UserFeedbackCopyWith(
          _$_UserFeedback value, $Res Function(_$_UserFeedback) then) =
      __$$_UserFeedbackCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String content, @JsonKey(name: '_fl_meta_') FlMeta? flMeta});

  @override
  $FlMetaCopyWith<$Res>? get flMeta;
}

/// @nodoc
class __$$_UserFeedbackCopyWithImpl<$Res>
    extends _$UserFeedbackCopyWithImpl<$Res, _$_UserFeedback>
    implements _$$_UserFeedbackCopyWith<$Res> {
  __$$_UserFeedbackCopyWithImpl(
      _$_UserFeedback _value, $Res Function(_$_UserFeedback) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? flMeta = freezed,
  }) {
    return _then(_$_UserFeedback(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UserFeedback implements _UserFeedback {
  const _$_UserFeedback(
      {this.content = '', @JsonKey(name: '_fl_meta_') this.flMeta});

  factory _$_UserFeedback.fromJson(Map<String, dynamic> json) =>
      _$$_UserFeedbackFromJson(json);

  @override
  @JsonKey()
  final String content;
  @override
  @JsonKey(name: '_fl_meta_')
  final FlMeta? flMeta;

  @override
  String toString() {
    return 'UserFeedback(content: $content, flMeta: $flMeta)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserFeedback &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.flMeta, flMeta) || other.flMeta == flMeta));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, content, flMeta);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_UserFeedbackCopyWith<_$_UserFeedback> get copyWith =>
      __$$_UserFeedbackCopyWithImpl<_$_UserFeedback>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserFeedbackToJson(
      this,
    );
  }
}

abstract class _UserFeedback implements UserFeedback {
  const factory _UserFeedback(
      {final String content,
      @JsonKey(name: '_fl_meta_') final FlMeta? flMeta}) = _$_UserFeedback;

  factory _UserFeedback.fromJson(Map<String, dynamic> json) =
      _$_UserFeedback.fromJson;

  @override
  String get content;
  @override
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta;
  @override
  @JsonKey(ignore: true)
  _$$_UserFeedbackCopyWith<_$_UserFeedback> get copyWith =>
      throw _privateConstructorUsedError;
}
