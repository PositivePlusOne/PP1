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
// Chat List Properties
  DateTime? get lastRelationshipsUpdated => throw _privateConstructorUsedError;
  DateTime? get lastChannelsUpdated => throw _privateConstructorUsedError;
  String get searchQuery =>
      throw _privateConstructorUsedError; // Current Conversation Properties
  DateTime? get currentChannelLastUpdated => throw _privateConstructorUsedError;
  Channel? get currentChannel => throw _privateConstructorUsedError;
  ChannelExtraData? get currentChannelExtraData =>
      throw _privateConstructorUsedError;
  List<String> get selectedMembers => throw _privateConstructorUsedError;
  bool get isBusy => throw _privateConstructorUsedError;

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
      String searchQuery,
      DateTime? currentChannelLastUpdated,
      Channel? currentChannel,
      ChannelExtraData? currentChannelExtraData,
      List<String> selectedMembers,
      bool isBusy});

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
    Object? searchQuery = null,
    Object? currentChannelLastUpdated = freezed,
    Object? currentChannel = freezed,
    Object? currentChannelExtraData = freezed,
    Object? selectedMembers = null,
    Object? isBusy = null,
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
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      currentChannelLastUpdated: freezed == currentChannelLastUpdated
          ? _value.currentChannelLastUpdated
          : currentChannelLastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      currentChannel: freezed == currentChannel
          ? _value.currentChannel
          : currentChannel // ignore: cast_nullable_to_non_nullable
              as Channel?,
      currentChannelExtraData: freezed == currentChannelExtraData
          ? _value.currentChannelExtraData
          : currentChannelExtraData // ignore: cast_nullable_to_non_nullable
              as ChannelExtraData?,
      selectedMembers: null == selectedMembers
          ? _value.selectedMembers
          : selectedMembers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
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
abstract class _$$ChatViewModelStateImplCopyWith<$Res>
    implements $ChatViewModelStateCopyWith<$Res> {
  factory _$$ChatViewModelStateImplCopyWith(_$ChatViewModelStateImpl value,
          $Res Function(_$ChatViewModelStateImpl) then) =
      __$$ChatViewModelStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime? lastRelationshipsUpdated,
      DateTime? lastChannelsUpdated,
      String searchQuery,
      DateTime? currentChannelLastUpdated,
      Channel? currentChannel,
      ChannelExtraData? currentChannelExtraData,
      List<String> selectedMembers,
      bool isBusy});

  @override
  $ChannelExtraDataCopyWith<$Res>? get currentChannelExtraData;
}

