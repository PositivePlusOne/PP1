// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:algolia/algolia.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/guidance/guidance_category.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/widgets/organisms/guidance/builders/guidance_article_builder.dart';
import 'package:app/widgets/organisms/guidance/builders/guidance_category_builder.dart';
import '../../dtos/database/guidance/guidance_article.dart';
import '../../dtos/database/guidance/guidance_directory_entry.dart';
import '../../services/third_party.dart';
import '../../widgets/organisms/guidance/guidance_search_results.dart';

part 'guidance_controller.freezed.dart';
part 'guidance_controller.g.dart';

typedef GuidanceCategoryCallback = void Function(GuidanceCategory);

enum GuidanceSection { guidance, directory, appHelp }

@freezed
class GuidanceControllerState with _$GuidanceControllerState {
  const factory GuidanceControllerState({
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

  GuidanceSection? get guidanceSection => state.guidanceSection;

  AppRouter get router => ref.read(appRouterProvider);

  void selectGuidanceSection(GuidanceSection gs) {
    state = state.copyWith(guidanceSection: gs);
  }

  void selectDirectorySection() {
    final AppRouter router = ref.read(appRouterProvider);

    state = state.copyWith(guidanceSection: GuidanceSection.directory);
    router.push(const GuidanceDirectoryRoute());
  }

  void guidanceCategoryCallback(GuidanceCategory gc) {
    if (guidanceSection == GuidanceSection.guidance) {
      loadGuidanceCategories(gc);
      return;
    }

    loadAppHelpCategories(gc);
  }

  Future<void> loadGuidanceCategories(GuidanceCategory? parent) {
    return loadCategories(parent, 'guidance');
  }

  Future<void> loadAppHelpCategories(GuidanceCategory? parent) {
    return loadCategories(parent, 'appHelp');
  }

  String buildCacheKey({
    GuidanceCategory? currentCategory,
    GuidanceArticle? currentArticle,
    GuidanceDirectoryEntry? currentDirectoryEntry,
    String? cursor,
    String? searchQuery,
  }) {
    return 'content-builder-$guidanceSection-${currentCategory?.flMeta?.id}-${currentArticle?.flMeta?.id}-${currentDirectoryEntry?.flMeta?.id}-$cursor-$searchQuery';
  }

  Future<void> loadCategories(GuidanceCategory? parent, String categoryType) async {
    final String cacheKey = buildCacheKey(currentCategory: parent);
    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);
    if (cacheController.containsInCache(cacheKey)) {
      await router.push(GuidanceEntryRoute(entryId: cacheKey));
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

      final catContent = GuidanceCategoryListBuilder(articles: arts, categories: cats, title: parent?.title, controller: this);

      cacheController.addToCache(key: cacheKey, value: catContent);
      state = state.copyWith(isBusy: false);
      await router.push(GuidanceEntryRoute(entryId: cacheKey));
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> Function(String, TextEditingController) get onSearch {
    switch (state.guidanceSection) {
      case GuidanceSection.guidance:
        return searchGuidance;
      case GuidanceSection.appHelp:
        return searchAppHelp;
      default:
        return (_, __) async {};
    }
  }

  Future<void> searchGuidance(String term, TextEditingController controller) => _searchGuidance(term, "guidance", controller);

  Future<void> searchAppHelp(String term, TextEditingController controller) => _searchGuidance(term, "appHelp", controller);

  Future<void> _searchGuidance(String term, String guidanceType, TextEditingController controller) async {
    if (term.trim().isEmpty) {
      return;
    }

    try {
      state = state.copyWith(isBusy: true);
      final CacheController cacheController = ref.read(cacheControllerProvider.notifier);
      final String cacheKey = buildCacheKey(searchQuery: term);
      if (cacheController.containsInCache(cacheKey)) {
        state = state.copyWith(isBusy: false);
        await router.push(GuidanceEntryRoute(entryId: cacheKey, searchTerm: term));
        return;
      }

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
      final resBuilder = GuidanceSearchResultsBuilder(categories, articles, this, state);

      cacheController.addToCache(key: cacheKey, value: resBuilder);
      state = state.copyWith(isBusy: false);
      controller.clear();

      await router.push(GuidanceEntryRoute(entryId: cacheKey, searchTerm: term));
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> pushGuidanceArticle(GuidanceArticle article) async {
    final String cacheKey = buildCacheKey(currentArticle: article);
    final CacheController cacheController = ref.read(cacheControllerProvider.notifier);
    final GuidanceArticleBuilder articleBuilder = GuidanceArticleBuilder(article: article, controller: this);
    cacheController.addToCache(key: cacheKey, value: articleBuilder);

    await router.push(GuidanceEntryRoute(entryId: cacheKey));
  }
}
