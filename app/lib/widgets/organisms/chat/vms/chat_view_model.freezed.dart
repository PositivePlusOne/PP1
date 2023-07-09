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
// TODO(ryan): These need to be excluded from chat eventually for performance reasons
// Chat List Properties
  DateTime? get lastRelationshipsUpdated => throw _privateConstructorUsedError;
  DateTime? get lastChannelsUpdated => throw _privateConstructorUsedError;
  String get chatMemberSearchQuery =>
      throw _privateConstructorUsedError; // Current Conversation Properties
  DateTime? get lastChannelUpdated => throw _privateConstructorUsedError;
  Channel? get currentChannel => throw _privateConstructorUsedError;
  ChannelExtraData? get currentChannelExtraData =>
      throw _privateConstructorUsedError;
  List<String> get currentChannelSelectedMembers =>
      throw _privateConstructorUsedError;
  String get currentChannelSearchQuery => throw _privateConstructorUsedError;

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
      {DateTime? lastRelationshipsUpdated,
      DateTime? lastChannelsUpdated,
      String chatMemberSearchQuery,
      DateTime? lastChannelUpdated,
      Channel? currentChannel,
      ChannelExtraData? currentChannelExtraData,
      List<String> currentChannelSelectedMembers,
      String currentChannelSearchQuery});

  $ChannelExtraDataCopyWith<$Res>? get currentChannelExtraData;
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
    Object? lastRelationshipsUpdated = freezed,
    Object? lastChannelsUpdated = freezed,
    Object? chatMemberSearchQuery = null,
    Object? lastChannelUpdated = freezed,
    Object? currentChannel = freezed,
    Object? currentChannelExtraData = freezed,
    Object? currentChannelSelectedMembers = null,
    Object? currentChannelSearchQuery = null,
  }) {
    return _then(_value.copyWith(
      lastRelationshipsUpdated: freezed == lastRelationshipsUpdated
          ? _value.lastRelationshipsUpdated
          : lastRelationshipsUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastChannelsUpdated: freezed == lastChannelsUpdated
          ? _value.lastChannelsUpdated
          : lastChannelsUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      chatMemberSearchQuery: null == chatMemberSearchQuery
          ? _value.chatMemberSearchQuery
          : chatMemberSearchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      lastChannelUpdated: freezed == lastChannelUpdated
          ? _value.lastChannelUpdated
          : lastChannelUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      currentChannel: freezed == currentChannel
          ? _value.currentChannel
          : currentChannel // ignore: cast_nullable_to_non_nullable
              as Channel?,
      currentChannelExtraData: freezed == currentChannelExtraData
          ? _value.currentChannelExtraData
          : currentChannelExtraData // ignore: cast_nullable_to_non_nullable
              as ChannelExtraData?,
      currentChannelSelectedMembers: null == currentChannelSelectedMembers
          ? _value.currentChannelSelectedMembers
          : currentChannelSelectedMembers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      currentChannelSearchQuery: null == currentChannelSearchQuery
          ? _value.currentChannelSearchQuery
          : currentChannelSearchQuery // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ChannelExtraDataCopyWith<$Res>? get currentChannelExtraData {
    if (_value.currentChannelExtraData == null) {
      return null;
    }

    return $ChannelExtraDataCopyWith<$Res>(_value.currentChannelExtraData!,
        (value) {
      return _then(_value.copyWith(currentChannelExtraData: value) as $Val);
    });
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
      {DateTime? lastRelationshipsUpdated,
      DateTime? lastChannelsUpdated,
      String chatMemberSearchQuery,
      DateTime? lastChannelUpdated,
      Channel? currentChannel,
      ChannelExtraData? currentChannelExtraData,
      List<String> currentChannelSelectedMembers,
      String currentChannelSearchQuery});

  @override
  $ChannelExtraDataCopyWith<$Res>? get currentChannelExtraData;
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
    Object? lastRelationshipsUpdated = freezed,
    Object? lastChannelsUpdated = freezed,
    Object? chatMemberSearchQuery = null,
    Object? lastChannelUpdated = freezed,
    Object? currentChannel = freezed,
    Object? currentChannelExtraData = freezed,
    Object? currentChannelSelectedMembers = null,
    Object? currentChannelSearchQuery = null,
  }) {
    return _then(_$_ChatViewModelState(
      lastRelationshipsUpdated: freezed == lastRelationshipsUpdated
          ? _value.lastRelationshipsUpdated
          : lastRelationshipsUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastChannelsUpdated: freezed == lastChannelsUpdated
          ? _value.lastChannelsUpdated
          : lastChannelsUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      chatMemberSearchQuery: null == chatMemberSearchQuery
          ? _value.chatMemberSearchQuery
          : chatMemberSearchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      lastChannelUpdated: freezed == lastChannelUpdated
          ? _value.lastChannelUpdated
          : lastChannelUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      currentChannel: freezed == currentChannel
          ? _value.currentChannel
          : currentChannel // ignore: cast_nullable_to_non_nullable
              as Channel?,
      currentChannelExtraData: freezed == currentChannelExtraData
          ? _value.currentChannelExtraData
          : currentChannelExtraData // ignore: cast_nullable_to_non_nullable
              as ChannelExtraData?,
      currentChannelSelectedMembers: null == currentChannelSelectedMembers
          ? _value._currentChannelSelectedMembers
          : currentChannelSelectedMembers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      currentChannelSearchQuery: null == currentChannelSearchQuery
          ? _value.currentChannelSearchQuery
          : currentChannelSearchQuery // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_ChatViewModelState implements _ChatViewModelState {
  const _$_ChatViewModelState(
      {this.lastRelationshipsUpdated,
      this.lastChannelsUpdated,
      this.chatMemberSearchQuery = '',
      this.lastChannelUpdated,
      this.currentChannel,
      this.currentChannelExtraData,
      final List<String> currentChannelSelectedMembers = const <String>[],
      this.currentChannelSearchQuery = ''})
      : _currentChannelSelectedMembers = currentChannelSelectedMembers;

// TODO(ryan): These need to be excluded from chat eventually for performance reasons
// Chat List Properties
  @override
  final DateTime? lastRelationshipsUpdated;
  @override
  final DateTime? lastChannelsUpdated;
  @override
  @JsonKey()
  final String chatMemberSearchQuery;
// Current Conversation Properties
  @override
  final DateTime? lastChannelUpdated;
  @override
  final Channel? currentChannel;
  @override
  final ChannelExtraData? currentChannelExtraData;
  final List<String> _currentChannelSelectedMembers;
  @override
  @JsonKey()
  List<String> get currentChannelSelectedMembers {
    if (_currentChannelSelectedMembers is EqualUnmodifiableListView)
      return _currentChannelSelectedMembers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_currentChannelSelectedMembers);
  }

  @override
  @JsonKey()
  final String currentChannelSearchQuery;

  @override
  String toString() {
    return 'ChatViewModelState(lastRelationshipsUpdated: $lastRelationshipsUpdated, lastChannelsUpdated: $lastChannelsUpdated, chatMemberSearchQuery: $chatMemberSearchQuery, lastChannelUpdated: $lastChannelUpdated, currentChannel: $currentChannel, currentChannelExtraData: $currentChannelExtraData, currentChannelSelectedMembers: $currentChannelSelectedMembers, currentChannelSearchQuery: $currentChannelSearchQuery)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ChatViewModelState &&
            (identical(
                    other.lastRelationshipsUpdated, lastRelationshipsUpdated) ||
                other.lastRelationshipsUpdated == lastRelationshipsUpdated) &&
            (identical(other.lastChannelsUpdated, lastChannelsUpdated) ||
                other.lastChannelsUpdated == lastChannelsUpdated) &&
            (identical(other.chatMemberSearchQuery, chatMemberSearchQuery) ||
                other.chatMemberSearchQuery == chatMemberSearchQuery) &&
            (identical(other.lastChannelUpdated, lastChannelUpdated) ||
                other.lastChannelUpdated == lastChannelUpdated) &&
            (identical(other.currentChannel, currentChannel) ||
                other.currentChannel == currentChannel) &&
            (identical(
                    other.currentChannelExtraData, currentChannelExtraData) ||
                other.currentChannelExtraData == currentChannelExtraData) &&
            const DeepCollectionEquality().equals(
                other._currentChannelSelectedMembers,
                _currentChannelSelectedMembers) &&
            (identical(other.currentChannelSearchQuery,
                    currentChannelSearchQuery) ||
                other.currentChannelSearchQuery == currentChannelSearchQuery));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      lastRelationshipsUpdated,
      lastChannelsUpdated,
      chatMemberSearchQuery,
      lastChannelUpdated,
      currentChannel,
      currentChannelExtraData,
      const DeepCollectionEquality().hash(_currentChannelSelectedMembers),
      currentChannelSearchQuery);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ChatViewModelStateCopyWith<_$_ChatViewModelState> get copyWith =>
      __$$_ChatViewModelStateCopyWithImpl<_$_ChatViewModelState>(
          this, _$identity);
}

abstract class _ChatViewModelState implements ChatViewModelState {
  const factory _ChatViewModelState(
      {final DateTime? lastRelationshipsUpdated,
      final DateTime? lastChannelsUpdated,
      final String chatMemberSearchQuery,
      final DateTime? lastChannelUpdated,
      final Channel? currentChannel,
      final ChannelExtraData? currentChannelExtraData,
      final List<String> currentChannelSelectedMembers,
      final String currentChannelSearchQuery}) = _$_ChatViewModelState;

  @override // TODO(ryan): These need to be excluded from chat eventually for performance reasons
// Chat List Properties
  DateTime? get lastRelationshipsUpdated;
  @override
  DateTime? get lastChannelsUpdated;
  @override
  String get chatMemberSearchQuery;
  @override // Current Conversation Properties
  DateTime? get lastChannelUpdated;
  @override
  Channel? get currentChannel;
  @override
  ChannelExtraData? get currentChannelExtraData;
  @override
  List<String> get currentChannelSelectedMembers;
  @override
  String get currentChannelSearchQuery;
  @override
  @JsonKey(ignore: true)
  _$$_ChatViewModelStateCopyWith<_$_ChatViewModelState> get copyWith =>
      throw _privateConstructorUsedError;
}
