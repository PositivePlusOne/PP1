// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'archived_member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ArchivedMember _$ArchivedMemberFromJson(Map<String, dynamic> json) {
  return _ArchivedMember.fromJson(json);
}

/// @nodoc
mixin _$ArchivedMember {
  @JsonKey(name: 'member_id')
  String? get memberId => throw _privateConstructorUsedError;
  @JsonKey(name: 'date_archived')
  DateTime? get dateArchived => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_message_id')
  String? get lastMessageId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ArchivedMemberCopyWith<ArchivedMember> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArchivedMemberCopyWith<$Res> {
  factory $ArchivedMemberCopyWith(
          ArchivedMember value, $Res Function(ArchivedMember) then) =
      _$ArchivedMemberCopyWithImpl<$Res, ArchivedMember>;
  @useResult
  $Res call(
      {@JsonKey(name: 'member_id') String? memberId,
      @JsonKey(name: 'date_archived') DateTime? dateArchived,
      @JsonKey(name: 'last_message_id') String? lastMessageId});
}

/// @nodoc
class _$ArchivedMemberCopyWithImpl<$Res, $Val extends ArchivedMember>
    implements $ArchivedMemberCopyWith<$Res> {
  _$ArchivedMemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberId = freezed,
    Object? dateArchived = freezed,
    Object? lastMessageId = freezed,
  }) {
    return _then(_value.copyWith(
      memberId: freezed == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String?,
      dateArchived: freezed == dateArchived
          ? _value.dateArchived
          : dateArchived // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastMessageId: freezed == lastMessageId
          ? _value.lastMessageId
          : lastMessageId // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ArchivedMemberImplCopyWith<$Res>
    implements $ArchivedMemberCopyWith<$Res> {
  factory _$$ArchivedMemberImplCopyWith(_$ArchivedMemberImpl value,
          $Res Function(_$ArchivedMemberImpl) then) =
      __$$ArchivedMemberImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'member_id') String? memberId,
      @JsonKey(name: 'date_archived') DateTime? dateArchived,
      @JsonKey(name: 'last_message_id') String? lastMessageId});
}

/// @nodoc
class __$$ArchivedMemberImplCopyWithImpl<$Res>
    extends _$ArchivedMemberCopyWithImpl<$Res, _$ArchivedMemberImpl>
    implements _$$ArchivedMemberImplCopyWith<$Res> {
  __$$ArchivedMemberImplCopyWithImpl(
      _$ArchivedMemberImpl _value, $Res Function(_$ArchivedMemberImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? memberId = freezed,
    Object? dateArchived = freezed,
    Object? lastMessageId = freezed,
  }) {
    return _then(_$ArchivedMemberImpl(
      memberId: freezed == memberId
          ? _value.memberId
          : memberId // ignore: cast_nullable_to_non_nullable
              as String?,
      dateArchived: freezed == dateArchived
          ? _value.dateArchived
          : dateArchived // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastMessageId: freezed == lastMessageId
          ? _value.lastMessageId
          : lastMessageId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ArchivedMemberImpl implements _ArchivedMember {
  const _$ArchivedMemberImpl(
      {@JsonKey(name: 'member_id') this.memberId,
      @JsonKey(name: 'date_archived') this.dateArchived,
      @JsonKey(name: 'last_message_id') this.lastMessageId});

  factory _$ArchivedMemberImpl.fromJson(Map<String, dynamic> json) =>
      _$$ArchivedMemberImplFromJson(json);

  @override
  @JsonKey(name: 'member_id')
  final String? memberId;
  @override
  @JsonKey(name: 'date_archived')
  final DateTime? dateArchived;
  @override
  @JsonKey(name: 'last_message_id')
  final String? lastMessageId;

  @override
  String toString() {
    return 'ArchivedMember(memberId: $memberId, dateArchived: $dateArchived, lastMessageId: $lastMessageId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArchivedMemberImpl &&
            (identical(other.memberId, memberId) ||
                other.memberId == memberId) &&
            (identical(other.dateArchived, dateArchived) ||
                other.dateArchived == dateArchived) &&
            (identical(other.lastMessageId, lastMessageId) ||
                other.lastMessageId == lastMessageId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, memberId, dateArchived, lastMessageId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ArchivedMemberImplCopyWith<_$ArchivedMemberImpl> get copyWith =>
      __$$ArchivedMemberImplCopyWithImpl<_$ArchivedMemberImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ArchivedMemberImplToJson(
      this,
    );
  }
}

abstract class _ArchivedMember implements ArchivedMember {
  const factory _ArchivedMember(
          {@JsonKey(name: 'member_id') final String? memberId,
          @JsonKey(name: 'date_archived') final DateTime? dateArchived,
          @JsonKey(name: 'last_message_id') final String? lastMessageId}) =
      _$ArchivedMemberImpl;

  factory _ArchivedMember.fromJson(Map<String, dynamic> json) =
      _$ArchivedMemberImpl.fromJson;

  @override
  @JsonKey(name: 'member_id')
  String? get memberId;
  @override
  @JsonKey(name: 'date_archived')
  DateTime? get dateArchived;
  @override
  @JsonKey(name: 'last_message_id')
  String? get lastMessageId;
  @override
  @JsonKey(ignore: true)
  _$$ArchivedMemberImplCopyWith<_$ArchivedMemberImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
