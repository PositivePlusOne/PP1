// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'content_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ContentState _$ContentStateFromJson(Map<String, dynamic> json) {
  return _ContentState.fromJson(json);
}

/// @nodoc
mixin _$ContentState {
  List<RecommendedContent> get recommendedContent =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ContentStateCopyWith<ContentState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContentStateCopyWith<$Res> {
  factory $ContentStateCopyWith(
          ContentState value, $Res Function(ContentState) then) =
      _$ContentStateCopyWithImpl<$Res>;
  $Res call({List<RecommendedContent> recommendedContent});
}

/// @nodoc
class _$ContentStateCopyWithImpl<$Res> implements $ContentStateCopyWith<$Res> {
  _$ContentStateCopyWithImpl(this._value, this._then);

  final ContentState _value;
  // ignore: unused_field
  final $Res Function(ContentState) _then;

  @override
  $Res call({
    Object? recommendedContent = freezed,
  }) {
    return _then(_value.copyWith(
      recommendedContent: recommendedContent == freezed
          ? _value.recommendedContent
          : recommendedContent // ignore: cast_nullable_to_non_nullable
              as List<RecommendedContent>,
    ));
  }
}

/// @nodoc
abstract class _$$_ContentStateCopyWith<$Res>
    implements $ContentStateCopyWith<$Res> {
  factory _$$_ContentStateCopyWith(
          _$_ContentState value, $Res Function(_$_ContentState) then) =
      __$$_ContentStateCopyWithImpl<$Res>;
  @override
  $Res call({List<RecommendedContent> recommendedContent});
}

/// @nodoc
class __$$_ContentStateCopyWithImpl<$Res>
    extends _$ContentStateCopyWithImpl<$Res>
    implements _$$_ContentStateCopyWith<$Res> {
  __$$_ContentStateCopyWithImpl(
      _$_ContentState _value, $Res Function(_$_ContentState) _then)
      : super(_value, (v) => _then(v as _$_ContentState));

  @override
  _$_ContentState get _value => super._value as _$_ContentState;

  @override
  $Res call({
    Object? recommendedContent = freezed,
  }) {
    return _then(_$_ContentState(
      recommendedContent: recommendedContent == freezed
          ? _value._recommendedContent
          : recommendedContent // ignore: cast_nullable_to_non_nullable
              as List<RecommendedContent>,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$_ContentState implements _ContentState {
  const _$_ContentState(
      {required final List<RecommendedContent> recommendedContent})
      : _recommendedContent = recommendedContent;

  factory _$_ContentState.fromJson(Map<String, dynamic> json) =>
      _$$_ContentStateFromJson(json);

  final List<RecommendedContent> _recommendedContent;
  @override
  List<RecommendedContent> get recommendedContent {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendedContent);
  }

  @override
  String toString() {
    return 'ContentState(recommendedContent: $recommendedContent)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ContentState &&
            const DeepCollectionEquality()
                .equals(other._recommendedContent, _recommendedContent));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_recommendedContent));

  @JsonKey(ignore: true)
  @override
  _$$_ContentStateCopyWith<_$_ContentState> get copyWith =>
      __$$_ContentStateCopyWithImpl<_$_ContentState>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ContentStateToJson(
      this,
    );
  }
}

abstract class _ContentState implements ContentState {
  const factory _ContentState(
          {required final List<RecommendedContent> recommendedContent}) =
      _$_ContentState;

  factory _ContentState.fromJson(Map<String, dynamic> json) =
      _$_ContentState.fromJson;

  @override
  List<RecommendedContent> get recommendedContent;
  @override
  @JsonKey(ignore: true)
  _$$_ContentStateCopyWith<_$_ContentState> get copyWith =>
      throw _privateConstructorUsedError;
}
