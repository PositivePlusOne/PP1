// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'company_sectors_select_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CompanySectorsSelectState {
  String? get searchQuery => throw _privateConstructorUsedError;
  List<CompanySectorsOption> get options => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $CompanySectorsSelectStateCopyWith<CompanySectorsSelectState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompanySectorsSelectStateCopyWith<$Res> {
  factory $CompanySectorsSelectStateCopyWith(CompanySectorsSelectState value,
          $Res Function(CompanySectorsSelectState) then) =
      _$CompanySectorsSelectStateCopyWithImpl<$Res, CompanySectorsSelectState>;
  @useResult
  $Res call({String? searchQuery, List<CompanySectorsOption> options});
}

/// @nodoc
class _$CompanySectorsSelectStateCopyWithImpl<$Res,
        $Val extends CompanySectorsSelectState>
    implements $CompanySectorsSelectStateCopyWith<$Res> {
  _$CompanySectorsSelectStateCopyWithImpl(this._value, this._then);

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
              as List<CompanySectorsOption>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CompanySectorsSelectStateImplCopyWith<$Res>
    implements $CompanySectorsSelectStateCopyWith<$Res> {
  factory _$$CompanySectorsSelectStateImplCopyWith(
          _$CompanySectorsSelectStateImpl value,
          $Res Function(_$CompanySectorsSelectStateImpl) then) =
      __$$CompanySectorsSelectStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? searchQuery, List<CompanySectorsOption> options});
}

/// @nodoc
class __$$CompanySectorsSelectStateImplCopyWithImpl<$Res>
    extends _$CompanySectorsSelectStateCopyWithImpl<$Res,
        _$CompanySectorsSelectStateImpl>
    implements _$$CompanySectorsSelectStateImplCopyWith<$Res> {
  __$$CompanySectorsSelectStateImplCopyWithImpl(
      _$CompanySectorsSelectStateImpl _value,
      $Res Function(_$CompanySectorsSelectStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchQuery = freezed,
    Object? options = null,
  }) {
    return _then(_$CompanySectorsSelectStateImpl(
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      options: null == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<CompanySectorsOption>,
    ));
  }
}

/// @nodoc

class _$CompanySectorsSelectStateImpl extends _CompanySectorsSelectState {
  const _$CompanySectorsSelectStateImpl(
      {this.searchQuery,
      final List<CompanySectorsOption> options =
          const <CompanySectorsOption>[]})
      : _options = options,
        super._();

  @override
  final String? searchQuery;
  final List<CompanySectorsOption> _options;
  @override
  @JsonKey()
  List<CompanySectorsOption> get options {
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_options);
  }

  @override
  String toString() {
    return 'CompanySectorsSelectState(searchQuery: $searchQuery, options: $options)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompanySectorsSelectStateImpl &&
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
  _$$CompanySectorsSelectStateImplCopyWith<_$CompanySectorsSelectStateImpl>
      get copyWith => __$$CompanySectorsSelectStateImplCopyWithImpl<
          _$CompanySectorsSelectStateImpl>(this, _$identity);
}

abstract class _CompanySectorsSelectState extends CompanySectorsSelectState {
  const factory _CompanySectorsSelectState(
          {final String? searchQuery,
          final List<CompanySectorsOption> options}) =
      _$CompanySectorsSelectStateImpl;
  const _CompanySectorsSelectState._() : super._();

  @override
  String? get searchQuery;
  @override
  List<CompanySectorsOption> get options;
  @override
  @JsonKey(ignore: true)
  _$$CompanySectorsSelectStateImplCopyWith<_$CompanySectorsSelectStateImpl>
      get copyWith => throw _privateConstructorUsedError;
}
