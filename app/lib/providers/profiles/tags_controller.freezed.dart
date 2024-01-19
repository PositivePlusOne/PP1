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
  HashMap<String, Tag> get allTags => throw _privateConstructorUsedError;
  HashMap<String, Tag> get popularTags => throw _privateConstructorUsedError;
  HashMap<String, Tag> get recentTags => throw _privateConstructorUsedError;
  HashMap<String, Tag> get topicTags => throw _privateConstructorUsedError;

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
  $Res call(
      {HashMap<String, Tag> allTags,
      HashMap<String, Tag> popularTags,
      HashMap<String, Tag> recentTags,
      HashMap<String, Tag> topicTags});
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
    Object? allTags = null,
    Object? popularTags = null,
    Object? recentTags = null,
    Object? topicTags = null,
  }) {
    return _then(_value.copyWith(
      allTags: null == allTags
          ? _value.allTags
          : allTags // ignore: cast_nullable_to_non_nullable
              as HashMap<String, Tag>,
      popularTags: null == popularTags
          ? _value.popularTags
          : popularTags // ignore: cast_nullable_to_non_nullable
              as HashMap<String, Tag>,
      recentTags: null == recentTags
          ? _value.recentTags
          : recentTags // ignore: cast_nullable_to_non_nullable
              as HashMap<String, Tag>,
      topicTags: null == topicTags
          ? _value.topicTags
          : topicTags // ignore: cast_nullable_to_non_nullable
              as HashMap<String, Tag>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TagsControllerStateImplCopyWith<$Res>
    implements $TagsControllerStateCopyWith<$Res> {
  factory _$$TagsControllerStateImplCopyWith(_$TagsControllerStateImpl value,
          $Res Function(_$TagsControllerStateImpl) then) =
      __$$TagsControllerStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {HashMap<String, Tag> allTags,
      HashMap<String, Tag> popularTags,
      HashMap<String, Tag> recentTags,
      HashMap<String, Tag> topicTags});
}

/// @nodoc
class __$$TagsControllerStateImplCopyWithImpl<$Res>
    extends _$TagsControllerStateCopyWithImpl<$Res, _$TagsControllerStateImpl>
    implements _$$TagsControllerStateImplCopyWith<$Res> {
  __$$TagsControllerStateImplCopyWithImpl(_$TagsControllerStateImpl _value,
      $Res Function(_$TagsControllerStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allTags = null,
    Object? popularTags = null,
    Object? recentTags = null,
    Object? topicTags = null,
  }) {
    return _then(_$TagsControllerStateImpl(
      allTags: null == allTags
          ? _value.allTags
          : allTags // ignore: cast_nullable_to_non_nullable
              as HashMap<String, Tag>,
      popularTags: null == popularTags
          ? _value.popularTags
          : popularTags // ignore: cast_nullable_to_non_nullable
              as HashMap<String, Tag>,
      recentTags: null == recentTags
          ? _value.recentTags
          : recentTags // ignore: cast_nullable_to_non_nullable
              as HashMap<String, Tag>,
      topicTags: null == topicTags
          ? _value.topicTags
          : topicTags // ignore: cast_nullable_to_non_nullable
              as HashMap<String, Tag>,
    ));
  }
}

/// @nodoc

class _$TagsControllerStateImpl implements _TagsControllerState {
  const _$TagsControllerStateImpl(
      {required this.allTags,
      required this.popularTags,
      required this.recentTags,
      required this.topicTags});

  @override
  final HashMap<String, Tag> allTags;
  @override
  final HashMap<String, Tag> popularTags;
  @override
  final HashMap<String, Tag> recentTags;
  @override
  final HashMap<String, Tag> topicTags;

  @override
  String toString() {
    return 'TagsControllerState(allTags: $allTags, popularTags: $popularTags, recentTags: $recentTags, topicTags: $topicTags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TagsControllerStateImpl &&
            const DeepCollectionEquality().equals(other.allTags, allTags) &&
            const DeepCollectionEquality()
                .equals(other.popularTags, popularTags) &&
            const DeepCollectionEquality()
                .equals(other.recentTags, recentTags) &&
            const DeepCollectionEquality().equals(other.topicTags, topicTags));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(allTags),
      const DeepCollectionEquality().hash(popularTags),
      const DeepCollectionEquality().hash(recentTags),
      const DeepCollectionEquality().hash(topicTags));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TagsControllerStateImplCopyWith<_$TagsControllerStateImpl> get copyWith =>
      __$$TagsControllerStateImplCopyWithImpl<_$TagsControllerStateImpl>(
          this, _$identity);
}

abstract class _TagsControllerState implements TagsControllerState {
  const factory _TagsControllerState(
          {required final HashMap<String, Tag> allTags,
          required final HashMap<String, Tag> popularTags,
          required final HashMap<String, Tag> recentTags,
          required final HashMap<String, Tag> topicTags}) =
      _$TagsControllerStateImpl;

  @override
  HashMap<String, Tag> get allTags;
  @override
  HashMap<String, Tag> get popularTags;
  @override
  HashMap<String, Tag> get recentTags;
  @override
  HashMap<String, Tag> get topicTags;
  @override
  @JsonKey(ignore: true)
  _$$TagsControllerStateImplCopyWith<_$TagsControllerStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
