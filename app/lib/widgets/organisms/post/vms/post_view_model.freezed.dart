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
  Activity? get activity => throw _privateConstructorUsedError;
  String get currentProfileId => throw _privateConstructorUsedError;
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
      Activity? activity,
      String currentProfileId,
      TargetFeed targetFeed,
      dynamic currentCommentText,
      bool isBusy,
      bool isRefreshing});

  $ActivityCopyWith<$Res>? get activity;
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
    Object? activity = freezed,
    Object? currentProfileId = null,
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
      activity: freezed == activity
          ? _value.activity
          : activity // ignore: cast_nullable_to_non_nullable
              as Activity?,
      currentProfileId: null == currentProfileId
          ? _value.currentProfileId
          : currentProfileId // ignore: cast_nullable_to_non_nullable
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
  $ActivityCopyWith<$Res>? get activity {
    if (_value.activity == null) {
      return null;
    }

    return $ActivityCopyWith<$Res>(_value.activity!, (value) {
      return _then(_value.copyWith(activity: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_PostViewModelStateCopyWith<$Res>
    implements $PostViewModelStateCopyWith<$Res> {
  factory _$$_PostViewModelStateCopyWith(_$_PostViewModelState value,
          $Res Function(_$_PostViewModelState) then) =
      __$$_PostViewModelStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String activityId,
      Activity? activity,
      String currentProfileId,
      TargetFeed targetFeed,
      dynamic currentCommentText,
      bool isBusy,
      bool isRefreshing});

  @override
  $ActivityCopyWith<$Res>? get activity;
}

/// @nodoc
class __$$_PostViewModelStateCopyWithImpl<$Res>
    extends _$PostViewModelStateCopyWithImpl<$Res, _$_PostViewModelState>
    implements _$$_PostViewModelStateCopyWith<$Res> {
  __$$_PostViewModelStateCopyWithImpl(
      _$_PostViewModelState _value, $Res Function(_$_PostViewModelState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activityId = null,
    Object? activity = freezed,
    Object? currentProfileId = null,
    Object? targetFeed = null,
    Object? currentCommentText = freezed,
    Object? isBusy = null,
    Object? isRefreshing = null,
  }) {
    return _then(_$_PostViewModelState(
      activityId: null == activityId
          ? _value.activityId
          : activityId // ignore: cast_nullable_to_non_nullable
              as String,
      activity: freezed == activity
          ? _value.activity
          : activity // ignore: cast_nullable_to_non_nullable
              as Activity?,
      currentProfileId: null == currentProfileId
          ? _value.currentProfileId
          : currentProfileId // ignore: cast_nullable_to_non_nullable
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

class _$_PostViewModelState implements _PostViewModelState {
  const _$_PostViewModelState(
      {required this.activityId,
      this.activity,
      this.currentProfileId = '',
      required this.targetFeed,
      this.currentCommentText = '',
      this.isBusy = false,
      this.isRefreshing = false});

  @override
  final String activityId;
  @override
  final Activity? activity;
  @override
  @JsonKey()
  final String currentProfileId;
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
    return 'PostViewModelState(activityId: $activityId, activity: $activity, currentProfileId: $currentProfileId, targetFeed: $targetFeed, currentCommentText: $currentCommentText, isBusy: $isBusy, isRefreshing: $isRefreshing)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PostViewModelState &&
            (identical(other.activityId, activityId) ||
                other.activityId == activityId) &&
            (identical(other.activity, activity) ||
                other.activity == activity) &&
            (identical(other.currentProfileId, currentProfileId) ||
                other.currentProfileId == currentProfileId) &&
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
      activity,
      currentProfileId,
      targetFeed,
      const DeepCollectionEquality().hash(currentCommentText),
      isBusy,
      isRefreshing);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PostViewModelStateCopyWith<_$_PostViewModelState> get copyWith =>
      __$$_PostViewModelStateCopyWithImpl<_$_PostViewModelState>(
          this, _$identity);
}

abstract class _PostViewModelState implements PostViewModelState {
  const factory _PostViewModelState(
      {required final String activityId,
      final Activity? activity,
      final String currentProfileId,
      required final TargetFeed targetFeed,
      final dynamic currentCommentText,
      final bool isBusy,
      final bool isRefreshing}) = _$_PostViewModelState;

  @override
  String get activityId;
  @override
  Activity? get activity;
  @override
  String get currentProfileId;
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
  _$$_PostViewModelStateCopyWith<_$_PostViewModelState> get copyWith =>
      throw _privateConstructorUsedError;
}
