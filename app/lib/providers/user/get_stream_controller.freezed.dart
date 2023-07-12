// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_stream_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$GetStreamControllerState {
  bool get isBusy => throw _privateConstructorUsedError;
  bool get hasFetchedChannels => throw _privateConstructorUsedError;
  List<Channel> get conversationChannels => throw _privateConstructorUsedError;
  List<Channel> get conversationChannelsWithMessages =>
      throw _privateConstructorUsedError;
  List<Member> get conversationMembers => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GetStreamControllerStateCopyWith<GetStreamControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetStreamControllerStateCopyWith<$Res> {
  factory $GetStreamControllerStateCopyWith(GetStreamControllerState value,
          $Res Function(GetStreamControllerState) then) =
      _$GetStreamControllerStateCopyWithImpl<$Res, GetStreamControllerState>;
  @useResult
  $Res call(
      {bool isBusy,
      bool hasFetchedChannels,
      List<Channel> conversationChannels,
      List<Channel> conversationChannelsWithMessages,
      List<Member> conversationMembers});
}

/// @nodoc
class _$GetStreamControllerStateCopyWithImpl<$Res,
        $Val extends GetStreamControllerState>
    implements $GetStreamControllerStateCopyWith<$Res> {
  _$GetStreamControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
    Object? hasFetchedChannels = null,
    Object? conversationChannels = null,
    Object? conversationChannelsWithMessages = null,
    Object? conversationMembers = null,
  }) {
    return _then(_value.copyWith(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      hasFetchedChannels: null == hasFetchedChannels
          ? _value.hasFetchedChannels
          : hasFetchedChannels // ignore: cast_nullable_to_non_nullable
              as bool,
      conversationChannels: null == conversationChannels
          ? _value.conversationChannels
          : conversationChannels // ignore: cast_nullable_to_non_nullable
              as List<Channel>,
      conversationChannelsWithMessages: null == conversationChannelsWithMessages
          ? _value.conversationChannelsWithMessages
          : conversationChannelsWithMessages // ignore: cast_nullable_to_non_nullable
              as List<Channel>,
      conversationMembers: null == conversationMembers
          ? _value.conversationMembers
          : conversationMembers // ignore: cast_nullable_to_non_nullable
              as List<Member>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_GetStreamControllerStateCopyWith<$Res>
    implements $GetStreamControllerStateCopyWith<$Res> {
  factory _$$_GetStreamControllerStateCopyWith(
          _$_GetStreamControllerState value,
          $Res Function(_$_GetStreamControllerState) then) =
      __$$_GetStreamControllerStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isBusy,
      bool hasFetchedChannels,
      List<Channel> conversationChannels,
      List<Channel> conversationChannelsWithMessages,
      List<Member> conversationMembers});
}

/// @nodoc
class __$$_GetStreamControllerStateCopyWithImpl<$Res>
    extends _$GetStreamControllerStateCopyWithImpl<$Res,
        _$_GetStreamControllerState>
    implements _$$_GetStreamControllerStateCopyWith<$Res> {
  __$$_GetStreamControllerStateCopyWithImpl(_$_GetStreamControllerState _value,
      $Res Function(_$_GetStreamControllerState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isBusy = null,
    Object? hasFetchedChannels = null,
    Object? conversationChannels = null,
    Object? conversationChannelsWithMessages = null,
    Object? conversationMembers = null,
  }) {
    return _then(_$_GetStreamControllerState(
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      hasFetchedChannels: null == hasFetchedChannels
          ? _value.hasFetchedChannels
          : hasFetchedChannels // ignore: cast_nullable_to_non_nullable
              as bool,
      conversationChannels: null == conversationChannels
          ? _value._conversationChannels
          : conversationChannels // ignore: cast_nullable_to_non_nullable
              as List<Channel>,
      conversationChannelsWithMessages: null == conversationChannelsWithMessages
          ? _value._conversationChannelsWithMessages
          : conversationChannelsWithMessages // ignore: cast_nullable_to_non_nullable
              as List<Channel>,
      conversationMembers: null == conversationMembers
          ? _value._conversationMembers
          : conversationMembers // ignore: cast_nullable_to_non_nullable
              as List<Member>,
    ));
  }
}

/// @nodoc

class _$_GetStreamControllerState implements _GetStreamControllerState {
  const _$_GetStreamControllerState(
      {this.isBusy = false,
      this.hasFetchedChannels = false,
      final List<Channel> conversationChannels = const [],
      final List<Channel> conversationChannelsWithMessages = const [],
      final List<Member> conversationMembers = const []})
      : _conversationChannels = conversationChannels,
        _conversationChannelsWithMessages = conversationChannelsWithMessages,
        _conversationMembers = conversationMembers;

  @override
  @JsonKey()
  final bool isBusy;
  @override
  @JsonKey()
  final bool hasFetchedChannels;
  final List<Channel> _conversationChannels;
  @override
  @JsonKey()
  List<Channel> get conversationChannels {
    if (_conversationChannels is EqualUnmodifiableListView)
      return _conversationChannels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_conversationChannels);
  }

  final List<Channel> _conversationChannelsWithMessages;
  @override
  @JsonKey()
  List<Channel> get conversationChannelsWithMessages {
    if (_conversationChannelsWithMessages is EqualUnmodifiableListView)
      return _conversationChannelsWithMessages;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_conversationChannelsWithMessages);
  }

  final List<Member> _conversationMembers;
  @override
  @JsonKey()
  List<Member> get conversationMembers {
    if (_conversationMembers is EqualUnmodifiableListView)
      return _conversationMembers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_conversationMembers);
  }

  @override
  String toString() {
    return 'GetStreamControllerState(isBusy: $isBusy, hasFetchedChannels: $hasFetchedChannels, conversationChannels: $conversationChannels, conversationChannelsWithMessages: $conversationChannelsWithMessages, conversationMembers: $conversationMembers)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GetStreamControllerState &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy) &&
            (identical(other.hasFetchedChannels, hasFetchedChannels) ||
                other.hasFetchedChannels == hasFetchedChannels) &&
            const DeepCollectionEquality()
                .equals(other._conversationChannels, _conversationChannels) &&
            const DeepCollectionEquality().equals(
                other._conversationChannelsWithMessages,
                _conversationChannelsWithMessages) &&
            const DeepCollectionEquality()
                .equals(other._conversationMembers, _conversationMembers));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isBusy,
      hasFetchedChannels,
      const DeepCollectionEquality().hash(_conversationChannels),
      const DeepCollectionEquality().hash(_conversationChannelsWithMessages),
      const DeepCollectionEquality().hash(_conversationMembers));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GetStreamControllerStateCopyWith<_$_GetStreamControllerState>
      get copyWith => __$$_GetStreamControllerStateCopyWithImpl<
          _$_GetStreamControllerState>(this, _$identity);
}

abstract class _GetStreamControllerState implements GetStreamControllerState {
  const factory _GetStreamControllerState(
      {final bool isBusy,
      final bool hasFetchedChannels,
      final List<Channel> conversationChannels,
      final List<Channel> conversationChannelsWithMessages,
      final List<Member> conversationMembers}) = _$_GetStreamControllerState;

  @override
  bool get isBusy;
  @override
  bool get hasFetchedChannels;
  @override
  List<Channel> get conversationChannels;
  @override
  List<Channel> get conversationChannelsWithMessages;
  @override
  List<Member> get conversationMembers;
  @override
  @JsonKey(ignore: true)
  _$$_GetStreamControllerStateCopyWith<_$_GetStreamControllerState>
      get copyWith => throw _privateConstructorUsedError;
}
