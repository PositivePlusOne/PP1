// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/guidance/guidance_category.dart';
import 'package:app/widgets/organisms/guidance/builders/guidance_cateogry_builder.dart';
import '../../dtos/database/guidance/guidance_article.dart';
import '../../services/third_party.dart';
import '../../widgets/organisms/guidance/builders/builder.dart';
import '../../widgets/organisms/guidance/builders/guidance_article_builder.dart';

part 'guidance_controller.freezed.dart';
part 'guidance_controller.g.dart';

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

  Future<void> loadGuidanceCategories(GuidanceCategory? gc) async {
    state = state.copyWith(isBusy: true);
    try {
      final logger = ref.read(loggerProvider);
      final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
      Map<String, dynamic> queryMap = {
        'locale': 'en',
        'parent': gc?.documentId,
      };

      final HttpsCallableResult res = await firebaseFunctions.httpsCallable('guidance-getGuidanceCategories').call(queryMap);
      logger.d(res.data);
      final cats = GuidanceCategory.decodeGuidanceCategoryList(res.data);
      final parentName = gc == null ? "Guidance" : gc.title;
      final catContent = GuidanceCategoryListBuilder(parentName, cats);
      // if there are some articles which are parented directly to a category, then we can get those here and concat them with the sub cats
      final newStack = [...state.guidancePageContentStack, catContent];
      state = state.copyWith(guidancePageContentStack: newStack);
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> loadArticles(GuidanceCategory gc) async {
    state = state.copyWith(isBusy: true);
    try {
      final logger = ref.read(loggerProvider);
      final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
      Map<String, dynamic> queryMap = {
        'locale': 'en',
        'parent': gc.documentId,
      };

      final HttpsCallableResult res = await firebaseFunctions.httpsCallable('guidance-getGuidanceArticles').call(queryMap);
      logger.d(res.data);
      final arts = GuidanceArticle.decodeGuidanceArticleList(res.data);
      final artListBuilder = GuidanceArticleListBuilder(gc.title, arts);
      final newStack = [...state.guidancePageContentStack, artListBuilder];
      state = state.copyWith(guidancePageContentStack: newStack);
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

  Future<void> popGuidanceContent() async {
    if (state.guidancePageContentStack.isNotEmpty) {
      final newStack = [...state.guidancePageContentStack];
      newStack.removeLast();
      state = state.copyWith(guidancePageContentStack: newStack);
    }
  }
}
