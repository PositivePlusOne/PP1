// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fl_relationship.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FlRelationship _$FlRelationshipFromJson(Map<String, dynamic> json) {
  return _FlRelationship.fromJson(json);
}

/// @nodoc
mixin _$FlRelationship {
  bool get blocked => throw _privateConstructorUsedError;
  bool get muted => throw _privateConstructorUsedError;
  bool get connected => throw _privateConstructorUsedError;
  bool get following => throw _privateConstructorUsedError;
  bool get hidden => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FlRelationshipCopyWith<FlRelationship> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FlRelationshipCopyWith<$Res> {
  factory $FlRelationshipCopyWith(
          FlRelationship value, $Res Function(FlRelationship) then) =
      _$FlRelationshipCopyWithImpl<$Res, FlRelationship>;
  @useResult
  $Res call(
      {bool blocked, bool muted, bool connected, bool following, bool hidden});
}

/// @nodoc
class _$FlRelationshipCopyWithImpl<$Res, $Val extends FlRelationship>
    implements $FlRelationshipCopyWith<$Res> {
  _$FlRelationshipCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? blocked = null,
    Object? muted = null,
    Object? connected = null,
    Object? following = null,
    Object? hidden = null,
  }) {
    return _then(_value.copyWith(
      blocked: null == blocked
          ? _value.blocked
          : blocked // ignore: cast_nullable_to_non_nullable
              as bool,
      muted: null == muted
          ? _value.muted
          : muted // ignore: cast_nullable_to_non_nullable
              as bool,
      connected: null == connected
          ? _value.connected
          : connected // ignore: cast_nullable_to_non_nullable
              as bool,
      following: null == following
          ? _value.following
          : following // ignore: cast_nullable_to_non_nullable
              as bool,
      hidden: null == hidden
          ? _value.hidden
          : hidden // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_FlRelationshipCopyWith<$Res>
    implements $FlRelationshipCopyWith<$Res> {
  factory _$$_FlRelationshipCopyWith(
          _$_FlRelationship value, $Res Function(_$_FlRelationship) then) =
      __$$_FlRelationshipCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool blocked, bool muted, bool connected, bool following, bool hidden});
}

/// @nodoc
class __$$_FlRelationshipCopyWithImpl<$Res>
    extends _$FlRelationshipCopyWithImpl<$Res, _$_FlRelationship>
    implements _$$_FlRelationshipCopyWith<$Res> {
  __$$_FlRelationshipCopyWithImpl(
      _$_FlRelationship _value, $Res Function(_$_FlRelationship) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? blocked = null,
    Object? muted = null,
    Object? connected = null,
    Object? following = null,
    Object? hidden = null,
  }) {
    return _then(_$_FlRelationship(
      blocked: null == blocked
          ? _value.blocked
          : blocked // ignore: cast_nullable_to_non_nullable
              as bool,
      muted: null == muted
          ? _value.muted
          : muted // ignore: cast_nullable_to_non_nullable
              as bool,
      connected: null == connected
          ? _value.connected
          : connected // ignore: cast_nullable_to_non_nullable
              as bool,
      following: null == following
          ? _value.following
          : following // ignore: cast_nullable_to_non_nullable
              as bool,
      hidden: null == hidden
          ? _value.hidden
          : hidden // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FlRelationship implements _FlRelationship {
  const _$_FlRelationship(
      {this.blocked = false,
      this.muted = false,
      this.connected = false,
      this.following = false,
      this.hidden = false});

  factory _$_FlRelationship.fromJson(Map<String, dynamic> json) =>
      _$$_FlRelationshipFromJson(json);

  @override
  @JsonKey()
  final bool blocked;
  @override
  @JsonKey()
  final bool muted;
  @override
  @JsonKey()
  final bool connected;
  @override
  @JsonKey()
  final bool following;
  @override
  @JsonKey()
  final bool hidden;

  @override
  String toString() {
    return 'FlRelationship(blocked: $blocked, muted: $muted, connected: $connected, following: $following, hidden: $hidden)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FlRelationship &&
            (identical(other.blocked, blocked) || other.blocked == blocked) &&
            (identical(other.muted, muted) || other.muted == muted) &&
            (identical(other.connected, connected) ||
                other.connected == connected) &&
            (identical(other.following, following) ||
                other.following == following) &&
            (identical(other.hidden, hidden) || other.hidden == hidden));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, blocked, muted, connected, following, hidden);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_FlRelationshipCopyWith<_$_FlRelationship> get copyWith =>
      __$$_FlRelationshipCopyWithImpl<_$_FlRelationship>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FlRelationshipToJson(
      this,
    );
  }
}

abstract class _FlRelationship implements FlRelationship {
  const factory _FlRelationship(
      {final bool blocked,
      final bool muted,
      final bool connected,
      final bool following,
      final bool hidden}) = _$_FlRelationship;

  factory _FlRelationship.fromJson(Map<String, dynamic> json) =
      _$_FlRelationship.fromJson;

  @override
  bool get blocked;
  @override
  bool get muted;
  @override
  bool get connected;
  @override
  bool get following;
  @override
  bool get hidden;
  @override
  @JsonKey(ignore: true)
  _$$_FlRelationshipCopyWith<_$_FlRelationship> get copyWith =>
      throw _privateConstructorUsedError;
}
