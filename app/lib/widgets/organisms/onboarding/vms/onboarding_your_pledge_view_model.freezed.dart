// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_your_pledge_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$OnboardingYourPledgeViewModelState {
  bool get hasAcceptedPledge => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $OnboardingYourPledgeViewModelStateCopyWith<
          OnboardingYourPledgeViewModelState>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnboardingYourPledgeViewModelStateCopyWith<$Res> {
  factory $OnboardingYourPledgeViewModelStateCopyWith(
          OnboardingYourPledgeViewModelState value,
          $Res Function(OnboardingYourPledgeViewModelState) then) =
      _$OnboardingYourPledgeViewModelStateCopyWithImpl<$Res,
          OnboardingYourPledgeViewModelState>;
  @useResult
  $Res call({bool hasAcceptedPledge});
}

/// @nodoc
class _$OnboardingYourPledgeViewModelStateCopyWithImpl<$Res,
        $Val extends OnboardingYourPledgeViewModelState>
    implements $OnboardingYourPledgeViewModelStateCopyWith<$Res> {
  _$OnboardingYourPledgeViewModelStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasAcceptedPledge = null,
  }) {
    return _then(_value.copyWith(
      hasAcceptedPledge: null == hasAcceptedPledge
          ? _value.hasAcceptedPledge
          : hasAcceptedPledge // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OnboardingYourPledgeViewModelStateImplCopyWith<$Res>
    implements $OnboardingYourPledgeViewModelStateCopyWith<$Res> {
  factory _$$OnboardingYourPledgeViewModelStateImplCopyWith(
          _$OnboardingYourPledgeViewModelStateImpl value,
          $Res Function(_$OnboardingYourPledgeViewModelStateImpl) then) =
      __$$OnboardingYourPledgeViewModelStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool hasAcceptedPledge});
}

/// @nodoc
class __$$OnboardingYourPledgeViewModelStateImplCopyWithImpl<$Res>
    extends _$OnboardingYourPledgeViewModelStateCopyWithImpl<$Res,
        _$OnboardingYourPledgeViewModelStateImpl>
    implements _$$OnboardingYourPledgeViewModelStateImplCopyWith<$Res> {
  __$$OnboardingYourPledgeViewModelStateImplCopyWithImpl(
      _$OnboardingYourPledgeViewModelStateImpl _value,
      $Res Function(_$OnboardingYourPledgeViewModelStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hasAcceptedPledge = null,
  }) {
    return _then(_$OnboardingYourPledgeViewModelStateImpl(
      hasAcceptedPledge: null == hasAcceptedPledge
          ? _value.hasAcceptedPledge
          : hasAcceptedPledge // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$OnboardingYourPledgeViewModelStateImpl
    implements _OnboardingYourPledgeViewModelState {
  const _$OnboardingYourPledgeViewModelStateImpl(
      {this.hasAcceptedPledge = false});

  @override
  @JsonKey()
  final bool hasAcceptedPledge;

  @override
  String toString() {
    return 'OnboardingYourPledgeViewModelState(hasAcceptedPledge: $hasAcceptedPledge)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnboardingYourPledgeViewModelStateImpl &&
            (identical(other.hasAcceptedPledge, hasAcceptedPledge) ||
                other.hasAcceptedPledge == hasAcceptedPledge));
  }

  @override
  int get hashCode => Object.hash(runtimeType, hasAcceptedPledge);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OnboardingYourPledgeViewModelStateImplCopyWith<
          _$OnboardingYourPledgeViewModelStateImpl>
      get copyWith => __$$OnboardingYourPledgeViewModelStateImplCopyWithImpl<
          _$OnboardingYourPledgeViewModelStateImpl>(this, _$identity);
}

abstract class _OnboardingYourPledgeViewModelState
    implements OnboardingYourPledgeViewModelState {
  const factory _OnboardingYourPledgeViewModelState(
          {final bool hasAcceptedPledge}) =
      _$OnboardingYourPledgeViewModelStateImpl;

  @override
  bool get hasAcceptedPledge;
  @override
  @JsonKey(ignore: true)
  _$$OnboardingYourPledgeViewModelStateImplCopyWith<
          _$OnboardingYourPledgeViewModelStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
