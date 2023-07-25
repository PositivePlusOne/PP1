// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tags_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$TagsControllerState {
  List<Tag> get tags => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TagsControllerStateCopyWith<TagsControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TagsControllerStateCopyWith<$Res> {
  factory $TagsControllerStateCopyWith(
          TagsControllerState value, $Res Function(TagsControllerState) then) =
      _$TagsControllerStateCopyWithImpl<$Res, TagsControllerState>;
  @useResult
  $Res call({List<Tag> tags});
}

/// @nodoc
class _$TagsControllerStateCopyWithImpl<$Res, $Val extends TagsControllerState>
    implements $TagsControllerStateCopyWith<$Res> {
  _$TagsControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tags = null,
  }) {
    return _then(_value.copyWith(
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<Tag>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_TagsControllerStateCopyWith<$Res>
    implements $TagsControllerStateCopyWith<$Res> {
  factory _$$_TagsControllerStateCopyWith(_$_TagsControllerState value,
          $Res Function(_$_TagsControllerState) then) =
      __$$_TagsControllerStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Tag> tags});
}

/// @nodoc
class __$$_TagsControllerStateCopyWithImpl<$Res>
    extends _$TagsControllerStateCopyWithImpl<$Res, _$_TagsControllerState>
    implements _$$_TagsControllerStateCopyWith<$Res> {
  __$$_TagsControllerStateCopyWithImpl(_$_TagsControllerState _value,
      $Res Function(_$_TagsControllerState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tags = null,
  }) {
    return _then(_$_TagsControllerState(
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<Tag>,
    ));
  }
}

/// @nodoc

class _$_TagsControllerState implements _TagsControllerState {
  const _$_TagsControllerState({final List<Tag> tags = const []})
      : _tags = tags;

  final List<Tag> _tags;
  @override
  @JsonKey()
  List<Tag> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  String toString() {
    return 'TagsControllerState(tags: $tags)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TagsControllerState &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_tags));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TagsControllerStateCopyWith<_$_TagsControllerState> get copyWith =>
      __$$_TagsControllerStateCopyWithImpl<_$_TagsControllerState>(
          this, _$identity);
}

abstract class _TagsControllerState implements TagsControllerState {
  const factory _TagsControllerState({final List<Tag> tags}) =
      _$_TagsControllerState;

  @override
  List<Tag> get tags;
  @override
  @JsonKey(ignore: true)
  _$$_TagsControllerStateCopyWith<_$_TagsControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}
