// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'messaging_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$MessagingControllerState {
  String get streamToken => throw _privateConstructorUsedError;
  bool get isBusy => throw _privateConstructorUsedError;
  Channel? get currentChannel => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MessagingControllerStateCopyWith<MessagingControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessagingControllerStateCopyWith<$Res> {
  factory $MessagingControllerStateCopyWith(MessagingControllerState value,
          $Res Function(MessagingControllerState) then) =
      _$MessagingControllerStateCopyWithImpl<$Res, MessagingControllerState>;
  @useResult
  $Res call({String streamToken, bool isBusy, Channel? currentChannel});
}

/// @nodoc
class _$MessagingControllerStateCopyWithImpl<$Res,
        $Val extends MessagingControllerState>
    implements $MessagingControllerStateCopyWith<$Res> {
  _$MessagingControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? streamToken = null,
    Object? isBusy = null,
    Object? currentChannel = freezed,
  }) {
    return _then(_value.copyWith(
      streamToken: null == streamToken
          ? _value.streamToken
          : streamToken // ignore: cast_nullable_to_non_nullable
              as String,
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      currentChannel: freezed == currentChannel
          ? _value.currentChannel
          : currentChannel // ignore: cast_nullable_to_non_nullable
              as Channel?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_MessagingControllerStateCopyWith<$Res>
    implements $MessagingControllerStateCopyWith<$Res> {
  factory _$$_MessagingControllerStateCopyWith(
          _$_MessagingControllerState value,
          $Res Function(_$_MessagingControllerState) then) =
      __$$_MessagingControllerStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String streamToken, bool isBusy, Channel? currentChannel});
}

/// @nodoc
class __$$_MessagingControllerStateCopyWithImpl<$Res>
    extends _$MessagingControllerStateCopyWithImpl<$Res,
        _$_MessagingControllerState>
    implements _$$_MessagingControllerStateCopyWith<$Res> {
  __$$_MessagingControllerStateCopyWithImpl(_$_MessagingControllerState _value,
      $Res Function(_$_MessagingControllerState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? streamToken = null,
    Object? isBusy = null,
    Object? currentChannel = freezed,
  }) {
    return _then(_$_MessagingControllerState(
      streamToken: null == streamToken
          ? _value.streamToken
          : streamToken // ignore: cast_nullable_to_non_nullable
              as String,
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      currentChannel: freezed == currentChannel
          ? _value.currentChannel
          : currentChannel // ignore: cast_nullable_to_non_nullable
              as Channel?,
    ));
  }
}

/// @nodoc

class _$_MessagingControllerState implements _MessagingControllerState {
  const _$_MessagingControllerState(
      {this.streamToken = '',
      this.isBusy = false,
      required this.currentChannel});

  @override
  @JsonKey()
  final String streamToken;
  @override
  @JsonKey()
  final bool isBusy;
  @override
  final Channel? currentChannel;

  @override
  String toString() {
    return 'MessagingControllerState(streamToken: $streamToken, isBusy: $isBusy, currentChannel: $currentChannel)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MessagingControllerState &&
            (identical(other.streamToken, streamToken) ||
                other.streamToken == streamToken) &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy) &&
            (identical(other.currentChannel, currentChannel) ||
                other.currentChannel == currentChannel));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, streamToken, isBusy, currentChannel);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MessagingControllerStateCopyWith<_$_MessagingControllerState>
      get copyWith => __$$_MessagingControllerStateCopyWithImpl<
          _$_MessagingControllerState>(this, _$identity);
}

abstract class _MessagingControllerState implements MessagingControllerState {
  const factory _MessagingControllerState(
      {final String streamToken,
      final bool isBusy,
      required final Channel? currentChannel}) = _$_MessagingControllerState;

  @override
  String get streamToken;
  @override
  bool get isBusy;
  @override
  Channel? get currentChannel;
  @override
  @JsonKey(ignore: true)
  _$$_MessagingControllerStateCopyWith<_$_MessagingControllerState>
      get copyWith => throw _privateConstructorUsedError;
}
