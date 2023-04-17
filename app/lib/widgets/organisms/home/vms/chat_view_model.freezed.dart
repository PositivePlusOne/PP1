// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ChatViewModelState {
  PositiveChatListController? get messageListController =>
      throw _privateConstructorUsedError;
  PositiveChatListController? get allUsersListController =>
      throw _privateConstructorUsedError;
  Channel? get currentChannel => throw _privateConstructorUsedError;
  DateTime? get lastRelationshipsUpdated => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ChatViewModelStateCopyWith<ChatViewModelState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChatViewModelStateCopyWith<$Res> {
  factory $ChatViewModelStateCopyWith(
          ChatViewModelState value, $Res Function(ChatViewModelState) then) =
      _$ChatViewModelStateCopyWithImpl<$Res, ChatViewModelState>;
  @useResult
  $Res call(
      {PositiveChatListController? messageListController,
      PositiveChatListController? allUsersListController,
      Channel? currentChannel,
      DateTime? lastRelationshipsUpdated});
}

/// @nodoc
class _$ChatViewModelStateCopyWithImpl<$Res, $Val extends ChatViewModelState>
    implements $ChatViewModelStateCopyWith<$Res> {
  _$ChatViewModelStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messageListController = freezed,
    Object? allUsersListController = freezed,
    Object? currentChannel = freezed,
    Object? lastRelationshipsUpdated = freezed,
  }) {
    return _then(_value.copyWith(
      messageListController: freezed == messageListController
          ? _value.messageListController
          : messageListController // ignore: cast_nullable_to_non_nullable
              as PositiveChatListController?,
      allUsersListController: freezed == allUsersListController
          ? _value.allUsersListController
          : allUsersListController // ignore: cast_nullable_to_non_nullable
              as PositiveChatListController?,
      currentChannel: freezed == currentChannel
          ? _value.currentChannel
          : currentChannel // ignore: cast_nullable_to_non_nullable
              as Channel?,
      lastRelationshipsUpdated: freezed == lastRelationshipsUpdated
          ? _value.lastRelationshipsUpdated
          : lastRelationshipsUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_ChatViewModelStateCopyWith<$Res>
    implements $ChatViewModelStateCopyWith<$Res> {
  factory _$$_ChatViewModelStateCopyWith(_$_ChatViewModelState value,
          $Res Function(_$_ChatViewModelState) then) =
      __$$_ChatViewModelStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {PositiveChatListController? messageListController,
      PositiveChatListController? allUsersListController,
      Channel? currentChannel,
      DateTime? lastRelationshipsUpdated});
}

/// @nodoc
class __$$_ChatViewModelStateCopyWithImpl<$Res>
    extends _$ChatViewModelStateCopyWithImpl<$Res, _$_ChatViewModelState>
    implements _$$_ChatViewModelStateCopyWith<$Res> {
  __$$_ChatViewModelStateCopyWithImpl(
      _$_ChatViewModelState _value, $Res Function(_$_ChatViewModelState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messageListController = freezed,
    Object? allUsersListController = freezed,
    Object? currentChannel = freezed,
    Object? lastRelationshipsUpdated = freezed,
  }) {
    return _then(_$_ChatViewModelState(
      messageListController: freezed == messageListController
          ? _value.messageListController
          : messageListController // ignore: cast_nullable_to_non_nullable
              as PositiveChatListController?,
      allUsersListController: freezed == allUsersListController
          ? _value.allUsersListController
          : allUsersListController // ignore: cast_nullable_to_non_nullable
              as PositiveChatListController?,
      currentChannel: freezed == currentChannel
          ? _value.currentChannel
          : currentChannel // ignore: cast_nullable_to_non_nullable
              as Channel?,
      lastRelationshipsUpdated: freezed == lastRelationshipsUpdated
          ? _value.lastRelationshipsUpdated
          : lastRelationshipsUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$_ChatViewModelState implements _ChatViewModelState {
  const _$_ChatViewModelState(
      {this.messageListController,
      this.allUsersListController,
      this.currentChannel,
      this.lastRelationshipsUpdated});

  @override
  final PositiveChatListController? messageListController;
  @override
  final PositiveChatListController? allUsersListController;
  @override
  final Channel? currentChannel;
  @override
  final DateTime? lastRelationshipsUpdated;

  @override
  String toString() {
    return 'ChatViewModelState(messageListController: $messageListController, allUsersListController: $allUsersListController, currentChannel: $currentChannel, lastRelationshipsUpdated: $lastRelationshipsUpdated)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ChatViewModelState &&
            (identical(other.messageListController, messageListController) ||
                other.messageListController == messageListController) &&
            (identical(other.allUsersListController, allUsersListController) ||
                other.allUsersListController == allUsersListController) &&
            (identical(other.currentChannel, currentChannel) ||
                other.currentChannel == currentChannel) &&
            (identical(
                    other.lastRelationshipsUpdated, lastRelationshipsUpdated) ||
                other.lastRelationshipsUpdated == lastRelationshipsUpdated));
  }

  @override
  int get hashCode => Object.hash(runtimeType, messageListController,
      allUsersListController, currentChannel, lastRelationshipsUpdated);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ChatViewModelStateCopyWith<_$_ChatViewModelState> get copyWith =>
      __$$_ChatViewModelStateCopyWithImpl<_$_ChatViewModelState>(
          this, _$identity);
}

abstract class _ChatViewModelState implements ChatViewModelState {
  const factory _ChatViewModelState(
      {final PositiveChatListController? messageListController,
      final PositiveChatListController? allUsersListController,
      final Channel? currentChannel,
      final DateTime? lastRelationshipsUpdated}) = _$_ChatViewModelState;

  @override
  PositiveChatListController? get messageListController;
  @override
  PositiveChatListController? get allUsersListController;
  @override
  Channel? get currentChannel;
  @override
  DateTime? get lastRelationshipsUpdated;
  @override
  @JsonKey(ignore: true)
  _$$_ChatViewModelStateCopyWith<_$_ChatViewModelState> get copyWith =>
      throw _privateConstructorUsedError;
}
