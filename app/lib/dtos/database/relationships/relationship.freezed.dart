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
  List<RelationshipMember> get members => throw _privateConstructorUsedError;
  @JsonKey(
      fromJson: RelationshipFlag.fromJsonList,
      toJson: RelationshipFlag.toJsonList)
  List<RelationshipFlag> get flags => throw _privateConstructorUsedError;
  bool get blocked => throw _privateConstructorUsedError;
  String get channelId => throw _privateConstructorUsedError;
  bool get connected => throw _privateConstructorUsedError;
  bool get following => throw _privateConstructorUsedError;
  bool get hidden => throw _privateConstructorUsedError;
  bool get muted => throw _privateConstructorUsedError;

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
      List<RelationshipMember> members,
      @JsonKey(
          fromJson: RelationshipFlag.fromJsonList,
          toJson: RelationshipFlag.toJsonList)
      List<RelationshipFlag> flags,
      bool blocked,
      String channelId,
      bool connected,
      bool following,
      bool hidden,
      bool muted});

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
    Object? members = null,
    Object? flags = null,
    Object? blocked = null,
    Object? channelId = null,
    Object? connected = null,
    Object? following = null,
    Object? hidden = null,
    Object? muted = null,
  }) {
    return _then(_value.copyWith(
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
      members: null == members
          ? _value.members
          : members // ignore: cast_nullable_to_non_nullable
              as List<RelationshipMember>,
      flags: null == flags
          ? _value.flags
          : flags // ignore: cast_nullable_to_non_nullable
              as List<RelationshipFlag>,
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
      muted: null == muted
          ? _value.muted
          : muted // ignore: cast_nullable_to_non_nullable
              as bool,
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
      List<RelationshipMember> members,
      @JsonKey(
          fromJson: RelationshipFlag.fromJsonList,
          toJson: RelationshipFlag.toJsonList)
      List<RelationshipFlag> flags,
      bool blocked,
      String channelId,
      bool connected,
      bool following,
      bool hidden,
      bool muted});

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
    Object? members = null,
    Object? flags = null,
    Object? blocked = null,
    Object? channelId = null,
    Object? connected = null,
    Object? following = null,
    Object? hidden = null,
    Object? muted = null,
  }) {
    return _then(_$_Relationship(
      flMeta: freezed == flMeta
          ? _value.flMeta
          : flMeta // ignore: cast_nullable_to_non_nullable
              as FlMeta?,
      members: null == members
          ? _value._members
          : members // ignore: cast_nullable_to_non_nullable
              as List<RelationshipMember>,
      flags: null == flags
          ? _value._flags
          : flags // ignore: cast_nullable_to_non_nullable
              as List<RelationshipFlag>,
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
      muted: null == muted
          ? _value.muted
          : muted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Relationship implements _Relationship {
  const _$_Relationship(
      {@JsonKey(name: '_fl_meta_') this.flMeta,
      final List<RelationshipMember> members = const [],
      @JsonKey(
          fromJson: RelationshipFlag.fromJsonList,
          toJson: RelationshipFlag.toJsonList)
      final List<RelationshipFlag> flags = const [],
      this.blocked = false,
      this.channelId = '',
      this.connected = false,
      this.following = false,
      this.hidden = false,
      this.muted = false})
      : _members = members,
        _flags = flags;

  factory _$_Relationship.fromJson(Map<String, dynamic> json) =>
      _$$_RelationshipFromJson(json);

  @override
  @JsonKey(name: '_fl_meta_')
  final FlMeta? flMeta;
  final List<RelationshipMember> _members;
  @override
  @JsonKey()
  List<RelationshipMember> get members {
    if (_members is EqualUnmodifiableListView) return _members;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_members);
  }

  final List<RelationshipFlag> _flags;
  @override
  @JsonKey(
      fromJson: RelationshipFlag.fromJsonList,
      toJson: RelationshipFlag.toJsonList)
  List<RelationshipFlag> get flags {
    if (_flags is EqualUnmodifiableListView) return _flags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_flags);
  }

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
  final bool muted;

  @override
  String toString() {
    return 'Relationship(flMeta: $flMeta, members: $members, flags: $flags, blocked: $blocked, channelId: $channelId, connected: $connected, following: $following, hidden: $hidden, muted: $muted)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Relationship &&
            (identical(other.flMeta, flMeta) || other.flMeta == flMeta) &&
            const DeepCollectionEquality().equals(other._members, _members) &&
            const DeepCollectionEquality().equals(other._flags, _flags) &&
            (identical(other.blocked, blocked) || other.blocked == blocked) &&
            (identical(other.channelId, channelId) ||
                other.channelId == channelId) &&
            (identical(other.connected, connected) ||
                other.connected == connected) &&
            (identical(other.following, following) ||
                other.following == following) &&
            (identical(other.hidden, hidden) || other.hidden == hidden) &&
            (identical(other.muted, muted) || other.muted == muted));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      flMeta,
      const DeepCollectionEquality().hash(_members),
      const DeepCollectionEquality().hash(_flags),
      blocked,
      channelId,
      connected,
      following,
      hidden,
      muted);

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
      final List<RelationshipMember> members,
      @JsonKey(
          fromJson: RelationshipFlag.fromJsonList,
          toJson: RelationshipFlag.toJsonList)
      final List<RelationshipFlag> flags,
      final bool blocked,
      final String channelId,
      final bool connected,
      final bool following,
      final bool hidden,
      final bool muted}) = _$_Relationship;

  factory _Relationship.fromJson(Map<String, dynamic> json) =
      _$_Relationship.fromJson;

  @override
  @JsonKey(name: '_fl_meta_')
  FlMeta? get flMeta;
  @override
  List<RelationshipMember> get members;
  @override
  @JsonKey(
      fromJson: RelationshipFlag.fromJsonList,
      toJson: RelationshipFlag.toJsonList)
  List<RelationshipFlag> get flags;
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
  bool get muted;
  @override
  @JsonKey(ignore: true)
  _$$_RelationshipCopyWith<_$_Relationship> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$RelationshipFlag {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() organisationManager,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? organisationManager,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? organisationManager,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_RelationshipFlagOrganisationManager value)
        organisationManager,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_RelationshipFlagOrganisationManager value)?
        organisationManager,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_RelationshipFlagOrganisationManager value)?
        organisationManager,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RelationshipFlagCopyWith<$Res> {
  factory $RelationshipFlagCopyWith(
          RelationshipFlag value, $Res Function(RelationshipFlag) then) =
      _$RelationshipFlagCopyWithImpl<$Res, RelationshipFlag>;
}

