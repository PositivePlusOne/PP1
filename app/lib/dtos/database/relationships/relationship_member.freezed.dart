// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'relationship_member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

RelationshipMember _$RelationshipMemberFromJson(Map<String, dynamic> json) {
  return _RelationshipMember.fromJson(json);
}

/// @nodoc
mixin _$RelationshipMember {
  bool get hasBlocked => throw _privateConstructorUsedError;
  bool get hasConnected => throw _privateConstructorUsedError;
  bool get hasFollowed => throw _privateConstructorUsedError;
  bool get hasHidden => throw _privateConstructorUsedError;
  bool get hasMuted => throw _privateConstructorUsedError;
  bool get hasManaged => throw _privateConstructorUsedError;
  String get memberId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RelationshipMemberCopyWith<RelationshipMember> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RelationshipMemberCopyWith<$Res> {
  factory $RelationshipMemberCopyWith(
          RelationshipMember value, $Res Function(RelationshipMember) then) =
      _$RelationshipMemberCopyWithImpl<$Res, RelationshipMember>;
  @useResult
  $Res call(
      {bool hasBlocked,
      bool hasConnected,
      bool hasFollowed,
      bool hasHidden,
      bool hasMuted,
      bool hasManaged,
      String memberId});
}

/// @nodoc
class _$RelationshipMemberCopyWithImpl<$Res, $Val extends RelationshipMember>
    implements $RelationshipMemberCopyWith<$Res> {
  _$RelationshipMemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasBlocked = null,
    Object? hasConnected = null,
    Object? hasFollowed = null,
    Object? hasHidden = null,
    Object? hasMuted = null,
    Object? hasManaged = null,
    Object? memberId = null,
  }) {
    return _then(_value.copyWith(
      hasBlocked: null == hasBlocked
          ? _value.hasBlocked
          : hasBlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      hasConnected: null == hasConnected
          ? _value.hasConnected
          : hasConnected // ignore: cast_nullable_to_non_nullable
              as bool,
      hasFollowed: null == hasFollowed
          ? _value.hasFollowed
          : hasFollowed // ignore: cast_nullable_to_non_nullable
              as bool,
      hasHidden: null == hasHidden
          ? _value.hasHidden
          : hasHidden // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMuted: null == hasMuted
          ? _value.hasMuted
          : hasMuted // ignore: cast_nullable_to_non_nullable
              as bool,
      hasManaged: null == hasManaged
          ? _value.hasManaged
          : hasManaged // ignore: cast_nullable_to_non_nullable
              as bool,
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RelationshipMemberImplCopyWith<$Res>
    implements $RelationshipMemberCopyWith<$Res> {
  factory _$$RelationshipMemberImplCopyWith(_$RelationshipMemberImpl value,
          $Res Function(_$RelationshipMemberImpl) then) =
      __$$RelationshipMemberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool hasBlocked,
      bool hasConnected,
      bool hasFollowed,
      bool hasHidden,
      bool hasMuted,
      bool hasManaged,
      String memberId});
}

/// @nodoc
class __$$RelationshipMemberImplCopyWithImpl<$Res>
    extends _$RelationshipMemberCopyWithImpl<$Res, _$RelationshipMemberImpl>
    implements _$$RelationshipMemberImplCopyWith<$Res> {
  __$$RelationshipMemberImplCopyWithImpl(_$RelationshipMemberImpl _value,
      $Res Function(_$RelationshipMemberImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasBlocked = null,
    Object? hasConnected = null,
    Object? hasFollowed = null,
    Object? hasHidden = null,
    Object? hasMuted = null,
    Object? hasManaged = null,
    Object? memberId = null,
  }) {
    return _then(_$RelationshipMemberImpl(
      hasBlocked: null == hasBlocked
          ? _value.hasBlocked
          : hasBlocked // ignore: cast_nullable_to_non_nullable
              as bool,
      hasConnected: null == hasConnected
          ? _value.hasConnected
          : hasConnected // ignore: cast_nullable_to_non_nullable
              as bool,
      hasFollowed: null == hasFollowed
          ? _value.hasFollowed
          : hasFollowed // ignore: cast_nullable_to_non_nullable
              as bool,
      hasHidden: null == hasHidden
          ? _value.hasHidden
          : hasHidden // ignore: cast_nullable_to_non_nullable
              as bool,
      hasMuted: null == hasMuted
          ? _value.hasMuted
          : hasMuted // ignore: cast_nullable_to_non_nullable
              as bool,
      hasManaged: null == hasManaged
          ? _value.hasManaged
          : hasManaged // ignore: cast_nullable_to_non_nullable
              as bool,
      memberId: null == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RelationshipMemberImpl implements _RelationshipMember {
  const _$RelationshipMemberImpl(
      {this.hasBlocked = false,
      this.hasConnected = false,
      this.hasFollowed = false,
      this.hasHidden = false,
      this.hasMuted = false,
      this.hasManaged = false,
      this.memberId = ''});

  factory _$RelationshipMemberImpl.fromJson(Map<String, dynamic> json) =>
      _$$RelationshipMemberImplFromJson(json);

  @override
  @JsonKey()
  final bool hasBlocked;
  @override
  @JsonKey()
  final bool hasConnected;
  @override
  @JsonKey()
  final bool hasFollowed;
  @override
  @JsonKey()
  final bool hasHidden;
  @override
  @JsonKey()
  final bool hasMuted;
  @override
  @JsonKey()
  final bool hasManaged;
  @override
  @JsonKey()
  final String memberId;

  @override
  String toString() {
    return 'RelationshipMember(hasBlocked: $hasBlocked, hasConnected: $hasConnected, hasFollowed: $hasFollowed, hasHidden: $hasHidden, hasMuted: $hasMuted, hasManaged: $hasManaged, memberId: $memberId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RelationshipMemberImpl &&
            (identical(other.hasBlocked, hasBlocked) ||
                other.hasBlocked == hasBlocked) &&
            (identical(other.hasConnected, hasConnected) ||
                other.hasConnected == hasConnected) &&
            (identical(other.hasFollowed, hasFollowed) ||
                other.hasFollowed == hasFollowed) &&
            (identical(other.hasHidden, hasHidden) ||
                other.hasHidden == hasHidden) &&
            (identical(other.hasMuted, hasMuted) ||
                other.hasMuted == hasMuted) &&
            (identical(other.hasManaged, hasManaged) ||
                other.hasManaged == hasManaged) &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, hasBlocked, hasConnected,
      hasFollowed, hasHidden, hasMuted, hasManaged, memberId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RelationshipMemberImplCopyWith<_$RelationshipMemberImpl> get copyWith =>
      __$$RelationshipMemberImplCopyWithImpl<_$RelationshipMemberImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RelationshipMemberImplToJson(
      this,
    );
  }
}

abstract class _RelationshipMember implements RelationshipMember {
  const factory _RelationshipMember(
      {final bool hasBlocked,
      final bool hasConnected,
      final bool hasFollowed,
      final bool hasHidden,
      final bool hasMuted,
      final bool hasManaged,
      final String memberId}) = _$RelationshipMemberImpl;

  factory _RelationshipMember.fromJson(Map<String, dynamic> json) =
      _$RelationshipMemberImpl.fromJson;

  @override
  bool get hasBlocked;
  @override
  bool get hasConnected;
  @override
  bool get hasFollowed;
  @override
  bool get hasHidden;
  @override
  bool get hasMuted;
  @override
  bool get hasManaged;
  @override
  String get memberId;
  @override
  @JsonKey(ignore: true)
  _$$RelationshipMemberImplCopyWith<_$RelationshipMemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