/// @nodoc
class __$$ChatViewModelStateImplCopyWithImpl<$Res>
    extends _$ChatViewModelStateCopyWithImpl<$Res, _$ChatViewModelStateImpl>
    implements _$$ChatViewModelStateImplCopyWith<$Res> {
  __$$ChatViewModelStateImplCopyWithImpl(_$ChatViewModelStateImpl _value,
      $Res Function(_$ChatViewModelStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lastRelationshipsUpdated = freezed,
    Object? lastChannelsUpdated = freezed,
    Object? searchQuery = null,
    Object? currentChannelLastUpdated = freezed,
    Object? currentChannel = freezed,
    Object? currentChannelExtraData = freezed,
    Object? selectedMembers = null,
    Object? isBusy = null,
  }) {
    return _then(_$ChatViewModelStateImpl(
      lastRelationshipsUpdated: freezed == lastRelationshipsUpdated
          ? _value.lastRelationshipsUpdated
          : lastRelationshipsUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastChannelsUpdated: freezed == lastChannelsUpdated
          ? _value.lastChannelsUpdated
          : lastChannelsUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      currentChannelLastUpdated: freezed == currentChannelLastUpdated
          ? _value.currentChannelLastUpdated
          : currentChannelLastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      currentChannel: freezed == currentChannel
          ? _value.currentChannel
          : currentChannel // ignore: cast_nullable_to_non_nullable
              as Channel?,
      currentChannelExtraData: freezed == currentChannelExtraData
          ? _value.currentChannelExtraData
          : currentChannelExtraData // ignore: cast_nullable_to_non_nullable
              as ChannelExtraData?,
      selectedMembers: null == selectedMembers
          ? _value._selectedMembers
          : selectedMembers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$ChatViewModelStateImpl implements _ChatViewModelState {
  const _$ChatViewModelStateImpl(
      {this.lastRelationshipsUpdated,
      this.lastChannelsUpdated,
      this.searchQuery = '',
      this.currentChannelLastUpdated,
      this.currentChannel,
      this.currentChannelExtraData,
      final List<String> selectedMembers = const <String>[],
      this.isBusy = false})
      : _selectedMembers = selectedMembers;

// Chat List Properties
  @override
  final DateTime? lastRelationshipsUpdated;
  @override
  final DateTime? lastChannelsUpdated;
  @override
  @JsonKey()
  final String searchQuery;
// Current Conversation Properties
  @override
  final DateTime? currentChannelLastUpdated;
  @override
  final Channel? currentChannel;
  @override
  final ChannelExtraData? currentChannelExtraData;
  final List<String> _selectedMembers;
  @override
  @JsonKey()
  List<String> get selectedMembers {
    if (_selectedMembers is EqualUnmodifiableListView) return _selectedMembers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedMembers);
  }

  @override
  @JsonKey()
  final bool isBusy;

  @override
  String toString() {
    return 'ChatViewModelState(lastRelationshipsUpdated: $lastRelationshipsUpdated, lastChannelsUpdated: $lastChannelsUpdated, searchQuery: $searchQuery, currentChannelLastUpdated: $currentChannelLastUpdated, currentChannel: $currentChannel, currentChannelExtraData: $currentChannelExtraData, selectedMembers: $selectedMembers, isBusy: $isBusy)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChatViewModelStateImpl &&
            (identical(
                    other.lastRelationshipsUpdated, lastRelationshipsUpdated) ||
                other.lastRelationshipsUpdated == lastRelationshipsUpdated) &&
            (identical(other.lastChannelsUpdated, lastChannelsUpdated) ||
                other.lastChannelsUpdated == lastChannelsUpdated) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.currentChannelLastUpdated,
                    currentChannelLastUpdated) ||
                other.currentChannelLastUpdated == currentChannelLastUpdated) &&
            (identical(other.currentChannel, currentChannel) ||
                other.currentChannel == currentChannel) &&
            (identical(
                    other.currentChannelExtraData, currentChannelExtraData) ||
                other.currentChannelExtraData == currentChannelExtraData) &&
            const DeepCollectionEquality()
                .equals(other._selectedMembers, _selectedMembers) &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      lastRelationshipsUpdated,
      lastChannelsUpdated,
      searchQuery,
      currentChannelLastUpdated,
      currentChannel,
      currentChannelExtraData,
      const DeepCollectionEquality().hash(_selectedMembers),
      isBusy);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChatViewModelStateImplCopyWith<_$ChatViewModelStateImpl> get copyWith =>
      __$$ChatViewModelStateImplCopyWithImpl<_$ChatViewModelStateImpl>(
          this, _$identity);
}

abstract class _ChatViewModelState implements ChatViewModelState {
  const factory _ChatViewModelState(
      {final DateTime? lastRelationshipsUpdated,
      final DateTime? lastChannelsUpdated,
      final String searchQuery,
      final DateTime? currentChannelLastUpdated,
      final Channel? currentChannel,
      final ChannelExtraData? currentChannelExtraData,
      final List<String> selectedMembers,
      final bool isBusy}) = _$ChatViewModelStateImpl;

  @override // Chat List Properties
  DateTime? get lastRelationshipsUpdated;
  @override
  DateTime? get lastChannelsUpdated;
  @override
  String get searchQuery;
  @override // Current Conversation Properties
  DateTime? get currentChannelLastUpdated;
  @override
  Channel? get currentChannel;
  @override
  ChannelExtraData? get currentChannelExtraData;
  @override
  List<String> get selectedMembers;
  @override
  bool get isBusy;
  @override
  @JsonKey(ignore: true)
  _$$ChatViewModelStateImplCopyWith<_$ChatViewModelStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
