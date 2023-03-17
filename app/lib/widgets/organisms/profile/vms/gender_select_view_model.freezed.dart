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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$GenderOption {
  String get label => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GenderOptionCopyWith<GenderOption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GenderOptionCopyWith<$Res> {
  factory $GenderOptionCopyWith(
          GenderOption value, $Res Function(GenderOption) then) =
      _$GenderOptionCopyWithImpl<$Res, GenderOption>;
  @useResult
  $Res call({String label, String id});
}

/// @nodoc
class _$GenderOptionCopyWithImpl<$Res, $Val extends GenderOption>
    implements $GenderOptionCopyWith<$Res> {
  _$GenderOptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? id = null,
  }) {
    return _then(_value.copyWith(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_GenderOptionCopyWith<$Res>
    implements $GenderOptionCopyWith<$Res> {
  factory _$$_GenderOptionCopyWith(
          _$_GenderOption value, $Res Function(_$_GenderOption) then) =
      __$$_GenderOptionCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String label, String id});
}

/// @nodoc
class __$$_GenderOptionCopyWithImpl<$Res>
    extends _$GenderOptionCopyWithImpl<$Res, _$_GenderOption>
    implements _$$_GenderOptionCopyWith<$Res> {
  __$$_GenderOptionCopyWithImpl(
      _$_GenderOption _value, $Res Function(_$_GenderOption) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? label = null,
    Object? id = null,
  }) {
    return _then(_$_GenderOption(
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_GenderOption implements _GenderOption {
  const _$_GenderOption({required this.label, required this.id});

  @override
  final String label;
  @override
  final String id;

  @override
  String toString() {
    return 'GenderOption(label: $label, id: $id)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GenderOption &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.id, id) || other.id == id));
  }

  @override
  int get hashCode => Object.hash(runtimeType, label, id);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GenderOptionCopyWith<_$_GenderOption> get copyWith =>
      __$$_GenderOptionCopyWithImpl<_$_GenderOption>(this, _$identity);
}

abstract class _GenderOption implements GenderOption {
  const factory _GenderOption(
      {required final String label,
      required final String id}) = _$_GenderOption;

  @override
  String get label;
  @override
  String get id;
  @override
  @JsonKey(ignore: true)
  _$$_GenderOptionCopyWith<_$_GenderOption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$GenderSelectState {
  String? get searchQuery => throw _privateConstructorUsedError;
  List<GenderOption>? get selectedOptions => throw _privateConstructorUsedError;
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
  $Res call(
      {String? searchQuery,
      List<GenderOption>? selectedOptions,
      List<GenderOption> options});
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
    Object? selectedOptions = freezed,
    Object? options = null,
  }) {
    return _then(_value.copyWith(
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedOptions: freezed == selectedOptions
          ? _value.selectedOptions
          : selectedOptions // ignore: cast_nullable_to_non_nullable
              as List<GenderOption>?,
      options: null == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<GenderOption>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_GenderSelectStateCopyWith<$Res>
    implements $GenderSelectStateCopyWith<$Res> {
  factory _$$_GenderSelectStateCopyWith(_$_GenderSelectState value,
          $Res Function(_$_GenderSelectState) then) =
      __$$_GenderSelectStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? searchQuery,
      List<GenderOption>? selectedOptions,
      List<GenderOption> options});
}

/// @nodoc
class __$$_GenderSelectStateCopyWithImpl<$Res>
    extends _$GenderSelectStateCopyWithImpl<$Res, _$_GenderSelectState>
    implements _$$_GenderSelectStateCopyWith<$Res> {
  __$$_GenderSelectStateCopyWithImpl(
      _$_GenderSelectState _value, $Res Function(_$_GenderSelectState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchQuery = freezed,
    Object? selectedOptions = freezed,
    Object? options = null,
  }) {
    return _then(_$_GenderSelectState(
      searchQuery: freezed == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String?,
      selectedOptions: freezed == selectedOptions
          ? _value._selectedOptions
          : selectedOptions // ignore: cast_nullable_to_non_nullable
              as List<GenderOption>?,
      options: null == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<GenderOption>,
    ));
  }
}

/// @nodoc

class _$_GenderSelectState implements _GenderSelectState {
  const _$_GenderSelectState(
      {this.searchQuery,
      final List<GenderOption>? selectedOptions,
      final List<GenderOption> options = const <GenderOption>[]})
      : _selectedOptions = selectedOptions,
        _options = options;

  @override
  final String? searchQuery;
  final List<GenderOption>? _selectedOptions;
  @override
  List<GenderOption>? get selectedOptions {
    final value = _selectedOptions;
    if (value == null) return null;
    if (_selectedOptions is EqualUnmodifiableListView) return _selectedOptions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

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
    return 'GenderSelectState(searchQuery: $searchQuery, selectedOptions: $selectedOptions, options: $options)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GenderSelectState &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            const DeepCollectionEquality()
                .equals(other._selectedOptions, _selectedOptions) &&
            const DeepCollectionEquality().equals(other._options, _options));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      searchQuery,
      const DeepCollectionEquality().hash(_selectedOptions),
      const DeepCollectionEquality().hash(_options));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_GenderSelectStateCopyWith<_$_GenderSelectState> get copyWith =>
      __$$_GenderSelectStateCopyWithImpl<_$_GenderSelectState>(
          this, _$identity);
}

abstract class _GenderSelectState implements GenderSelectState {
  const factory _GenderSelectState(
      {final String? searchQuery,
      final List<GenderOption>? selectedOptions,
      final List<GenderOption> options}) = _$_GenderSelectState;

  @override
  String? get searchQuery;
  @override
  List<GenderOption>? get selectedOptions;
  @override
  List<GenderOption> get options;
  @override
  @JsonKey(ignore: true)
  _$$_GenderSelectStateCopyWith<_$_GenderSelectState> get copyWith =>
      throw _privateConstructorUsedError;
}
