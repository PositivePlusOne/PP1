// Package imports:
import 'package:algolia/algolia.dart';
import 'package:app/constants/search_constants.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import '../../../../hooks/lifecycle_hook.dart';
import '../../../../services/third_party.dart';

part 'search_view_model.freezed.dart';
part 'search_view_model.g.dart';

@freezed
class SearchViewModelState with _$SearchViewModelState {
  const factory SearchViewModelState({
    @Default('') String searchQuery,
    @Default([]) List<Map<String, dynamic>> searchResults,
    @Default(false) bool isSearching,
    Object? currentError,
  }) = _SearchViewModelState;

  factory SearchViewModelState.initialState() => const SearchViewModelState();
}

@riverpod
class SearchViewModel extends _$SearchViewModel with LifecycleMixin {
  @override
  SearchViewModelState build() {
    return SearchViewModelState.initialState();
  }

  Future<void> onSearchSubmitted(String term) async {
    final Logger logger = ref.read(loggerProvider);
    final Algolia algolia = ref.read(algoliaProvider);

    logger.i('Searching for $term');
    state = state.copyWith(searchResults: [], currentError: false);

    if (term.trim().isEmpty) {
      return;
    }

    state = state.copyWith(isSearching: true);

    try {
      final AlgoliaQuery query = algolia.instance.index(kSearchDefaultIndex).query(term);
      final AlgoliaQuerySnapshot snapshot = await query.getObjects();
      logger.d('Search results: ${snapshot.hits}');
      state = state.copyWith(searchResults: snapshot.hits.map((e) => e.data).toList());
    } catch (ex) {
      logger.e('Error searching for $term', ex);
      state = state.copyWith(currentError: ex);
    } finally {
      state = state.copyWith(isSearching: false);
    }
  }
}
