// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_extra_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ChannelExtraData _$ChannelExtraDataFromJson(Map<String, dynamic> json) {
  return _ChannelExtraData.fromJson(json);
}

/// @nodoc
mixin _$ChannelExtraData {
  bool? get hidden => throw _privateConstructorUsedError;
  bool? get disabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'archived_members')
  List<ArchivedMember>? get archivedMembers =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChannelExtraDataCopyWith<ChannelExtraData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChannelExtraDataCopyWith<$Res> {
  factory $ChannelExtraDataCopyWith(
          ChannelExtraData value, $Res Function(ChannelExtraData) then) =
      _$ChannelExtraDataCopyWithImpl<$Res, ChannelExtraData>;
  @useResult
  $Res call(
      {bool? hidden,
      bool? disabled,
      @JsonKey(name: 'archived_members')
      List<ArchivedMember>? archivedMembers});
}

/// @nodoc
class _$ChannelExtraDataCopyWithImpl<$Res, $Val extends ChannelExtraData>
    implements $ChannelExtraDataCopyWith<$Res> {
  _$ChannelExtraDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hidden = freezed,
    Object? disabled = freezed,
    Object? archivedMembers = freezed,
  }) {
    return _then(_value.copyWith(
      hidden: freezed == hidden
          ? _value.hidden
          : hidden // ignore: cast_nullable_to_non_nullable
              as bool?,
      disabled: freezed == disabled
          ? _value.disabled
          : disabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      archivedMembers: freezed == archivedMembers
          ? _value.archivedMembers
          : archivedMembers // ignore: cast_nullable_to_non_nullable
              as List<ArchivedMember>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChannelExtraDataImplCopyWith<$Res>
    implements $ChannelExtraDataCopyWith<$Res> {
  factory _$$ChannelExtraDataImplCopyWith(_$ChannelExtraDataImpl value,
          $Res Function(_$ChannelExtraDataImpl) then) =
      __$$ChannelExtraDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool? hidden,
      bool? disabled,
      @JsonKey(name: 'archived_members')
      List<ArchivedMember>? archivedMembers});
}

/// @nodoc
class __$$ChannelExtraDataImplCopyWithImpl<$Res>
    extends _$ChannelExtraDataCopyWithImpl<$Res, _$ChannelExtraDataImpl>
    implements _$$ChannelExtraDataImplCopyWith<$Res> {
  __$$ChannelExtraDataImplCopyWithImpl(_$ChannelExtraDataImpl _value,
      $Res Function(_$ChannelExtraDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hidden = freezed,
    Object? disabled = freezed,
    Object? archivedMembers = freezed,
  }) {
    return _then(_$ChannelExtraDataImpl(
      hidden: freezed == hidden
          ? _value.hidden
          : hidden // ignore: cast_nullable_to_non_nullable
              as bool?,
      disabled: freezed == disabled
          ? _value.disabled
          : disabled // ignore: cast_nullable_to_non_nullable
              as bool?,
      archivedMembers: freezed == archivedMembers
          ? _value._archivedMembers
          : archivedMembers // ignore: cast_nullable_to_non_nullable
              as List<ArchivedMember>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChannelExtraDataImpl implements _ChannelExtraData {
  const _$ChannelExtraDataImpl(
      {this.hidden,
      this.disabled,
      @JsonKey(name: 'archived_members')
      final List<ArchivedMember>? archivedMembers})
      : _archivedMembers = archivedMembers;

  factory _$ChannelExtraDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChannelExtraDataImplFromJson(json);

  @override
  final bool? hidden;
  @override
  final bool? disabled;
  final List<ArchivedMember>? _archivedMembers;
  @override
  @JsonKey(name: 'archived_members')
  List<ArchivedMember>? get archivedMembers {
    final value = _archivedMembers;
    if (value == null) return null;
    if (_archivedMembers is EqualUnmodifiableListView) return _archivedMembers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ChannelExtraData(hidden: $hidden, disabled: $disabled, archivedMembers: $archivedMembers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChannelExtraDataImpl &&
            (identical(other.hidden, hidden) || other.hidden == hidden) &&
            (identical(other.disabled, disabled) ||
                other.disabled == disabled) &&
            const DeepCollectionEquality()
                .equals(other._archivedMembers, _archivedMembers));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, hidden, disabled,
      const DeepCollectionEquality().hash(_archivedMembers));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChannelExtraDataImplCopyWith<_$ChannelExtraDataImpl> get copyWith =>
      __$$ChannelExtraDataImplCopyWithImpl<_$ChannelExtraDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChannelExtraDataImplToJson(
      this,
    );
  }
}

abstract class _ChannelExtraData implements ChannelExtraData {
  const factory _ChannelExtraData(
      {final bool? hidden,
      final bool? disabled,
      @JsonKey(name: 'archived_members')
      final List<ArchivedMember>? archivedMembers}) = _$ChannelExtraDataImpl;

  factory _ChannelExtraData.fromJson(Map<String, dynamic> json) =
      _$ChannelExtraDataImpl.fromJson;

  @override
  bool? get hidden;
  @override
  bool? get disabled;
  @override
  @JsonKey(name: 'archived_members')
  List<ArchivedMember>? get archivedMembers;
  @override
  @JsonKey(ignore: true)
  _$$ChannelExtraDataImplCopyWith<_$ChannelExtraDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
