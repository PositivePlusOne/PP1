// Package imports:
import 'package:algolia/algolia.dart';
import 'package:app/constants/search_constants.dart';
import 'package:app/dtos/database/common/fl_meta.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import '../../../../dtos/database/user/user_profile.dart';
import '../../../../hooks/lifecycle_hook.dart';
import '../../../../services/third_party.dart';

part 'search_view_model.freezed.dart';
part 'search_view_model.g.dart';

@freezed
class SearchViewModelState with _$SearchViewModelState {
  const factory SearchViewModelState({
    @Default('') String searchQuery,
    @Default([]) List<UserProfile> searchProfileResults,
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
    final Algolia algolia = await ref.read(algoliaProvider.future);

    logger.i('Searching for $term');
    state = state.copyWith(searchProfileResults: [], currentError: false);

    if (term.trim().isEmpty) {
      return;
    }

    state = state.copyWith(isSearching: true);

    try {
      final AlgoliaQuery query = algolia.instance.index(kSearchDefaultIndex).query(term);
      final AlgoliaQuerySnapshot snapshot = await query.getObjects();
      logger.d('Search results: ${snapshot.hits}');

      for (final AlgoliaObjectSnapshot hit in snapshot.hits) {
        if (hit.data.containsKey('_fl_meta_')) {
          final FlMeta meta = FlMeta.fromJson(hit.data['_fl_meta_'] as Map<String, dynamic>);
          switch (meta.schema ?? '') {
            case 'users':
              state = state.copyWith(searchProfileResults: [...state.searchProfileResults, UserProfile.fromJson(hit.data)]);
              break;
            default:
              logger.w('Unknown search result type: $meta');
          }
        }
      }
    } catch (ex) {
      logger.e('Error searching for $term', ex);
      state = state.copyWith(currentError: ex);
    } finally {
      state = state.copyWith(isSearching: false);
    }
  }
}
