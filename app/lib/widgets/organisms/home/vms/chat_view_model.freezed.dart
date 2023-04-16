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
  bool get isRefreshing => throw _privateConstructorUsedError;
  List<Channel> get availableChannels => throw _privateConstructorUsedError;

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
  $Res call({bool isRefreshing, List<Channel> availableChannels});
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
    Object? isRefreshing = null,
    Object? availableChannels = null,
  }) {
    return _then(_value.copyWith(
      isRefreshing: null == isRefreshing
          ? _value.isRefreshing
          : isRefreshing // ignore: cast_nullable_to_non_nullable
              as bool,
      availableChannels: null == availableChannels
          ? _value.availableChannels
          : availableChannels // ignore: cast_nullable_to_non_nullable
              as List<Channel>,
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
  $Res call({bool isRefreshing, List<Channel> availableChannels});
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
    Object? isRefreshing = null,
    Object? availableChannels = null,
  }) {
    return _then(_$_ChatViewModelState(
      isRefreshing: null == isRefreshing
          ? _value.isRefreshing
          : isRefreshing // ignore: cast_nullable_to_non_nullable
              as bool,
      availableChannels: null == availableChannels
          ? _value._availableChannels
          : availableChannels // ignore: cast_nullable_to_non_nullable
              as List<Channel>,
    ));
  }
}

/// @nodoc

class _$_ChatViewModelState implements _ChatViewModelState {
  const _$_ChatViewModelState(
      {this.isRefreshing = false,
      final List<Channel> availableChannels = const []})
      : _availableChannels = availableChannels;

  @override
  @JsonKey()
  final bool isRefreshing;
  final List<Channel> _availableChannels;
  @override
  @JsonKey()
  List<Channel> get availableChannels {
    if (_availableChannels is EqualUnmodifiableListView)
      return _availableChannels;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_availableChannels);
  }

  @override
  String toString() {
    return 'ChatViewModelState(isRefreshing: $isRefreshing, availableChannels: $availableChannels)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ChatViewModelState &&
            (identical(other.isRefreshing, isRefreshing) ||
                other.isRefreshing == isRefreshing) &&
            const DeepCollectionEquality()
                .equals(other._availableChannels, _availableChannels));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isRefreshing,
      const DeepCollectionEquality().hash(_availableChannels));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_ChatViewModelStateCopyWith<_$_ChatViewModelState> get copyWith =>
      __$$_ChatViewModelStateCopyWithImpl<_$_ChatViewModelState>(
          this, _$identity);
}

abstract class _ChatViewModelState implements ChatViewModelState {
  const factory _ChatViewModelState(
      {final bool isRefreshing,
      final List<Channel> availableChannels}) = _$_ChatViewModelState;

  @override
  bool get isRefreshing;
  @override
  List<Channel> get availableChannels;
  @override
  @JsonKey(ignore: true)
  _$$_ChatViewModelStateCopyWith<_$_ChatViewModelState> get copyWith =>
      throw _privateConstructorUsedError;
}
