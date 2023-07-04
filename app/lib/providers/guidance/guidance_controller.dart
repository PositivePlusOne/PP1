// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:algolia/algolia.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/guidance/guidance_category.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/widgets/organisms/guidance/builders/guidance_cateogry_builder.dart';
import '../../dtos/database/guidance/guidance_article.dart';
import '../../dtos/database/guidance/guidance_directory_entry.dart';
import '../../services/third_party.dart';
import '../../widgets/organisms/guidance/builders/builder.dart';
import '../../widgets/organisms/guidance/builders/guidance_article_builder.dart';
import '../../widgets/organisms/guidance/builders/guidance_entry_builder.dart';
import '../../widgets/organisms/guidance/guidance_search_results.dart';

part 'guidance_controller.freezed.dart';
part 'guidance_controller.g.dart';

typedef GuidanceCategoryCallback = void Function(GuidanceCategory);

enum GuidanceSection { guidance, directory, appHelp }

@freezed
class GuidanceControllerState with _$GuidanceControllerState {
  const factory GuidanceControllerState({
    @Default({}) Map<String, ContentBuilder> guidancePageBuilders,
    @Default(false) bool isBusy,
    @Default(null) GuidanceSection? guidanceSection,
    required TextEditingController searchController,
    @Default(false) bool isSearching,
    @Default(null) Timer? searchTimer,
  }) = _GuidanceControllerState;

  factory GuidanceControllerState.initialState({String initialText = ''}) => GuidanceControllerState(
        searchController: TextEditingController(text: initialText),
      );
}

@riverpod
class GuidanceController extends _$GuidanceController {
  @override
  GuidanceControllerState build() {
    return GuidanceControllerState.initialState();
  }

  GuidanceSection? get guidanceSection => state.guidanceSection;

  AppRouter get router => ref.read(appRouterProvider);

  bool get busy => state.isBusy;

  Future<bool> onWillPopScope() async {
    final AppRouter router = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);
    setIsSearching(false);

    logger.i("Popping guidance page");
    router.removeLast();

