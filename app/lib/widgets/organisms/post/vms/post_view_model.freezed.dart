// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'post_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PostViewModelState {
  String get activityId => throw _privateConstructorUsedError;
  TargetFeed get targetFeed => throw _privateConstructorUsedError;
  dynamic get currentCommentText => throw _privateConstructorUsedError;
  bool get isBusy => throw _privateConstructorUsedError;
  bool get isRefreshing => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PostViewModelStateCopyWith<PostViewModelState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PostViewModelStateCopyWith<$Res> {
  factory $PostViewModelStateCopyWith(
          PostViewModelState value, $Res Function(PostViewModelState) then) =
      _$PostViewModelStateCopyWithImpl<$Res, PostViewModelState>;
  @useResult
  $Res call(
      {String activityId,
      TargetFeed targetFeed,
      dynamic currentCommentText,
      bool isBusy,
      bool isRefreshing});

  $TargetFeedCopyWith<$Res> get targetFeed;
}

/// @nodoc
class _$PostViewModelStateCopyWithImpl<$Res, $Val extends PostViewModelState>
    implements $PostViewModelStateCopyWith<$Res> {
  _$PostViewModelStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activityId = null,
    Object? targetFeed = null,
    Object? currentCommentText = freezed,
    Object? isBusy = null,
    Object? isRefreshing = null,
  }) {
    return _then(_value.copyWith(
      activityId: null == activityId
          ? _value.activityId
          : activityId // ignore: cast_nullable_to_non_nullable
              as String,
      targetFeed: null == targetFeed
          ? _value.targetFeed
          : targetFeed // ignore: cast_nullable_to_non_nullable
              as TargetFeed,
      currentCommentText: freezed == currentCommentText
          ? _value.currentCommentText
          : currentCommentText // ignore: cast_nullable_to_non_nullable
              as dynamic,
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      isRefreshing: null == isRefreshing
          ? _value.isRefreshing
          : isRefreshing // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $TargetFeedCopyWith<$Res> get targetFeed {
    return $TargetFeedCopyWith<$Res>(_value.targetFeed, (value) {
      return _then(_value.copyWith(targetFeed: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PostViewModelStateImplCopyWith<$Res>
    implements $PostViewModelStateCopyWith<$Res> {
  factory _$$PostViewModelStateImplCopyWith(_$PostViewModelStateImpl value,
          $Res Function(_$PostViewModelStateImpl) then) =
      __$$PostViewModelStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String activityId,
      TargetFeed targetFeed,
      dynamic currentCommentText,
      bool isBusy,
      bool isRefreshing});

  @override
  $TargetFeedCopyWith<$Res> get targetFeed;
}

/// @nodoc
class __$$PostViewModelStateImplCopyWithImpl<$Res>
    extends _$PostViewModelStateCopyWithImpl<$Res, _$PostViewModelStateImpl>
    implements _$$PostViewModelStateImplCopyWith<$Res> {
  __$$PostViewModelStateImplCopyWithImpl(_$PostViewModelStateImpl _value,
      $Res Function(_$PostViewModelStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activityId = null,
    Object? targetFeed = null,
    Object? currentCommentText = freezed,
    Object? isBusy = null,
    Object? isRefreshing = null,
  }) {
    return _then(_$PostViewModelStateImpl(
      activityId: null == activityId
          ? _value.activityId
          : activityId // ignore: cast_nullable_to_non_nullable
              as String,
      targetFeed: null == targetFeed
          ? _value.targetFeed
          : targetFeed // ignore: cast_nullable_to_non_nullable
              as TargetFeed,
      currentCommentText: freezed == currentCommentText
          ? _value.currentCommentText!
          : currentCommentText,
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      isRefreshing: null == isRefreshing
          ? _value.isRefreshing
          : isRefreshing // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$PostViewModelStateImpl implements _PostViewModelState {
  const _$PostViewModelStateImpl(
      {required this.activityId,
      required this.targetFeed,
      this.currentCommentText = '',
      this.isBusy = false,
      this.isRefreshing = false});

  @override
  final String activityId;
  @override
  final TargetFeed targetFeed;
  @override
  @JsonKey()
  final dynamic currentCommentText;
  @override
  @JsonKey()
  final bool isBusy;
  @override
  @JsonKey()
  final bool isRefreshing;

  @override
  String toString() {
    return 'PostViewModelState(activityId: $activityId, targetFeed: $targetFeed, currentCommentText: $currentCommentText, isBusy: $isBusy, isRefreshing: $isRefreshing)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PostViewModelStateImpl &&
            (identical(other.activityId, activityId) ||
                other.activityId == activityId) &&
            (identical(other.targetFeed, targetFeed) ||
                other.targetFeed == targetFeed) &&
            const DeepCollectionEquality()
                .equals(other.currentCommentText, currentCommentText) &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy) &&
            (identical(other.isRefreshing, isRefreshing) ||
                other.isRefreshing == isRefreshing));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      activityId,
      targetFeed,
      const DeepCollectionEquality().hash(currentCommentText),
      isBusy,
      isRefreshing);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PostViewModelStateImplCopyWith<_$PostViewModelStateImpl> get copyWith =>
      __$$PostViewModelStateImplCopyWithImpl<_$PostViewModelStateImpl>(
          this, _$identity);
}

abstract class _PostViewModelState implements PostViewModelState {
  const factory _PostViewModelState(
      {required final String activityId,
      required final TargetFeed targetFeed,
      final dynamic currentCommentText,
      final bool isBusy,
      final bool isRefreshing}) = _$PostViewModelStateImpl;

  @override
  String get activityId;
  @override
  TargetFeed get targetFeed;
  @override
  dynamic get currentCommentText;
  @override
  bool get isBusy;
  @override
  bool get isRefreshing;
  @override
  @JsonKey(ignore: true)
  _$$PostViewModelStateImplCopyWith<_$PostViewModelStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
