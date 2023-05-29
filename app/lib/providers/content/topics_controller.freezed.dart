// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'topics_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$TopicsControllerState {
  List<Topic> get topics => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TopicsControllerStateCopyWith<TopicsControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopicsControllerStateCopyWith<$Res> {
  factory $TopicsControllerStateCopyWith(TopicsControllerState value,
          $Res Function(TopicsControllerState) then) =
      _$TopicsControllerStateCopyWithImpl<$Res, TopicsControllerState>;
  @useResult
  $Res call({List<Topic> topics});
}

/// @nodoc
class _$TopicsControllerStateCopyWithImpl<$Res,
        $Val extends TopicsControllerState>
    implements $TopicsControllerStateCopyWith<$Res> {
  _$TopicsControllerStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topics = null,
  }) {
    return _then(_value.copyWith(
      topics: null == topics
          ? _value.topics
          : topics // ignore: cast_nullable_to_non_nullable
              as List<Topic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_TopicsControllerStateCopyWith<$Res>
    implements $TopicsControllerStateCopyWith<$Res> {
  factory _$$_TopicsControllerStateCopyWith(_$_TopicsControllerState value,
          $Res Function(_$_TopicsControllerState) then) =
      __$$_TopicsControllerStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Topic> topics});
}

/// @nodoc
class __$$_TopicsControllerStateCopyWithImpl<$Res>
    extends _$TopicsControllerStateCopyWithImpl<$Res, _$_TopicsControllerState>
    implements _$$_TopicsControllerStateCopyWith<$Res> {
  __$$_TopicsControllerStateCopyWithImpl(_$_TopicsControllerState _value,
      $Res Function(_$_TopicsControllerState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topics = null,
  }) {
    return _then(_$_TopicsControllerState(
      topics: null == topics
          ? _value._topics
          : topics // ignore: cast_nullable_to_non_nullable
              as List<Topic>,
    ));
  }
}

/// @nodoc

class _$_TopicsControllerState implements _TopicsControllerState {
  const _$_TopicsControllerState({final List<Topic> topics = const []})
      : _topics = topics;

  final List<Topic> _topics;
  @override
  @JsonKey()
  List<Topic> get topics {
    if (_topics is EqualUnmodifiableListView) return _topics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topics);
  }

  @override
  String toString() {
    return 'TopicsControllerState(topics: $topics)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TopicsControllerState &&
            const DeepCollectionEquality().equals(other._topics, _topics));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_topics));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TopicsControllerStateCopyWith<_$_TopicsControllerState> get copyWith =>
      __$$_TopicsControllerStateCopyWithImpl<_$_TopicsControllerState>(
          this, _$identity);
}

abstract class _TopicsControllerState implements TopicsControllerState {
  const factory _TopicsControllerState({final List<Topic> topics}) =
      _$_TopicsControllerState;

  @override
  List<Topic> get topics;
  @override
  @JsonKey(ignore: true)
  _$$_TopicsControllerStateCopyWith<_$_TopicsControllerState> get copyWith =>
      throw _privateConstructorUsedError;
}