/// @nodoc
class _$RelationshipFlagCopyWithImpl<$Res, $Val extends RelationshipFlag>
    implements $RelationshipFlagCopyWith<$Res> {
  _$RelationshipFlagCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$_RelationshipFlagOrganisationManagerCopyWith<$Res> {
  factory _$$_RelationshipFlagOrganisationManagerCopyWith(
          _$_RelationshipFlagOrganisationManager value,
          $Res Function(_$_RelationshipFlagOrganisationManager) then) =
      __$$_RelationshipFlagOrganisationManagerCopyWithImpl<$Res>;
}

/// @nodoc
class __$$_RelationshipFlagOrganisationManagerCopyWithImpl<$Res>
    extends _$RelationshipFlagCopyWithImpl<$Res,
        _$_RelationshipFlagOrganisationManager>
    implements _$$_RelationshipFlagOrganisationManagerCopyWith<$Res> {
  __$$_RelationshipFlagOrganisationManagerCopyWithImpl(
      _$_RelationshipFlagOrganisationManager _value,
      $Res Function(_$_RelationshipFlagOrganisationManager) _then)
      : super(_value, _then);
}

/// @nodoc

class _$_RelationshipFlagOrganisationManager
    implements _RelationshipFlagOrganisationManager {
  const _$_RelationshipFlagOrganisationManager();

  @override
  String toString() {
    return 'RelationshipFlag.organisationManager()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_RelationshipFlagOrganisationManager);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() organisationManager,
  }) {
    return organisationManager();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? organisationManager,
  }) {
    return organisationManager?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? organisationManager,
    required TResult orElse(),
  }) {
    if (organisationManager != null) {
      return organisationManager();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_RelationshipFlagOrganisationManager value)
        organisationManager,
  }) {
    return organisationManager(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_RelationshipFlagOrganisationManager value)?
        organisationManager,
  }) {
    return organisationManager?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_RelationshipFlagOrganisationManager value)?
        organisationManager,
    required TResult orElse(),
  }) {
    if (organisationManager != null) {
      return organisationManager(this);
    }
    return orElse();
  }
}

abstract class _RelationshipFlagOrganisationManager
    implements RelationshipFlag {
  const factory _RelationshipFlagOrganisationManager() =
      _$_RelationshipFlagOrganisationManager;
}
