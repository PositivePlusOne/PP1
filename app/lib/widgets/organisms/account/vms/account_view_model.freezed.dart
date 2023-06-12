// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$AccountViewModelState {
  bool get isBusy => throw _privateConstructorUsedError;
  feedback_dto.Feedback get feedback => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AccountViewModelStateCopyWith<AccountViewModelState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountViewModelStateCopyWith<$Res> {
  factory $AccountViewModelStateCopyWith(AccountViewModelState value,
          $Res Function(AccountViewModelState) then) =
      _$AccountViewModelStateCopyWithImpl<$Res, AccountViewModelState>;
  @useResult
  $Res call({bool isBusy, feedback_dto.Feedback feedback});

  $FeedbackCopyWith<$Res> get feedback;
}

/// @nodoc
class _$AccountViewModelStateCopyWithImpl<$Res,
        $Val extends AccountViewModelState>
    implements $AccountViewModelStateCopyWith<$Res> {
  _$AccountViewModelStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
    Object? feedback = null,
  }) {
    return _then(_value.copyWith(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      feedback: null == feedback
          ? _value.feedback
          : feedback // ignore: cast_nullable_to_non_nullable
              as feedback_dto.Feedback,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $FeedbackCopyWith<$Res> get feedback {
    return $FeedbackCopyWith<$Res>(_value.feedback, (value) {
      return _then(_value.copyWith(feedback: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_AccountViewModelStateCopyWith<$Res>
    implements $AccountViewModelStateCopyWith<$Res> {
  factory _$$_AccountViewModelStateCopyWith(_$_AccountViewModelState value,
          $Res Function(_$_AccountViewModelState) then) =
      __$$_AccountViewModelStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isBusy, feedback_dto.Feedback feedback});

  @override
  $FeedbackCopyWith<$Res> get feedback;
}

/// @nodoc
class __$$_AccountViewModelStateCopyWithImpl<$Res>
    extends _$AccountViewModelStateCopyWithImpl<$Res, _$_AccountViewModelState>
    implements _$$_AccountViewModelStateCopyWith<$Res> {
  __$$_AccountViewModelStateCopyWithImpl(_$_AccountViewModelState _value,
      $Res Function(_$_AccountViewModelState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
    Object? feedback = null,
  }) {
    return _then(_$_AccountViewModelState(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      feedback: null == feedback
          ? _value.feedback
          : feedback // ignore: cast_nullable_to_non_nullable
              as feedback_dto.Feedback,
    ));
  }
}

/// @nodoc

class _$_AccountViewModelState implements _AccountViewModelState {
  const _$_AccountViewModelState({this.isBusy = false, required this.feedback});

  @override
  @JsonKey()
  final bool isBusy;
  @override
  final feedback_dto.Feedback feedback;

  @override
  String toString() {
    return 'AccountViewModelState(isBusy: $isBusy, feedback: $feedback)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AccountViewModelState &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy) &&
            (identical(other.feedback, feedback) ||
                other.feedback == feedback));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isBusy, feedback);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AccountViewModelStateCopyWith<_$_AccountViewModelState> get copyWith =>
      __$$_AccountViewModelStateCopyWithImpl<_$_AccountViewModelState>(
          this, _$identity);
}

abstract class _AccountViewModelState implements AccountViewModelState {
  const factory _AccountViewModelState(
          {final bool isBusy, required final feedback_dto.Feedback feedback}) =
      _$_AccountViewModelState;

  @override
  bool get isBusy;
  @override
  feedback_dto.Feedback get feedback;
  @override
  @JsonKey(ignore: true)
  _$$_AccountViewModelStateCopyWith<_$_AccountViewModelState> get copyWith =>
      throw _privateConstructorUsedError;
}
