// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'zephyr_paginated_results.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ZephyrPaginatedResults _$ZephyrPaginatedResultsFromJson(
    Map<String, dynamic> json) {
  return _ZephyrPaginatedResults.fromJson(json);
}

/// @nodoc
mixin _$ZephyrPaginatedResults {
  String? get next => throw _privateConstructorUsedError;
  int get startAt => throw _privateConstructorUsedError;
  int get maxResults => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  bool get isLast => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get values => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ZephyrPaginatedResultsCopyWith<ZephyrPaginatedResults> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ZephyrPaginatedResultsCopyWith<$Res> {
  factory $ZephyrPaginatedResultsCopyWith(ZephyrPaginatedResults value,
          $Res Function(ZephyrPaginatedResults) then) =
      _$ZephyrPaginatedResultsCopyWithImpl<$Res>;
  $Res call(
      {String? next,
      int startAt,
      int maxResults,
      int total,
      bool isLast,
      List<Map<String, dynamic>> values});
}

/// @nodoc
class _$ZephyrPaginatedResultsCopyWithImpl<$Res>
    implements $ZephyrPaginatedResultsCopyWith<$Res> {
  _$ZephyrPaginatedResultsCopyWithImpl(this._value, this._then);

  final ZephyrPaginatedResults _value;
  // ignore: unused_field
  final $Res Function(ZephyrPaginatedResults) _then;

  @override
  $Res call({
    Object? next = freezed,
    Object? startAt = freezed,
    Object? maxResults = freezed,
    Object? total = freezed,
    Object? isLast = freezed,
    Object? values = freezed,
  }) {
    return _then(_value.copyWith(
      next: next == freezed
          ? _value.next
          : next // ignore: cast_nullable_to_non_nullable
              as String?,
      startAt: startAt == freezed
          ? _value.startAt
          : startAt // ignore: cast_nullable_to_non_nullable
              as int,
      maxResults: maxResults == freezed
          ? _value.maxResults
          : maxResults // ignore: cast_nullable_to_non_nullable
              as int,
      total: total == freezed
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      isLast: isLast == freezed
          ? _value.isLast
          : isLast // ignore: cast_nullable_to_non_nullable
              as bool,
      values: values == freezed
          ? _value.values
          : values // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
    ));
  }
}

/// @nodoc
abstract class _$$_ZephyrPaginatedResultsCopyWith<$Res>
    implements $ZephyrPaginatedResultsCopyWith<$Res> {
  factory _$$_ZephyrPaginatedResultsCopyWith(_$_ZephyrPaginatedResults value,
          $Res Function(_$_ZephyrPaginatedResults) then) =
      __$$_ZephyrPaginatedResultsCopyWithImpl<$Res>;
  @override
  $Res call(
      {String? next,
      int startAt,
      int maxResults,
      int total,
      bool isLast,
      List<Map<String, dynamic>> values});
}

/// @nodoc
class __$$_ZephyrPaginatedResultsCopyWithImpl<$Res>
    extends _$ZephyrPaginatedResultsCopyWithImpl<$Res>
    implements _$$_ZephyrPaginatedResultsCopyWith<$Res> {
  __$$_ZephyrPaginatedResultsCopyWithImpl(_$_ZephyrPaginatedResults _value,
      $Res Function(_$_ZephyrPaginatedResults) _then)
      : super(_value, (v) => _then(v as _$_ZephyrPaginatedResults));

  @override
  _$_ZephyrPaginatedResults get _value =>
      super._value as _$_ZephyrPaginatedResults;

  @override
  $Res call({
    Object? next = freezed,
    Object? startAt = freezed,
    Object? maxResults = freezed,
    Object? total = freezed,
    Object? isLast = freezed,
    Object? values = freezed,
  }) {
    return _then(_$_ZephyrPaginatedResults(
      next: next == freezed
          ? _value.next
          : next // ignore: cast_nullable_to_non_nullable
              as String?,
      startAt: startAt == freezed
          ? _value.startAt
          : startAt // ignore: cast_nullable_to_non_nullable
              as int,
      maxResults: maxResults == freezed
          ? _value.maxResults
          : maxResults // ignore: cast_nullable_to_non_nullable
              as int,
      total: total == freezed
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      isLast: isLast == freezed
          ? _value.isLast
          : isLast // ignore: cast_nullable_to_non_nullable
              as bool,
      values: values == freezed
          ? _value._values
          : values // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_ZephyrPaginatedResults implements _ZephyrPaginatedResults {
  const _$_ZephyrPaginatedResults(
      {this.next,
      this.startAt = 0,
      this.maxResults = 0,
      this.total = 0,
      this.isLast = true,
      final List<Map<String, dynamic>> values = const [<String, dynamic>{}]})
      : _values = values;

  factory _$_ZephyrPaginatedResults.fromJson(Map<String, dynamic> json) =>
      _$$_ZephyrPaginatedResultsFromJson(json);

  @override
  final String? next;
  @override
  @JsonKey()
  final int startAt;
  @override
  @JsonKey()
  final int maxResults;
  @override
  @JsonKey()
  final int total;
  @override
  @JsonKey()
  final bool isLast;
  final List<Map<String, dynamic>> _values;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get values {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_values);
  }

  @override
  String toString() {
    return 'ZephyrPaginatedResults(next: $next, startAt: $startAt, maxResults: $maxResults, total: $total, isLast: $isLast, values: $values)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_ZephyrPaginatedResults &&
            const DeepCollectionEquality().equals(other.next, next) &&
            const DeepCollectionEquality().equals(other.startAt, startAt) &&
            const DeepCollectionEquality()
                .equals(other.maxResults, maxResults) &&
            const DeepCollectionEquality().equals(other.total, total) &&
            const DeepCollectionEquality().equals(other.isLast, isLast) &&
            const DeepCollectionEquality().equals(other._values, _values));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(next),
      const DeepCollectionEquality().hash(startAt),
      const DeepCollectionEquality().hash(maxResults),
      const DeepCollectionEquality().hash(total),
      const DeepCollectionEquality().hash(isLast),
      const DeepCollectionEquality().hash(_values));

  @JsonKey(ignore: true)
  @override
  _$$_ZephyrPaginatedResultsCopyWith<_$_ZephyrPaginatedResults> get copyWith =>
      __$$_ZephyrPaginatedResultsCopyWithImpl<_$_ZephyrPaginatedResults>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ZephyrPaginatedResultsToJson(
      this,
    );
  }
}

abstract class _ZephyrPaginatedResults implements ZephyrPaginatedResults {
  const factory _ZephyrPaginatedResults(
      {final String? next,
      final int startAt,
      final int maxResults,
      final int total,
      final bool isLast,
      final List<Map<String, dynamic>> values}) = _$_ZephyrPaginatedResults;

  factory _ZephyrPaginatedResults.fromJson(Map<String, dynamic> json) =
      _$_ZephyrPaginatedResults.fromJson;

  @override
  String? get next;
  @override
  int get startAt;
  @override
  int get maxResults;
  @override
  int get total;
  @override
  bool get isLast;
  @override
  List<Map<String, dynamic>> get values;
  @override
  @JsonKey(ignore: true)
  _$$_ZephyrPaginatedResultsCopyWith<_$_ZephyrPaginatedResults> get copyWith =>
      throw _privateConstructorUsedError;
}
