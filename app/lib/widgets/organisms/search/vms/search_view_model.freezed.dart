// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SearchViewModelState {
  String get searchQuery => throw _privateConstructorUsedError;
  List<Map<String, dynamic>> get searchResults =>
      throw _privateConstructorUsedError;
  bool get isSearching => throw _privateConstructorUsedError;
  Object? get currentError => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SearchViewModelStateCopyWith<SearchViewModelState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchViewModelStateCopyWith<$Res> {
  factory $SearchViewModelStateCopyWith(SearchViewModelState value,
          $Res Function(SearchViewModelState) then) =
      _$SearchViewModelStateCopyWithImpl<$Res, SearchViewModelState>;
  @useResult
  $Res call(
      {String searchQuery,
      List<Map<String, dynamic>> searchResults,
      bool isSearching,
      Object? currentError});
}

/// @nodoc
class _$SearchViewModelStateCopyWithImpl<$Res,
        $Val extends SearchViewModelState>
    implements $SearchViewModelStateCopyWith<$Res> {
  _$SearchViewModelStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchQuery = null,
    Object? searchResults = null,
    Object? isSearching = null,
    Object? currentError = freezed,
  }) {
    return _then(_value.copyWith(
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      searchResults: null == searchResults
          ? _value.searchResults
          : searchResults // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      isSearching: null == isSearching
          ? _value.isSearching
          : isSearching // ignore: cast_nullable_to_non_nullable
              as bool,
      currentError:
          freezed == currentError ? _value.currentError : currentError,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_SearchViewModelStateCopyWith<$Res>
    implements $SearchViewModelStateCopyWith<$Res> {
  factory _$$_SearchViewModelStateCopyWith(_$_SearchViewModelState value,
          $Res Function(_$_SearchViewModelState) then) =
      __$$_SearchViewModelStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String searchQuery,
      List<Map<String, dynamic>> searchResults,
      bool isSearching,
      Object? currentError});
}

/// @nodoc
class __$$_SearchViewModelStateCopyWithImpl<$Res>
    extends _$SearchViewModelStateCopyWithImpl<$Res, _$_SearchViewModelState>
    implements _$$_SearchViewModelStateCopyWith<$Res> {
  __$$_SearchViewModelStateCopyWithImpl(_$_SearchViewModelState _value,
      $Res Function(_$_SearchViewModelState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchQuery = null,
    Object? searchResults = null,
    Object? isSearching = null,
    Object? currentError = freezed,
  }) {
    return _then(_$_SearchViewModelState(
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      searchResults: null == searchResults
          ? _value._searchResults
          : searchResults // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
      isSearching: null == isSearching
          ? _value.isSearching
          : isSearching // ignore: cast_nullable_to_non_nullable
              as bool,
      currentError:
          freezed == currentError ? _value.currentError : currentError,
    ));
  }
}

/// @nodoc

class _$_SearchViewModelState implements _SearchViewModelState {
  const _$_SearchViewModelState(
      {this.searchQuery = '',
      final List<Map<String, dynamic>> searchResults = const [],
      this.isSearching = false,
      this.currentError})
      : _searchResults = searchResults;

  @override
  @JsonKey()
  final String searchQuery;
  final List<Map<String, dynamic>> _searchResults;
  @override
  @JsonKey()
  List<Map<String, dynamic>> get searchResults {
    if (_searchResults is EqualUnmodifiableListView) return _searchResults;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_searchResults);
  }

  @override
  @JsonKey()
  final bool isSearching;
  @override
  final Object? currentError;

  @override
  String toString() {
    return 'SearchViewModelState(searchQuery: $searchQuery, searchResults: $searchResults, isSearching: $isSearching, currentError: $currentError)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SearchViewModelState &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            const DeepCollectionEquality()
                .equals(other._searchResults, _searchResults) &&
            (identical(other.isSearching, isSearching) ||
                other.isSearching == isSearching) &&
            const DeepCollectionEquality()
                .equals(other.currentError, currentError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      searchQuery,
      const DeepCollectionEquality().hash(_searchResults),
      isSearching,
      const DeepCollectionEquality().hash(currentError));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_SearchViewModelStateCopyWith<_$_SearchViewModelState> get copyWith =>
      __$$_SearchViewModelStateCopyWithImpl<_$_SearchViewModelState>(
          this, _$identity);
}

abstract class _SearchViewModelState implements SearchViewModelState {
  const factory _SearchViewModelState(
      {final String searchQuery,
      final List<Map<String, dynamic>> searchResults,
      final bool isSearching,
      final Object? currentError}) = _$_SearchViewModelState;

  @override
  String get searchQuery;
  @override
  List<Map<String, dynamic>> get searchResults;
  @override
  bool get isSearching;
  @override
  Object? get currentError;
  @override
  @JsonKey(ignore: true)
  _$$_SearchViewModelStateCopyWith<_$_SearchViewModelState> get copyWith =>
      throw _privateConstructorUsedError;
}
