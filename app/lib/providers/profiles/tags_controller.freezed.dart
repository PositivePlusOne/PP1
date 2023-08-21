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
  List<Tag> get recommendedTags => throw _privateConstructorUsedError;

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
  $Res call({List<Tag> recommendedTags});
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
    Object? recommendedTags = null,
  }) {
    return _then(_value.copyWith(
      recommendedTags: null == recommendedTags
          ? _value.recommendedTags
          : recommendedTags // ignore: cast_nullable_to_non_nullable
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
  $Res call({List<Tag> recommendedTags});
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
    Object? recommendedTags = null,
  }) {
    return _then(_$_TagsControllerState(
      recommendedTags: null == recommendedTags
          ? _value._recommendedTags
          : recommendedTags // ignore: cast_nullable_to_non_nullable
              as List<Tag>,
    ));
  }
}

/// @nodoc

class _$_TagsControllerState implements _TagsControllerState {
  const _$_TagsControllerState(
      {final List<Tag> recommendedTags = const <Tag>[]})
      : _recommendedTags = recommendedTags;

  final List<Tag> _recommendedTags;
  @override
  @JsonKey()
  List<Tag> get recommendedTags {
    if (_recommendedTags is EqualUnmodifiableListView) return _recommendedTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendedTags);
  }

  @override
  String toString() {
    return 'TagsControllerState(recommendedTags: $recommendedTags)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TagsControllerState &&
            const DeepCollectionEquality()
                .equals(other._recommendedTags, _recommendedTags));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_recommendedTags));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TagsControllerStateCopyWith<_$_TagsControllerState> get copyWith =>
      __$$_TagsControllerStateCopyWithImpl<_$_TagsControllerState>(
          this, _$identity);
}

abstract class _TagsControllerState implements TagsControllerState {
  const factory _TagsControllerState({final List<Tag> recommendedTags}) =
      _$_TagsControllerState;

  @override
  List<Tag> get recommendedTags;
  @override
  @JsonKey(ignore: true)
  _$$_TagsControllerStateCopyWith<_$_TagsControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}
