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
  StreamChatClient? get streamClient => throw _privateConstructorUsedError;

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
  $Res call({String streamToken, StreamChatClient? streamClient});
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
    Object? streamClient = freezed,
  }) {
    return _then(_value.copyWith(
      streamToken: null == streamToken
          ? _value.streamToken
          : streamToken // ignore: cast_nullable_to_non_nullable
              as String,
      streamClient: freezed == streamClient
          ? _value.streamClient
          : streamClient // ignore: cast_nullable_to_non_nullable
              as StreamChatClient?,
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
  $Res call({String streamToken, StreamChatClient? streamClient});
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
    Object? streamClient = freezed,
  }) {
    return _then(_$_MessagingControllerState(
      streamToken: null == streamToken
          ? _value.streamToken
          : streamToken // ignore: cast_nullable_to_non_nullable
              as String,
      streamClient: freezed == streamClient
          ? _value.streamClient
          : streamClient // ignore: cast_nullable_to_non_nullable
              as StreamChatClient?,
    ));
  }
}

/// @nodoc

class _$_MessagingControllerState implements _MessagingControllerState {
  const _$_MessagingControllerState({this.streamToken = '', this.streamClient});

  @override
  @JsonKey()
  final String streamToken;
  @override
  final StreamChatClient? streamClient;

  @override
  String toString() {
    return 'MessagingControllerState(streamToken: $streamToken, streamClient: $streamClient)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MessagingControllerState &&
            (identical(other.streamToken, streamToken) ||
                other.streamToken == streamToken) &&
            (identical(other.streamClient, streamClient) ||
                other.streamClient == streamClient));
  }

  @override
  int get hashCode => Object.hash(runtimeType, streamToken, streamClient);

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
      final StreamChatClient? streamClient}) = _$_MessagingControllerState;

  @override
  String get streamToken;
  @override
  StreamChatClient? get streamClient;
  @override
  @JsonKey(ignore: true)
  _$$_MessagingControllerStateCopyWith<_$_MessagingControllerState>
      get copyWith => throw _privateConstructorUsedError;
}
