// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$HomeViewModelState {
  bool get isRefreshing => throw _privateConstructorUsedError;
  bool get hasPerformedInitialRefresh => throw _privateConstructorUsedError;
  dynamic get currentTabIndex => throw _privateConstructorUsedError;
  List<Activity> get events => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HomeViewModelStateCopyWith<HomeViewModelState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeViewModelStateCopyWith<$Res> {
  factory $HomeViewModelStateCopyWith(
          HomeViewModelState value, $Res Function(HomeViewModelState) then) =
      _$HomeViewModelStateCopyWithImpl<$Res, HomeViewModelState>;
  @useResult
  $Res call(
      {bool isRefreshing,
      bool hasPerformedInitialRefresh,
      dynamic currentTabIndex,
      List<Activity> events});
}

/// @nodoc
class _$HomeViewModelStateCopyWithImpl<$Res, $Val extends HomeViewModelState>
    implements $HomeViewModelStateCopyWith<$Res> {
  _$HomeViewModelStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isRefreshing = null,
    Object? hasPerformedInitialRefresh = null,
    Object? currentTabIndex = freezed,
    Object? events = null,
  }) {
    return _then(_value.copyWith(
      isRefreshing: null == isRefreshing
          ? _value.isRefreshing
          : isRefreshing // ignore: cast_nullable_to_non_nullable
              as bool,
      hasPerformedInitialRefresh: null == hasPerformedInitialRefresh
          ? _value.hasPerformedInitialRefresh
          : hasPerformedInitialRefresh // ignore: cast_nullable_to_non_nullable
              as bool,
      currentTabIndex: freezed == currentTabIndex
          ? _value.currentTabIndex
          : currentTabIndex // ignore: cast_nullable_to_non_nullable
              as dynamic,
      events: null == events
          ? _value.events
          : events // ignore: cast_nullable_to_non_nullable
              as List<Activity>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_HomeViewModelStateCopyWith<$Res>
    implements $HomeViewModelStateCopyWith<$Res> {
  factory _$$_HomeViewModelStateCopyWith(_$_HomeViewModelState value,
          $Res Function(_$_HomeViewModelState) then) =
      __$$_HomeViewModelStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isRefreshing,
      bool hasPerformedInitialRefresh,
      dynamic currentTabIndex,
      List<Activity> events});
}

/// @nodoc
class __$$_HomeViewModelStateCopyWithImpl<$Res>
    extends _$HomeViewModelStateCopyWithImpl<$Res, _$_HomeViewModelState>
    implements _$$_HomeViewModelStateCopyWith<$Res> {
  __$$_HomeViewModelStateCopyWithImpl(
      _$_HomeViewModelState _value, $Res Function(_$_HomeViewModelState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isRefreshing = null,
    Object? hasPerformedInitialRefresh = null,
    Object? currentTabIndex = freezed,
    Object? events = null,
  }) {
    return _then(_$_HomeViewModelState(
      isRefreshing: null == isRefreshing
          ? _value.isRefreshing
          : isRefreshing // ignore: cast_nullable_to_non_nullable
              as bool,
      hasPerformedInitialRefresh: null == hasPerformedInitialRefresh
          ? _value.hasPerformedInitialRefresh
          : hasPerformedInitialRefresh // ignore: cast_nullable_to_non_nullable
              as bool,
      currentTabIndex: freezed == currentTabIndex
          ? _value.currentTabIndex!
          : currentTabIndex,
      events: null == events
          ? _value._events
          : events // ignore: cast_nullable_to_non_nullable
              as List<Activity>,
    ));
  }
}

/// @nodoc

class _$_HomeViewModelState implements _HomeViewModelState {
  const _$_HomeViewModelState(
      {this.isRefreshing = false,
      this.hasPerformedInitialRefresh = false,
      this.currentTabIndex = 0,
      final List<Activity> events = const []})
      : _events = events;

  @override
  @JsonKey()
  final bool isRefreshing;
  @override
  @JsonKey()
  final bool hasPerformedInitialRefresh;
  @override
  @JsonKey()
  final dynamic currentTabIndex;
  final List<Activity> _events;
  @override
  @JsonKey()
  List<Activity> get events {
    if (_events is EqualUnmodifiableListView) return _events;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_events);
  }

  @override
  String toString() {
    return 'HomeViewModelState(isRefreshing: $isRefreshing, hasPerformedInitialRefresh: $hasPerformedInitialRefresh, currentTabIndex: $currentTabIndex, events: $events)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_HomeViewModelState &&
            (identical(other.isRefreshing, isRefreshing) ||
                other.isRefreshing == isRefreshing) &&
            (identical(other.hasPerformedInitialRefresh,
                    hasPerformedInitialRefresh) ||
                other.hasPerformedInitialRefresh ==
                    hasPerformedInitialRefresh) &&
            const DeepCollectionEquality()
                .equals(other.currentTabIndex, currentTabIndex) &&
            const DeepCollectionEquality().equals(other._events, _events));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isRefreshing,
      hasPerformedInitialRefresh,
      const DeepCollectionEquality().hash(currentTabIndex),
      const DeepCollectionEquality().hash(_events));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_HomeViewModelStateCopyWith<_$_HomeViewModelState> get copyWith =>
      __$$_HomeViewModelStateCopyWithImpl<_$_HomeViewModelState>(
          this, _$identity);
}

abstract class _HomeViewModelState implements HomeViewModelState {
  const factory _HomeViewModelState(
      {final bool isRefreshing,
      final bool hasPerformedInitialRefresh,
      final dynamic currentTabIndex,
      final List<Activity> events}) = _$_HomeViewModelState;

  @override
  bool get isRefreshing;
  @override
  bool get hasPerformedInitialRefresh;
  @override
  dynamic get currentTabIndex;
  @override
  List<Activity> get events;
  @override
  @JsonKey(ignore: true)
  _$$_HomeViewModelStateCopyWith<_$_HomeViewModelState> get copyWith =>
      throw _privateConstructorUsedError;
}
