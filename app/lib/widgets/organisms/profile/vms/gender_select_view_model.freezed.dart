// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gender_select_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GenderSelectState {
  String? get searchQuery => throw _privateConstructorUsedError;
  List<GenderOption> get options => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GenderSelectStateCopyWith<GenderSelectState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GenderSelectStateCopyWith<$Res> {
  factory $GenderSelectStateCopyWith(
          GenderSelectState value, $Res Function(GenderSelectState) then) =
      _$GenderSelectStateCopyWithImpl<$Res, GenderSelectState>;
  @useResult
  $Res call({String? searchQuery, List<GenderOption> options});
}

/// @nodoc
class _$GenderSelectStateCopyWithImpl<$Res, $Val extends GenderSelectState>
    implements $GenderSelectStateCopyWith<$Res> {
  _$GenderSelectStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchQuery = freezed,
    Object? options = null,
  }) {
    return _then(_value.copyWith(
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      options: null == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<GenderOption>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GenderSelectStateImplCopyWith<$Res>
    implements $GenderSelectStateCopyWith<$Res> {
  factory _$$GenderSelectStateImplCopyWith(_$GenderSelectStateImpl value,
          $Res Function(_$GenderSelectStateImpl) then) =
      __$$GenderSelectStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? searchQuery, List<GenderOption> options});
}

/// @nodoc
class __$$GenderSelectStateImplCopyWithImpl<$Res>
    extends _$GenderSelectStateCopyWithImpl<$Res, _$GenderSelectStateImpl>
    implements _$$GenderSelectStateImplCopyWith<$Res> {
  __$$GenderSelectStateImplCopyWithImpl(_$GenderSelectStateImpl _value,
      $Res Function(_$GenderSelectStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchQuery = freezed,
    Object? options = null,
  }) {
    return _then(_$GenderSelectStateImpl(
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      options: null == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<GenderOption>,
    ));
  }
}

/// @nodoc

class _$GenderSelectStateImpl extends _GenderSelectState {
  const _$GenderSelectStateImpl(
      {this.searchQuery,
      final List<GenderOption> options = const <GenderOption>[]})
      : _options = options,
        super._();

  @override
  final String? searchQuery;
  final List<GenderOption> _options;
  @override
  @JsonKey()
  List<GenderOption> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  @override
  String toString() {
    return 'GenderSelectState(searchQuery: $searchQuery, options: $options)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GenderSelectStateImpl &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            const DeepCollectionEquality().equals(other._options, _options));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, searchQuery, const DeepCollectionEquality().hash(_options));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GenderSelectStateImplCopyWith<_$GenderSelectStateImpl> get copyWith =>
      __$$GenderSelectStateImplCopyWithImpl<_$GenderSelectStateImpl>(
          this, _$identity);
}

abstract class _GenderSelectState extends GenderSelectState {
  const factory _GenderSelectState(
      {final String? searchQuery,
      final List<GenderOption> options}) = _$GenderSelectStateImpl;
  const _GenderSelectState._() : super._();

  @override
  String? get searchQuery;
  @override
  List<GenderOption> get options;
  @override
  @JsonKey(ignore: true)
  _$$GenderSelectStateImplCopyWith<_$GenderSelectStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
