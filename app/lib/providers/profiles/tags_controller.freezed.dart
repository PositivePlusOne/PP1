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
  List<Tag> get popularTags => throw _privateConstructorUsedError;
  List<Tag> get recentTags => throw _privateConstructorUsedError;
  List<Tag> get topicTags => throw _privateConstructorUsedError;

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
  $Res call({List<Tag> popularTags, List<Tag> recentTags, List<Tag> topicTags});
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
    Object? popularTags = null,
    Object? recentTags = null,
    Object? topicTags = null,
  }) {
    return _then(_value.copyWith(
      popularTags: null == popularTags
          ? _value.popularTags
          : popularTags // ignore: cast_nullable_to_non_nullable
              as List<Tag>,
      recentTags: null == recentTags
          ? _value.recentTags
          : recentTags // ignore: cast_nullable_to_non_nullable
              as List<Tag>,
      topicTags: null == topicTags
          ? _value.topicTags
          : topicTags // ignore: cast_nullable_to_non_nullable
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
  $Res call({List<Tag> popularTags, List<Tag> recentTags, List<Tag> topicTags});
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
    Object? popularTags = null,
    Object? recentTags = null,
    Object? topicTags = null,
  }) {
    return _then(_$_TagsControllerState(
      popularTags: null == popularTags
          ? _value._popularTags
          : popularTags // ignore: cast_nullable_to_non_nullable
              as List<Tag>,
      recentTags: null == recentTags
          ? _value._recentTags
          : recentTags // ignore: cast_nullable_to_non_nullable
              as List<Tag>,
      topicTags: null == topicTags
          ? _value._topicTags
          : topicTags // ignore: cast_nullable_to_non_nullable
              as List<Tag>,
    ));
  }
}

/// @nodoc

class _$_TagsControllerState implements _TagsControllerState {
  const _$_TagsControllerState(
      {final List<Tag> popularTags = const <Tag>[],
      final List<Tag> recentTags = const <Tag>[],
      final List<Tag> topicTags = const <Tag>[]})
      : _popularTags = popularTags,
        _recentTags = recentTags,
        _topicTags = topicTags;

  final List<Tag> _popularTags;
  @override
  @JsonKey()
  List<Tag> get popularTags {
    if (_popularTags is EqualUnmodifiableListView) return _popularTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_popularTags);
  }

  final List<Tag> _recentTags;
  @override
  @JsonKey()
  List<Tag> get recentTags {
    if (_recentTags is EqualUnmodifiableListView) return _recentTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recentTags);
  }

  final List<Tag> _topicTags;
  @override
  @JsonKey()
  List<Tag> get topicTags {
    if (_topicTags is EqualUnmodifiableListView) return _topicTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topicTags);
  }

  @override
  String toString() {
    return 'TagsControllerState(popularTags: $popularTags, recentTags: $recentTags, topicTags: $topicTags)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TagsControllerState &&
            const DeepCollectionEquality()
                .equals(other._popularTags, _popularTags) &&
            const DeepCollectionEquality()
                .equals(other._recentTags, _recentTags) &&
            const DeepCollectionEquality()
                .equals(other._topicTags, _topicTags));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_popularTags),
      const DeepCollectionEquality().hash(_recentTags),
      const DeepCollectionEquality().hash(_topicTags));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TagsControllerStateCopyWith<_$_TagsControllerState> get copyWith =>
      __$$_TagsControllerStateCopyWithImpl<_$_TagsControllerState>(
          this, _$identity);
}

abstract class _TagsControllerState implements TagsControllerState {
  const factory _TagsControllerState(
      {final List<Tag> popularTags,
      final List<Tag> recentTags,
      final List<Tag> topicTags}) = _$_TagsControllerState;

  @override
  List<Tag> get popularTags;
  @override
  List<Tag> get recentTags;
  @override
  List<Tag> get topicTags;
  @override
  @JsonKey(ignore: true)
  _$$_TagsControllerStateCopyWith<_$_TagsControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}
