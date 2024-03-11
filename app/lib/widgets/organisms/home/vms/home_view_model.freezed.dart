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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HomeViewModelState {
  bool get isRefreshing => throw _privateConstructorUsedError;
  bool get hasDoneInitialChecks => throw _privateConstructorUsedError;
  dynamic get currentTabIndex => throw _privateConstructorUsedError;

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
      {bool isRefreshing, bool hasDoneInitialChecks, dynamic currentTabIndex});
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
    Object? hasDoneInitialChecks = null,
    Object? currentTabIndex = freezed,
  }) {
    return _then(_value.copyWith(
      isRefreshing: null == isRefreshing
          ? _value.isRefreshing
          : isRefreshing // ignore: cast_nullable_to_non_nullable
              as bool,
      hasDoneInitialChecks: null == hasDoneInitialChecks
          ? _value.hasDoneInitialChecks
          : hasDoneInitialChecks // ignore: cast_nullable_to_non_nullable
              as bool,
      currentTabIndex: freezed == currentTabIndex
          ? _value.currentTabIndex
          : currentTabIndex // ignore: cast_nullable_to_non_nullable
              as dynamic,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HomeViewModelStateImplCopyWith<$Res>
    implements $HomeViewModelStateCopyWith<$Res> {
  factory _$$HomeViewModelStateImplCopyWith(_$HomeViewModelStateImpl value,
          $Res Function(_$HomeViewModelStateImpl) then) =
      __$$HomeViewModelStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isRefreshing, bool hasDoneInitialChecks, dynamic currentTabIndex});
}

/// @nodoc
class __$$HomeViewModelStateImplCopyWithImpl<$Res>
    extends _$HomeViewModelStateCopyWithImpl<$Res, _$HomeViewModelStateImpl>
    implements _$$HomeViewModelStateImplCopyWith<$Res> {
  __$$HomeViewModelStateImplCopyWithImpl(_$HomeViewModelStateImpl _value,
      $Res Function(_$HomeViewModelStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isRefreshing = null,
    Object? hasDoneInitialChecks = null,
    Object? currentTabIndex = freezed,
  }) {
    return _then(_$HomeViewModelStateImpl(
      isRefreshing: null == isRefreshing
          ? _value.isRefreshing
          : isRefreshing // ignore: cast_nullable_to_non_nullable
              as bool,
      hasDoneInitialChecks: null == hasDoneInitialChecks
          ? _value.hasDoneInitialChecks
          : hasDoneInitialChecks // ignore: cast_nullable_to_non_nullable
              as bool,
      currentTabIndex: freezed == currentTabIndex
          ? _value.currentTabIndex!
          : currentTabIndex,
    ));
  }
}

/// @nodoc

class _$HomeViewModelStateImpl implements _HomeViewModelState {
  const _$HomeViewModelStateImpl(
      {this.isRefreshing = false,
      this.hasDoneInitialChecks = false,
      this.currentTabIndex = 0});

  @override
  @JsonKey()
  final bool isRefreshing;
  @override
  @JsonKey()
  final bool hasDoneInitialChecks;
  @override
  @JsonKey()
  final dynamic currentTabIndex;

  @override
  String toString() {
    return 'HomeViewModelState(isRefreshing: $isRefreshing, hasDoneInitialChecks: $hasDoneInitialChecks, currentTabIndex: $currentTabIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeViewModelStateImpl &&
            (identical(other.isRefreshing, isRefreshing) ||
                other.isRefreshing == isRefreshing) &&
            (identical(other.hasDoneInitialChecks, hasDoneInitialChecks) ||
                other.hasDoneInitialChecks == hasDoneInitialChecks) &&
            const DeepCollectionEquality()
                .equals(other.currentTabIndex, currentTabIndex));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isRefreshing,
      hasDoneInitialChecks,
      const DeepCollectionEquality().hash(currentTabIndex));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeViewModelStateImplCopyWith<_$HomeViewModelStateImpl> get copyWith =>
      __$$HomeViewModelStateImplCopyWithImpl<_$HomeViewModelStateImpl>(
          this, _$identity);
}

abstract class _HomeViewModelState implements HomeViewModelState {
  const factory _HomeViewModelState(
      {final bool isRefreshing,
      final bool hasDoneInitialChecks,
      final dynamic currentTabIndex}) = _$HomeViewModelStateImpl;

  @override
  bool get isRefreshing;
  @override
  bool get hasDoneInitialChecks;
  @override
  dynamic get currentTabIndex;
  @override
  @JsonKey(ignore: true)
  _$$HomeViewModelStateImplCopyWith<_$HomeViewModelStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
