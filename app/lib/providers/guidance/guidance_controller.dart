// Package imports:

// Package imports:
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

part 'guidance_controller.freezed.dart';
part 'guidance_controller.g.dart';

typedef GuidanceCategoryCallback = void Function(GuidanceCategory);

@freezed
class GuidanceControllerState with _$GuidanceControllerState {
  const factory GuidanceControllerState({
    @Default([]) List<ContentBuilder> guidancePageContentStack,
    @Default(false) bool isBusy,
  }) = _GuidanceControllerState;

  factory GuidanceControllerState.initialState() => const GuidanceControllerState();
}

@Riverpod(keepAlive: true)
class GuidanceController extends _$GuidanceController {
  @override
  GuidanceControllerState build() {
    return GuidanceControllerState.initialState();
  }

  bool get shouldShowBackButton => state.guidancePageContentStack.isNotEmpty;
  bool get shouldShowLogo => state.guidancePageContentStack.isEmpty;

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

  Future<void> loadGuidanceCategories(GuidanceCategory? gc) {
    void onTapCallback(GuidanceCategory gc) {
      if (gc.parent == null) {
        loadGuidanceCategories(gc);
      } else {
        loadArticles(gc);
      }
    }

    return loadCategories(gc, 'Guidance', 'guidance', onTapCallback);
  }

  Future<void> loadAppHelpCategories(GuidanceCategory? gc) {
    void onTapCallback(GuidanceCategory gc) {
      if (gc.parent == null) {
        loadAppHelpCategories(gc);
      } else {
        loadArticles(gc);
      }
    }

    return loadCategories(gc, 'App Help', 'appHelp', onTapCallback);
  }

  Future<void> loadCategories(GuidanceCategory? parent, String topLevelTitle, String categoryType, GuidanceCategoryCallback gcb) async {
    try {
      state = state.copyWith(isBusy: true);
      final queryMap = {
        'locale': 'en',
        'parent': parent?.documentId,
        'guidanceType': categoryType,
      };

      final res = await ref.read(firebaseFunctionsProvider).httpsCallable('guidance-getGuidanceCategories').call(queryMap);
      final cats = GuidanceCategory.decodeGuidanceCategoryList(res.data);
      final parentName = parent == null ? topLevelTitle : parent.title;
      final catContent = GuidanceCategoryListBuilder(parentName, cats, gcb);
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

  Future<void> pushGuidanceArticle(GuidanceArticle ga) async {
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

  Future<void> pushGuidanceDirectoryEntry(GuidanceDirectoryEntry gde) async {
    final builder = GuidanceDirectoryEntryContentBuilder(gde);
    final newStack = [
      ...state.guidancePageContentStack,
      builder,
    ];
    state = state.copyWith(guidancePageContentStack: newStack);
  }
}
