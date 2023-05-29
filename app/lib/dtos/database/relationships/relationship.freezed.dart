// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'relationship.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Relationship _$RelationshipFromJson(Map<String, dynamic> json) {
  return _Relationship.fromJson(json);
}

/// @nodoc
mixin _$Relationship {
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta => throw _privateConstructorUsedError;
  bool get blocked => throw _privateConstructorUsedError;
  String get channelId => throw _privateConstructorUsedError;
  bool get connected => throw _privateConstructorUsedError;
  bool get following => throw _privateConstructorUsedError;
  bool get hidden => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;
  bool get muted => throw _privateConstructorUsedError;
  List<RelationshipMember> get members => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RelationshipCopyWith<Relationship> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RelationshipCopyWith<$Res> {
  factory $RelationshipCopyWith(
          Relationship value, $Res Function(Relationship) then) =
      _$RelationshipCopyWithImpl<$Res, Relationship>;
  @useResult
  $Res call(
      {@JsonKey(name: '_fl_meta_') FlMeta? flMeta,
      bool blocked,
      String channelId,
      bool connected,
      bool following,
      bool hidden,
      String id,
      bool muted,
      List<RelationshipMember> members});

  $FlMetaCopyWith<$Res>? get flMeta;
}

/// @nodoc
class _$RelationshipCopyWithImpl<$Res, $Val extends Relationship>
    implements $RelationshipCopyWith<$Res> {
  _$RelationshipCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flMeta = freezed,
    Object? blocked = null,
    Object? channelId = null,
    Object? connected = null,
    Object? following = null,
    Object? hidden = null,
    Object? id = null,
    Object? muted = null,
    Object? members = null,
  }) {
    return _then(_value.copyWith(
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
      blocked: null == blocked
          ? _value.blocked
          : blocked // ignore: cast_nullable_to_non_nullable
              as bool,
      channelId: null == channelId
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String,
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
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      muted: null == muted
          ? _value.muted
          : muted // ignore: cast_nullable_to_non_nullable
              as bool,
      members: null == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<RelationshipMember>,
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
abstract class _$$_RelationshipCopyWith<$Res>
    implements $RelationshipCopyWith<$Res> {
  factory _$$_RelationshipCopyWith(
          _$_Relationship value, $Res Function(_$_Relationship) then) =
      __$$_RelationshipCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: '_fl_meta_') FlMeta? flMeta,
      bool blocked,
      String channelId,
      bool connected,
      bool following,
      bool hidden,
      String id,
      bool muted,
      List<RelationshipMember> members});

  @override
  $FlMetaCopyWith<$Res>? get flMeta;
}

/// @nodoc
class __$$_RelationshipCopyWithImpl<$Res>
    extends _$RelationshipCopyWithImpl<$Res, _$_Relationship>
    implements _$$_RelationshipCopyWith<$Res> {
  __$$_RelationshipCopyWithImpl(
      _$_Relationship _value, $Res Function(_$_Relationship) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flMeta = freezed,
    Object? blocked = null,
    Object? channelId = null,
    Object? connected = null,
    Object? following = null,
    Object? hidden = null,
    Object? id = null,
    Object? muted = null,
    Object? members = null,
  }) {
    return _then(_$_Relationship(
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
      blocked: null == blocked
          ? _value.blocked
          : blocked // ignore: cast_nullable_to_non_nullable
              as bool,
      channelId: null == channelId
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String,
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
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      muted: null == muted
          ? _value.muted
          : muted // ignore: cast_nullable_to_non_nullable
              as bool,
      members: null == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<RelationshipMember>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Relationship implements _Relationship {
  const _$_Relationship(
      {@JsonKey(name: '_fl_meta_') this.flMeta,
      this.blocked = false,
      this.channelId = '',
      this.connected = false,
      this.following = false,
      this.hidden = false,
      this.id = '',
      this.muted = false,
      final List<RelationshipMember> members = const []})
      : _members = members;

  factory _$_Relationship.fromJson(Map<String, dynamic> json) =>
      _$$_RelationshipFromJson(json);

  @override
  @JsonKey(name: '_fl_meta_')
  final FlMeta? flMeta;
  @override
  @JsonKey()
  final bool blocked;
  @override
  @JsonKey()
  final String channelId;
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
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final bool muted;
  final List<RelationshipMember> _members;
  @override
  @JsonKey()
  List<RelationshipMember> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  @override
  String toString() {
    return 'Relationship(flMeta: $flMeta, blocked: $blocked, channelId: $channelId, connected: $connected, following: $following, hidden: $hidden, id: $id, muted: $muted, members: $members)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Relationship &&
            (identical(other.flMeta, flMeta) || other.flMeta == flMeta) &&
            (identical(other.blocked, blocked) || other.blocked == blocked) &&
            (identical(other.channelId, channelId) ||
                other.channelId == channelId) &&
            (identical(other.connected, connected) ||
                other.connected == connected) &&
            (identical(other.following, following) ||
                other.following == following) &&
            (identical(other.hidden, hidden) || other.hidden == hidden) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.muted, muted) || other.muted == muted) &&
            const DeepCollectionEquality().equals(other._members, _members));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      flMeta,
      blocked,
      channelId,
      connected,
      following,
      hidden,
      id,
      muted,
      const DeepCollectionEquality().hash(_members));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_RelationshipCopyWith<_$_Relationship> get copyWith =>
      __$$_RelationshipCopyWithImpl<_$_Relationship>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_RelationshipToJson(
      this,
    );
  }
}

abstract class _Relationship implements Relationship {
  const factory _Relationship(
      {@JsonKey(name: '_fl_meta_') final FlMeta? flMeta,
      final bool blocked,
      final String channelId,
      final bool connected,
      final bool following,
      final bool hidden,
      final String id,
      final bool muted,
      final List<RelationshipMember> members}) = _$_Relationship;

  factory _Relationship.fromJson(Map<String, dynamic> json) =
      _$_Relationship.fromJson;

  @override
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta;
  @override
  bool get blocked;
  @override
  String get channelId;
  @override
  bool get connected;
  @override
  bool get following;
  @override
  bool get hidden;
  @override
  String get id;
  @override
  bool get muted;
  @override
  List<RelationshipMember> get members;
  @override
  @JsonKey(ignore: true)
  _$$_RelationshipCopyWith<_$_Relationship> get copyWith =>
      throw _privateConstructorUsedError;
}
