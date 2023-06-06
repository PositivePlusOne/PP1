// Package imports:

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
    @Default([]) List<ContentBuilder> guidancePageContentStack,
    @Default(false) bool isBusy,
    @Default(null) GuidanceSection? guidanceSection,
  }) = _GuidanceControllerState;

  factory GuidanceControllerState.initialState() => const GuidanceControllerState();
}

@Riverpod(keepAlive: true)
class GuidanceController extends _$GuidanceController {
  @override
  GuidanceControllerState build() {
    return GuidanceControllerState.initialState();
  }

  bool get shouldShowAppBar => state.guidancePageContentStack.isEmpty;

  GuidanceSection? get guidanceSection => state.guidanceSection;

  Future<bool> onWillPopScope() async {
    final AppRouter router = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    if (state.guidancePageContentStack.isNotEmpty) {
      logger.i("Popping guidance content");
      state = state.copyWith(guidancePageContentStack: List.of(state.guidancePageContentStack)..removeLast());
      return false;
    }

    logger.i("Popping guidance page");
    router.removeWhere((route) => true);
    router.push(const HomeRoute());
    return false;
  }

  void selectGuidanceSection(GuidanceSection gs) => state = state.copyWith(guidanceSection: gs);

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
      state = state.copyWith(
        guidancePageContentStack: [
          ...state.guidancePageContentStack,
          catContent,
        ],
      );
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> loadArticles(GuidanceCategory gc) async {
    try {
      state = state.copyWith(isBusy: true);
      final queryMap = {
        'locale': 'en',
        'parent': gc.documentId,
      };
      final res = await ref.read(firebaseFunctionsProvider).httpsCallable('guidance-getGuidanceArticles').call(queryMap);
      final arts = GuidanceArticle.decodeGuidanceArticleList(res.data);
      state = state.copyWith(
        guidancePageContentStack: [
          ...state.guidancePageContentStack,
          GuidanceArticleListBuilder(gc.title, arts),
        ],
      );
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  void pushGuidanceArticle(GuidanceArticle ga) {
    final builder = GuidanceArticleContentBuilder(ga);
    final newStack = [
      ...state.guidancePageContentStack,
      builder,
    ];
    state = state.copyWith(guidancePageContentStack: newStack);
  }

  Future<void> loadDirectoryEntries() async {
    try {
      state = state.copyWith(isBusy: true);
      final res = await ref.read(firebaseFunctionsProvider).httpsCallable('guidance-getGuidanceDirectoryEntries').call();
      final entries = GuidanceDirectoryEntry.decodeGuidanceArticleList(res.data);
      state = state.copyWith(
        guidancePageContentStack: [
          ...state.guidancePageContentStack,
          GuidanceDirectoryEntryListBuilder(entries),
        ],
      );
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  void pushGuidanceDirectoryEntry(GuidanceDirectoryEntry gde) {
    final builder = GuidanceDirectoryEntryContentBuilder(gde);
    final newStack = [
      ...state.guidancePageContentStack,
      builder,
    ];
    state = state.copyWith(guidancePageContentStack: newStack);
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

  Future<void> searchGuidance(String term) => _searchGuidance(term, "guidance");

  Future<void> searchAppHelp(String term) => _searchGuidance(term, "appHelp");

  Future<void> _searchGuidance(String term, String guidanceType) async {
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

      final content = GuidanceSearchResultsBuilder(categories, articles);

      state = state.copyWith(
        guidancePageContentStack: [
          ...state.guidancePageContentStack,
          content,
        ],
      );
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> searchDirectory(String term) async {
    try {
      state = state.copyWith(isBusy: true);

      final Algolia algolia = await ref.read(algoliaProvider.future);

      final directoryIndex = algolia.instance.index('guidanceDirectoryEntries');

      //! Put in pagination later, when we can absorb the cost better
      final query = directoryIndex.query(term);
      final directorySnap = await query.getObjects();
      final directoryEntries = GuidanceDirectoryEntry.listFromAlgoliaSnap(directorySnap.hits);

      final content = GuidanceDirectoryEntryListBuilder(directoryEntries);

      state = state.copyWith(
        guidancePageContentStack: [
          ...state.guidancePageContentStack,
          content,
        ],
      );
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }
}
