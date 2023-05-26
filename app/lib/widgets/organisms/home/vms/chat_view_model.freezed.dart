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
  List<String> get selectedMemberIds => throw _privateConstructorUsedError;
  StreamChannelListController? get messageListController =>
      throw _privateConstructorUsedError;
  StreamMemberListController? get memberListController =>
      throw _privateConstructorUsedError;
  String get conversationSearchText => throw _privateConstructorUsedError;
  String get peopleSearchText => throw _privateConstructorUsedError;
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
      {List<String> selectedMemberIds,
      StreamChannelListController? messageListController,
      StreamMemberListController? memberListController,
      String conversationSearchText,
      String peopleSearchText,
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
    Object? selectedMemberIds = null,
    Object? messageListController = freezed,
    Object? memberListController = freezed,
    Object? conversationSearchText = null,
    Object? peopleSearchText = null,
    Object? currentChannel = freezed,
    Object? lastRelationshipsUpdated = freezed,
  }) {
    return _then(_value.copyWith(
      selectedMemberIds: null == selectedMemberIds
          ? _value.selectedMemberIds
          : selectedMemberIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      messageListController: freezed == messageListController
          ? _value.messageListController
          : messageListController // ignore: cast_nullable_to_non_nullable
              as StreamChannelListController?,
      memberListController: freezed == memberListController
          ? _value.memberListController
          : memberListController // ignore: cast_nullable_to_non_nullable
              as StreamMemberListController?,
      conversationSearchText: null == conversationSearchText
          ? _value.conversationSearchText
          : conversationSearchText // ignore: cast_nullable_to_non_nullable
              as String,
      peopleSearchText: null == peopleSearchText
          ? _value.peopleSearchText
          : peopleSearchText // ignore: cast_nullable_to_non_nullable
              as String,
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
      {List<String> selectedMemberIds,
      StreamChannelListController? messageListController,
      StreamMemberListController? memberListController,
      String conversationSearchText,
      String peopleSearchText,
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
    Object? selectedMemberIds = null,
    Object? messageListController = freezed,
    Object? memberListController = freezed,
    Object? conversationSearchText = null,
    Object? peopleSearchText = null,
    Object? currentChannel = freezed,
    Object? lastRelationshipsUpdated = freezed,
  }) {
    return _then(_$_ChatViewModelState(
      selectedMemberIds: null == selectedMemberIds
          ? _value._selectedMemberIds
          : selectedMemberIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      messageListController: freezed == messageListController
          ? _value.messageListController
          : messageListController // ignore: cast_nullable_to_non_nullable
              as StreamChannelListController?,
      memberListController: freezed == memberListController
          ? _value.memberListController
          : memberListController // ignore: cast_nullable_to_non_nullable
              as StreamMemberListController?,
      conversationSearchText: null == conversationSearchText
          ? _value.conversationSearchText
          : conversationSearchText // ignore: cast_nullable_to_non_nullable
              as String,
      peopleSearchText: null == peopleSearchText
          ? _value.peopleSearchText
          : peopleSearchText // ignore: cast_nullable_to_non_nullable
              as String,
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
      {final List<String> selectedMemberIds = const <String>[],
      this.messageListController,
      this.memberListController,
      this.conversationSearchText = '',
      this.peopleSearchText = '',
      this.currentChannel,
      this.lastRelationshipsUpdated})
      : _selectedMemberIds = selectedMemberIds;

  final List<String> _selectedMemberIds;
  @override
  @JsonKey()
  List<String> get selectedMemberIds {
    if (_selectedMemberIds is EqualUnmodifiableListView)
      return _selectedMemberIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedMemberIds);
  }

  @override
  final StreamChannelListController? messageListController;
  @override
  final StreamMemberListController? memberListController;
  @override
  @JsonKey()
  final String conversationSearchText;
  @override
  @JsonKey()
  final String peopleSearchText;
  @override
  final Channel? currentChannel;
  @override
  final DateTime? lastRelationshipsUpdated;

  @override
  String toString() {
    return 'ChatViewModelState(selectedMemberIds: $selectedMemberIds, messageListController: $messageListController, memberListController: $memberListController, conversationSearchText: $conversationSearchText, peopleSearchText: $peopleSearchText, currentChannel: $currentChannel, lastRelationshipsUpdated: $lastRelationshipsUpdated)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ChatViewModelState &&
            const DeepCollectionEquality()
                .equals(other._selectedMemberIds, _selectedMemberIds) &&
            (identical(other.messageListController, messageListController) ||
                other.messageListController == messageListController) &&
            (identical(other.memberListController, memberListController) ||
                other.memberListController == memberListController) &&
            (identical(other.conversationSearchText, conversationSearchText) ||
                other.conversationSearchText == conversationSearchText) &&
            (identical(other.peopleSearchText, peopleSearchText) ||
                other.peopleSearchText == peopleSearchText) &&
            (identical(other.currentChannel, currentChannel) ||
                other.currentChannel == currentChannel) &&
            (identical(
                    other.lastRelationshipsUpdated, lastRelationshipsUpdated) ||
                other.lastRelationshipsUpdated == lastRelationshipsUpdated));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_selectedMemberIds),
      messageListController,
      memberListController,
      conversationSearchText,
      peopleSearchText,
      currentChannel,
      lastRelationshipsUpdated);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ChatViewModelStateCopyWith<_$_ChatViewModelState> get copyWith =>
      __$$_ChatViewModelStateCopyWithImpl<_$_ChatViewModelState>(
          this, _$identity);
}

abstract class _ChatViewModelState implements ChatViewModelState {
  const factory _ChatViewModelState(
      {final List<String> selectedMemberIds,
      final StreamChannelListController? messageListController,
      final StreamMemberListController? memberListController,
      final String conversationSearchText,
      final String peopleSearchText,
      final Channel? currentChannel,
      final DateTime? lastRelationshipsUpdated}) = _$_ChatViewModelState;

  @override
  List<String> get selectedMemberIds;
  @override
  StreamChannelListController? get messageListController;
  @override
  StreamMemberListController? get memberListController;
  @override
  String get conversationSearchText;
  @override
  String get peopleSearchText;
  @override
  Channel? get currentChannel;
  @override
  DateTime? get lastRelationshipsUpdated;
  @override
  @JsonKey(ignore: true)
  _$$_ChatViewModelStateCopyWith<_$_ChatViewModelState> get copyWith =>
      throw _privateConstructorUsedError;
}
