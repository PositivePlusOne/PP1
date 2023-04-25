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
  dynamic get currentTabIndex => throw _privateConstructorUsedError;
  dynamic get scrollOffset => throw _privateConstructorUsedError;

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
  $Res call({bool isRefreshing, dynamic currentTabIndex, dynamic scrollOffset});
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
    Object? currentTabIndex = freezed,
    Object? scrollOffset = freezed,
  }) {
    return _then(_value.copyWith(
      isRefreshing: null == isRefreshing
          ? _value.isRefreshing
          : isRefreshing // ignore: cast_nullable_to_non_nullable
              as bool,
      currentTabIndex: freezed == currentTabIndex
          ? _value.currentTabIndex
          : currentTabIndex // ignore: cast_nullable_to_non_nullable
              as dynamic,
      scrollOffset: freezed == scrollOffset
          ? _value.scrollOffset
          : scrollOffset // ignore: cast_nullable_to_non_nullable
              as dynamic,
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
  $Res call({bool isRefreshing, dynamic currentTabIndex, dynamic scrollOffset});
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
    Object? currentTabIndex = freezed,
    Object? scrollOffset = freezed,
  }) {
    return _then(_$_HomeViewModelState(
      isRefreshing: null == isRefreshing
          ? _value.isRefreshing
          : isRefreshing // ignore: cast_nullable_to_non_nullable
              as bool,
      currentTabIndex: freezed == currentTabIndex
          ? _value.currentTabIndex!
          : currentTabIndex,
      scrollOffset:
          freezed == scrollOffset ? _value.scrollOffset! : scrollOffset,
    ));
  }
}

/// @nodoc

class _$_HomeViewModelState implements _HomeViewModelState {
  const _$_HomeViewModelState(
      {this.isRefreshing = false,
      this.currentTabIndex = 0,
      this.scrollOffset = 0.0});

  @override
  @JsonKey()
  final bool isRefreshing;
  @override
  @JsonKey()
  final dynamic currentTabIndex;
  @override
  @JsonKey()
  final dynamic scrollOffset;

  @override
  String toString() {
    return 'HomeViewModelState(isRefreshing: $isRefreshing, currentTabIndex: $currentTabIndex, scrollOffset: $scrollOffset)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_HomeViewModelState &&
            (identical(other.isRefreshing, isRefreshing) ||
                other.isRefreshing == isRefreshing) &&
            const DeepCollectionEquality()
                .equals(other.currentTabIndex, currentTabIndex) &&
            const DeepCollectionEquality()
                .equals(other.scrollOffset, scrollOffset));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isRefreshing,
      const DeepCollectionEquality().hash(currentTabIndex),
      const DeepCollectionEquality().hash(scrollOffset));

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
      final dynamic currentTabIndex,
      final dynamic scrollOffset}) = _$_HomeViewModelState;

  @override
  bool get isRefreshing;
  @override
  dynamic get currentTabIndex;
  @override
  dynamic get scrollOffset;
  @override
  @JsonKey(ignore: true)
  _$$_HomeViewModelStateCopyWith<_$_HomeViewModelState> get copyWith =>
      throw _privateConstructorUsedError;
}