    return false;
  }

  void selectGuidanceSection(GuidanceSection gs) {
    state = state.copyWith(guidanceSection: gs);
    addSearchController(gs);
  }

  void addSearchController(GuidanceSection gs) {
    state.searchController?.dispose();
    final controller = TextEditingController();
    controller.addListener(() {
      // debounce search
      if (state.searchTimer != null) {
        state.searchTimer!.cancel();
      }

      state = state.copyWith(
        searchTimer: Timer(
          const Duration(milliseconds: 500),
          () {
            if (controller.text.trim().isEmpty) {
              return;
            }

            onSearch(controller.text);
          },
        ),
      );
    });

    state = state.copyWith(searchController: controller);
  }

  void guidanceCategoryCallback(GuidanceCategory gc) {
    if (gc.parent == null) {
      // was a top level cat so should load sub cats
      if (guidanceSection == GuidanceSection.guidance) {
        loadGuidanceCategories(gc);
        return;
      }
      loadAppHelpCategories(gc);
      return;
    }

    // was a sub cat so should load articles
    loadArticles(gc);
  }

  Future<void> loadGuidanceCategories(GuidanceCategory? parent) {
    return loadCategories(parent, 'guidance');
  }

  Future<void> loadAppHelpCategories(GuidanceCategory? parent) {
    return loadCategories(parent, 'appHelp');
  }

  Future<void> loadCategories(GuidanceCategory? parent, String categoryType) async {
    if (busy) {
      return;
    }

    try {
      state = state.copyWith(isBusy: true);
      final queryMap = {
        'locale': 'en',
        'parent': parent?.documentId,
        'guidanceType': categoryType,
      };

      final res = ref.read(firebaseFunctionsProvider).httpsCallable('guidance-getGuidanceCategories').call(queryMap);
      final res2 = ref.read(firebaseFunctionsProvider).httpsCallable('guidance-getGuidanceArticles').call(queryMap);

      final results = await Future.wait([res, res2]);

      final cats = GuidanceCategory.decodeGuidanceCategoryList(results[0].data);
      final arts = GuidanceArticle.decodeGuidanceArticleList(results[1].data);

      final catContent = GuidanceCategoryListBuilder(parent?.title, cats, arts);
      // if there are some articles which are parented directly to a category, then we can get those here and concat them with the sub cats;
      final builderKey = parent?.documentId ?? "topLevel";
      addBuilderToState(catContent, builderKey);
      if (state.isSearching) {
        // already have search results so replace them
        router.removeLast();
        state.searchController?.clear();
      }
      setIsSearching(false);
      router.push(
        GuidanceEntryRoute(entryId: builderKey),
      );
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  void addBuilderToState(ContentBuilder builder, String key) {
    final builders = {...state.guidancePageBuilders};
    builders[key] = builder;
    state = state.copyWith(
      guidancePageBuilders: builders,
    );
  }

  Future<void> loadArticles(GuidanceCategory gc) async {
    if (busy) {
      return;
    }

    try {
      state = state.copyWith(isBusy: true);
      final queryMap = {
        'locale': 'en',
        'parent': gc.documentId,
        'guidanceType': '',
      };

      final res = await ref.read(firebaseFunctionsProvider).httpsCallable('guidance-getGuidanceArticles').call(queryMap);
      final arts = GuidanceArticle.decodeGuidanceArticleList(res.data);
      final artListBuilder = GuidanceArticleListBuilder(gc.title, arts);
      final builderKey = gc.documentId;
      addBuilderToState(artListBuilder, builderKey);
      if (state.isSearching) {
        // already have search results so replace them
        router.removeLast();
        state.searchController?.clear();
      }
      setIsSearching(false);
      router.push(
        GuidanceEntryRoute(entryId: builderKey),
      );
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  void pushGuidanceArticle(GuidanceArticle ga) {
    if (busy) {
      return;
    }
    final artContentBuilder = GuidanceArticleContentBuilder(ga);
    final builderKey = ga.documentId;
    addBuilderToState(artContentBuilder, builderKey);
    router.push(GuidanceEntryRoute(entryId: builderKey));
  }

  Future<void> loadDirectoryEntries() async {
    if (busy) {
      return;
    }

    try {
      state = state.copyWith(isBusy: true);
      final res = await ref.read(firebaseFunctionsProvider).httpsCallable('guidance-getGuidanceDirectoryEntries').call();
      final entries = GuidanceDirectoryEntry.decodeGuidanceArticleList(res.data);
      final dirEntryListBuilder = GuidanceDirectoryEntryListBuilder(entries);
      const builderKey = "directoryEntries";
      addBuilderToState(dirEntryListBuilder, builderKey);
      if (state.isSearching) {
        // already have search results so replace them
        state.searchController?.clear();
        router.removeLast();
      }
      setIsSearching(false);
      router.push(GuidanceEntryRoute(entryId: builderKey));
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  void pushGuidanceDirectoryEntry(GuidanceDirectoryEntry gde) {
    if (busy) {
      return;
    }
    final dirEntryBuilder = GuidanceDirectoryEntryContentBuilder(gde);
    final builderKey = gde.documentId;
    addBuilderToState(dirEntryBuilder, builderKey);
    router.push(GuidanceEntryRoute(entryId: builderKey));
  }

  Future<void> Function(String) get onSearch {
    switch (state.guidanceSection) {
      case GuidanceSection.guidance:
        return searchGuidance;
      case GuidanceSection.directory:
        return searchDirectory;
      case GuidanceSection.appHelp:
        return searchAppHelp;
      default:
        return (_) async {};
    }
  }

  // setIsSearching indicates that a search results page is currently being displayed
  void setIsSearching(bool isSearching) {
    state = state.copyWith(isSearching: isSearching);
  }

  Future<void> searchGuidance(String term) => _searchGuidance(term, "guidance");

  Future<void> searchAppHelp(String term) => _searchGuidance(term, "appHelp");

  Future<void> _searchGuidance(String term, String guidanceType) async {
    if (!shouldSearch(term)) {
      return;
    }

    try {
      state = state.copyWith(isBusy: true);

      final Algolia algolia = await ref.read(algoliaProvider.future);

      final articleIndex = algolia.instance.index('guidanceArticles');
      final categoryIndex = algolia.instance.index('guidanceCategories');

      //! Put in pagination later, when we can absorb the cost better
      final articleQuery = articleIndex.query(term).filters('guidanceType:$guidanceType');
      final articleSnap = await articleQuery.getObjects();
      final articles = GuidanceArticle.listFromAlgoliaSnap(articleSnap.hits);

      final catQuery = categoryIndex.query(term).filters('guidanceType:"$guidanceType"');
      final categorySnap = await catQuery.getObjects();
      final categories = GuidanceCategory.listFromAlgoliaSnap(categorySnap.hits);

      final resBuilder = GuidanceSearchResultsBuilder(categories, articles);

      addBuilderToState(resBuilder, term);
      setIsSearching(true);
      router.push(GuidanceEntryRoute(entryId: term));
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> searchDirectory(String term) async {
    if (!shouldSearch(term)) {
      return;
    }

    try {
      state = state.copyWith(isBusy: true);

      final Algolia algolia = await ref.read(algoliaProvider.future);

      final directoryIndex = algolia.instance.index('guidanceDirectoryEntries');

      //! Put in pagination later, when we can absorb the cost better
      final query = directoryIndex.query(term);
      final directorySnap = await query.getObjects();
      final directoryEntries = GuidanceDirectoryEntry.listFromAlgoliaSnap(directorySnap.hits);

      final dirEntryListBuilder = GuidanceDirectoryEntryListBuilder(directoryEntries);
      addBuilderToState(dirEntryListBuilder, term);
      if (state.isSearching) {
        router.removeLast();
      }

      setIsSearching(true);
      router.push(GuidanceEntryRoute(entryId: term));
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  bool shouldSearch(String term) {
    if (busy) {
      return false;
    }

    if (term == state.previousSearchTerm) {
      return false;
    }

    if (term == "") {
      // if we get to this point then user was searching and has now cleared the search and so we need to pop the search results
      setIsSearching(false);
      state = state.copyWith(previousSearchTerm: term);
      router.removeLast();
      return false;
    }
    state = state.copyWith(previousSearchTerm: term);
    return true;
  }
}
