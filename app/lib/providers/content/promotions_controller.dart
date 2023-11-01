// Package imports:
import 'package:app/dtos/database/enrichment/promotions.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'promotions_controller.freezed.dart';
part 'promotions_controller.g.dart';

@freezed
class PromotionsControllerState with _$PromotionsControllerState {
  const factory PromotionsControllerState({
    @Default(0) int promotionIndex,
    @Default('') String cursor,
    @Default([]) List<String> promotionIds,
  }) = _PromotionsControllerState;
  factory PromotionsControllerState.initialState() => const PromotionsControllerState();
}

@Riverpod(keepAlive: true)
class PromotionsController extends _$PromotionsController {
  @override
  PromotionsControllerState build() {
    return PromotionsControllerState.initialState();
  }

  Future<void> loadNextPromotionWindow() async {
    // final CacheController cacheController = ref.read(cacheControllerProvider);
    // final Promotion? promotions = cacheController.get(state.cursor);

    // if (promotions == null) {
    //   return;
    // }

    // final List<String> promotionIds = promotions.promotions.map((Promotion promotion) => promotion.id).toList();
    // state = state.copyWith(
    //   cursor: promotions.cursor,
    //   promotionIds: [...state.promotionIds, ...promotionIds],
    // );
  }

  Promotion? getNextPromotion() {
    if (state.promotionIds.isEmpty) {
      return null;
    }

    // Check if we need to reset the index
    if (state.promotionIndex >= state.promotionIds.length) {
      state = state.copyWith(promotionIndex: 0);
    }

    final CacheController cacheController = ref.read(cacheControllerProvider);
    final String promotionId = state.promotionIds[state.promotionIndex];
    final Promotion? promotion = cacheController.get(promotionId);

    if (promotion == null) {
      return null;
    }

    state = state.copyWith(promotionIndex: state.promotionIndex + 1);
    return promotion;
  }

  //? Play with this number to see what works best
  bool shouldGrabNextPromotionsWindow() {
    return state.promotionIndex >= state.promotionIds.length - 5;
  }
}
