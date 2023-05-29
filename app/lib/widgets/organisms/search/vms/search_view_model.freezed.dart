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
  List<String> get searchProfileResults => throw _privateConstructorUsedError;
  bool get isBusy => throw _privateConstructorUsedError;
  bool get isSearching => throw _privateConstructorUsedError;
  bool get shouldDisplaySearchResults => throw _privateConstructorUsedError;
  int get currentTab => throw _privateConstructorUsedError;

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
      List<String> searchProfileResults,
      bool isBusy,
      bool isSearching,
      bool shouldDisplaySearchResults,
      int currentTab});
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
    Object? searchProfileResults = null,
    Object? isBusy = null,
    Object? isSearching = null,
    Object? shouldDisplaySearchResults = null,
    Object? currentTab = null,
  }) {
    return _then(_value.copyWith(
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      searchProfileResults: null == searchProfileResults
          ? _value.searchProfileResults
          : searchProfileResults // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      isSearching: null == isSearching
          ? _value.isSearching
          : isSearching // ignore: cast_nullable_to_non_nullable
              as bool,
      shouldDisplaySearchResults: null == shouldDisplaySearchResults
          ? _value.shouldDisplaySearchResults
          : shouldDisplaySearchResults // ignore: cast_nullable_to_non_nullable
              as bool,
      currentTab: null == currentTab
          ? _value.currentTab
          : currentTab // ignore: cast_nullable_to_non_nullable
              as int,
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
      List<String> searchProfileResults,
      bool isBusy,
      bool isSearching,
      bool shouldDisplaySearchResults,
      int currentTab});
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
    Object? searchProfileResults = null,
    Object? isBusy = null,
    Object? isSearching = null,
    Object? shouldDisplaySearchResults = null,
    Object? currentTab = null,
  }) {
    return _then(_$_SearchViewModelState(
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      searchProfileResults: null == searchProfileResults
          ? _value._searchProfileResults
          : searchProfileResults // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isBusy: null == isBusy
          ? _value.isBusy
          : isBusy // ignore: cast_nullable_to_non_nullable
              as bool,
      isSearching: null == isSearching
          ? _value.isSearching
          : isSearching // ignore: cast_nullable_to_non_nullable
              as bool,
      shouldDisplaySearchResults: null == shouldDisplaySearchResults
          ? _value.shouldDisplaySearchResults
          : shouldDisplaySearchResults // ignore: cast_nullable_to_non_nullable
              as bool,
      currentTab: null == currentTab
          ? _value.currentTab
          : currentTab // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$_SearchViewModelState implements _SearchViewModelState {
  const _$_SearchViewModelState(
      {this.searchQuery = '',
      final List<String> searchProfileResults = const [],
      this.isBusy = false,
      this.isSearching = false,
      this.shouldDisplaySearchResults = false,
      this.currentTab = 0})
      : _searchProfileResults = searchProfileResults;

  @override
  @JsonKey()
  final String searchQuery;
  final List<String> _searchProfileResults;
  @override
  @JsonKey()
  List<String> get searchProfileResults {
    if (_searchProfileResults is EqualUnmodifiableListView)
      return _searchProfileResults;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_searchProfileResults);
  }

  @override
  @JsonKey()
  final bool isBusy;
  @override
  @JsonKey()
  final bool isSearching;
  @override
  @JsonKey()
  final bool shouldDisplaySearchResults;
  @override
  @JsonKey()
  final int currentTab;

  @override
  String toString() {
    return 'SearchViewModelState(searchQuery: $searchQuery, searchProfileResults: $searchProfileResults, isBusy: $isBusy, isSearching: $isSearching, shouldDisplaySearchResults: $shouldDisplaySearchResults, currentTab: $currentTab)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_SearchViewModelState &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            const DeepCollectionEquality()
                .equals(other._searchProfileResults, _searchProfileResults) &&
            (identical(other.isBusy, isBusy) || other.isBusy == isBusy) &&
            (identical(other.isSearching, isSearching) ||
                other.isSearching == isSearching) &&
            (identical(other.shouldDisplaySearchResults,
                    shouldDisplaySearchResults) ||
                other.shouldDisplaySearchResults ==
                    shouldDisplaySearchResults) &&
            (identical(other.currentTab, currentTab) ||
                other.currentTab == currentTab));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      searchQuery,
      const DeepCollectionEquality().hash(_searchProfileResults),
      isBusy,
      isSearching,
      shouldDisplaySearchResults,
      currentTab);

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
      final List<String> searchProfileResults,
      final bool isBusy,
      final bool isSearching,
      final bool shouldDisplaySearchResults,
      final int currentTab}) = _$_SearchViewModelState;

  @override
  String get searchQuery;
  @override
  List<String> get searchProfileResults;
  @override
  bool get isBusy;
  @override
  bool get isSearching;
  @override
  bool get shouldDisplaySearchResults;
  @override
  int get currentTab;
  @override
  @JsonKey(ignore: true)
  _$$_SearchViewModelStateCopyWith<_$_SearchViewModelState> get copyWith =>
      throw _privateConstructorUsedError;
}
